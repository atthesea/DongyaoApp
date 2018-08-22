#ifndef LINEMODELDATA_H
#define LINEMODELDATA_H

#include <QObject>
#include <QColor>

class LineModelData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int startX READ startX WRITE setStartX NOTIFY startXChanged)
    Q_PROPERTY(int startY READ startY WRITE setStartY NOTIFY startYChanged)
    Q_PROPERTY(int endX READ endX WRITE setEndX NOTIFY endXChanged)
    Q_PROPERTY(int endY READ endY WRITE setEndY NOTIFY endYChanged)
    Q_PROPERTY(int p1x READ p1x WRITE setP1x NOTIFY p1xChanged)
    Q_PROPERTY(int p1y READ p1y WRITE setP1y NOTIFY p1yChanged)
    Q_PROPERTY(int p2x READ p2x WRITE setP2x NOTIFY p2xChanged)
    Q_PROPERTY(int p2y READ p2y WRITE setP2y NOTIFY p2yChanged)
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(int myid READ myid WRITE setMyid NOTIFY myidChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(int floor READ floor WRITE setFloor NOTIFY floorChanged)
public:
    explicit LineModelData(QObject *parent = nullptr): QObject(parent){}

    int startX(){return m_startX;}
    int startY(){return m_startY;}
    int endX(){return m_endX;}
    int endY(){return m_endY;}
    int p1x(){return m_p1x;}
    int p1y(){return m_p1y;}
    int p2x(){return m_p2x;}
    int p2y(){return m_p2y;}
    int type(){return m_type;}
    int myid(){return m_myid;}
    QColor color(){return m_color;}
    int floor(){return m_floor;}

    void setStartX(int _startX){m_startX = _startX;emit startXChanged(_startX);}
    void setStartY(int _startY){m_startY = _startY;emit startYChanged(_startY);}
    void setEndX(int _endX){m_endX = _endX;emit endXChanged(_endX);}
    void setEndY(int _endY){m_endY = _endY;emit endYChanged(_endY);}
    void setP1x(int _p1x){m_p1x = _p1x;emit p1xChanged(_p1x);}
    void setP1y(int _p1y){m_p1y = _p1y;emit p1yChanged(_p1y);}
    void setP2x(int _p2x){m_p2x = _p2x;emit p2xChanged(_p2x);}
    void setP2y(int _p2y){m_p2y = _p2y;emit p2yChanged(_p2y);}
    void setType(int _type){m_type = _type;emit typeChanged(_type);}
    void setMyid(int _myid){m_myid = _myid;emit myidChanged(_myid);}
    void setColor(QColor _color){m_color=_color;emit colorChanged(_color);}
    void setFloor(int _floor){m_floor=_floor;emit floorChanged(_floor);}
signals:
    void startXChanged(int _startX);
    void startYChanged(int _startY);
    void endXChanged(int _endX);
    void endYChanged(int _endY);
    void p1xChanged(int _p1x);
    void p1yChanged(int _p1y);
    void p2xChanged(int _p2x);
    void p2yChanged(int _p2y);
    void typeChanged(int _type);
    void myidChanged(int _myid);
    void colorChanged(QColor _color);
    void floorChanged(int _floor);
public slots:

private:
    int m_startX;
    int m_startY;
    int m_endX;
    int m_endY;
    int m_p1x;
    int m_p1y;
    int m_p2x;
    int m_p2y;
    int m_type;
    int m_myid;
    int m_floor;
    QColor m_color;
};

#endif // LINEMODELDATA_H
