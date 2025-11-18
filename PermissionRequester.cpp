#include "PermissionRequester.h"

PermissionRequester::PermissionRequester(QObject *parent)
    : QObject(parent)
{
    // 构造函数的实现（如果有需要初始化的内容）
}

void PermissionRequester::requestPermissions()
{

#ifdef Q_OS_IOS
    // iOS 平台权限请求
    if (@available(iOS 14.0, *)) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            qDebug() << "Location permission granted on iOS";
        } else {
            qDebug() << "Location permission denied on iOS";
        }
    }
#endif
}

void PermissionRequester::exitApp() {
#ifdef Q_OS_ANDROID
    // Android 平台退出应用
    //QAndroidJniObject::callStaticMethod<void>("java/lang/System", "exit", "(I)V", 0);
    QJniObject::callStaticMethod<void>("java/lang/System",
                                       "exit",
                                       "(I)V",
                                       0);
#endif

#ifdef Q_OS_IOS
    // iOS 平台退出应用（不推荐直接退出，通常由用户操作退出）
    qDebug() << "Exiting app on iOS is not recommended.";
#endif
    QCoreApplication::quit();
}
