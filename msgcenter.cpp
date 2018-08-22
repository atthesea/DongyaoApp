#include "msgcenter.h"
#include "msgcenter.h"
#include <assert.h>
#include "global.h"
#include "base64.h"
#include <iostream>
#include "protocol.h"
#include "floormodeldata.h"
#include "linemodeldata.h"
#include "agvpositionmodeldata.h"
#include <QImage>

static struct
{
    int id;
    QColor color;
} COMMON_COLOR_TABLE[] =
{
{0,Qt::red},
{1,Qt::green},
{2,Qt::blue},
{3,Qt::cyan},
{4,Qt::magenta},
{5,Qt::yellow},
};

MsgCenter::MsgCenter(QObject *parent) : QObject(parent),
    quit(false),
    isMapLoaded(false)
{

}
MsgCenter::~MsgCenter()
{
    quit =true;
    condition.wakeAll();
    if(thread_msg_process.joinable())thread_msg_process.join();
}

void MsgCenter::init()
{
    connect(&dispatch_connection,SIGNAL(sig_connect()),this,SIGNAL(sig_connection_connected()));
    connect(&dispatch_connection,SIGNAL(sig_disconnect()),this,SIGNAL(sig_connection_disconnected()));
    connect(&dispatch_connection,SIGNAL(sig_onRead(QString)),this,SLOT(push(QString)));
    dispatch_connection.connToServer(g_config->getDispatch_ip(),g_config->getDispatch_port());

    //响应消息处理的线程
    thread_msg_process = std::thread([&](){
        while(!quit){
            responsesMtx.lock();
            if(responses.size()<=0){
                condition.wait(&responsesMtx);
            }
            if(quit){
                responsesMtx.unlock();
                break;
            }
            QString response = responses.front();
            responses.pop_front();
            responsesMtx.unlock();

            QJsonDocument d = QJsonDocument::fromJson(response.toLocal8Bit());
            parseOneMsg(d.object());
        }
        qDebug()<<"QUIT";
    });
}

void MsgCenter::resetIpPort(QString ip,int port)
{
    g_config->setDispatch_ip(ip);
    g_config->setDispatch_port(port);
    dispatch_connection.reset(g_config->getDispatch_ip(),g_config->getDispatch_port());
}

QString MsgCenter::getServerIp()
{
    return g_config->getDispatch_ip();
}
int MsgCenter::getServerPort()
{
    return g_config->getDispatch_port();
}

//入队响应消息
void MsgCenter::push(const QString &response)
{
    responsesMtx.lock();
    responses.push_back(response);
    condition.wakeAll();
    responsesMtx.unlock();
}

void MsgCenter::requestWaitResponse(const QJsonObject &request)
{
    emit sendNewRequest();
    //qDebug()<<"send request:"<<" req->"<<request["todo"].toString().c_str()<<" queue->"<<request["queuenumber"].toString().c_str();
    if(!dispatch_connection.send(request)){
        emit sendRequestFail();
        return ;
    }
    int kk = 200;
    while(!getResponse&&--kk>0)
    {
        QyhSleep(100);
    }
    if(kk<=0)
        emit waitResponseTimeOut();

}

void MsgCenter::iniRequsttMsg(QJsonObject &request)
{
    request["queuenumber"] = ++queueNumber;
    request["type"] = MSG_TYPE_REQUEST;
}

void MsgCenter::parseOneMsg(const QJsonObject &response)
{
    //判断消息格式是否正确
    if(response["type"].isNull()||response["queuenumber"].isNull()||response["todo"].isNull()){
        return ;
    }

    //是否和发送请求的queuenumber序号相同，相同标记 得到响应
    if(response["queuenumber"].toInt() == queueNumber)getResponse = true;

    //错误判断和显示
    if(!response["result"].isNull() &&  response["result"].toInt() == RETURN_MSG_RESULT_FAIL)
    {
        //报告错误！
        emit err(response["error_code"].toInt(),response["error_info"].toString());
        return ;
    }

    //没有错误，那么根据响应的指令，找到对应的处理方式处理
    typedef std::function<void(const QJsonObject &)> ProcessFunction;

    static struct
    {
        MSG_TODO t;
        ProcessFunction f;
    } table[] =
    {
    { MSG_TODO_USER_LOGIN,std::bind(&MsgCenter::response_user_login,this,std::placeholders::_1) },
    { MSG_TODO_USER_LOGOUT,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_USER_CHANGED_PASSWORD,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_USER_LIST,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_USER_DELTE,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_USER_ADD,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_USER_MODIFY,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_MAP_SET_MAP,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_MAP_GET_MAP,std::bind(&MsgCenter::response_map_get,this,std::placeholders::_1) },
    { MSG_TODO_AGV_MANAGE_LIST,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_AGV_MANAGE_ADD,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_AGV_MANAGE_DELETE,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_AGV_MANAGE_MODIFY,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TASK_CREATE,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TASK_QUERY_STATUS,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TASK_CANCEL,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TASK_LIST_UNDO,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TASK_LIST_DOING,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TASK_LIST_DONE_TODAY,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TASK_LIST_DURING,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_LOG_LIST_DURING,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_SUB_AGV_POSITION,std::bind(&MsgCenter::response_subAgvPosition,this,std::placeholders::_1) },
    { MSG_TODO_CANCEL_SUB_AGV_POSITION,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_SUB_AGV_STATSU,std::bind(&MsgCenter::response_subAgvStatus,this,std::placeholders::_1) },
    { MSG_TODO_CANCEL_SUB_AGV_STATSU,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_SUB_LOG,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_CANCEL_SUB_LOG,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_SUB_TASK,std::bind(&MsgCenter::response_task_sub,this,std::placeholders::_1) },
    { MSG_TODO_CANCEL_SUB_TASK,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TRAFFIC_CONTROL_STATION,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TRAFFIC_CONTROL_LINE,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TRAFFIC_RELEASE_STATION,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_TRAFFIC_RELEASE_LINE,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_PUB_AGV_POSITION,std::bind(&MsgCenter::pub_agv_position,this,std::placeholders::_1) },
    { MSG_TODO_PUB_AGV_STATUS,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_PUB_LOG,std::bind(&MsgCenter::response_null,this,std::placeholders::_1) },
    { MSG_TODO_PUB_TASK,std::bind(&MsgCenter::pub_agv_task,this,std::placeholders::_1) },
};

    table[response["todo"].toInt()].f(response);

    return ;
}

void MsgCenter::response_null(const QJsonObject &response)
{
    Q_UNUSED(response)
}

void MsgCenter::response_user_login(const QJsonObject &response)
{
    emit loginSuccess(response["role"].toInt());
}

void MsgCenter::response_map_get(const QJsonObject &response)
{
    //TODO:
    QJsonDocument d(response);
    qDebug()<<"get map json length = "<<d.toJson().length();
    g_onemap->clear();
    //地图信息
    auto ps = response["points"].toArray();
    for (int i = 0; i < ps.size(); ++i)
    {
        QJsonObject station = ps[i].toObject();
        int id = station["id"].toInt();
        std::string name = station["name"].toString().toStdString();
        int station_type = station["point_type"].toInt();
        int x = station["x"].toInt();
        int y = station["y"].toInt();
        int realX = station["realX"].toInt();
        int realY = station["realY"].toInt();
        int realA = station["realA"].toInt();
        int labelXoffset = station["labelXoffset"].toInt();
        int labelYoffset = station["labelYoffset"].toInt();
        bool mapchange = station["mapChange"].toBool();
        bool locked = station["locked"].toBool();
        std::string ip = station["ip"].toString().toStdString();
        int port = station["port"].toInt();
        int agvType = station["agvType"].toInt();
        std::string lineId = station["lineId"].toString().toStdString();

        MapPoint *p = new MapPoint(id,name,(MapPoint::Map_Point_Type)station_type,x,y,realX,realY,realA,labelXoffset,labelYoffset,mapchange,locked,ip,port,agvType,lineId);
        g_onemap->addSpirit(p);
    }

    //2.解析线路
    auto pas = response["paths"].toArray();
    for (int i = 0; i < pas.size(); ++i)
    {
        QJsonObject line = pas[i].toObject();
        int id = line["id"].toInt();
        std::string name = line["name"].toString().toStdString();
        int type = line["type"].toInt();
        int start = line["start"].toInt();
        int end = line["end"].toInt();
        int p1x = line["p1x"].toInt();
        int p1y = line["p1y"].toInt();
        int p2x = line["p2x"].toInt();
        int p2y = line["p2y"].toInt();
        int length = line["length"].toInt();
        bool locked = line["locked"].toBool();
        double speed = line["speed"].toDouble();
        MapPath *p = new MapPath(id,name,start,end,(MapPath::Map_Path_Type)type,length,p1x,p1y,p2x,p2y,locked,speed);
        g_onemap->addSpirit(p);
    }

    //4.解析背景图片

    auto bs = response["bkgs"].toArray();
    for (int i = 0; i < bs.size(); ++i)
    {
        QJsonObject bkg = bs[i].toObject();
        int id = bkg["id"].toInt();
        std::string name = bkg["name"].toString().toStdString();
        std::string database64 = bkg["data"].toString().toStdString();
        int lenlen = Base64decode_len(database64.c_str());
        char *data = new char[lenlen];
        Base64decode(data,database64.c_str());
        int imgdatalen = bkg["data_len"].toInt();
        int width = bkg["width"].toInt();
        int height = bkg["height"].toInt();
        int x = bkg["x"].toInt();
        int y = bkg["y"].toInt();
        std::string filename = bkg["filename"].toString().toStdString();
        MapBackground *p = new MapBackground(id,name,data, lenlen,width,height,filename);
        p->setX(x);
        p->setY(y);
        g_onemap->addSpirit(p);
    }

    //3.解析楼层

    auto fs = response["floors"].toArray();
    for (int i = 0; i < fs.size(); ++i)
    {
        QJsonObject floor = fs[i].toObject();
        int id = floor["id"].toInt();
        std::string name = floor["name"].toString().toStdString();
        auto points = floor["points"].toArray();
        auto paths = floor["paths"].toArray();
        int bkg = floor["bkg"].toInt();
        int originX = floor["originX"].toInt();
        int originY = floor["originY"].toInt();
        double rate = floor["rate"].toDouble();
        MapFloor *p = new MapFloor(id, name);
        p->setBkg(bkg);
        p->setOriginX(originX);
        p->setOriginY(originY);
        p->setRate(rate);
        for (int k = 0; k < points.size(); ++k) {
            p->addPoint(points[k].toInt());
        }
        for (int k = 0; k < paths.size(); ++k) {
            p->addPath(paths[k].toInt());
        }
        g_onemap->addSpirit(p);
    }

    //5.解析block
    auto bbs = response["blocks"].toArray();
    for (int i = 0; i < bbs.size(); ++i)
    {
        QJsonObject block = bbs[i].toObject();
        int id = block["id"].toInt();
        std::string name = block["name"].toString().toStdString();
        QJsonArray spirits = block["spirits"].toArray();
        MapBlock *p = new MapBlock(id,name);
        for(int k=0;k<spirits.size();++k){
            p->addSpirit(spirits[k].toInt());
        }
        g_onemap->addSpirit(p);
    }

    //6.解析group

    //5.解析block
    auto gs = response["groups"].toArray();
    for (int i = 0; i < gs.size(); ++i)
    {
        QJsonObject group = gs[i].toObject();
        int id = group["id"].toInt();
        std::string name = group["name"].toString().toStdString();
        QJsonArray spirits = group["spirits"].toArray();
        MapGroup *p = new MapGroup(id,name);
        for(int k=0;k<spirits.size();++k){
            p->addSpirit(spirits[k].toInt());
        }
        g_onemap->addSpirit(p);
    }

    int max_id = response["maxId"].toInt();
    g_onemap->setMaxId(max_id);
    isMapLoaded = true;
    emit mapGetSuccess();
}


void MsgCenter::pub_agv_position(const QJsonObject &response)
{
    QMutexLocker l(&pathMtx);
    QMutexLocker l2(&agvMtx);
    draw_paths.clear();
    draw_agvs.clear();
    auto json_agvs = response["agvs"].toArray();
    for(int i=0;i<json_agvs.size();++i)
    {
        QJsonObject json_one_agv = json_agvs[i].toObject();
        int id = json_one_agv["id"].toInt();
        QString name = json_one_agv["name"].toString();
        double x = json_one_agv["x"].toDouble();
        double y = json_one_agv["y"].toDouble();
        double theta = json_one_agv["theta"].toDouble();
        int floor = json_one_agv["floor"].toInt();
        //emit sig_pub_agv_position(id,name,x,y,theta,floor);

        AgvPositionModelData *a = new AgvPositionModelData;
        a->setMyid(id);
        a->setColor(COMMON_COLOR_TABLE[id%6].color);
        a->setFloorid(floor);
        a->setName(name);
        a->setTheta(theta);
        a->setX(x);
        a->setY(y);
        draw_agvs.append(a);

        QString occurs = json_one_agv["occurs"].toString();
        QStringList ocs = occurs.split(";");

        foreach (auto oc, ocs) {
            int lineId = oc.toInt();
            auto path = g_onemap->getPathById(lineId);
            if(path == nullptr)continue;
            auto start = g_onemap->getPointById(path->getStart());
            auto end = g_onemap->getPointById(path->getEnd());
            if(start == nullptr || end == nullptr)continue;
            auto floorId = g_onemap->getFloor(lineId);
            auto floorptr = g_onemap->getFloorById(floorId);
            if(floorptr == nullptr)continue;
            auto bkgptr = g_onemap->getBackgroundById(floorptr->getBkg());
            if(bkgptr==nullptr)continue;

            LineModelData *l = new LineModelData;
            l->setColor(COMMON_COLOR_TABLE[id%6].color);
            l->setMyid(lineId);
            l->setStartX(start->getX() - bkgptr->getX());
            l->setStartY(start->getY() - bkgptr->getY());
            l->setEndX(end->getX() - bkgptr->getX());
            l->setEndY(end->getY() - bkgptr->getY());
            l->setP1x(path->getP1x() - bkgptr->getX());
            l->setP1y(path->getP1y() - bkgptr->getY());
            l->setP2x(path->getP2x() - bkgptr->getX());
            l->setP2y(path->getP2y() - bkgptr->getY());
            l->setType(static_cast<int>( path->getPathType()));
            l->setFloor(g_onemap->getFloor(lineId));
            draw_paths.append(l);
        }
    }
    emit sig_update_agv_lines();
}

void MsgCenter::response_task_sub(const QJsonObject &response)
{
    emit subTaskSuccess();
}

bool MsgCenter::hasBkg(int floorId)
{
    QImage img;
    auto floor = g_onemap->getFloorById(floorId);
    if(floor!=nullptr){
        int bkgId = floor->getBkg();
        auto bkg = g_onemap->getBackgroundById(bkgId);

        if(bkg!=nullptr){
            QByteArray ba(bkg->getImgData(),bkg->getImgDataLen());
            img.loadFromData(ba);
            if(!img.isNull()){
                return true;
            }
        }
    }
    return false;
}

void MsgCenter::pub_agv_task(const QJsonObject &response)
{
    //TODO:
    //更新任务列表
    QJsonArray json_tasks = response["tasks"].toArray();
    agvtaskinfos.clear();
    for(int i=0;i<json_tasks.size();++i){
        QJsonObject json_one_task = json_tasks[i].toObject();
        TASK_INFO ti;
        ti.excuteAgv = json_one_task["agv"].toInt();
        if(ti.excuteAgv<=0)ti.excuteAgv = 0;
        ti.priority = json_one_task["priority"].toInt();
        ti.status = json_one_task["status"].toInt();
        ti.produceTime = json_one_task["produceTime"].toString();
        ti.cancelTime = json_one_task["cancelTime"].toString();
        ti.doTime =json_one_task["doTime"].toString();
        ti.doneTime = json_one_task["doneTime"].toString();
        ti.errorTime = json_one_task["errorTime"].toString();
        ti.doingIndex = json_one_task["doingIndex"].toInt();
        ti.errorCode = json_one_task["errorCode"].toInt();
        ti.errorInfo = json_one_task["errorInfo"].toString();
        ti.id = json_one_task["id"].toInt();
        ti.isCancel = json_one_task["isCancel"].toBool();

        QJsonArray json_nodes = json_one_task["nodes"].toArray();
        for(int j=0;j<json_nodes.size();++j){
            QJsonObject json_one_node = json_nodes[j].toObject();
            TaskNode node;
            node.stationid = json_one_node["station"].toInt();
            QJsonArray json_things = json_one_node["things"].toArray();
            for(int k=0;k<json_things.size();++k){
                QJsonObject json_one_thing = json_things[k].toObject();
                //                node.dowhat = json_one_thing["id"].toInt();
                //                //node.params =
            }
            ti.nodes.append(node);
        }
        agvtaskinfos.append(ti);
    }
    emit onSubTask();
}

void MsgCenter::response_subAgvPosition(const QJsonObject &response)
{
    emit subAgvPositionSuccess();
}

void MsgCenter::response_subAgvStatus(const QJsonObject &response)
{
    emit subAgvStatusSuccess();
}

void MsgCenter::response_subTask(const QJsonObject &response)
{
    emit subTaskSuccess();
}

/////////////////////////////////////请求登录
void MsgCenter::login(QString username,QString password)
{
    QJsonObject request;
    iniRequsttMsg(request);
    request["todo"] = MSG_TODO_USER_LOGIN;
    request["username"] = username;
    request["password"] = password;
    requestWaitResponse(request);
}

void MsgCenter::subAgvPosition()
{
    QJsonObject request;
    iniRequsttMsg(request);
    request["todo"] = MSG_TODO_SUB_AGV_POSITION;
    requestWaitResponse(request);
}

void MsgCenter::subAgvStatus()
{
    QJsonObject request;
    iniRequsttMsg(request);
    request["todo"] = MSG_TODO_SUB_AGV_STATSU;
    requestWaitResponse(request);
}

void MsgCenter::subTask()
{
    QJsonObject request;
    iniRequsttMsg(request);
    request["todo"] = MSG_TODO_SUB_TASK;
    requestWaitResponse(request);
}

QString ByteArrayToHexString(QByteArray data){
    QString ret(data.toHex().toUpper());
    int len = ret.length()/2;
    for(int i=1;i<len;i++)
    {
        ret.insert(2*i+i-1," ");
    }

    return ret;
}

void MsgCenter::mapLoad()
{
    QJsonObject request;
    iniRequsttMsg(request);
    request["todo"] = MSG_TODO_MAP_GET_MAP;
    requestWaitResponse(request);
}

QList<QObject *> MsgCenter::getFloors()
{
    QList<QObject *> qsl;
    auto pp = g_onemap->getFloors();
    foreach (auto p, pp) {
        FloorModelData *f = new FloorModelData;
        f->setMyId(p->getId());
        f->setName(QString::fromStdString(p->getName()));
        qsl<<f;
    }
    return qsl;
}

int MsgCenter::getBkgWidth(int floorid)
{
    auto floor = g_onemap->getFloorById(floorid);
    if(floor == nullptr)return 800;
    auto bkg = g_onemap->getBackgroundById(floor->getBkg());
    return bkg->getWidth();
}

int MsgCenter::getBkgHeight(int floorid)
{
    auto floor = g_onemap->getFloorById(floorid);
    if(floor == nullptr)return 640;
    auto bkg = g_onemap->getBackgroundById(floor->getBkg());
    return bkg->getHeight();
}
