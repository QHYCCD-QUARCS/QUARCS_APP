import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

Dialog {
    id: privacyDialog
    title: qsTr("用户须知")
    standardButtons: Dialog.NoButton
    width: 400  // 设置弹窗宽度
    height: 250 // 设置弹窗高度
    focus: false // 确保弹窗不显示键盘
    font.family: (Qt.platform.os === "ios") ?"PingFang SC":""//iOS默认中文字体

    property string currentLanguage: ""
    //property string selectedLanguage: "zh" // 默认语言为中文

    contentItem: Column {
        width: parent.width
        spacing: 10

        ComboBox {
            font.family: (Qt.platform.os === "ios") ?"PingFang SC":""//iOS默认中文字体
            id: languageSelector
            width: parent.width
            model: ["中文", "English"]
            onCurrentIndexChanged: {
                currentLanguage = currentIndex === 0 ? "zh" : "en";
            }
        }

        Text {
            font.family: (Qt.platform.os === "ios")?"PingFang SC":""//iOS默认中文字体
            text: currentLanguage === "zh" ? qsTr("请阅读") : qsTr("Please read")
            wrapMode: Text.WordWrap
            width: parent.width
        }

        Text {
            font.family: (Qt.platform.os === "ios") ?"PingFang SC":""//iOS默认中文字体
            text: currentLanguage === "zh" ? "<a href='https://your-privacy-policy-url.com/zh'>《隐私政策》</a>" : "<a href='https://your-privacy-policy-url.com/en'>Privacy Policy</a>"
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            width: parent.width
            onLinkActivated: function(url) {
                Qt.openUrlExternally(url)
            }
        }

        Text {
            font.family: (Qt.platform.os === "ios") ?"PingFang SC":""//iOS默认中文字体
            text: currentLanguage === "zh" ? qsTr("以继续使用此应用，此应用不存储用户任何个人信息。") : qsTr("to continue using this app. This app does not store any personal information.")
            wrapMode: Text.WordWrap
            width: parent.width
        }
    }

    footer: RowLayout {
        width: parent.width
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            text: currentLanguage === "zh" ? qsTr("拒绝") : qsTr("No")
            Layout.alignment: Qt.AlignCenter
//            background:  {
//                color: control.pressed ? "lightgray" : "red"
//                //Rectangle radius: 5
//            }
            onClicked: {
                privacyDialog.rejected();
            }
        }
        Button {
            text: currentLanguage === "zh" ? qsTr("同意") : qsTr("Yes")
            Layout.alignment: Qt.AlignCenter
//            background: Rectangle {
//                color: control.pressed ? "lightgray" : "green"
//                radius: 5
//            }
            onClicked: {
                privacyDialog.accepted();
            }
        }        
    }

    onAccepted: {
        var db = LocalStorage.openDatabaseSync("AppData", "1.0", "Local storage for app", 100);
        db.transaction(function(tx) {
            tx.executeSql('INSERT OR REPLACE INTO Settings VALUES (?, ?)', ["privacyAccepted", "true"]);
        });
        privacyDialog.visible = false;
        privacyDialog.accepted();
    }

    onRejected: {
        Qt.quit();
    }
}
