#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "serverfinder.h"
#include <QNetworkInterface>
#include <QQmlContext>
#ifdef Q_OS_IOS
#import <Foundation/Foundation.h>
#endif

/*
// QString getWifiIpAddress() {
//     QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();
//     qDebug() << "Number of interfaces:" << interfaces.size();
//     foreach (const QNetworkInterface &interface, interfaces) {
//         qDebug() << "Interface name:" << interface.humanReadableName();
//         qDebug() << "Interface index:" << interface.index();
//         qDebug() << "Interface flags:" << interface.flags();
//         if (interface.flags().testFlag(QNetworkInterface::IsUp) &&
//             interface.flags().testFlag(QNetworkInterface::IsRunning) &&
//             !interface.flags().testFlag(QNetworkInterface::IsLoopBack)
//                 ) {
//             foreach (const QNetworkAddressEntry &entry, interface.addressEntries()) {
//                 if (entry.ip().protocol() == QAbstractSocket::IPv4Protocol) {
//                     qDebug() << "Found IP address:" << entry.ip().toString();
//                     return entry.ip().toString();
//                 }
//             }
//         }
//     }
//     qDebug() << "No IP address found";
//     return QString();
// }*/

// 获取应用名称
QString getAppName() {
#if defined(Q_OS_IOS)
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return QString::fromNSString(appName);
#endif
    return "Unknown App";
}

// 获取应用版本号
QString getAppVersion() {
#if defined(Q_OS_IOS)
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return QString::fromNSString(version);
#endif
    return "Unknown Version";
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    // 注册 ServerFinder 类
    qmlRegisterType<ServerFinder>("CustomTypes", 1, 0, "ServerFinder");

    QQmlApplicationEngine engine;
    // 获取应用信息
    QString appName = getAppName();
    QString appversion = getAppVersion();
    // 将应用信息传递给 QML
    engine.rootContext()->setContextProperty("appName", appName);
    engine.rootContext()->setContextProperty("appVersion", appversion);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
