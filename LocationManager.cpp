#include "LocationManager.h"

LocationManager::LocationManager(QObject *parent)
    : QObject(parent)
{
    source = QGeoPositionInfoSource::createDefaultSource(this);
    if (source) {
        //connect(source, &QGeoPositionInfoSource::positionUpdated,this, &LocationManager::onPositionUpdated);
        // 启动定位
        source->startUpdates();
    } else {
        qWarning() << "No position source available!";
    }
}
LocationManager::~LocationManager() {
    if (source) {
        source->stopUpdates(); // 停止更新
        delete source; // 释放资源
    }
}
void LocationManager::onPositionUpdated(const QGeoPositionInfo &info) {
    QGeoCoordinate coordinate = info.coordinate();
    qDebug() << "Position updated:" << coordinate.latitude() << coordinate.longitude();
}

//void LocationManager::checkForErrors() {
//    // 实现
//}
