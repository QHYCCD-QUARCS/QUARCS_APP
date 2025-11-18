#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "serverfinder.h"
#include <QNetworkInterface>
#include <QQmlContext>

#ifdef Q_OS_ANDROID
#include "PermissionRequester.h"
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

/* //获取WiFi信息
// QString getWifiInfo() {
//     QString result;
//     const QString targetInterface = "wlan0"; // 手机WiFi接口通常为wlan0
//     QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();
//     foreach (const QNetworkInterface &interface, interfaces) {
//         if (interface.name() == targetInterface &&
//             interface.flags().testFlag(QNetworkInterface::IsUp) &&
//             interface.flags().testFlag(QNetworkInterface::IsRunning) //&&!interface.flags().testFlag(QNetworkInterface::IsLoopBack)
//             ){
//             foreach (const QNetworkAddressEntry &entry, interface.addressEntries()) {
//                 if (entry.ip().protocol() == QAbstractSocket::IPv4Protocol) {
//                     result += "IP: " + entry.ip().toString() + "\n";
//                     break;
//                 }
//             }
//             break; // 找到wlan0后立即退出循环
//         }
//     }
// // 2. 获取 WiFi SSID（分平台实现）
// #ifdef Q_OS_ANDROID
//     // Android 通过 JNI 获取 SSID
//     QJniObject  context = QJniObject ::callStaticObjectMethod(
//         "org/qtproject/qt/android/QtNative",
//         "context",
//         "()Landroid/content/Context;"
//         );
//     if (context.isValid()) {
//         QJniObject  wifiManager = context.callObjectMethod(
//             "getSystemService",
//             "(Ljava/lang/String;)Ljava/lang/Object;",
//             QJniObject ::fromString("wifi").object()
//             );
//         if (wifiManager.isValid()) {
//             QJniObject  wifiInfo = wifiManager.callObjectMethod(
//                 "getConnectionInfo",
//                 "()Landroid/net/wifi/WifiInfo;"
//                 );
//             if (wifiInfo.isValid()) {
//                 QString ssid = wifiInfo.callObjectMethod("getSSID", "()Ljava/lang/String;").toString();
//                 result += "SSID: " + ssid.replace("\"", "");
//             }
//         }
//     }
// #endif
//     return result.isEmpty() ? "No WiFi Info Found" : result;
// }*/

// 获取应用名称
QString getAppName() {
#ifdef Q_OS_ANDROID
    QJniObject context = QNativeInterface::QAndroidApplication::context();  // 获取 Android 上下文
    if (!context.isValid())
        return QString();

    // 获取包名
    QJniObject packageName = context.callObjectMethod("getPackageName", "()Ljava/lang/String;");
    if (!packageName.isValid())
        return QString();

    // 获取 PackageManager
    QJniObject packageManager = context.callObjectMethod("getPackageManager", "()Landroid/content/pm/PackageManager;");
    if (!packageManager.isValid())
        return QString();

    // 获取 ApplicationInfo
    QJniObject appInfo = packageManager.callObjectMethod(
        "getApplicationInfo",
        "(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;",
        packageName.object<jstring>(), 0);
    if (!appInfo.isValid())
        return QString();

    // 获取 appName（CharSequence）
    QJniObject appName = appInfo.callObjectMethod(
        "loadLabel",
        "(Landroid/content/pm/PackageManager;)Ljava/lang/CharSequence;",
        packageManager.object());
    if (!appName.isValid())
        return QString();

    return appName.toString();  // 返回应用名称
#endif
    return "Unknown App";
}

// 获取应用版本号
QString getAppVersion() {
#ifdef Q_OS_ANDROID
    QJniObject context = QNativeInterface::QAndroidApplication::context();
    if (!context.isValid())
        return QString();

    // 获取包名
    QJniObject packageName = context.callObjectMethod("getPackageName", "()Ljava/lang/String;");
    if (!packageName.isValid())
        return QString();

    // 获取 PackageManager
    QJniObject packageManager = context.callObjectMethod("getPackageManager", "()Landroid/content/pm/PackageManager;");
    if (!packageManager.isValid())
        return QString();

    // 获取 PackageInfo（getPackageInfo(String pkg, int flags)）
    QJniObject packageInfo = packageManager.callObjectMethod(
        "getPackageInfo",
        "(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;",
        packageName.object<jstring>(),
        0);
    if (!packageInfo.isValid())
        return QString();

    // 获取 versionName 字段
    QJniObject versionName = packageInfo.getObjectField<jstring>("versionName");
    if (!versionName.isValid())
        return QString();

    return versionName.toString();
#endif
    return "Unknown Version";
}

int main(int argc, char *argv[])
{
    // qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    qDebug() << "SSL 支持状态:" << QSslSocket::supportsSsl();
    qDebug() << "SSL 版本:" << QSslSocket::sslLibraryVersionString();
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);//QT6已弃用，默认开启
#endif
    QGuiApplication app(argc, argv);


    // 注册 ServerFinder 类
    qmlRegisterType<ServerFinder>("CustomTypes", 1, 0, "ServerFinder");

    QQmlApplicationEngine engine;
    // 获取应用信息
    QString appName = getAppName();
    QString appversion = getAppVersion();
    // QString wifiInfo = getWifiInfo();
    // 将应用信息传递给 QML
    engine.rootContext()->setContextProperty("appName", appName);
    engine.rootContext()->setContextProperty("appVersion", appversion);

#ifdef Q_OS_ANDROID
    // 在应用启动时请求权限
    PermissionRequester permissionRequester;
    engine.rootContext()->setContextProperty("permissionRequester", &permissionRequester);
    permissionRequester.requestPermissions();  // 请求权限

#endif

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
