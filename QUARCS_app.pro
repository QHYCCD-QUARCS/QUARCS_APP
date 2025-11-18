TEMPLATE = app
VERSION = 1.0.6
QT += webview
QT += network websockets
QT += positioning
QT += core quick  positioningquick
# QMAKE_CXXFLAGS += -Dfile.encoding=UTF-8

CONFIG += c++17
DEFINES += QT_DEPRECATED_WARNINGS
SOURCES += \
        serverfinder.cpp

RESOURCES += \
        qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


HEADERS += \
    serverfinder.h

DISTFILES +=\
    android-sources/AndroidManifest.xml \
    android-sources/LOGOq.png\
    ios-sources/Asset.xcassets/AppIcon.appiconset/Contents.json \
    ios-sources/Asset.xcassets/AppIcon.appiconset/LOGOios.jpg \
    ios-sources/Asset.xcassets/Contents.json \
    ios-sources/Info.plist \
    ios-sources/LOGOios.jpg
android{
    SOURCES+=main.cpp \
        PermissionRequester.cpp
    HEADERS += \
        PermissionRequester.h
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
    include(C:\Qt6\Android\android_openssl-master/openssl.pri)

}
ios{
    HEADERS += ioswifihelper.h
    # OBJECTIVE_SOURCES += ioswifihelper.mm
    LIBS += -framework SystemConfiguration
    LIBS += -framework CoreFoundation
    LIBS += -framework CoreLocation
    SOURCES+=main.mm \
        ioswifihelper.mm
    QMAKE_INFO_PLIST = ios-sources/Info.plist
}
