#ifndef TASKMODELDATA_H
#define TASKMODELDATA_H

#include <QObject>

class TaskModelData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int excuteAgv READ excuteAgv WRITE setExcuteAgv NOTIFY excuteAgvChanged)
    Q_PROPERTY(int priority READ priority WRITE setPriority NOTIFY priorityChanged)
    Q_PROPERTY(int status READ status WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(QString produceTime READ produceTime WRITE setProduceTime NOTIFY produceTimeChanged)
    Q_PROPERTY(QString doTime READ doTime WRITE setDoTime NOTIFY doTimeChanged)
    Q_PROPERTY(QString doneTime READ doneTime WRITE setDoneTime NOTIFY doneTimeChanged)
    Q_PROPERTY(QString cancelTime READ cancelTime WRITE setCancelTime NOTIFY cancelTimeChanged)
    Q_PROPERTY(QString errorTime READ errorTime WRITE setErrorTime NOTIFY errorTimeChanged)
    Q_PROPERTY(QString errorCode READ errorCode WRITE setErrorCode NOTIFY errorCodeChanged)
    Q_PROPERTY(QString errorInfo READ errorInfo WRITE setErrorInfo NOTIFY errorInfoChanged)
    Q_PROPERTY(bool isCancel READ isCancel WRITE setIsCancel NOTIFY isCancelChanged)
    Q_PROPERTY(QString discribe READ discribe WRITE setDiscribe NOTIFY discribeChanged)


public:
    explicit TaskModelData(QObject *parent = nullptr);

signals:

public slots:
};

#endif // TASKMODELDATA_H
