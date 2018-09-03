#ifndef MSGCENTER_H
#define MSGCENTER_H
#include <thread>
#include <QObject>
#include <QMap>
#include <QQueue>
#include <QString>
#include <QString>
#include <QWaitCondition>
#include <QMutex>
#include <QMutexLocker>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "common.h"
#include "dispatchconnection.h"
#include "mapmap/onemap.h"

class MsgCenter : public QObject
{
    Q_OBJECT
public:
    explicit MsgCenter(QObject *parent = nullptr);

    ~MsgCenter();

    Q_INVOKABLE void init();

    Q_INVOKABLE void resetIpPort(QString ip,int port);

    Q_INVOKABLE QString getServerIp();
    Q_INVOKABLE int getServerPort();

    Q_INVOKABLE bool getIsConnect(){return dispatch_connection.isConnect();}

    Q_INVOKABLE bool hasBkg(int floorId);

    //一共五个请求：登陆/载入地图/订阅任务/订阅位置/订阅状态
    Q_INVOKABLE void login(QString username,QString password);
    Q_INVOKABLE void mapLoad();
    Q_INVOKABLE void subTask();
    Q_INVOKABLE void subAgvPosition();
    Q_INVOKABLE void subAgvStatus();

    //获取楼层信息
    Q_INVOKABLE QList<QObject *> getFloors();

    //获取线路信息
    Q_INVOKABLE QList<QObject *> getDrawPaths(){
        QMutexLocker l(&pathMtx);
        return draw_paths;
    }

    //获取agv信息
    Q_INVOKABLE QList<QObject *> getDrawAgvs(){
        QMutexLocker l(&agvMtx);
        return draw_agvs;
    }

    //获取任务列表
    Q_INVOKABLE QList<QObject *> getTaskInfoModel(){
        QMutexLocker l(&taskMtx);
        return agvtaskinfos;
    }
    Q_INVOKABLE bool getIsMapLoaded(){return isMapLoaded;}

    Q_INVOKABLE int getBkgWidth(int floorid);
    Q_INVOKABLE int getBkgHeight(int floorid);
signals:
    //连接状态改变
    void sig_connection_connected();
    void sig_connection_disconnected();

    //全局的 发送请求失败
    void sendRequestFail();//发送请求失败
    //全局的 等待返回超时
    void waitResponseTimeOut();//等待返回超时
    //全局的 错误提示信息
    void tip(QString tipstr);//全局的提示信息
    //全局的 返回错误显示
    void err(int errcode,QString info);
    //发送了新的请求，清空上次请求的错误信息等
    void sendNewRequest();

    //五个请求：登陆/载入地图/订阅任务/订阅位置/订阅状态 成功信息
    void loginSuccess(int role);
    void mapGetSuccess();
    void subTaskSuccess();
    void subAgvPositionSuccess();
    void subAgvStatusSuccess();

    //订阅的任务信息接收  成功
    void onSubTask();
    //获取到一个agv位置信息
    //void sig_pub_agv_position(int id,QString name,double x,double y,double theta,int floor);
    void sig_update_agv_lines();
public slots:
    void push(const QString &response);
private:
    void response_null(const QJsonObject &response);
    //用户部分
    void response_user_login(const QJsonObject &response);
    void response_map_get(const QJsonObject &response);
    void pub_agv_position(const QJsonObject &response);
    void response_task_sub(const QJsonObject &response);
    void pub_agv_task(const QJsonObject &response);

    void response_subAgvPosition(const QJsonObject &response);
    void response_subAgvStatus(const QJsonObject &response);
    void response_subTask(const QJsonObject &response);


    void parseOneMsg(const QJsonObject &response);

    void iniRequsttMsg(QJsonObject &request);

    void requestWaitResponse(const QJsonObject &request);

    std::atomic_int queueNumber;

    std::atomic_bool getResponse;

    QMutex taskMtx;
    QList<QObject *> agvtaskinfos;

    DispatchConnection dispatch_connection;

    QQueue<QString> responses;
    QWaitCondition condition;
    QMutex responsesMtx;

    volatile bool quit;

    std::thread thread_msg_process;

    bool isMapLoaded;

    QMutex pathMtx;
    QMutex agvMtx;
    QList<QObject *> draw_paths;
    QList<QObject *> draw_agvs;
};

#endif // MSGCENTER_H
