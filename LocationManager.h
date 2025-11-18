#ifndef LOCATIONMANAGER_H
#define LOCATIONMANAGER_H
#include <QObject>
#include <QtPositioning/QGeoPositionInfoSource>
#include <QtPositioning/QGeoPositionInfo>
#include <QtPositioning/QGeoCoordinate>
#include <QDebug>

class LocationManager : public QObject
{
    Q_OBJECT
public:
    explicit LocationManager(QObject *parent = nullptr);  // 构造函数声明
    virtual ~LocationManager();  // 虚析构函数声明

private slots:
    void onPositionUpdated(const QGeoPositionInfo &info);
    //void checkForErrors();

private:
    QGeoPositionInfoSource *source;
};
#endif // LOCATIONMANAGER_H
