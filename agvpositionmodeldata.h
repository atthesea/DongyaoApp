#ifndef AGVPOSITIONMODELDATA_H
#define AGVPOSITIONMODELDATA_H

#include <QObject>
#include <QColor>


class AgvPositionModelData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(int y READ y WRITE setY NOTIFY yChanged)
    Q_PROPERTY(int theta READ theta WRITE setTheta NOTIFY thetaChanged)
    Q_PROPERTY(int myid READ myid WRITE setMyid NOTIFY myidChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int floorid READ floorid WRITE setFloorid NOTIFY flooridChanged)
    //Q_PROPERTY(QStringList occus READ occus WRITE setOccus NOTIFY occusChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)

public:
    explicit AgvPositionModelData(QObject *parent = nullptr): QObject(parent)
    {
    }

    int x(){return m_x;}
    int y(){return m_y;}
    int theta(){return m_theta;}
    int myid(){return m_myid;}
    QString name(){return m_name;}
    int floorid(){return m_floorid;}
    //QStringList occus(){return m_occus;}
    QColor color(){return m_color;}

    void setX(int _x){m_x = _x;emit xChanged(_x);}
    void setY(int _y){m_y = _y;emit yChanged(_y);}
    void setTheta(int _theta){m_theta = _theta;emit thetaChanged(_theta);}
    void setMyid(int _myid){m_myid = _myid;emit myidChanged(_myid);}
    void setName(QString _name){m_name = _name;emit nameChanged(_name);}
    void setFloorid(int _floorid){m_floorid = _floorid;emit flooridChanged(_floorid);}
    //void setOccus(QStringList _occus){m_occus = _occus;emit occusChanged(_occus);}
    void setColor(QColor _color){m_color = _color;emit colorChanged(_color);}
signals:
    void xChanged(int _x);
    void yChanged(int _y);
    void thetaChanged(int _theta);
    void myidChanged(int _myid);
    void nameChanged(QString _name);
    void flooridChanged(int _floorid);
    //void occusChanged(QStringList _occus);
    void colorChanged(QColor _color);
public slots:

private:
    int m_x;
    int m_y;
    int m_theta;
    int m_myid;
    QString m_name;
    int m_floorid;
    //QStringList m_occus;
    QColor m_color;

};

#endif // AGVPOSITIONMODELDATA_H
