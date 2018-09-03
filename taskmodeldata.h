#ifndef TASKMODELDATA_H
#define TASKMODELDATA_H

#include <QObject>

class TaskModelData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int myid READ myid WRITE setMyid NOTIFY myidChanged)
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

    int myid(){return m_myid;}
    int excuteAgv(){return m_excuteAgv;}
    int priority(){return m_priority;}
    int status(){return m_status;}
    QString produceTime(){return m_produceTime;}
    QString doTime(){return m_doTime;}
    QString doneTime(){return m_doneTime;}
    QString cancelTime(){return m_cancelTime;}
    QString errorTime(){return m_errorTime;}
    QString errorCode(){return m_errorCode;}
    QString errorInfo(){return m_errorInfo;}
    bool isCancel(){return m_isCancel;}
    QString discribe(){return m_discribe;}


    void setMyid(int _id){m_myid = _id;emit myidChanged(_id);}
    void setExcuteAgv(int _excuteAgv){m_excuteAgv = _excuteAgv;emit excuteAgvChanged(_excuteAgv);}
    void setPriority(int _priority){m_priority = _priority;emit priorityChanged(_priority);}
    void setStatus(int _status){m_status = _status;emit statusChanged(_status);}
    void setProduceTime(QString _produceTime){m_produceTime = _produceTime;emit produceTimeChanged(_produceTime);}
    void setDoTime(QString _doTime){m_doTime = _doTime;emit doTimeChanged(_doTime);}
    void setDoneTime(QString _doneTime){m_doneTime = _doneTime;emit doneTimeChanged(_doneTime);}
    void setCancelTime(QString _cancelTime){m_cancelTime = _cancelTime;emit cancelTimeChanged(_cancelTime);}
    void setErrorTime(QString _errorTime){m_errorTime = _errorTime;emit errorTimeChanged(_errorTime);}
    void setErrorCode(QString _errorCode){m_errorCode = _errorCode;emit errorCodeChanged(_errorCode);}
    void setErrorInfo(QString _errorInfo){m_errorInfo = _errorInfo;emit errorInfoChanged(_errorInfo);}
    void setIsCancel(bool _isCancel){m_isCancel = _isCancel;emit isCancelChanged(_isCancel);}
    void setDiscribe(QString _discribe){m_discribe = _discribe;emit discribeChanged(_discribe);}


signals:
    void myidChanged(int _id);
    void excuteAgvChanged(int _excuteAgv);
    void priorityChanged(int _priority);
    void statusChanged(int _status);
    void produceTimeChanged(QString _produceTime);
    void doTimeChanged(QString _doTime);
    void doneTimeChanged(QString _doneTime);
    void cancelTimeChanged(QString _cancelTime);
    void errorTimeChanged(QString _errorTime);
    void errorCodeChanged(QString _errorCode);
    void errorInfoChanged(QString _errorInfo);
    void isCancelChanged(bool _isCancel);
    void discribeChanged(QString _discribe);

public slots:

private:
    int m_myid;
    int m_excuteAgv;
    int m_priority;
    int m_status;
    QString m_produceTime;
    QString m_doTime;
    QString m_doneTime;
    QString m_cancelTime;
    QString m_errorTime;
    QString m_errorCode;
    QString m_errorInfo;
    bool m_isCancel;
    QString m_discribe;
};

#endif // TASKMODELDATA_H
