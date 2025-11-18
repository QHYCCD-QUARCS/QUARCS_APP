#ifndef PERMISSIONREQUESTER_H
#define PERMISSIONREQUESTER_H
#include <QObject>
#include <QDebug>
// #include <QFile>
// #include <QTextStream>

#ifdef Q_OS_ANDROID
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
#include <QtAndroid>
#else
#include <QPermissions>
#include <QJniObject>// 替代 QAndroidJniObject
#include <QJniEnvironment> // 替代 QAndroidJniEnvironment
#include <QCoreApplication>

#endif
#endif

#ifdef Q_OS_IOS
#include <CoreLocation/CoreLocation.h>
#endif



class PermissionRequester : public QObject
{
    Q_OBJECT
public:
    explicit PermissionRequester(QObject *parent = nullptr);  // 构造函数声明
    Q_INVOKABLE void requestPermissions();  // 请求权限的声明
    Q_INVOKABLE void exitApp() ;
signals:
    void positionUpdated(); // 信号，通知 QML 经纬度更新
};

#endif // PERMISSIONREQUESTER_H
