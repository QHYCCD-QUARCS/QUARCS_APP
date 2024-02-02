//#ifndef SERVERFINDER_H
//#define SERVERFINDER_H


//class ServerFinder
//{
//public:
//    ServerFinder();
//};

//#endif // SERVERFINDER_H


// ServerFinder.h
#ifndef SERVERFINDER_H
#define SERVERFINDER_H

#include <QObject>
#include <QUdpSocket>
#include <QHostAddress>
#include <QElapsedTimer>
#define QHYCCD_SUCCESS                  0
#define QHYCCD_ERROR                    0xFFFFFFFF
class ServerFinder : public QObject
{
    Q_OBJECT
public:
    explicit ServerFinder(QObject *parent = nullptr);

    Q_INVOKABLE QString findServerAddress();//int QHostAddress QHostAddress &serverAddress (const QVariant &serverAddressVariant);//(QHostAddress &serverAddress);
};

#endif // SERVERFINDER_H
