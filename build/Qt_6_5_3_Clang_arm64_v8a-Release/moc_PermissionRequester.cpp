/****************************************************************************
** Meta object code from reading C++ file 'PermissionRequester.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.5.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../PermissionRequester.h"
#include <QtCore/qmetatype.h>

#if __has_include(<QtCore/qtmochelpers.h>)
#include <QtCore/qtmochelpers.h>
#else
QT_BEGIN_MOC_NAMESPACE
#endif


#include <memory>

#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'PermissionRequester.h' doesn't include <QObject>."
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
struct qt_meta_stringdata_CLASSPermissionRequesterENDCLASS_t {};
static constexpr auto qt_meta_stringdata_CLASSPermissionRequesterENDCLASS = QtMocHelpers::stringData(
    "PermissionRequester",
    "positionUpdated",
    "",
    "requestPermissions",
    "exitApp"
);
#else  // !QT_MOC_HAS_STRING_DATA
struct qt_meta_stringdata_CLASSPermissionRequesterENDCLASS_t {
    uint offsetsAndSizes[10];
    char stringdata0[20];
    char stringdata1[16];
    char stringdata2[1];
    char stringdata3[19];
    char stringdata4[8];
};
#define QT_MOC_LITERAL(ofs, len) \
    uint(sizeof(qt_meta_stringdata_CLASSPermissionRequesterENDCLASS_t::offsetsAndSizes) + ofs), len 
Q_CONSTINIT static const qt_meta_stringdata_CLASSPermissionRequesterENDCLASS_t qt_meta_stringdata_CLASSPermissionRequesterENDCLASS = {
    {
        QT_MOC_LITERAL(0, 19),  // "PermissionRequester"
        QT_MOC_LITERAL(20, 15),  // "positionUpdated"
        QT_MOC_LITERAL(36, 0),  // ""
        QT_MOC_LITERAL(37, 18),  // "requestPermissions"
        QT_MOC_LITERAL(56, 7)   // "exitApp"
    },
    "PermissionRequester",
    "positionUpdated",
    "",
    "requestPermissions",
    "exitApp"
};
#undef QT_MOC_LITERAL
#endif // !QT_MOC_HAS_STRING_DATA
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_CLASSPermissionRequesterENDCLASS[] = {

 // content:
      11,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,   32,    2, 0x06,    1 /* Public */,

 // methods: name, argc, parameters, tag, flags, initial metatype offsets
       3,    0,   33,    2, 0x02,    2 /* Public */,
       4,    0,   34,    2, 0x02,    3 /* Public */,

 // signals: parameters
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

Q_CONSTINIT const QMetaObject PermissionRequester::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_CLASSPermissionRequesterENDCLASS.offsetsAndSizes,
    qt_meta_data_CLASSPermissionRequesterENDCLASS,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_CLASSPermissionRequesterENDCLASS_t,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<PermissionRequester, std::true_type>,
        // method 'positionUpdated'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'requestPermissions'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'exitApp'
        QtPrivate::TypeAndForceComplete<void, std::false_type>
    >,
    nullptr
} };

void PermissionRequester::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<PermissionRequester *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->positionUpdated(); break;
        case 1: _t->requestPermissions(); break;
        case 2: _t->exitApp(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (PermissionRequester::*)();
            if (_t _q_method = &PermissionRequester::positionUpdated; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
    }
    (void)_a;
}

const QMetaObject *PermissionRequester::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *PermissionRequester::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CLASSPermissionRequesterENDCLASS.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int PermissionRequester::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void PermissionRequester::positionUpdated()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
