#include "dispatchconnection.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QHostInfo>

#include "global.h"

DispatchConnection::DispatchConnection(QObject *parent) : QObject(parent),
    sendQueueNumber(1)
{

}

DispatchConnection::~DispatchConnection()
{
    m_webSocket.close();
}

bool DispatchConnection::send(const QJsonObject &json)
{
    QJsonDocument d(json);
    QString ss(d.toJson());
    return ss.length() ==  m_webSocket.sendTextMessage(ss);
}

void DispatchConnection::reset(QString _ip, int _port)
{
    ip = _ip;
    port = _port;
    QString _url = QString("ws://%1:%2").arg(ip).arg(port);
    m_webSocket.open(QUrl(_url));
}

void DispatchConnection::connToServer(QString _ip,int _port)
{
    ip = _ip;
    port = _port;
    connect(&m_webSocket, &QWebSocket::connected, this, &DispatchConnection::sig_connect);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &DispatchConnection::sig_disconnect);
    connect(&m_webSocket, &QWebSocket::textMessageReceived,this,&DispatchConnection::sig_onRead);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &DispatchConnection::slot_disconnect);

//    QHostInfo info=QHostInfo::fromName(QHostInfo::localHostName());

//    if (info.error() != QHostInfo::NoError)
//    {
//        qDebug() << "Lookup failed:" << info.errorString();
//        return;
//    }

//    for (int i = 0;i < info.addresses().size();i++)
//    {
//        qDebug() << "Found address:" << info.addresses()[i].toString() << endl;
//    }

    QString _url = QString("ws://%1:%2").arg(ip).arg(port);
    qDebug()<<"url = "<<_url.toLatin1();
    m_webSocket.open(QUrl(_url));
}

//void DispatchConnection::slot_read(QString msg)
//{
//    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
//    QJsonObject obj = d.object();
//    emit sig_onRead(obj);
//}

void DispatchConnection::slot_disconnect()
{
    //重连
    QString _url = QString("ws://%1:%2").arg(ip).arg(port);
    try{
        QyhSleep(5000);
        m_webSocket.open(QUrl(_url));
    }catch(...){

    }
}

