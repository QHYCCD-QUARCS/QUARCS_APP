#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QtWebSockets/QWebSocket>
//#include <QMessageBox>
//#include <QTimer>
#include "serverfinder.h"




/*
 创建一个自定义信号，用于在连接失败时发出信号
//class ConnectionManager : public QObject
//{
//    Q_OBJECT
//public:
//    explicit ConnectionManager(QObject *parent = nullptr) : QObject(parent) {}

//signals:
//    void connectionFailed();
//};*/

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    // 注册 ServerFinder 类
    qmlRegisterType<ServerFinder>("CustomTypes", 1, 0, "ServerFinder");
    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}


/*
//ConnectionManager connectionManager;
// 创建一个 QWebSocket 对象
QWebSocket wskt;
// 创建一个定时器用于处理连接超时
QTimer connectTimer;
connectTimer.setSingleShot(true); // 设置定时器仅触发一次
// 处理发生错误信号
QObject::connect(&wskt, QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error),
                 &app, [&wskt, &app](QAbstractSocket::SocketError error) {//&connectionManager
    Q_UNUSED(error); // 防止未使用参数的编译器警告
    qDebug() << "WebSocket error occurred.";
    //emit connectionManager.connectionFailed(); // 发出连接失败信号
});

// 连接到指定 IP 的 WebSocket 服务器
QUrl wsurl("ws://192.168.2.172:8000"); // 替换为您的 WebSocket 服务器 IP 地址和端口号
wskt.open(wsurl);
// 启动连接超时定时器，设置超时时间为 10 秒（可根据需要调整）
connectTimer.start(1500); // 1.5 秒超时
*/
/*    // 处理连接成功信号
//    QObject::connect(&wskt, &QWebSocket::connected, [&wskt, &app]() {
//        qDebug() << "WebSocket connected!";
//        //QMessageBox::information(this, "连接", "IP: " + wsurl);
//        // 在这里可以添加发送和接收数据的逻辑
//    });
//    // 处理发生错误信号
//    QObject::connect(&wskt, QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error),
//                     &app, [&connectionManager, &app](QAbstractSocket::SocketError error) {//&connectTimer, &QTimer::timeout,&wskt, &app
//        //if (wskt.state() != QAbstractSocket::ConnectedState) {
//            qDebug() << "WebSocket connection timed out or failed.";
//            emit connectionManager.connectionFailed();
//            //app.exit(-1); // 如果连接超时或失败，退出应用程序
//        //}
//    });
//    // 处理连接失败信号
//    QObject::connect(&wskt, &QWebSocket::disconnected, [&app]() {
//        qDebug() << "WebSocket disconnected. Connection failed.";
//        app.exit(-1); // 如果连接失败，退出应用程序
//    });
*/
