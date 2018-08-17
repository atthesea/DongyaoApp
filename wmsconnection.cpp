#include "wmsconnection.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

#include "global.h"

#define TODO_REQUEST_STORAGE    1
#define TODO_UPDATE_STORAGE     2
#define TODO_SEND_TASK          3

#define MSG_TYPE_REQUEST        0
#define MSG_TYPE_RESPONSE       1

WmsConnection::WmsConnection(QObject *parent) : QObject(parent),
    sendQueueNumber(1)
{

}

void WmsConnection::connToServer(QString ip,int port)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &WmsConnection::sig_connect);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WmsConnection::sig_disconnect);
    connect(&m_webSocket, &QWebSocket::textMessageReceived,this,&WmsConnection::slot_read);

    QString _url = QString("ws://%1:%2").arg(ip).arg(port);
    m_webSocket.open(QUrl(_url));
    QyhSleep(5000);

    //TODO:
    emit sig_request_all_success();
}

bool WmsConnection::getIsConnect()
{
    return m_webSocket.state() == QAbstractSocket::ConnectedState;
}

void WmsConnection::slot_read(QString msg)
{
    //TODO:
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject obj = d.object();

    //解析obj的内容






    //如果是请求全部库位信息，
    //emit sig_request_all_success();

}

//刚连接上，请求全部库位信息
void WmsConnection::slot_connect()
{
    requestAllStorayType();
}

//请求全部的库位信息
void WmsConnection::requestAllStorayType()
{

}

//请求库位信息
bool WmsConnection::requestStorayType(QString floor_info)
{
    QJsonObject obj;
    int queuenumber = sendQueueNumber++;
    if(queuenumber>255)queuenumber = 1;

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
    obj["store_no"] = "ALL";

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    m_webSocket.sendTextMessage(strJson);

    return true;
}

//设置库位信息
bool WmsConnection::setStorageType(int id,StorageData::STORAGE_TYPE type)
{


    return true;
}

//任务请求//TODO
bool WmsConnection::sendTask()
{


    return true;
}
