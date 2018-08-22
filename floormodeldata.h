#ifndef FLOORMODELDATA_H
#define FLOORMODELDATA_H

#include <QObject>

class FloorModelData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int myId READ myId WRITE setMyId NOTIFY myIdChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
public:
    explicit FloorModelData(QObject *parent = nullptr): QObject(parent),
        m_id(-1),
        m_name("")
    {
    }

    int myId(){return m_id;}
    QString name(){return m_name;}

    void setMyId(int _id){m_id=_id;emit myIdChanged(_id);}
    void setName(QString _name){m_name=_name;emit nameChanged(_name);}
signals:
    void myIdChanged(int);
    void nameChanged(QString);
public slots:

private:
    int m_id;
    QString m_name;
};

#endif // FLOORMODELDATA_H
