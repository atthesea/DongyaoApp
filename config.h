#ifndef CONFIG_H
#define CONFIG_H

#include <QObject>
#include <QVariant>
#include <QJsonObject>
#include "storagedata.h"
#include "task.h"

class Config : public QObject
{
    Q_OBJECT
public:
    explicit Config(QObject *parent = nullptr);
    Q_INVOKABLE void load();
    Q_INVOKABLE void save();

    Q_INVOKABLE QList<QObject *> getStorageDatas(){return storagetDatas;}
    Q_INVOKABLE QList<QObject *> getTasks(){return tasks;}
    Q_INVOKABLE QString getArea(){return area;}
    Q_INVOKABLE int getFloorid(){return floorid;}
    Q_INVOKABLE QString getWms_ip(){return wms_ip;}
    Q_INVOKABLE int getWms_port(){return wms_port;}
    Q_INVOKABLE QString getDispatch_ip(){return dispatch_ip;}
    Q_INVOKABLE int getDispatch_port(){return dispatch_port;}
    Q_INVOKABLE QString getAdmin_pwd(){return admin_pwd;}
    Q_INVOKABLE QString getUsername(){return username;}
    Q_INVOKABLE QString getUserpwd(){return userpwd;}
    Q_INVOKABLE int getStorage_width(){return storage_width;}
    Q_INVOKABLE int getStorage_height(){return storage_height;}

    Q_INVOKABLE void setDispatch_ip(QString _ip){params["dispatch_ip"] = _ip; }
    Q_INVOKABLE void setDispatch_port(int _port){params["dispatch_port"] = _port; }
    Q_INVOKABLE void setWms_ip(QString _ip){params["wms_ip"] = _ip; }
    Q_INVOKABLE void setWms_port(int _port){params["wms_port"] = _port; }
    Q_INVOKABLE void setFloor(QString _floor){params["floor"] = _floor; }

signals:
    void loadSuccess();
    void loadFail();

    void saveSuccess();
    void saveFail();
public slots:

private:
    QList<QObject *> storagetDatas;
    QList<QObject *> tasks;
    QString area;
    int floorid;
    QString wms_ip;
    int wms_port;
    QString dispatch_ip;
    int dispatch_port;
    QString username;
    QString userpwd;
    QString admin_pwd;
    int storage_width;
    int storage_height;

    QJsonObject params;
};

#endif // CONFIG_H
