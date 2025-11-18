/****************************************************************************
** Meta object code from reading C++ file 'serverfinder.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.5.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../serverfinder.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#if __has_include(<QtCore/qtmochelpers.h>)
#include <QtCore/qtmochelpers.h>
#else
QT_BEGIN_MOC_NAMESPACE
#endif


#include <memory>

#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'serverfinder.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.5.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {

#ifdef QT_MOC_HAS_STRINGDATA
struct qt_meta_stringdata_CLASSServerFinderENDCLASS_t {};
static constexpr auto qt_meta_stringdata_CLASSServerFinderENDCLASS = QtMocHelpers::stringData(
    "ServerFinder",
    "serverAddressesFound",
    "",
    "addresses",
    "errorOccurred",
    "error",
    "serverClose",
    "fileContentChanged",
    "wifiInfoChanged",
    "progressChanged",
    "progress",
    "bytesReceived",
    "bytesTotal",
    "statusChanged",
    "downloadFinished",
    "filePath",
    "downloadErrorOccurred",
    "currentFilePathChanged",
    "uploadProgressChanged",
    "bytesSent",
    "uploadStatusChanged",
    "uploadFinished",
    "response",
    "uploadErrorOccurred",
    "searchForServers",
    "timeout",
    "searchForCloseServers",
    "updateWifiInfo",
    "onDownloadProgress",
    "onFinished",
    "onReadyRead",
    "onDownloadErrorOccurred",
    "QNetworkReply::NetworkError",
    "code",
    "onUploadProgress",
    "onUploadFinished",
    "onUploadErrorOccurred",
    "findServerAddress",
    "findClose",
    "loadFile",
    "startDownload",
    "url",
    "cancelDownload",
    "startUpload",
    "cancelUpload",
    "clearCache",
    "fileContent",
    "wifiInfo",
    "status",
    "currentFilePath",
    "uploadProgress",
    "uploadStatus"
);
#else  // !QT_MOC_HAS_STRING_DATA
struct qt_meta_stringdata_CLASSServerFinderENDCLASS_t {
    uint offsetsAndSizes[104];
    char stringdata0[13];
    char stringdata1[21];
    char stringdata2[1];
    char stringdata3[10];
    char stringdata4[14];
    char stringdata5[6];
    char stringdata6[12];
    char stringdata7[19];
    char stringdata8[16];
    char stringdata9[16];
    char stringdata10[9];
    char stringdata11[14];
    char stringdata12[11];
    char stringdata13[14];
    char stringdata14[17];
    char stringdata15[9];
    char stringdata16[22];
    char stringdata17[23];
    char stringdata18[22];
    char stringdata19[10];
    char stringdata20[20];
    char stringdata21[15];
    char stringdata22[9];
    char stringdata23[20];
    char stringdata24[17];
    char stringdata25[8];
    char stringdata26[22];
    char stringdata27[15];
    char stringdata28[19];
    char stringdata29[11];
    char stringdata30[12];
    char stringdata31[24];
    char stringdata32[28];
    char stringdata33[5];
    char stringdata34[17];
    char stringdata35[17];
    char stringdata36[22];
    char stringdata37[18];
    char stringdata38[10];
    char stringdata39[9];
    char stringdata40[14];
    char stringdata41[4];
    char stringdata42[15];
    char stringdata43[12];
    char stringdata44[13];
    char stringdata45[11];
    char stringdata46[12];
    char stringdata47[9];
    char stringdata48[7];
    char stringdata49[16];
    char stringdata50[15];
    char stringdata51[13];
};
#define QT_MOC_LITERAL(ofs, len) \
    uint(sizeof(qt_meta_stringdata_CLASSServerFinderENDCLASS_t::offsetsAndSizes) + ofs), len 
Q_CONSTINIT static const qt_meta_stringdata_CLASSServerFinderENDCLASS_t qt_meta_stringdata_CLASSServerFinderENDCLASS = {
    {
        QT_MOC_LITERAL(0, 12),  // "ServerFinder"
        QT_MOC_LITERAL(13, 20),  // "serverAddressesFound"
        QT_MOC_LITERAL(34, 0),  // ""
        QT_MOC_LITERAL(35, 9),  // "addresses"
        QT_MOC_LITERAL(45, 13),  // "errorOccurred"
        QT_MOC_LITERAL(59, 5),  // "error"
        QT_MOC_LITERAL(65, 11),  // "serverClose"
        QT_MOC_LITERAL(77, 18),  // "fileContentChanged"
        QT_MOC_LITERAL(96, 15),  // "wifiInfoChanged"
        QT_MOC_LITERAL(112, 15),  // "progressChanged"
        QT_MOC_LITERAL(128, 8),  // "progress"
        QT_MOC_LITERAL(137, 13),  // "bytesReceived"
        QT_MOC_LITERAL(151, 10),  // "bytesTotal"
        QT_MOC_LITERAL(162, 13),  // "statusChanged"
        QT_MOC_LITERAL(176, 16),  // "downloadFinished"
        QT_MOC_LITERAL(193, 8),  // "filePath"
        QT_MOC_LITERAL(202, 21),  // "downloadErrorOccurred"
        QT_MOC_LITERAL(224, 22),  // "currentFilePathChanged"
        QT_MOC_LITERAL(247, 21),  // "uploadProgressChanged"
        QT_MOC_LITERAL(269, 9),  // "bytesSent"
        QT_MOC_LITERAL(279, 19),  // "uploadStatusChanged"
        QT_MOC_LITERAL(299, 14),  // "uploadFinished"
        QT_MOC_LITERAL(314, 8),  // "response"
        QT_MOC_LITERAL(323, 19),  // "uploadErrorOccurred"
        QT_MOC_LITERAL(343, 16),  // "searchForServers"
        QT_MOC_LITERAL(360, 7),  // "timeout"
        QT_MOC_LITERAL(368, 21),  // "searchForCloseServers"
        QT_MOC_LITERAL(390, 14),  // "updateWifiInfo"
        QT_MOC_LITERAL(405, 18),  // "onDownloadProgress"
        QT_MOC_LITERAL(424, 10),  // "onFinished"
        QT_MOC_LITERAL(435, 11),  // "onReadyRead"
        QT_MOC_LITERAL(447, 23),  // "onDownloadErrorOccurred"
        QT_MOC_LITERAL(471, 27),  // "QNetworkReply::NetworkError"
        QT_MOC_LITERAL(499, 4),  // "code"
        QT_MOC_LITERAL(504, 16),  // "onUploadProgress"
        QT_MOC_LITERAL(521, 16),  // "onUploadFinished"
        QT_MOC_LITERAL(538, 21),  // "onUploadErrorOccurred"
        QT_MOC_LITERAL(560, 17),  // "findServerAddress"
        QT_MOC_LITERAL(578, 9),  // "findClose"
        QT_MOC_LITERAL(588, 8),  // "loadFile"
        QT_MOC_LITERAL(597, 13),  // "startDownload"
        QT_MOC_LITERAL(611, 3),  // "url"
        QT_MOC_LITERAL(615, 14),  // "cancelDownload"
        QT_MOC_LITERAL(630, 11),  // "startUpload"
        QT_MOC_LITERAL(642, 12),  // "cancelUpload"
        QT_MOC_LITERAL(655, 10),  // "clearCache"
        QT_MOC_LITERAL(666, 11),  // "fileContent"
        QT_MOC_LITERAL(678, 8),  // "wifiInfo"
        QT_MOC_LITERAL(687, 6),  // "status"
        QT_MOC_LITERAL(694, 15),  // "currentFilePath"
        QT_MOC_LITERAL(710, 14),  // "uploadProgress"
        QT_MOC_LITERAL(725, 12)   // "uploadStatus"
    },
    "ServerFinder",
    "serverAddressesFound",
    "",
    "addresses",
    "errorOccurred",
    "error",
    "serverClose",
    "fileContentChanged",
    "wifiInfoChanged",
    "progressChanged",
    "progress",
    "bytesReceived",
    "bytesTotal",
    "statusChanged",
    "downloadFinished",
    "filePath",
    "downloadErrorOccurred",
    "currentFilePathChanged",
    "uploadProgressChanged",
    "bytesSent",
    "uploadStatusChanged",
    "uploadFinished",
    "response",
    "uploadErrorOccurred",
    "searchForServers",
    "timeout",
    "searchForCloseServers",
    "updateWifiInfo",
    "onDownloadProgress",
    "onFinished",
    "onReadyRead",
    "onDownloadErrorOccurred",
    "QNetworkReply::NetworkError",
    "code",
    "onUploadProgress",
    "onUploadFinished",
    "onUploadErrorOccurred",
    "findServerAddress",
    "findClose",
    "loadFile",
    "startDownload",
    "url",
    "cancelDownload",
    "startUpload",
    "cancelUpload",
    "clearCache",
    "fileContent",
    "wifiInfo",
    "status",
    "currentFilePath",
    "uploadProgress",
    "uploadStatus"
};
#undef QT_MOC_LITERAL
#endif // !QT_MOC_HAS_STRING_DATA
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_CLASSServerFinderENDCLASS[] = {

 // content:
      11,       // revision
       0,       // classname
       0,    0, // classinfo
      33,   14, // methods
       7,  293, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
      14,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    1,  212,    2, 0x06,    8 /* Public */,
       4,    1,  215,    2, 0x06,   10 /* Public */,
       6,    0,  218,    2, 0x06,   12 /* Public */,
       7,    0,  219,    2, 0x06,   13 /* Public */,
       8,    0,  220,    2, 0x06,   14 /* Public */,
       9,    3,  221,    2, 0x06,   15 /* Public */,
      13,    0,  228,    2, 0x06,   19 /* Public */,
      14,    1,  229,    2, 0x06,   20 /* Public */,
      16,    1,  232,    2, 0x06,   22 /* Public */,
      17,    0,  235,    2, 0x06,   24 /* Public */,
      18,    3,  236,    2, 0x06,   25 /* Public */,
      20,    0,  243,    2, 0x06,   29 /* Public */,
      21,    1,  244,    2, 0x06,   30 /* Public */,
      23,    1,  247,    2, 0x06,   32 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
      24,    1,  250,    2, 0x0a,   34 /* Public */,
      26,    0,  253,    2, 0x0a,   36 /* Public */,
      27,    0,  254,    2, 0x0a,   37 /* Public */,
      28,    2,  255,    2, 0x08,   38 /* Private */,
      29,    0,  260,    2, 0x08,   41 /* Private */,
      30,    0,  261,    2, 0x08,   42 /* Private */,
      31,    1,  262,    2, 0x08,   43 /* Private */,
      34,    2,  265,    2, 0x08,   45 /* Private */,
      35,    0,  270,    2, 0x08,   48 /* Private */,
      36,    1,  271,    2, 0x08,   49 /* Private */,

 // methods: name, argc, parameters, tag, flags, initial metatype offsets
      37,    1,  274,    2, 0x02,   51 /* Public */,
      37,    0,  277,    2, 0x22,   53 /* Public | MethodCloned */,
      38,    0,  278,    2, 0x02,   54 /* Public */,
      39,    1,  279,    2, 0x02,   55 /* Public */,
      40,    1,  282,    2, 0x02,   57 /* Public */,
      42,    0,  285,    2, 0x02,   59 /* Public */,
      43,    2,  286,    2, 0x02,   60 /* Public */,
      44,    0,  291,    2, 0x02,   63 /* Public */,
      45,    0,  292,    2, 0x02,   64 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QStringList,    3,
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Double, QMetaType::LongLong, QMetaType::LongLong,   10,   11,   12,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,   15,
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Double, QMetaType::LongLong, QMetaType::LongLong,   10,   19,   12,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,   22,
    QMetaType::Void, QMetaType::QString,    5,

 // slots: parameters
    QMetaType::Void, QMetaType::Int,   25,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::LongLong, QMetaType::LongLong,   11,   12,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 32,   33,
    QMetaType::Void, QMetaType::LongLong, QMetaType::LongLong,   19,   12,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 32,   33,

 // methods: parameters
    QMetaType::Void, QMetaType::Int,   25,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Bool, QMetaType::QString,   15,
    QMetaType::Void, QMetaType::QUrl,   41,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QUrl, QMetaType::QString,   41,   15,
    QMetaType::Void,
    QMetaType::Void,

 // properties: name, type, flags
      46, QMetaType::QString, 0x00015001, uint(3), 0,
      47, QMetaType::QString, 0x00015001, uint(4), 0,
      10, QMetaType::Double, 0x00015001, uint(5), 0,
      48, QMetaType::QString, 0x00015001, uint(6), 0,
      49, QMetaType::QString, 0x00015001, uint(9), 0,
      50, QMetaType::Double, 0x00015001, uint(10), 0,
      51, QMetaType::QString, 0x00015001, uint(11), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject ServerFinder::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_CLASSServerFinderENDCLASS.offsetsAndSizes,
    qt_meta_data_CLASSServerFinderENDCLASS,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_CLASSServerFinderENDCLASS_t,
        // property 'fileContent'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'wifiInfo'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'progress'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'status'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'currentFilePath'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'uploadProgress'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'uploadStatus'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<ServerFinder, std::true_type>,
        // method 'serverAddressesFound'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QStringList &, std::false_type>,
        // method 'errorOccurred'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'serverClose'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'fileContentChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'wifiInfoChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'progressChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<double, std::false_type>,
        QtPrivate::TypeAndForceComplete<qint64, std::false_type>,
        QtPrivate::TypeAndForceComplete<qint64, std::false_type>,
        // method 'statusChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'downloadFinished'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'downloadErrorOccurred'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'currentFilePathChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'uploadProgressChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<double, std::false_type>,
        QtPrivate::TypeAndForceComplete<qint64, std::false_type>,
        QtPrivate::TypeAndForceComplete<qint64, std::false_type>,
        // method 'uploadStatusChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'uploadFinished'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'uploadErrorOccurred'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'searchForServers'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'searchForCloseServers'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'updateWifiInfo'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'onDownloadProgress'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<qint64, std::false_type>,
        QtPrivate::TypeAndForceComplete<qint64, std::false_type>,
        // method 'onFinished'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'onReadyRead'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'onDownloadErrorOccurred'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QNetworkReply::NetworkError, std::false_type>,
        // method 'onUploadProgress'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<qint64, std::false_type>,
        QtPrivate::TypeAndForceComplete<qint64, std::false_type>,
        // method 'onUploadFinished'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'onUploadErrorOccurred'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QNetworkReply::NetworkError, std::false_type>,
        // method 'findServerAddress'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'findServerAddress'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'findClose'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'loadFile'
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'startDownload'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QUrl &, std::false_type>,
        // method 'cancelDownload'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'startUpload'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QUrl &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'cancelUpload'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'clearCache'
        QtPrivate::TypeAndForceComplete<void, std::false_type>
    >,
    nullptr
} };

void ServerFinder::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<ServerFinder *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->serverAddressesFound((*reinterpret_cast< std::add_pointer_t<QStringList>>(_a[1]))); break;
        case 1: _t->errorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 2: _t->serverClose(); break;
        case 3: _t->fileContentChanged(); break;
        case 4: _t->wifiInfoChanged(); break;
        case 5: _t->progressChanged((*reinterpret_cast< std::add_pointer_t<double>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<qint64>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<qint64>>(_a[3]))); break;
        case 6: _t->statusChanged(); break;
        case 7: _t->downloadFinished((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 8: _t->downloadErrorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 9: _t->currentFilePathChanged(); break;
        case 10: _t->uploadProgressChanged((*reinterpret_cast< std::add_pointer_t<double>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<qint64>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<qint64>>(_a[3]))); break;
        case 11: _t->uploadStatusChanged(); break;
        case 12: _t->uploadFinished((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 13: _t->uploadErrorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 14: _t->searchForServers((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 15: _t->searchForCloseServers(); break;
        case 16: _t->updateWifiInfo(); break;
        case 17: _t->onDownloadProgress((*reinterpret_cast< std::add_pointer_t<qint64>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<qint64>>(_a[2]))); break;
        case 18: _t->onFinished(); break;
        case 19: _t->onReadyRead(); break;
        case 20: _t->onDownloadErrorOccurred((*reinterpret_cast< std::add_pointer_t<QNetworkReply::NetworkError>>(_a[1]))); break;
        case 21: _t->onUploadProgress((*reinterpret_cast< std::add_pointer_t<qint64>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<qint64>>(_a[2]))); break;
        case 22: _t->onUploadFinished(); break;
        case 23: _t->onUploadErrorOccurred((*reinterpret_cast< std::add_pointer_t<QNetworkReply::NetworkError>>(_a[1]))); break;
        case 24: _t->findServerAddress((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 25: _t->findServerAddress(); break;
        case 26: _t->findClose(); break;
        case 27: { bool _r = _t->loadFile((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 28: _t->startDownload((*reinterpret_cast< std::add_pointer_t<QUrl>>(_a[1]))); break;
        case 29: _t->cancelDownload(); break;
        case 30: _t->startUpload((*reinterpret_cast< std::add_pointer_t<QUrl>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[2]))); break;
        case 31: _t->cancelUpload(); break;
        case 32: _t->clearCache(); break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 20:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QNetworkReply::NetworkError >(); break;
            }
            break;
        case 23:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QNetworkReply::NetworkError >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (ServerFinder::*)(const QStringList & );
            if (_t _q_method = &ServerFinder::serverAddressesFound; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)(const QString & );
            if (_t _q_method = &ServerFinder::errorOccurred; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)();
            if (_t _q_method = &ServerFinder::serverClose; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)();
            if (_t _q_method = &ServerFinder::fileContentChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)();
            if (_t _q_method = &ServerFinder::wifiInfoChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)(double , qint64 , qint64 );
            if (_t _q_method = &ServerFinder::progressChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 5;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)();
            if (_t _q_method = &ServerFinder::statusChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 6;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)(const QString & );
            if (_t _q_method = &ServerFinder::downloadFinished; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 7;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)(const QString & );
            if (_t _q_method = &ServerFinder::downloadErrorOccurred; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 8;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)();
            if (_t _q_method = &ServerFinder::currentFilePathChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 9;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)(double , qint64 , qint64 );
            if (_t _q_method = &ServerFinder::uploadProgressChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 10;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)();
            if (_t _q_method = &ServerFinder::uploadStatusChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 11;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)(const QString & );
            if (_t _q_method = &ServerFinder::uploadFinished; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 12;
                return;
            }
        }
        {
            using _t = void (ServerFinder::*)(const QString & );
            if (_t _q_method = &ServerFinder::uploadErrorOccurred; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 13;
                return;
            }
        }
    }else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<ServerFinder *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->fileContent(); break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->wifiInfo(); break;
        case 2: *reinterpret_cast< double*>(_v) = _t->progress(); break;
        case 3: *reinterpret_cast< QString*>(_v) = _t->status(); break;
        case 4: *reinterpret_cast< QString*>(_v) = _t->currentFilePath(); break;
        case 5: *reinterpret_cast< double*>(_v) = _t->uploadProgress(); break;
        case 6: *reinterpret_cast< QString*>(_v) = _t->uploadStatus(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    } else if (_c == QMetaObject::BindableProperty) {
    }
}

const QMetaObject *ServerFinder::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ServerFinder::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CLASSServerFinderENDCLASS.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ServerFinder::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 33)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 33;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 33)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 33;
    }else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
    return _id;
}

// SIGNAL 0
void ServerFinder::serverAddressesFound(const QStringList & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void ServerFinder::errorOccurred(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void ServerFinder::serverClose()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void ServerFinder::fileContentChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void ServerFinder::wifiInfoChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void ServerFinder::progressChanged(double _t1, qint64 _t2, qint64 _t3)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))), const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t2))), const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t3))) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void ServerFinder::statusChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void ServerFinder::downloadFinished(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 7, _a);
}

// SIGNAL 8
void ServerFinder::downloadErrorOccurred(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 8, _a);
}

// SIGNAL 9
void ServerFinder::currentFilePathChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void ServerFinder::uploadProgressChanged(double _t1, qint64 _t2, qint64 _t3)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))), const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t2))), const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t3))) };
    QMetaObject::activate(this, &staticMetaObject, 10, _a);
}

// SIGNAL 11
void ServerFinder::uploadStatusChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 11, nullptr);
}

// SIGNAL 12
void ServerFinder::uploadFinished(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 12, _a);
}

// SIGNAL 13
void ServerFinder::uploadErrorOccurred(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 13, _a);
}
QT_WARNING_POP
