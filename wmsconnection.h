#ifndef WMSCONNECTION_H
#define WMSCONNECTION_H

#include <QObject>
#include <QWebSocket>
#include <QTimer>
#include "storagedata.h"

class WmsConnection : public QObject
{
    Q_OBJECT
public:
    explicit WmsConnection(QObject *parent = nullptr);

    Q_INVOKABLE void connToServer(QString ip,int port);

    Q_INVOKABLE bool getIsConnect(){return connected;}
    //请求库位信息
    Q_INVOKABLE bool requestStorayType(QString store_no);

    //设置库位信息
    Q_INVOKABLE bool setStorageType(QString _store_no, QString _storage_no, int _storage_type);

    //任务请求//TODO
    Q_INVOKABLE bool sendTask(QString _from_store_no, QString _to_store_no, int _store_type);

    Q_INVOKABLE bool isConnected(){return connected;}
signals:
    void sig_connect();
    void sig_disconnect();
    void sig_set_storage_type(QString store_no, QString storage_no, int storage_type);//通知界面更新库位信息
    void sig_request_all_success();
    void sig_recv_response(QString msg);
public slots:
    void slot_read(QString msg);
    void slot_connect();
    void slot_disconnect();

    void slot_timerCheckConnection();
private:
    void requestAllStorayType();
    void func_updateStorage(QJsonObject obj);

    QWebSocket m_webSocket;

    QAtomicInt sendQueueNumber;
    bool connected;
    QTimer *timer;

     QString url;
};

#endif // WMSCONNECTION_H
