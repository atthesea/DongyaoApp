#include "wmsconnection.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <iostream>
#include "global.h"

#define TODO_REQUEST_STORAGE    1
#define TODO_UPDATE_STORAGE     2
#define TODO_SEND_TASK          3

#define MSG_TYPE_REQUEST        0
#define MSG_TYPE_RESPONSE       1

WmsConnection::WmsConnection(QObject *parent) : QObject(parent),
    sendQueueNumber(1),
    connected(false)
{

}

void WmsConnection::connToServer(QString ip,int port)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &WmsConnection::sig_connect);
    connect(&m_webSocket, &QWebSocket::connected, this, &WmsConnection::slot_connect);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WmsConnection::sig_disconnect);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WmsConnection::slot_disconnect);
    connect(&m_webSocket, &QWebSocket::textMessageReceived,this,&WmsConnection::slot_read);

    url = QString("ws://%1:%2").arg(ip).arg(port);

    m_webSocket.open(QUrl(url));

    timer = new QTimer;
    timer->setInterval(5000);
    connect(timer,&QTimer::timeout,this,&WmsConnection::slot_timerCheckConnection);
    timer->start();
}

//更新单个库存信息
void WmsConnection::func_updateStorage(QJsonObject obj)
{
    QString store_no = obj["store_no"].toString();
    QString storage_no = obj["storage_no"].toString();
    int status = obj["status"].toInt();
    int storage_type = status ? obj["material"].toString().toInt() : StorageData::STORAGE_TYPE_NULL;
    emit sig_set_storage_type(store_no, storage_no, storage_type);
}

void WmsConnection::slot_timerCheckConnection()
{
    if(connected)return ;
    m_webSocket.open(QUrl(url));
}

//解析消息
void WmsConnection::slot_read(QString msg)
{
    //TODO:
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject obj = d.object();

    int msg_type = obj["todo"].toInt();

    switch (msg_type) {
    case TODO_REQUEST_STORAGE:
    {
        std::cout<<"load storage from server"<<std::endl;
        std::cout<<msg.toStdString()<<std::endl;
        //解析obj的内容
        int count = obj["storage_count"].toInt();

        QJsonArray storage_info = obj["storage_info"].toArray();

        for(auto storage:storage_info)
        {
            QJsonObject one = storage.toObject();
            func_updateStorage(one);
        }

        //如果是请求全部库位信息，
        emit sig_request_all_success();
        break;
    }
    case TODO_UPDATE_STORAGE:
    {
        int msg_direction = obj["type"].toInt();
        if(MSG_TYPE_REQUEST == msg_direction)
        {
            std::cout<<"update storage from server"<<std::endl;
            std::cout<<msg.toStdString()<<std::endl;
            func_updateStorage(obj);
        }
        else
        {
            std::cout<<"server response-send update storage result:"<<obj["retcode"].toInt()<<obj["retmsg"].toString().toStdString()<<std::endl;
            emit sig_recv_response(obj["retmsg"].toString());

        }
        break;
    }
    case TODO_SEND_TASK:
    {
        std::cout<<"server response-send task result:"<<obj["retcode"].toInt()<<obj["retmsg"].toString().toStdString()<<std::endl;
        emit sig_recv_response(obj["retmsg"].toString());
        break;
    }
    default:
        break;
    }
}

//刚连接上，请求全部库位信息
void WmsConnection::slot_connect()
{
    std::cout<<"connected"<<std::endl;
    connected = true;
    //emit sig_request_all_success();
    requestAllStorayType();
}

//
void WmsConnection::slot_disconnect()
{
    std::cout<<"disconnected"<<std::endl;
    connected = false;
    emit sig_recv_response("同服务器连接已断开，请检查网络");
}

//请求全部的库位信息
void WmsConnection::requestAllStorayType()
{
    requestStorayType("ALL");
}

//请求库位信息
bool WmsConnection::requestStorayType(QString store_no)
{
    QJsonObject obj;
    int queuenumber = sendQueueNumber++;
    if(sendQueueNumber>255)sendQueueNumber = 1;

    obj["todo"] = TODO_REQUEST_STORAGE;
    obj["type"] = MSG_TYPE_REQUEST;
    obj["queuenumber"] = queuenumber;
    //    ALL     查询所有
    //    F1_MATERIAL一楼材料区
    //    F2_MATERIAL二楼材料区
    //    F1_EMPTYTRAY一楼空托盘区
    //    F2_ENDPRODUCT二楼成品区
    //    F3_WQ	三楼外清室
    //    F3_WB	三楼外包室
    //    F3_CB	三楼拆包机
    //    F3_MD	三楼码垛区
    //    F3_XB　	三楼线边库
    //    F3_EMPTYTRAY三楼空托盘区
    //    F3_TRASH	三楼垃圾区
    //    F1_TRASH	一楼垃圾区
    obj["store_no"] = store_no;

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    m_webSocket.sendTextMessage(strJson);

    return true;
}

//设置库位信息
bool WmsConnection::setStorageType(QString _store_no, QString _storage_no, int _storage_type)
{
    QJsonObject obj;
    int queuenumber = sendQueueNumber++;
    if(sendQueueNumber>255)sendQueueNumber = 1;

    obj["todo"] = TODO_UPDATE_STORAGE;
    obj["type"] = MSG_TYPE_REQUEST;
    obj["queuenumber"] = queuenumber;
    obj["store_no"] = _store_no;
    obj["storage_no"] = _storage_no;

    if(StorageData::STORAGE_TYPE_NULL == _storage_type)
    {
        obj["status"] = 0;
        obj["material"] = "";
    }
    else
    {
        obj["status"] = 1;
        obj["material"] = _storage_type;
    }

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    m_webSocket.sendTextMessage(strJson);

    return true;
}

//任务请求//TODO
bool WmsConnection::sendTask(QString _from_store_no, QString _to_store_no, int _store_type)
{
    QJsonObject obj;
    int queuenumber = sendQueueNumber++;
    if(sendQueueNumber>255)sendQueueNumber = 1;

    obj["todo"] = TODO_SEND_TASK;
    obj["type"] = MSG_TYPE_REQUEST;
    obj["queuenumber"] = queuenumber;
    obj["from_store_no"] = _from_store_no;
    obj["to_store_no"] = _to_store_no;
    obj["store_type"] = _store_type;

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    m_webSocket.sendTextMessage(strJson);

    return true;
}
