#include "config.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QDebug>

Config::Config(QObject *parent) : QObject(parent)
{
}


void Config::load()
{
#ifdef Q_OS_ANDROID
    //获取
    QString path = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation);
    QFile file(path + "/dongyao_app_config.json");
    //如果文件不存在，将assets下的config.json复制到该目录下
    if(!file.exists()){
        QFile asseetsConfigFile("assets:/dongyao_app_config.json");
        if(!asseetsConfigFile.open(QIODevice::ReadOnly)){
            emit loadFail();
            return ;
        }
        QByteArray val = asseetsConfigFile.readAll();
        asseetsConfigFile.close();
        if(!file.open(QIODevice::ReadWrite | QIODevice::Text)){
            emit loadFail();
            return ;
        }
        file.write(val);
        file.close();
    }
#else
    QFile file( "dongyao_app_config.json" );
#endif
    if(!file.open(QIODevice::ReadOnly)){
        emit loadFail();
        return ;
    }
    QByteArray val = file.readAll();
    file.close();
    qDebug()<<"val="<<val.trimmed();
    QJsonDocument d = QJsonDocument::fromJson(val.trimmed());
    params = d.object();

    floor = params["floor"].toString();
    wms_ip = params["wms_ip"].toString();
    wms_port = params["wms_port"].toInt();
    dispatch_ip = params["dispatch_ip"].toString();
    dispatch_port = params["dispatch_port"].toInt();
    admin_pwd = params["admin_pwd"].toString();
    username = params["username"].toString();
    userpwd = params["userpwd"].toString();
    storage_width = params["storage_width"].toInt();
    storage_height = params["storage_height"].toInt();

    QJsonArray handTasks = params["HandTasks"].toArray();
    QList<Task *> allTasks;
    foreach (auto one, handTasks) {
        Task *task =  new Task;
        task->setTask_no(one["task_no"].toInt());
        task->setTask_discribe(one["task_discribe"].toString());
        task->setFrom(one["task_from_store_no"].toString());
        task->setTo(one["task_to_store_no"].toString());
        allTasks.append(task);
    }

    QJsonObject flobj = params[floor].toObject();
    QJsonArray taskArr = flobj["hand_tasks"].toArray();
    foreach (auto one, taskArr) {
        int taskNo = one.toInt();
        foreach (auto task, allTasks) {
            if(task->task_no() == taskNo){
                tasks.append(task);
            }
        }
    }

    QJsonArray arr = flobj["storages"].toArray();

    foreach (auto one, arr) {
        StorageData *data = new StorageData;
        data->setStorage_no(one["storage_no"].toString());
        data->setStore_no(one["store_no"].toString());
        data->setCanbe_trash(one["type_canbe_trash"].toBool());
        data->setCanbe_raw(one["type_canbe_raw"].toBool());
        data->setCanbe_null(one["type_canbe_null"].toBool());
        data->setCanbe_pack(one["type_canbe_pack"].toBool());
        data->setCanbe_product(one["type_canbe_product"].toBool());
        data->setCanbe_tray(one["type_canbe_tray"].toBool());

        if(one["current_type"] == "type_null"){
            data->setStorage_type(StorageData::STORAGE_TYPE_NULL);
        }else if(one["current_type"] == "type_raw"){
            data->setStorage_type(StorageData::STORAGE_TYPE_MATERIAL);
        }else if(one["current_type"] == "type_tray"){
            data->setStorage_type(StorageData::STORAGE_TYPE_TRAY);
        }else if(one["current_type"] == "type_pack"){
            data->setStorage_type(StorageData::STORAGE_TYPE_PACKING);
        }else if(one["current_type"] == "type_trash"){
            data->setStorage_type(StorageData::STORAGE_TYPE_GARBAGE);
        }else if(one["current_type"] == "type_product"){
            data->setStorage_type(StorageData::STORAGE_TYPE_PRODUCT);
        }

        data->setX(one["storage_x"].toInt());
        data->setY(one["storage_y"].toInt());
        storagetDatas.append(data);
    }

    emit loadSuccess();
}

void Config::save()
{
    QJsonDocument saveDoc(params);
#ifdef Q_OS_ANDROID
    QString path = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation);
    QFile saveFile(path + "/dongyao_app_config.json");
#else
    QFile saveFile( "dongyao_app_config.json" );
#endif
    if(!saveFile.open(QIODevice::WriteOnly)){
        emit saveFail();
        return ;
    }
    saveFile.write(saveDoc.toJson());
    saveFile.close();
    emit saveSuccess();
}


