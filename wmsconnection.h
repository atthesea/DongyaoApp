#ifndef WMSCONNECTION_H
#define WMSCONNECTION_H

#include <QObject>
#include <QWebSocket>
#include "storagedata.h"

class WmsConnection : public QObject
{
    Q_OBJECT
public:
    explicit WmsConnection(QObject *parent = nullptr);

    Q_INVOKABLE void connToServer(QString ip,int port);

    Q_INVOKABLE bool getIsConnect();

    //请求库位信息
    Q_INVOKABLE bool requestStorayType(QString floor_info);

    //设置库位信息
    Q_INVOKABLE bool setStorageType(int id,StorageData::STORAGE_TYPE type);

    //任务请求//TODO
    Q_INVOKABLE bool sendTask();

signals:
    void sig_connect();
    void sig_disconnect();
    void sig_set_storage_type(int storage_no,StorageData::STORAGE_TYPE storage_type);//通知界面更新库位信息
    void sig_request_all_success();
public slots:
    void slot_read(QString msg);
    void slot_connect();
private:
    void requestAllStorayType();

    QWebSocket m_webSocket;

    QAtomicInt sendQueueNumber;

};

#endif // WMSCONNECTION_H
