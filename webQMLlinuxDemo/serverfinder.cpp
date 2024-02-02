//#include "serverfinder.h"

//ServerFinder::ServerFinder()
//{

//}
// ServerFinder.cpp
#include "serverfinder.h"

ServerFinder::ServerFinder(QObject *parent) : QObject(parent) {}

//int QHostAddress
QString ServerFinder::findServerAddress() {//QHostAddress &serverAddress (const QVariant &serverAddressVariant){//QHostAddress &serverAddress) {
    // 转换 QVariant 为 QHostAddress 类型
    //QHostAddress serverAddress = serverAddressVariant.value<QHostAddress>();
    QString serverAddress = NULL;
    // 创建UDP套接字
    QUdpSocket socket;
    socket.bind(QHostAddress(QHostAddress::AnyIPv4), 8080, QUdpSocket::ShareAddress);
    // 设置超时时间
    QElapsedTimer t;
    t.start();
    int timeout=3000;
    // 循环接收消息
    while (t.elapsed() < timeout)
    {
        // 接收消息
        QByteArray datagram;
        QHostAddress senderAddress;
        quint16 senderPort;
        if (socket.hasPendingDatagrams())
        {
            datagram.resize(socket.pendingDatagramSize());
            socket.readDatagram(datagram.data(), datagram.size(), &senderAddress, &senderPort);
            qDebug()<<"ip :"<<senderAddress;
            // 判断消息是否是服务器的回复消息
            if (datagram == "Stellarium Shared Memory Service") // !senderAddress.isNull())
            {
                serverAddress = senderAddress.toString();
                break;
            }
        }
    }
    if(t.elapsed()>=3000){
        qDebug()<<"findServerAddress | timeout";
        serverAddress="0.0.0.0";//.setAddress
        return serverAddress;//QHYCCD_ERROR;
    }
    else{
        return serverAddress;//QHYCCD_SUCCESS;
    }
}
