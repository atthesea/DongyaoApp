#ifndef DISPATCHCONNECTION_H
#define DISPATCHCONNECTION_H

#include <QObject>
#include <QWebSocket>

class DispatchConnection : public QObject
{
    Q_OBJECT
public:
    explicit DispatchConnection(QObject *parent = nullptr);
    ~DispatchConnection();

    bool isConnect(){return m_webSocket.state() == QAbstractSocket::ConnectedState; }
    void connToServer(QString _ip, int _port);
    void reset(QString _ip, int _port);
    bool send(const QJsonObject &json);
signals:
    void sig_connect();
    void sig_disconnect();
    void sig_onRead(QString);
public slots:
    void slot_disconnect();
private:
    QWebSocket m_webSocket;

    QAtomicInt sendQueueNumber;
    QString ip;
    int port;

    bool quit;
};

#endif // DISPATCHCONNECTION_H
