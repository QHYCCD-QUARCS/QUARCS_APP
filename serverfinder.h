// ServerFinder.h
#ifndef SERVERFINDER_H
#define SERVERFINDER_H

#include <QObject>
#include <QUdpSocket>
#include <QHostAddress>
#include <QElapsedTimer>
#include <QWebSocket>
#include <QFile>
#include <QTextStream>
#include <QJsonObject>
#include <QJsonDocument>  // 如果需要序列化为 JSON 字符串
#include <QNetworkInterface>
#include <QTimer>

#include <QNetworkAccessManager>//下载更新包功能
#include <QNetworkReply>
#include <QStandardPaths>
#include <QDir>
#include <QHttpMultiPart>

#ifdef Q_OS_ANDROID
#include <QPermissions>
#include <QJniObject>// 替代 QAndroidJniObject
#include <QJniEnvironment> // 替代 QAndroidJniEnvironment
#include <QCoreApplication>
#endif

#ifdef Q_OS_IOS
// // Forward declaration for iOS WiFi helper
// class IOSWiFiHelper;
#include <CoreFoundation/CoreFoundation.h>
#include <SystemConfiguration/SystemConfiguration.h>
#endif

#define QHYCCD_SUCCESS                  0
#define QHYCCD_ERROR                    0xFFFFFFFF
class ServerFinder : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fileContent READ fileContent NOTIFY fileContentChanged) // 暴露文件内容属性
    Q_PROPERTY(QString wifiInfo READ wifiInfo NOTIFY wifiInfoChanged) // 确保属性声明

    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    // Q_PROPERTY(QString downloadFilePath READ downloadFilePath NOTIFY downloadFilePathChanged)
    Q_PROPERTY(QString currentFilePath READ currentFilePath NOTIFY currentFilePathChanged)
    Q_PROPERTY(double uploadProgress READ uploadProgress NOTIFY uploadProgressChanged)
    Q_PROPERTY(QString uploadStatus READ uploadStatus NOTIFY uploadStatusChanged)

public:
    explicit ServerFinder(QObject *parent = nullptr);
    ~ServerFinder();
    Q_INVOKABLE void findServerAddress(int timeout = 3000); // 修改为异步函数
    Q_INVOKABLE void findClose();

    Q_INVOKABLE bool loadFile(const QString &filePath); // 文件加载方法
    QString fileContent() const { return m_fileContent; } // 获取文件内容

    QString wifiInfo() const;

    Q_INVOKABLE void startDownload(const QUrl &url);
    Q_INVOKABLE void cancelDownload();
    Q_INVOKABLE void startUpload(const QUrl &url, const QString &filePath);//, const QString &fieldName = "file"
    Q_INVOKABLE void cancelUpload();

    double progress() const { return m_progress; }
    QString status() const { return m_status; }
    // QString downloadFilePath() const { return m_currentFilePath; }
    QString currentFilePath() const { return m_currentFilePath; }
    QString uploadStatus() const { return m_uploadStatus; }
    double uploadProgress() const { return m_uploadProgress; }

    qint64 getDownloadedFileSize() const;
    bool downloadedFileExists() const;
    void cleanupDownload();
    void cleanupUpload();

    void onUploadTimeout();

    Q_INVOKABLE void clearCache();

    signals:
        void serverAddressesFound(const QStringList &addresses);  // 当找到地址时发送信号
        void errorOccurred(const QString &error);  // 如果发生错误则发送错误信号
        void serverClose();
        void fileContentChanged(); // 文件内容变化信号

        void wifiInfoChanged(); // 通知 QML 数据变化

        void progressChanged(double progress, qint64 bytesReceived, qint64 bytesTotal);
        void statusChanged();
        void downloadFinished(const QString &filePath);
        void downloadErrorOccurred(const QString &error);
        // void downloadFilePathChanged();
        void currentFilePathChanged();
        void uploadProgressChanged(double progress, qint64 bytesSent, qint64 bytesTotal);
        void uploadStatusChanged();
        void uploadFinished(const QString &response);
        void uploadErrorOccurred(const QString &error);

public slots:
    void searchForServers(int timeout);
    void searchForCloseServers();

    void updateWifiInfo(); // 手动触发更新

    // void confirmOverwrite(bool overwrite); // 用户确认后的处理

private slots:
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void onFinished();
    void onReadyRead();
    void onDownloadErrorOccurred(QNetworkReply::NetworkError code);
    void onUploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void onUploadFinished();
    void onUploadErrorOccurred(QNetworkReply::NetworkError code);

private:
    QStringList serverAddresses;
    QString m_fileContent; // 存储文件内容

    QString m_wifiInfo="WiFi";
    QTimer m_timer; // 定时检查 WiFi 状态
#ifdef Q_OS_IOS
    IOSWiFiHelper* m_iosWiFiHelper;
#endif

    QNetworkAccessManager m_manager;
    QScopedPointer<QNetworkReply, QScopedPointerDeleteLater> m_reply;
    // QScopedPointer<QNetworkReply, QScopedPointerDeleteLater> m_uploadReply;
    QNetworkReply* m_uploadReply = nullptr;
    QFile m_file;
    double m_progress;
    QString m_status;
    QString m_fileName;
    QUrl m_currentUrl;       // 新增：保存当前下载URL
    QString m_currentFilePath;
    double m_uploadProgress;
    QString m_uploadStatus;
    QHttpMultiPart *m_multiPart;

    QTimer* m_uploadTimeoutTimer;  // 上传超时计时器
    qint64 m_lastBytesSent;       // 记录上次上传的字节数

    QFile file;
#ifdef Q_OS_ANDROID
#endif
};

#endif // SERVERFINDER_H
