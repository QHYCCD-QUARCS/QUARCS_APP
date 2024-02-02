import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtWebView 1.1
import QtWebSockets 1.1 // 导入 Qt 网络模块
import CustomTypes 1.0 // 导入 ServerFinder 类所在的命名空间



ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: qsTr("QSCOPE")
    // 创建 ServerFinder 对象
    property var serverFinder: ServerFinder{}
    Component.onCompleted: {
        var serverAddress;
        serverAddress = serverFinder.findServerAddress();//var result   serverAddress
        if (serverAddress != "0.0.0.0"){//null
            console.log("Server found at address:", serverAddress);
            // 在这里执行接下来的逻辑，根据找到服务器的地址做处理
            webView.url = "http://"+serverAddress+":8080";//"http://192.168.2.111:8080";//"http://"+serverAddress+":8080";//"https://stellarium-web.org/";
            webView.visible = true; // 设置 WebView 可见
        } else {
            console.log("Server not found or timeout occurred.");
            // 处理未找到服务器或超时的情况
            /*//dialog.parent = ApplicationWindow;
            //dialog.modal = true;
            //dialog.open();// 调用显示提示框的函数*/
            //showText.text="未连接同网段:"+serverAddress+"请检查WIFI连接！"
            modalDialog.visible=true;
        }
    }


    Rectangle {
        id: modalDialog
        width: 300//parent.width
        height: 200//parent.height
        border {
            color: "black"
            width: 1
        }
        visible: false
        anchors.centerIn: parent
        z: PopupModal
        // 标题栏
        Rectangle {
            width: parent.width
            height: 30
            color: "lightgrey"
            Text {
                anchors.centerIn: parent
                text: "提示"
                font.family: (Qt.platform.os === "ios") ?"PingFang SC":""//iOS默认中文字体
                font.pixelSize: 18
            }
        }
        Item {
            width: parent.width
            height: parent.height - 30 // 减去标题栏的高度
            Text {
                id: showText
                anchors.centerIn: parent
                text: "请检查WIFI连接！"
                font.family: (Qt.platform.os === "ios") ?"PingFang SC":""
                font.pixelSize: 18
            }
            Button {
                anchors {//horizontalCenter: parent.horizontalCenter
                    right: parent.right
                    bottom: parent.bottom//margins: 20
                    rightMargin: 20
                    bottomMargin: 0
                }
                text: "OK"
                onClicked: {// 关闭对话框
                    modalDialog.visible = false;
                    Qt.quit();
                }
            }
        }
    }





    Dialog {
        id: dialog
        title: "提示"
        standardButtons: Dialog.Ok
        Label {
            text: "Please check the WiFi connection and restart the software!!"
        }
        onAccepted: {
            Qt.quit(); // 用户点击 OK 后退出应用程序
        }
    }
    WebView{
        id:webView
        anchors.fill: parent
        visible: false // 初始化时先隐藏 WebView
        //scale: 1 //将页面类似图片放大缩小
//        onLoadingChanged: {
//            if (loadRequest.status === WebView.LoadSucceededStatus) {
//                // Execute JavaScript to set further scaling if needed
//                webview.runJavaScript("document.body.style.zoom = '350%';")
//            }
//        }
        //url:"https://stellarium-web.org/"
    }
}
