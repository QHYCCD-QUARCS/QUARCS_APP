#include "ioswifihelper.h"
#include <QString>

// 引入 iOS 原生框架
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>

// 检查定位权限是否授权
bool isLocationAuthorized() {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
            status == kCLAuthorizationStatusAuthorizedAlways);
}
IOSWiFiHelper::IOSWiFiHelper(QObject *parent) : QObject(parent)
{
    // 构造函数（可空）
}

QString IOSWiFiHelper::getSSID() const
{
    QString ssid;
    if (!isLocationAuthorized()) {
      return "[permission denied: location required]";
    }

    // 1. 获取支持 WiFi 的接口列表
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (interfaces) {
        // 2. 遍历接口
        CFIndex count = CFArrayGetCount(interfaces);
        for (CFIndex i = 0; i < count; i++) {
            CFStringRef interface = (CFStringRef)CFArrayGetValueAtIndex(interfaces, i);

            // 3. 获取当前接口的网络信息
            CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo(interface);
            if (networkInfo) {
                // 4. 提取 SSID
                CFStringRef ssidRef = (CFStringRef)CFDictionaryGetValue(networkInfo, kCNNetworkInfoKeySSID);
                if (ssidRef) {
                    char ssidBuffer[256];
                    if (CFStringGetCString(ssidRef, ssidBuffer, sizeof(ssidBuffer), kCFStringEncodingUTF8)) {
                        ssid = QString::fromUtf8(ssidBuffer);
                    }
                }
                CFRelease(networkInfo);  // 手动释放内存
            }
        }
        CFRelease(interfaces);  // 手动释放内存
    }

    return ssid;  // 返回 SSID 或空字符串（如果失败）
}

// @interface IOSWiFiHelper () <CLLocationManagerDelegate>
// @property (nonatomic, strong) CLLocationManager *locationManager;
// @property (nonatomic, copy) void (^permissionCompletion)(BOOL granted);
// @end

// @implementation IOSWiFiHelper

// - (void)requestLocationPermissionWithCompletion:(void (^)(BOOL granted))completion {
//     self.permissionCompletion = completion;

//     self.locationManager = [[CLLocationManager alloc] init];
//     self.locationManager.delegate = self;
//     [self.locationManager requestWhenInUseAuthorization]; // 触发系统弹窗
// }

// // CLLocationManagerDelegate 方法，监听用户选择
// - (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//     if (status != kCLAuthorizationStatusNotDetermined) {
//         BOOL granted = (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
//                        status == kCLAuthorizationStatusAuthorizedAlways);
//         if (self.permissionCompletion) {
//             self.permissionCompletion(granted); // 回调结果
//             self.permissionCompletion = nil;   // 防止重复调用
//         }
//     }
// }

// @end
