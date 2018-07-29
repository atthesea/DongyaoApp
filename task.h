#ifndef TASK_H
#define TASK_H

#include <QObject>

class Task : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int task_no READ task_no WRITE setTask_no NOTIFY task_noChanged)
    Q_PROPERTY(QString task_discribe READ task_discribe WRITE setTask_discribe NOTIFY task_discribeChanged)
    Q_PROPERTY(QString from READ from WRITE setFrom NOTIFY fromChanged)
    Q_PROPERTY(QString to READ to WRITE setTo NOTIFY toChanged)

public:
    explicit Task(QObject *parent = nullptr);

    Task(const Task &b){
        m_task_no = b.m_task_no;
        m_task_discribe = b.m_task_discribe;
        m_from = b.m_from;
        m_to = b.m_to;
    }

    //READERS
    int task_no(){return m_task_no;}
    QString task_discribe(){return m_task_discribe;}
    QString from(){return m_from;}
    QString to(){return m_to;}

    //WRITERS
    void setTask_no(int _task_no){m_task_no=_task_no;emit task_noChanged(_task_no);}
    void setTask_discribe(QString _task_discribe){m_task_discribe = _task_discribe;emit task_discribeChanged(_task_discribe);}
    void setFrom(QString _from){m_from = _from;emit fromChanged(_from);}
    void setTo(QString _to){m_to = _to;emit toChanged(_to);}

signals:
    void task_noChanged(int _task_no);
    void task_discribeChanged(QString _task_discribe);
    void fromChanged(QString _from);
    void toChanged(QString _to);
public slots:

private:
    int m_task_no;
    QString m_task_discribe;
    QString m_from;
    QString m_to;
};

#endif // TASK_H
