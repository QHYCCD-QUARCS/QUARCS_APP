import QtQuick //2.12
import QtQuick.Window //2.12
import QtQuick.Layouts //1.12

import QtQuick.Controls //2.12
import QtWebView //1.1
import QtWebSockets 1.5 // 导入 Qt 网络模块
import CustomTypes 1.0 // 导入 ServerFinder 类所在的命名空间
import QtQuick.LocalStorage 2.0//存储APP的设置

import Qt.labs.folderlistmodel //2.0
import Qt.labs.platform

import Qt.labs.settings 6.0 //Qt.labs.settings 1.0
import QtPositioning 6.5

ApplicationWindow {
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("QUARCS")
    visibility:"FullScreen"//Window.FullScreen兼容QT6  //全屏显示
    flags: Qt.Window | Qt.FramelessWindowHint  //| Qt.MaximizeUsingFullscreenGeometryHint// 设置为无边框窗口

    Image {
        id:bground
        anchors.fill: parent // 图像填充整个窗口
        source: "qrc:/img/Image_BG.png"
        fillMode: Image.Stretch // 拉伸模式
        //opacity: 1.0 // 设置透明度为 1，确保图片完全显示
    }

    // 创建 ServerFinder 对象
    property var serverFinder: ServerFinder{}
    property bool privacyAccepted: false
    // 添加语言切换功能变量，默认英文
    property string currentLanguage: "en"
    property bool isInitialized: false  // 标志，用于控制初始化时不更新数据库
    Settings {
        id: languageSettings
        property string language: "en" // 默认语言
    }
    // 用于跟踪更多的当前页面
    property string currentPage: "setmain"; // 默认更多页面显示主页面-
    // 选中的 IP 地址
    property string selectedIp: "";
    // 在 QML 文件的顶部定义全局变量
    property var ipList: [] //var   全局变量，用于存储 IP 地址列表
    // 定义计时器和变量
    property int elapsedTime: 0  // 用于存储经过的时间（秒）
    // 使用 Qt.labs.folderlistmodel 来读取文件
    property string fileContent: ""
    property real aspectRatio: Screen.width / Screen.height // 定义宽高比变量
    // 添加模式功能变量，默认WIFI模式说明
    //property string currentMode: "wifi"
    property string currentTime: ""// 定义一个属性来存储当前时间
    property string currentLat: "0"//纬度
    property string currentLong: "0"//经度
    property string currentAlt: "0"//海拔

//    // 位置源      QGeoPositionInfoSource
    PositionSource{
        id: positionSource
        active: false // 启用定位
        // updateInterval: 1000  // ms每1秒更新一次
        preferredPositioningMethods: PositionSource.AllPositioningMethods//SatellitePositioningMethods // 使用卫星定位以获取海拔
        onPositionChanged: {
            let coord = position.coordinate
            // console.log("定位方法:", positionSource.positioningMethod)
            // if (positionSource.positioningMethod === PositionSource.NonSatellitePositioningMethod) {
            //         console.log("❌ 使用基站/WiFi定位，不支持海拔测量")
            //     }
            // console.log("原始海拔值:", coord.altitude)
            // console.log("海拔数据类型:", typeof coord.altitude)
            // console.log("海拔原始字符串:", coord.altitude.toString())
            // console.log("海拔垂直精度:", position.verticalAccuracy)
            // console.log("JSON格式:", JSON.stringify({
            //                                           latitude: coord.latitude,
            //                                           longitude: coord.longitude,
            //                                           altitude: coord.altitude,
            //                                           altitudeType: typeof coord.altitude,
            //                                           isValid: !isNaN(coord.altitude) && isFinite(coord.altitude)
            //                                       }))

            currentLat=coord.latitude.toFixed(6)
            currentLong=coord.longitude.toFixed(6)
            // currentAlt=coord.altitude.toFixed(2)
            console.log("定位信息获取Lat.:", coord.latitude, "Long.:", coord.longitude)
            locationLat.text = currentLat === 0?(currentLanguage === "zh" ? qsTr("纬度:未获取") : qsTr("Lat.:Not acquired")):(currentLanguage === "zh" ? qsTr("纬度:"+currentLat): qsTr("Lat.:"+currentLat))
            locationLong.text = currentLong === 0?(currentLanguage === "zh" ? qsTr("经度:未获取") : qsTr("Long.:Not acquired")):(currentLanguage === "zh" ? qsTr("经度:"+currentLong): qsTr("Long.:"+currentLong))
            // locationAlt.text = currentAlt === 0?(currentLanguage === "zh" ? qsTr("海拔:未获取") : qsTr("Alt.:Not acquired")):(currentLanguage === "zh" ? qsTr("海拔:"+currentAlt): qsTr("Alt.:"+currentAlt))
            positionSource.active = false  // 关闭持续更新，只获取一次
        }
        onSourceErrorChanged: {
            if (sourceError === PositionSource.AccessError) {
                console.log("定位权限被拒绝")
                locationLat.text = currentLanguage === "zh" ? qsTr("纬度：无权限") : qsTr("Lat.:No permission");
                locationLong.text = currentLanguage === "zh" ? qsTr("经度：无权限") : qsTr("Long.:No permission");
                // locationAlt.text = currentLanguage === "zh" ? qsTr("海拔：无权限") : qsTr("Alt.:Not permission")
            }
        }
    }

    Component.onCompleted: {
        //获取定位权限
        console.log("Component.onCompleted aspectRatio : ", aspectRatio.toFixed(2),"=",Screen.width,"/",Screen.height)
        positionSource.active = true
        updateTime()
        serverFinder.updateWifiInfo()
        // 在启动时加载保存的语言设置
        if (languageSettings.language !== "") {
            currentLanguage = languageSettings.language
        }
        if (0)//0 Qt.platform.os !== "android" && Qt.platform.os !== "ios")
        {
            var db = LocalStorage.openDatabaseSync("AppData", "1.0", "Local storage for app", 100);
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(key TEXT, value TEXT)');
                var rs = tx.executeSql('SELECT value FROM Settings WHERE key = "privacyAccepted"');
                if (rs.rows.length > 0) {
                    privacyAccepted = rs.rows.item(0).value === "true";
                }
                else {
                    privacyAccepted = false;
                }
            });
            if (!privacyAccepted) {
                privacyPolicyDialog.visible = true;
            }
            else {
                privacyPolicyDialog.visible = false;
                startDialog.visible=true;
            }
        }
        else {
            privacyPolicyDialog.visible = false;//隐私政策显示隐藏
            ipRectangle.visible=false;//IP输入提示隐藏
            webDialog.visible=false;//Web页面设置隐藏
            webViewURL.visible = false;//WebView设置隐藏
            moreDialog.visible=false;//更多页面 隐藏
            locationDialog.visible=false;//经纬度信息页面隐藏
            scanDialog.visible=false;//扫描页面 隐藏
            startDialog.visible=true;
        }
    }

    Timer {
        id: timer
        interval: 1000  // 每秒触发一次
        running: false  // 初始时计时器不运行
        repeat: true  // 使计时器不断重复
        onTriggered: {
            elapsedTime += 1  // 每次触发时增加 1 秒
            if(startDialog.enabled===false){
                startText.text=currentLanguage === "zh" ?qsTr("开启中···"+elapsedTime ):qsTr("Start···"+elapsedTime )
            }
            if(btn_scan.enabled===false){
                btn_scanText.text=currentLanguage === "zh" ?qsTr(""+elapsedTime ):qsTr(""+elapsedTime ) // 更新扫描按钮文本，显示经过的秒数
            }
            if(stackLayout_more.currentIndex === moreDialog.updatePageIndex){//updateRectangle.visible
                btn_update_scanText.text=currentLanguage === "zh" ?qsTr(""+elapsedTime ):qsTr(""+elapsedTime )
            }
            if(webDialog.visible===true  && webViewURL.visible === false){//&& webDialog.enabled===true
                // if(elapsedTime>70 && webViewURL.loadProgress<70){elapsedTime=70}
                bgroundText.text=currentLanguage === "zh" ? qsTr("正在加载中···"+elapsedTime +"秒 ("+webViewURL.loadProgress+"%)"): qsTr("Loading..."+elapsedTime +"s ("+webViewURL.loadProgress+"%)")
                //bgText.text=qsTr("stop"+webDialog.isStopped)
            }
        }
    }
    // 时间更新Timer - 控制时间显示更新
    Timer {
        id: timeUpdateTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered:{
            updateTime()
        }
    }

    //隐私政策
    PrivacyPolicyDialog {
        id: privacyPolicyDialog
        visible: false
        anchors.centerIn: parent
        currentLanguage: currentLanguage
        onAccepted: {
            var db = LocalStorage.openDatabaseSync("AppData", "1.0", "Local storage for app", 100);
            db.transaction(function(tx) {
                tx.executeSql('INSERT OR REPLACE INTO Settings VALUES (?, ?)', ["privacyAccepted", "true"]);
            });
            privacyPolicyDialog.visible = false;
        }
        onRejected: {
            Qt.quit();
        }
    }

    Connections {
        target: serverFinder
        function onWifiInfoChanged()
        {
            console.log("serverFinder onWifiInfoChanged is:", serverFinder.wifiInfo)
            wifitext.text="WiFi: "+serverFinder.wifiInfo//currentLanguage ===  : "WiFi C: "+serverFinder.wifiInfo //wifitext.text=serverFinder.wifiInfo
        }
    }
    //主页面
    Rectangle {
        id: startDialog
        anchors.fill: parent
        color:  "transparent"
        // Logo 图标
        Rectangle {
            id: logo
            width: aspectRatio>1.7?parent.width*0.37:parent.width*0.37
            height: aspectRatio>1.7?parent.height*0.14:parent.height*0.14
            anchors.centerIn: parent
            color:"transparent"
            Image {
                id:bc_logo
                anchors.fill: parent // 图像填充整个窗口
                source: "qrc:/img/Image_BG_logo.png" //bc_logofillMode: Image.Stretch // 拉伸模式
                fillMode: Image.PreserveAspectFit
            }
        }
        //取消开始按钮，点击任意位置进入
        MouseArea {
            width: parent.width
            height: parent.height*0.8
            x: 0
            y:parent.height*0.2
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                elapsedTime = 0;  // 重置计时
                timer.start();  // 启动计时器
                serverFinder.findServerAddress(3000);  // 设置超时时间为 3000 毫秒
                startDialog.enabled=false;                    //start.visible=true;
                startText.text=currentLanguage === "zh" ?qsTr("开启中···"+0 ):qsTr("Start···"+0)
            }
        }
        //退出按钮
        Button {
            id:btn_quit
            width: aspectRatio>1.7 ?parent.width*100/1334:parent.width*80/1334 //parent.width*100/1334
            height:btn_quit.width*9/10//parent.height*90/750
            anchors {
                top: parent.top
                right: parent.right
            }
            background: Rectangle {
                color: "transparent" // 背景色设置为透明
            }
            Image {
                source: "qrc:/img/Btn_quit.png";
                fillMode: Image.PreserveAspectFit
                width: btn_quit.width *60/100
                height: btn_quit.width *60/100
                anchors {
                    left: parent.left // 图标靠左
                    bottom: parent.bottom // 图标靠下
                    margins: 5 // 适当设置边距，使图标不紧贴按钮边缘
                }
            }
            onClicked: {
                if(Qt.platform.os==="android"){
                    permissionRequester.exitApp();  // 调用 C++ 函数退出应用
                }
                Qt.quit()  // 退出应用
            }
        }
       //定位按钮/**/ //还未实现具体功能，暂时隐藏
        Button {
            id:btn_location
            width:btn_quit.width//parent.width*100/1334
            height:btn_location.width*9/10
            anchors {
                top: parent.top
                left: btn_set.right//parent.left
            }
            background: Rectangle {
                color: "transparent" // 背景色设置为透明
            }
            Image {
                source: "qrc:/img/Btn_location.png";
                fillMode: Image.PreserveAspectFit
                width: btn_quit.width *60/100
                height: btn_quit.width *60/100
                anchors {
                    right: parent.right // 图标靠右
                    bottom: parent.bottom // 图标靠下
                    margins: 5 // 适当设置边距，使图标不紧贴按钮边缘
                }
            }
            onClicked: {
                startDialog.visible=false;
                // scanDialog.visible=false;
                locationDialog.visible=true;
            }
        }
        //设置按钮
        Button {
            id:btn_set
            width: btn_quit.width//parent.width*100/1334
            height:btn_set.width*9/10
            anchors {
                top: parent.top
                left: parent.left//btn_location.right
            }
            background: Rectangle {
                color: "transparent" // 背景色设置为透明
            }
            Image {
                source: "qrc:/img/Btn_set.png";
                fillMode: Image.PreserveAspectFit
                width: btn_quit.width *60/100
                height: btn_quit.width *60/100
                anchors {
                    right: parent.right // 图标靠右
                    bottom: parent.bottom // 图标靠下
                    margins: 5 // 适当设置边距，使图标不紧贴按钮边缘
                }
            }
            onClicked: {
                startDialog.visible=false;
                scanDialog.visible=false;
                moreDialog.visible=true;
            }
        }
        Text{
            id:startText
            font.family: (Qt.platform.os === "ios") ?"PingFang SC":"Roboto"//iOS默认中文字体
            font.pixelSize: aspectRatio>1.7 ?12:18//确保不设置时各平台字体大小一致
            anchors {//anchors.centerIn: parent
                bottom: parent.bottom
                bottomMargin: parent.height * 0.1 // 距离底部的比例边距
                horizontalCenter: parent.horizontalCenter
            }
            text: currentLanguage === "zh" ?qsTr("点击任意位置继续"):qsTr("Click anywhere to continue") //...初始文本
            color: "white"//+Screen.width+"/"+Screen.height+"="+aspectRatio.toFixed(2)   +Screen.width+"/"+Screen.height+"="+aspectRatio.toFixed(2)
        }
        // 监听 serverFinder 的信号，当查找完成时更新按钮文字
        Connections {
            target: serverFinder
            function onServerAddressesFound(addresses){
                if(stackLayout_more.currentIndex != moreDialog.updatePageIndex)
                {
                    startDialog.visible=false;
                    scanDialog.visible=true;
                    timer.stop();  // 停止计时器
                    elapsedTime = 0;  // 重置计时
                    ipList = addresses;
                    updateIPlistshow_color();
                }
            }
            function onErrorOccurred(error) {
                if(stackLayout_more.currentIndex != moreDialog.updatePageIndex)
                {
                    timer.stop();  // 停止计时器
                    elapsedTime = 0;  // 重置计时
                    scanDialog.visible=false;
                    startDialog.visible=true;
                }
            }
        }
        // 设置当 startDialog 从不可见变为可见时重置按钮
        onVisibleChanged: {
            if (visible) {
                startDialog.enabled=true;
                startText.text=currentLanguage === "zh" ?qsTr("点击任意位置继续"):qsTr("Click anywhere to continue")//+aspectRatio+aspectRatio
            }
        }
    }

    //扫描页面
    Rectangle {
        id: scanDialog
        visible: false
        anchors.fill: parent
        color:  "transparent"
        //标题栏
        Rectangle {//1334*70  (0,0)
            id: title
            width:parent.width
            height:aspectRatio>1.7?parent.height*7/75:parent.height*5/75
            x:0
            y:0
            color:  "transparent"
            Image {
                id:scan_title
                anchors.fill: parent // 图像填充整个窗口
                source: "qrc:/img/Scan_title.png" //
                opacity:1
            }
            //返回按钮
            Button{//17*30   (30,20)
                id:btn_scan_back
                width: parent.width*47/1334
                height: parent.height
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                }
                background: Rectangle {
                    color: "transparent" // 背景色设置为透明
                }
                Image {
                    id: btn_Img_scan_back
                    source: "qrc:/img/Btn_back.png"
                    width: title.width*0.013//30 // 图标的大小
                    height: title.height*3/7//30
                    anchors {
                        right: parent.right // 图标靠右
                        verticalCenter: parent.verticalCenter // 图标垂直居中//bottom: parent.bottom // 图标靠下
                        margins: 5 // 适当设置边距，使图标不紧贴按钮边缘
                    }
                }
                onClicked: {
                    scanDialog.visible=false;
                    startDialog.visible=true;
                }
            }
            //标题文字
            Text {  //anchors.verticalCenter: parent.verticalCenter //垂直居中
                anchors.centerIn: parent//anchors.fill: parent     //x: parent.height*0.7
                text:currentLanguage === "zh" ? qsTr("QUARCS服务器连接"): qsTr("QUARCS Server Connection")
                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"                
                color: "white"
                font.pixelSize: aspectRatio>1.7 ?16:24//16
            }
        }
        //内容
        Rectangle {//1274*620  (30,100)
            id: content
            width:parent.width*0.955
            height:aspectRatio>1.7?parent.height*62/75:parent.height*66/75//parent.height*0.826
            y:aspectRatio>1.7?parent.height*10/75:parent.height*7/75//parent.height*2/15
            anchors.horizontalCenter: parent.horizontalCenter//水平居中            //anchors.verticalCenter: parent.verticalCenter //垂直居中
            color:  "transparent"
            Image {
                id:scan_content
                anchors.fill: parent // 图像填充整个窗口
                source: "qrc:/img/Scan_content.png" //
                opacity: 1
            }
            //向导说明
            Rectangle {//680*560  (60,130)--(30,30)
                id: guideRectangle
                width: parent.width*0.534
                height: parent.height*0.9
                x: parent.width*0.024
                y: parent.height*3/62
                color:"transparent"//"red"
                Image {
                    id:scan_guide
                    anchors.fill: parent // 图像填充整个窗口
                    source: "qrc:/img/Scan_guide.png"//scan_guide
                    opacity: 1//0.2
                }
                // (盒子热点模式)
                Rectangle {//680*280  (60,130)
                    id:wifimodeTitle            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                    anchors.top: parent.top         //anchors.topMargin: 10
                    width: guideRectangle.width
                    height: guideRectangle.height / 2-1
                    color: "transparent"
                    Rectangle {//50*50  (90,145)----(30,15)
                        id:wifiModeIcon            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                        width: parent.width*4/68
                        height: wifiModeIcon.width
                        x: parent.width*3/68//aspectRatio>1.7?:parent.width*3/68
                        y: parent.width*1/68//aspectRatio>1.7?parent.height*3/56:parent.height*3/56//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                        color: "transparent"
                        Image {
                            anchors.fill: wifiModeIcon // 背景图像填充整个窗口
                            source: "qrc:/img/guide_wifi.png"//guide_bg
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    Text {  //155,71-----95
                        text:currentLanguage === "zh" ? qsTr("盒子热点模式"): qsTr("StarMaster Pro Wi-Fi Mode")
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                        color: "white"
                        font.pixelSize: aspectRatio>1.7 ?16:24
                        x: aspectRatio>1.7?parent.width*5/34:parent.width*19/136
                        anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                    }
                    Rectangle {//678*1  (61,210)----(1,80)
                        id:wifiModeLine            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                        width: parent.width-1
                        height: 1
                        x: wifimodeTitle.x+0.5
                        y: wifiModeIcon.height+2*wifiModeIcon.y//aspectRatio>1.7?parent.height*2/7:parent.height*2/7
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/img/Scan_guide_line.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    //wifi说明内容
                    Rectangle {
                        width: wifimodeTitle.width*0.95
                        height:parent.height-wifiModeIcon.height-3*wifiModeIcon.y
                        y:wifiModeLine.y+wifiModeLine.height+wifiModeIcon.y//aspectRatio>1.7?parent.height*2/7+wifiModeLine.height+1:parent.height*2/7+wifiModeLine.height+1
                        anchors.horizontalCenter: parent.horizontalCenter//水平居中
                        color:"transparent"
                        ScrollView {
                            clip: true  // 如果文本超出区域，则不显示
                            width: parent.width
                            height: parent.height
                                Text {
                                    id: guideWifiText
                                    width: parent.width
                                    height: parent.height
                                    // textFormat: Text.RichText
                                    wrapMode: Text.Wrap  // 允许文本换行
                                    text:currentLanguage === "zh" ? qsTr("* 手机的WiFi设置为设备所发出的热点WiFi即可使用QUARCS应用\n* 注:该WiFi连接无需密码\n* 未找到实体设备时可点击虚拟设备体验,首次打开时间可能较长,请耐心等待"):
                                                                         qsTr("* Connect your phone to the StarMaster Pro's Wi-Fi hotspot to start using the QUARCS app.\n* No password required for connecting to the Wi-Fi hotspot\n* If physical devices are not detected, you can click on virtual devices to explore the application.\n  Please note that opening the application for the first time may take a little longer. Thank you for your patience.")
                                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                    font.pixelSize: aspectRatio>1.7 ?12:18//确保不设置时各平台字体大小一致//font.pixelSize: aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20//anchors.centerIn: parent
                                    anchors.centerIn: parent
                                    color: "white"
                                }
                            // }
                        }
                    }
                    Rectangle {
                        id:wifi_wlan_Line            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                        width: parent.width-1
                        height: 1
                        x: wifimodeTitle.x+0.5
                        y: wifimodeTitle.height
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/img/Scan_guide_line.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                }
                // (局域网模式)
                Rectangle {//680*280  (60,410)
                    id:wlanmodeTitle            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                    anchors.bottom: guideRectangle.bottom
                    width: guideRectangle.width
                    height: guideRectangle.height / 2-1
                    color: "transparent"
                    Rectangle {//50*50  (90,425)----(30,15)
                        id:wlanModeIcon            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                        width: parent.width*4/68
                        height: wlanModeIcon.width
                        x: parent.width*3/68
                        y: parent.width*1/68//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                        color: "transparent"
                        Image {
                            anchors.fill: wlanModeIcon // guide_bg背景图像填充整个窗口
                            source: "qrc:/img/guide_wlan.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    Text {  //155,71-----95
                        text:currentLanguage === "zh" ? qsTr("局域网模式"): qsTr("WLAN Mode")
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                        color: "white"
                        font.pixelSize:aspectRatio>1.7 ?16:24// aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20                   //anchors.centerIn: parent
                        x: aspectRatio>1.7?parent.width*5/34:parent.width*19/136
                        anchors.verticalCenter: wlanModeIcon.verticalCenter //垂直居中
                    }
                    Rectangle {//678*1  (61,210)----(1,80)
                        id:wlanModeLine            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                        width: parent.width-1
                        height: 1
                        x: wlanmodeTitle.x+0.5
                        y: wlanModeIcon.height+2*wlanModeIcon.y
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/img/Scan_guide_line.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    //wlan说明内容
                    Rectangle {
                        width: parent.width*0.95
                        height:parent.height-1-wlanModeIcon.height-3*wlanModeIcon.y
                        y:wlanModeLine.y+wlanModeLine.height+wlanModeIcon.y
                        anchors.horizontalCenter: parent.horizontalCenter//水平居中
                        color:"transparent"
                        ScrollView {
                            clip: true  // 如果文本超出区域，则不显示
                            width: parent.width
                            height: parent.height
                            // Column {
                                anchors.fill:parent//width: parent.width
                                spacing: 10
                                Text {
                                    id: guideWlanText
                                    wrapMode: Text.Wrap  // 允许文本换行
                                    text:currentLanguage === "zh" ? qsTr("* 设备连接到局域网内,手机连接同局域网的WLAN  即可使用QUARCS应用\n* 未找到实体设备时可点击虚拟设备体验,首次打开时间可能较长,请耐心等待"):
                                                                         qsTr("* Connect your phone and StarMaster Pro to the same WLAN, and QUARCS will work. \n* If physical devices are not detected, you can click on virtual devices to explore the application.\n  Please note that opening the application for the first time may take a little longer. Thank you for your patience.")
                                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                    font.pixelSize: aspectRatio>1.7 ?12:18//确保不设置时各平台字体大小一致//font.pixelSize: aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20//anchors.centerIn: parent
                                    width: parent.width
                                    height: parent.height
                                    anchors.centerIn: parent
                                    color: "white"
                                }
                            // }
                        }
                    }
                }
          }
            //扫描结果 改为按钮，避免点击文字以外的位置无反应
            Button {//324*80   (770,130)--(,30)
                id: result
                width:parent.width*0.254
                height:btn_scan_back.height//parent.height*0.13
                x:guideRectangle.x+guideRectangle.width+guideRectangle.x
                y:guideRectangle.y
                // color:  "transparent"
                Image {
                    id:scan_result
                    anchors.fill: parent
                    source: "transparent"
                }
                background: Image {
                    id:btn_Img_scan_result
                    source: "qrc:/img/Scan_result.png";
                    anchors.fill: parent
                }
                Text {
                    text:currentLanguage === "zh" ? qsTr("未扫到设备 "): qsTr("No Devices Detected")
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    color: "white"
                    font.pixelSize: aspectRatio>1.7 ?14:22//aspectRatio>1.7 ? Screen.width * 0.023 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20                   //anchors.centerIn: parent
                    anchors.centerIn: parent
                }
                onClicked: {
                    ipRectangle.visible=true;
                    scanDialog.enabled=false;
                }
            }
            //扫描按钮
            Button{//170*80
                id: btn_scan
                width:parent.width* 170/1274// *0.14//
                height:result.height
                y:guideRectangle.y
                anchors {
                    right: parent.right
                    rightMargin:guideRectangle.x // 距离右边的比例边距
                }
                Image {
                    id:scan_btn
                    anchors.fill: parent
                    source: "transparent"
                }
                background: Image {
                    id:btn_Img_scan
                    source: "qrc:/img/Btn_bg_scan.png";
                    anchors.fill: parent
                }
                contentItem: Item{
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    Row {
                        width:scan_icon.width + btn_scanText.width + 5
                        height: parent.height
                        anchors.centerIn: parent
                        spacing: 5
                        Image {
                            id:scan_icon
                            source: "qrc:/img/Btn_scan.png";
                            fillMode: Image.PreserveAspectFit
                            width: btn_scan.height *5/16
                            height: btn_scan.height *5/16
                            anchors.verticalCenter: parent.verticalCenter //垂直居中      //visible: true // 初始时可见
                        }
                        // 按钮文字部分
                        Text {
                            id:btn_scanText
                            text:currentLanguage === "zh" ? qsTr("扫描"): qsTr("Scan")
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20
                            color: "white"//verticalAlignment: Text.AlignVCenter//垂直//horizontalAlignment: Text.AlignHCenter//width: parent.width * 0.7  // 只占左侧的 70% 宽度，避免遮挡图案
                            anchors.verticalCenter: parent.verticalCenter //垂直居中//anchors.centerIn: parent
                        }
                    }
                }
                onClicked: {
                    ipList=""
                    updateIPlistshow_color();
                    btn_Img_scan.opacity=0.5//透明
                    elapsedTime = 0;  // 重置计时qsTr(elapsedTime)
                    btn_scanText.text=currentLanguage === "zh" ? qsTr("0"): qsTr("0")
                    btn_scan.enabled=false;
                    btn_scan_back.enabled=false;
                    listContent.enabled=false
                    btn_Img_scan_back.opacity=0.1
                    vdVirDevice.enabled=false
                    btn_Img_scan_vd.opacity=0.4

                    timer.start();  // 开始计时器
                    serverFinder.findServerAddress(3000);  // 设置超时时间为 3000 毫秒
                }
            }
            //扫描结果文字提示
            Rectangle {
                id:scanEndText
                width:parent.width*0.28
                height: vdVirDevice.height
                anchors {
                    top:result.bottom
                    topMargin: parent.height*3/62
                    right: content.right
                    rightMargin:(content.width-guideRectangle.x-guideRectangle.width-scanEndText.width)/2 // 距离右边的比例边距
                }
                color:"transparent"
                Text {
                    id:scan_endText
                    text:""
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20
                    color: "white"                    //anchors.verticalCenter: parent.verticalCenter //垂直居中//
                    anchors.centerIn: parent
                }
            }
            //扫描列表
            Rectangle {//330*280
                id:pdPhyDevice
                width:parent.width*0.261
                height: wifimodeTitle.height
                anchors {
                    bottom: vdVirDevice.top
                    bottomMargin: (vdVirDevice.y-scanEndText.y-scanEndText.height-pdPhyDevice.height)/2
                    right: content.right
                    rightMargin:(content.width-guideRectangle.x-guideRectangle.width-pdPhyDevice.width)/2 // 距离右边的比例边距
                }//     anchors.horizontalCenter: parent.horizontalCenter//水平居中
                color: "transparent"
                // ScrollView包装Text
                ScrollView {
                    clip: true  // 如果文本超出区域，则不显示
                    width: parent.width
                    height: parent.height//*0.9
                    contentHeight: listContent.implicitHeight
                    z:1
                    /**/
                    WebSocket {
                        id: webSocket
                        active: false // 默认不自动连接
                        onStatusChanged:function(status) {
                            console.log("WebSocket connected to:", url," status:",status);
                            if (status === WebSocket.Open) {
                                console.log("WebSocket success:", url);
                                // 启动定时器
                                sendTimer.start();
                                webViewURL.visible = true;
                            }else if (status === WebSocket.Error) {
                                console.error("WebSocket error:", errorString)
                                var errorMsg = currentLanguage === "zh" ?
                                            qsTr("QUARCS 连接已断开，可能是 WiFi 网络自动切换导致，请检查网络设置。") :
                                            qsTr("QUARCS connection lost due to WiFi auto-switching. Please verify network configuration.");
                                webFailRectangle.errorDetail = errorMsg; // 更新错误详情
                                elapsedTime = 0;  // 重置计时
                                timer.stop();
                                sendTimer.stop(); // 停止定时器
                                webFailRectangle.visible = true;
                            }else if (status === WebSocket.Closed) {
                                sendTimer.stop(); // 连接关闭时停止定时器
                            }
                        }
                    }

                    Timer {
                        id: sendTimer
                        interval: 10000 // 10秒
                        repeat: false// 使计时器不断重复
                        triggeredOnStart: false // 立即触发一次
                        onTriggered: {
                            if (webSocket.status === WebSocket.Open) {
                                // 发送坐标数据
                                const data = JSON.stringify({
                                    type: "APP_msg",
                                    time: currentTime,
                                    lat: Number(currentLat),
                                    lon: Number(currentLong),
                                    language: currentLanguage,
                                    wifiname: serverFinder.wifiInfo
                                });

                                if (webSocket.sendTextMessage(data)) {
                                    console.log("webSocket Message sent successfully", data);
                                } else {
                                    console.error("webSocket Failed to send message (connection may not be ready)");
                                }
                            }
                        }
                    }
                    // 显示设备列表，条件是 ipList 不为空
                    Text {
                        id: listContent
                        // z: 1
                        textFormat: Text.RichText
                        wrapMode: Text.Wrap  // 允许文本换行
                        text:""
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                        font.pixelSize: aspectRatio>1.7 ?20:28//aspectRatio>1.7? Screen.width * 0.04 : Screen.width * 0.04
                        width: parent.width
                        height:implicitHeight// parent.height
                        anchors.centerIn: parent  // 确保文本居中显示
                        visible: ipList.length > 0  // 当有设备时显示设备列表
                        onLinkActivated:(link) =>{
                            // if (webSocket.active) {
                            //     webSocket.active = false; // 关闭旧连接
                            // }
                            selectedIp = link;// 更新选中的 IP 地址
                            webViewURL.hasErrorOccurred=false
                            //更新显示打开选中IP网页
                            updateIPlistshow_color();
                            webDialog.visible=true
                            webViewURL.url = "http://" + selectedIp + ":8080";
                        }
                    }
                }
                // 显示图标，条件是 ipList 为空
                Image {
                    id: noDeviceImage
                    source: "qrc:/img/Nolist.png"  // 图标路径
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    visible: ipList.length === 0  // 当没有设备时显示图标
                }
            }
            //虚拟设备 改为按钮，避免点击文字以外的位置无反应
            Button{//330*60
                id: vdVirDevice
                width:parent.width*0.26
                height:btn_scan_back.height//parent.height*0.11
                anchors {
                    bottom: guideRectangle.bottom
                    right: content.right
                    rightMargin:(content.width-guideRectangle.x-guideRectangle.width-vdVirDevice.width)/2 // 距离右边的比例边距
                }
                Image {
                    id:scan_vd
                    anchors.fill: parent
                    source: "transparent"
                }
                background: Image {
                    id:btn_Img_scan_vd
                    source: "qrc:/img/VirtualDevice.png";
                    anchors.fill: parent
                }
                Text {
                    id:vdContent
                    textFormat: Text.RichText
                    text:currentLanguage === "zh" ? qsTr("<a href='virtual_device_link' style='text-decoration: none;'><font color='#006EFF'>虚拟设备 ></font></a>"):
                                                    qsTr("<a href='virtual_device_link'  style='text-decoration: none;'><font color='#006EFF'>Virtual Devices ></font></a>")
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    color: "white"
                    font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.023 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20                   //anchors.centerIn: parent
                    anchors.centerIn: parent
                }
                onClicked: {
                    selectedIp = "8.211.156.247";
                    webDialog.visible=true
                    webViewURL.hasErrorOccurred=false
                    webViewURL.url ="http://" + selectedIp + ":8080";
                }
            }
        }
        // 监听 serverFinder 的信号，当查找完成时更新按钮文字
        Connections {
            target: serverFinder
            function onServerAddressesFound(addresses){
                btn_scanText.text = currentLanguage === "zh" ? qsTr("扫描"): qsTr("Scan");
                btn_scan.enabled = true;
                btn_Img_scan.opacity=1;
                btn_scan_back.enabled=true;
                listContent.enabled=true;
                btn_Img_scan_back.opacity=1;
                vdVirDevice.enabled=true
                btn_Img_scan_vd.opacity=1
                timer.stop();  // 停止计时器
                elapsedTime = 0;  // 重置计时
                ipList = addresses//serverFinder.serverAddresses;
                selectedIp=""
                updateIPlistshow_color();
            }
            function onErrorOccurred(error) {
                btn_scanText.text = currentLanguage === "zh" ? qsTr("扫描"): qsTr("Scan");
                btn_scan.enabled = true;
                btn_Img_scan.opacity=1;
                btn_scan_back.enabled=true;
                btn_Img_scan_back.opacity=1;
                timer.stop();  // 停止计时器
                elapsedTime = 0;  // 重置计时
                listContent.text= currentLanguage === "zh" ? qsTr("扫描错误"):qsTr("Scan Error")
            }
        }
        onVisibleChanged:{
            if(visible){                
                selectedIp=""
                updateIPlistshow_color();
                btn_scanText.text=currentLanguage === "zh" ? qsTr("扫描"): qsTr("Scan")
                // btn_scan.clicked()//避免更换wifi后列表不更新问题
                scanDialog.enabled=true;
                startDialog.visible=false;
            }
        }
    }

    //IP提示框
    Rectangle {
        id: ipRectangle
        visible: false
        anchors.fill: parent
        color:  "transparent"
        Image {
            id:bg_IP
            anchors.fill: parent
            source: "qrc:/img/IP_bg.png"//scan_IPbg   Scan_result
            fillMode: Image.Stretch // 拉伸模式//  fillMode: Image.PreserveAspectFit//
            opacity:1
        }
        Rectangle {
            id: ipConncet//visible: false
            color:  "transparent"
            width: parent.width*520/1334
            height: aspectRatio>1.7 ? parent.height*411/750:parent.height*261/750//parent.height*411/750
            anchors.centerIn: parent//anchors.horizontalCenter: parent.horizontalCenter//anchors.verticalCenter: parent.verticalCenter
            Image {            //id:bg_IP
                anchors.fill: parent // 图像填充整个窗口
                source: "qrc:/img/IP_ImgBg.png"
                fillMode: Image.Stretch//fillMode: Image.PreserveAspectFit
                opacity:1
            }
            //IP图标
            Rectangle {
                id:ipIcon            //anchors.horizontalCenter: parent.horizontalCenter//水平居中//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                width: parent.width*5/52
                height: ipIcon.width
                x: parent.width*3/52
                y: aspectRatio>1.7 ? parent.height*15/411:parent.height*7/261 //parent.height*15/411
                color: "transparent"
                Image {
                    anchors.fill: ipIcon // guide_bg背景图像填充整个窗口
                    source: "qrc:/img/IP_icon.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
            //IP文字标题
            Text {
                text:currentLanguage === "zh" ? qsTr("请输入设备IP"): qsTr("Input Device IP")
                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                color: "white"
                font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 //anchors.centerIn: parent
                x:parent.width*108/520
                anchors.verticalCenter: ipIcon.verticalCenter //垂直居中
            }
            //IP分割线
            Rectangle {
                id:ipLine            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                width: parent.width-2//ipConncet.width*518/520//ipRectangle.width*518/1334//parent.width-2
                height: 1
                anchors{
                    left:parent.left
                    right: parent.right
                    leftMargin: 1
                    rightMargin: 1
                }
                y: parent.height*80/411
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: "qrc:/img/IP_line.png"
                    fillMode: Image.Stretch//
                    //fillMode: Image.PreserveAspectFit
                }
            }
            //IP输入框
            Rectangle {
                width: parent.width*400/520
                height:parent.height*80/411
                x:parent.width*60/520
                y:parent.height*141/411
                anchors.horizontalCenter: parent.horizontalCenter//水平居中
                color:"transparent"
                Image {            //id:bg_IP
                    anchors.fill: parent // 图像填充整个窗口
                    source: "qrc:/img/IP_input.png"
                    fillMode: Image.Stretch//fillMode: Image.PreserveAspectFit
                    opacity:1
                }
                TextInput {
                    id: ipAddressInput
                    anchors.fill: parent
                    font.pixelSize: aspectRatio>1.7 ?16:20//16//Screen.width * 0.024//34  //focus: visible
                    text: "" // 初始化为空
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    inputMethodHints: Qt.ImhPreferNumbers // 数字键盘
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    padding: 0
                    // 当内容改变时更新按钮状态
                    onTextChanged: {
                        // 使用正则表达式移除汉字字符var newText = ipAddressInput.text.replace(/[\u4e00-\u9fa5。]/g, ''); // 移除所有汉字字符
                        var newText = ipAddressInput.text.replace(/[^0-9.]/g, ''); // 只允许数字和点号
                        ipAddressInput.text = newText; // 更新文本内容
                        // 当输入框内容发生变化时，判断是否输入超过最大长度
                        if (ipAddressInput.text.length > 15) {
                            ipAddressInput.text = ipAddressInput.text.substring(0, 15); // 只保留前15个字符
                        }
                        ipButton.enabled = validateIP(ipAddressInput.text.trim())
                    }
                }
                Text {
                    anchors.centerIn: parent//anchors.fill: ipAddressInput
                    font.pixelSize:aspectRatio>1.7 ?16:20//Screen.width * 0.024
                    text: currentLanguage === "zh" ? qsTr("示例:") + "192.168.1.1" : qsTr("eg.") + "192.168.1.1"
                    color: "grey"
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    visible: ipAddressInput.text.trim() === "" // 当输入框为空时显示
                }
            }
            //取消按钮
            Button {
                id: cancelButton
                width:parent.width*180/520
                height:parent.height*80/411
                y:parent.height*271/411
                anchors {
                    left: parent.left
                    leftMargin:parent.width*60/520
                }
                Image {
                    id:btn_cancel
                    anchors.fill: parent
                    source: "transparent"
                }
                background: Image {
                    id:btn_Img_IP
                    source: "qrc:/img/IP_Btn_enable.png";
                    fillMode: Image.Stretch//fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }
                Text{
                    text: currentLanguage === "zh" ? qsTr("取消"): qsTr("Cancel")
                    color: "white"
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    font.pixelSize:aspectRatio>1.7 ?16:24//Screen.width * 0.025
                    anchors.centerIn: parent
                }
                onClicked: {
                    ipRectangle.visible = false
                    scanDialog.enabled=true
                }
            }
            //连接按钮
            Button {
                id: ipButton
                enabled: false
                width:parent.width*180/520
                height:parent.height*80/411
                y:parent.height*271/411
                anchors {
                    right: parent.right
                    rightMargin:parent.width*60/520
                }
                Image {
                    id:btn_conncet
                    anchors.fill: parent
                    source: "transparent"
                }
                background: Image {
                    id:btn_Img_IPc
                    source: ipButton.enabled===true?"qrc:/img/IP_Btn_enable.png":"qrc:/img/IP_Btn_disable.png"
                    fillMode: Image.Stretch//fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }
                Text{
                    text: currentLanguage === "zh" ? qsTr("连接") : qsTr("Conncet")
                    color: "white"
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    font.pixelSize: aspectRatio>1.7 ?16:24//Screen.width * 0.025
                    anchors.centerIn: parent
                }
                onClicked: {
                    var userInput = ipAddressInput.text.trim();
                    if (validateIP(userInput)) {
                        scanDialog.visible=false;
                        ipRectangle.visible=false;
                        // if (webSocket.active) {
                        //     webSocket.active = false; // 关闭旧连接
                        // }
                        selectedIp=userInput
                        webViewURL.hasErrorOccurred=false
                        webDialog.visible=true
                        webViewURL.url = "http://" + selectedIp +":8080";
                        elapsedTime = 0;  // 重置计时
                        timer.start();  // 开始计时器
                    }
                }
            }
        }
    }

    //设置页面
    Rectangle {
        id: moreDialog
        visible: false
        anchors.fill: parent
        color:  "transparent"
        property int mainPageIndex: 0
        property int helpPageIndex: 1
        property int aboutPageIndex: 2
        property int updatePageIndex: 3
        property int agreementPageIndex: 4
        property int policyPageIndex: 5
        //标题栏
        Rectangle {//1334*70  (0,0)
            id: set_title
            width:parent.width
            height:aspectRatio>1.7?parent.height*7/75:parent.height*5/75
            x:0
            y:0
            color:  "transparent"
            Image {
                id:set_bg_title
                anchors.fill: parent // 图像填充整个窗口
                source: "qrc:/img/Scan_title.png"
                opacity:1
            }
            //返回按钮
            Button{//17*30   (30,20)
                id:btn_set_back
                width: parent.width*47/1334
                height: parent.height
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                }
                background: Rectangle {
                    color: "transparent" // 背景色设置为透明
                }
                Image {
                    id: btn_Img_set_back
                    source: "qrc:/img/Btn_back.png"
                    width: title.width*0.013//30 // 图标的大小
                    height: title.height*3/7//30
                    anchors {
                        right: parent.right // 图标靠右
                        verticalCenter: parent.verticalCenter // 图标垂直居中//bottom: parent.bottom // 图标靠下
                        margins: 5 // 适当设置边距，使图标不紧贴按钮边缘
                    }
                }
                onClicked: {
                    downloadProgress.value=0
                    progressText.text=""
                    downloadStatusText.text=""
                    progressText.visible=false
                    downloadStatusText.visible=false
                    if(stackLayout_more.currentIndex === moreDialog.helpPageIndex ||
                            stackLayout_more.currentIndex === moreDialog.aboutPageIndex ||
                            stackLayout_more.currentIndex === moreDialog.agreementPageIndex ||
                            stackLayout_more.currentIndex === moreDialog.policyPageIndex){
                        // 返回主页面
                        stackLayout_more.currentIndex = moreDialog.mainPageIndex
                        set_title_text.text = currentLanguage === "zh" ? qsTr("设置") : qsTr("Set up")
                    }
                    else if(stackLayout_more.currentIndex === moreDialog.updatePageIndex) {
                        // 从更新页面返回到关于页面
                        stackLayout_more.currentIndex = moreDialog.aboutPageIndex
                        set_title_text.text = currentLanguage === "zh" ? qsTr("关于") : qsTr("About")
                    }
                    else {
                        // 从主设置页面返回
                        moreDialog.visible = false
                        startDialog.visible = true
                    }
                }
            }
            //标题文字
            Text {  //anchors.verticalCenter: parent.verticalCenter //垂直居中
                id:set_title_text
                anchors.centerIn: parent//anchors.fill: parent     //x: parent.height*0.7
                text: currentLanguage === "zh" ? qsTr("设置"):qsTr("Set up")
                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                color: "white"
                font.pixelSize:aspectRatio>1.7 ?16:24// aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20
            }
        }
        //内容栏
        Rectangle {//1274*620  (30,100)
            id:set_connect
            width: parent.width*1274/1334
            height: aspectRatio>1.7?parent.height*62/75:parent.height*66/75
            x: parent.width*30/1334
            y:aspectRatio>1.7?parent.height*10/75:parent.height*7/75
            color:  "transparent"
            // 设置背景图
            Image {
                source: "qrc:/img/Set_bg.png"
                anchors.fill: parent
                fillMode: Image.Stretch // 拉伸模式//opacity:1
            }
            StackLayout{
                id: stackLayout_more
                anchors.fill: parent
                currentIndex: 0
                onCurrentIndexChanged:{
                    if (stackLayout_more.currentIndex === moreDialog.updatePageIndex) {
                        // 更新页面特有的初始化逻辑
                        btn_update_scan.clicked()
                        set_title_text.text=currentLanguage === "zh" ? qsTr("更新"): qsTr("Update")
                        downlodPathtext.text=currentLanguage === "zh" ?("✓   下载已完成 \n     请连接设备网络 ，将更新包发送给指定的设备，发送过程请勿断开连接 \n     等待设备接收完成后在页面进行更新。更新完成后重新使用\n     更新包存储位置:"+serverFinder.currentFilePath)
                                                                     :( "✓   Download Complete \n     Connect to device network,Transfer update (don't disconnect) \n     Complete the update on the device itself ,Restart the app after update \n     Package location: "+serverFinder.currentFilePath)
                    }else if (stackLayout_more.currentIndex === moreDialog.aboutPageIndex) {
                        downloadProgress.value=0
                        progressText.text=""// downloadStatusText.text=""
                        progressText.visible=false
                        downloadStatusText.visible=false
                    }
                }
                //设置主页内容0
                Rectangle{
                    id: mainPage
                    color: "transparent"
                    //设置区域
                    Rectangle {//(1210*520)  (60,130)---(30,30)
                        id:set_main
                        width: set_connect.width *1210/ 1274
                        height: set_connect.height*52 / 62
                        x: set_connect.width*30/ 1274
                        y: set_connect.height*3/62
                        color: "transparent"
                        Image {
                            source: "qrc:/img/Set_bg_main.png"
                            anchors.fill: parent
                            fillMode: Image.Stretch // 拉伸模式
                        }
                        //语言设置图标
                        Rectangle {//100*103  //50*50  (90,157)---(30,27)
                            id:set_languageIcon            //anchors.horizontalCenter: parent.horizontalCenter//水平居中//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                            width: parent.width*10/121
                            height: parent.height*103/520
                            anchors{
                                top:parent.top
                                left: parent.left
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_lanIcon.png";
                                fillMode: Image.PreserveAspectFit
                                width: set_languageIcon.width *5/8
                                height: set_languageIcon.height *50/103//set_languageIcon.height *23/50//anchors.centerIn:ipIcon// parent
                                anchors.centerIn: set_languageIcon
                            }
                        }
                        //语言设置文字
                        Text {
                            text:currentLanguage === "zh" ? qsTr("语言设置"): qsTr("Language setting")
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            color: "white"
                            font.pixelSize:aspectRatio>1.7 ?16:24// aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 //anchors.centerIn: parent
                            x:set_languageIcon.width
                            anchors.verticalCenter: set_languageIcon.verticalCenter //垂直居中
                        }
                        //语言切换
                        ComboBox {
                            width: set_languageIcon.width*2
                            height: set_languageIcon.height
                            anchors{
                                top:parent.top
                                right: parent.right
                                rightMargin: set_languageIcon.width*3/8
                            }
                            // 自定义边框
                            background: Rectangle {
                                anchors.fill: parent
                                color: "transparent"  // 背景透明
                            }
                            model: ["English", "中文"]
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02
                            popup.font.pixelSize: aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02
                            popup.font.family:  (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                             // 使用 Component.onCompleted 来设置 currentIndex
                            Component.onCompleted: {
                                currentIndex = (currentLanguage === "en") ? 0 : 1;
                            }
                            onCurrentTextChanged: { // 语言切换逻辑
                                currentLanguage = currentIndex === 0 ? "en" : "zh";
                                languageSettings.language =currentLanguage
                                saveLanguageSettings()
                                // changeLanguage(currentLanguage)
                                set_title_text.text = currentLanguage === "zh" ? qsTr("设置") : qsTr("Set up");
                            }
                            // 自定义下拉框箭头图标
                            indicator: Item {
                                height:parent.height*0.1//10/103
                                anchors.verticalCenter: parent.verticalCenter //垂直居中
                                anchors.right: parent.right      //anchors.rightMargin: set_languageIcon.width*3/8  // 设置右侧间距，确保箭头不超出边界
                                Image {
                                    height: parent.height//*0.1
                                    anchors.right:parent.right //anchors.verticalCenter: parent.verticalCenter //垂直居中  //anchors.rightMargin: set_languageIcon.width*3/8
                                    source: "qrc:/img/set_combox.png"  //自定义箭头图标
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }
                        //分割线01
                        Rectangle {
                            id:setLine01
                            width: parent.width-2-set_languageIcon.width *3/8
                            height: 1
                            anchors{
                                left:parent.left
                                right: parent.right
                                leftMargin: set_languageIcon.width
                                rightMargin: set_languageIcon.width *3/8
                            }
                            y: set_languageIcon.height
                            color: "transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc:/img/IP_line.png"
                                fillMode: Image.Stretch
                            }
                        }

                        //帮助图标
                        Rectangle {
                            id:set_helpIcon            //anchors.horizontalCenter: parent.horizontalCenter//水平居中//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                            width: set_languageIcon.width
                            height: set_languageIcon.height
                            anchors{
                                top:set_languageIcon.bottom
                                left: parent.left
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_helpIcon.png";
                                fillMode: Image.PreserveAspectFit
                                width: set_helpIcon.width *5/8
                                height: set_helpIcon.height *50/103
                                anchors.centerIn: set_helpIcon
                            }
                        }
                        //帮助文字
                        Text {
                            text:currentLanguage === "zh" ? qsTr("帮助"): qsTr("Help")
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            color: "white"
                            font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 //anchors.centerIn: parent
                            x:set_helpIcon.width
                            anchors.verticalCenter: set_helpIcon.verticalCenter //垂直居中
                        }
                        //箭头图标
                        Rectangle {
                            width: set_languageIcon.width
                            height: set_languageIcon.height
                            anchors{
                                right: parent.right
                                rightMargin: set_languageIcon.width *3/8
                                top:set_languageIcon.bottom
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_right.png"  //自定义箭头图标
                                height: parent.height*0.2
                                anchors.right:parent.right
                                anchors.verticalCenter: parent.verticalCenter //垂直居中
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                        //分割线02
                        Rectangle {
                            id:setLine02
                            width: parent.width-2-set_languageIcon.width *3/8
                            height: 1
                            anchors{
                                left:parent.left
                                right: parent.right
                                leftMargin: set_helpIcon.width
                                rightMargin: set_languageIcon.width *3/8
                            }
                            y: set_helpIcon.y+set_helpIcon.height
                            color: "transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc:/img/IP_line.png"
                                fillMode: Image.Stretch
                            }
                        }
                        MouseArea {
                            width: set_main.width
                            height: set_languageIcon.height
                            anchors{
                                top:set_languageIcon.bottom
                                left: parent.left
                            }
                            onClicked: {
                                // stackLayout_more.currentIndex = 1 // 跳转到帮助页面
                                // currentPage="help"
                                stackLayout_more.currentIndex = moreDialog.helpPageIndex
                                set_title_text.text=currentLanguage === "zh" ? qsTr("帮助中心"): qsTr("Help Center")
                            }
                        }

                        //关于图标
                        Rectangle {
                            id:set_aboutIcon            //anchors.horizontalCenter: parent.horizontalCenter//水平居中//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                            width: set_languageIcon.width
                            height: set_languageIcon.height
                            anchors{
                                top:set_helpIcon.bottom
                                left: parent.left
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_aboutIcon.png";
                                fillMode: Image.PreserveAspectFit
                                width: set_aboutIcon.width *5/8
                                height: set_aboutIcon.height *50/103//set_languageIcon.height *23/50//anchors.centerIn:ipIcon// parent
                                anchors.centerIn: set_aboutIcon
                            }
                        }
                        //关于文字
                        Text {
                            text:currentLanguage === "zh" ? qsTr("关于"): qsTr("About")
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            color: "white"
                            font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 //anchors.centerIn: parent
                            x:set_aboutIcon.width
                            anchors.verticalCenter: set_aboutIcon.verticalCenter //垂直居中
                        }
                        //箭头图标
                        Rectangle {
                            width: set_languageIcon.width
                            height: set_languageIcon.height
                            anchors{
                                right: parent.right
                                rightMargin: set_languageIcon.width *3/8
                                top:set_helpIcon.bottom
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_right.png"  //自定义箭头图标
                                height: parent.height*0.2
                                anchors.right:parent.right
                                anchors.verticalCenter: parent.verticalCenter //垂直居中
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                        //分割线03
                        Rectangle {
                            id:setLine03
                            width: parent.width-2-set_languageIcon.width *3/8
                            height: 1
                            anchors{
                                left:parent.left
                                right: parent.right
                                leftMargin: set_languageIcon.width
                                rightMargin: set_languageIcon.width *3/8
                            }
                            y: set_aboutIcon.y+set_aboutIcon.height
                            color: "transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc:/img/IP_line.png"
                                fillMode: Image.Stretch
                            }
                        }
                        MouseArea {
                            width: set_main.width
                            height: set_languageIcon.height
                            anchors{
                                top:set_helpIcon.bottom
                                left: parent.left
                            }
                            onClicked: {
                                serverFinder.updateWifiInfo()
                                stackLayout_more.currentIndex = moreDialog.aboutPageIndex
                                set_title_text.text=currentLanguage === "zh" ? qsTr("关于"): qsTr("About")
                                btn_download.enabled=true
                                progressText.text =""
                                downloadStatusText.text=""
                                progressText.visible=false
                                downloadStatusText.visible=false
                            }
                        }

                        //用户协议图标
                        Rectangle {
                            id:set_uaIcon            //anchors.horizontalCenter: parent.horizontalCenter//水平居中//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                            width: set_languageIcon.width
                            height: set_languageIcon.height
                            anchors{
                                top:set_aboutIcon.bottom
                                left: parent.left
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_uaIcon.png";
                                fillMode: Image.PreserveAspectFit
                                width: set_uaIcon.width *5/8
                                height: set_uaIcon.height *50/103//set_languageIcon.height *23/50//anchors.centerIn:ipIcon// parent
                                anchors.centerIn: set_uaIcon
                            }
                        }
                        //用户协议文字
                        Text {
                            text:currentLanguage === "zh" ? qsTr("用户协议"): qsTr("User Agreement")
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            color: "white"
                            font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 //anchors.centerIn: parent
                            x:set_uaIcon.width
                            anchors.verticalCenter: set_uaIcon.verticalCenter //垂直居中
                        }
                        //箭头图标
                        Rectangle {
                            width: set_languageIcon.width
                            height: set_languageIcon.height
                            anchors{
                                right: parent.right
                                rightMargin: set_languageIcon.width *3/8
                                top:set_aboutIcon.bottom
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_right.png"  //自定义箭头图标
                                height: parent.height*0.2
                                anchors.right:parent.right
                                anchors.verticalCenter: parent.verticalCenter //垂直居中
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                        //分割线04
                        Rectangle {
                            id:setLine04         //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                            width: parent.width-2-set_languageIcon.width *3/8
                            height: 1
                            anchors{
                                left:parent.left
                                right: parent.right
                                leftMargin: set_uaIcon.width
                                rightMargin: set_languageIcon.width *3/8
                            }
                            y: set_uaIcon.y+set_uaIcon.height
                            color: "transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc:/img/IP_line.png"
                                fillMode: Image.Stretch
                            }
                        }
                        MouseArea {
                            width: set_main.width
                            height: set_languageIcon.height
                            anchors{
                                top:set_aboutIcon.bottom
                                left: parent.left
                            }
                            onClicked: {
                                if(currentLanguage === "zh" ){
                                    serverFinder.loadFile("qrc:/img/zh_yhxy.html")//loadFile("zh_yhxy.txt");// loadFile("zh_yhxy.html")
                                } else{
                                    serverFinder.loadFile("qrc:/img/en_yhxy.html");//permissionRequester.loadFile("qrc:/img/en_yhxy.txt");
                                }
                                // mainPage.visible=false;
                                // agreeRectangle.visible=true;
                                // currentPage="agreement"
                                stackLayout_more.currentIndex = moreDialog.agreementPageIndex
                                set_title_text.text=currentLanguage === "zh" ? qsTr("QUARCS应用程序用户协议"): qsTr("QUARCS Application User Agreement")
                            }
                        }

                        //隐私政策图标
                        Rectangle {
                            id:set_ppIcon            //anchors.horizontalCenter: parent.horizontalCenter//水平居中//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                            width: set_languageIcon.width
                            height: set_languageIcon.height
                            anchors{
                                top:set_uaIcon.bottom
                                left: parent.left
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_ppIcon.png";
                                fillMode: Image.PreserveAspectFit
                                width: set_ppIcon.width *5/8
                                height: set_ppIcon.height *50/103
                                anchors.centerIn: set_ppIcon
                            }
                        }
                        //隐私政策文字
                        Text {
                            text:currentLanguage === "zh" ? qsTr("隐私政策"): qsTr("Privacy Policy")
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            color: "white"
                            font.pixelSize: aspectRatio>1.7 ?16:24//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 //anchors.centerIn: parent
                            x:set_ppIcon.width
                            anchors.verticalCenter: set_ppIcon.verticalCenter //垂直居中
                        }
                        //箭头图标
                        Rectangle {
                            width: set_languageIcon.width
                            height: set_languageIcon.height
                            anchors{
                                right: parent.right
                                rightMargin: set_languageIcon.width *3/8
                                top:set_uaIcon.bottom
                            }
                            color: "transparent"
                            Image {
                                source: "qrc:/img/set_right.png"  //自定义箭头图标
                                height: parent.height*0.2
                                anchors.right:parent.right
                                anchors.verticalCenter: parent.verticalCenter //垂直居中
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                        MouseArea {//anchors.fill: parent
                            width: set_main.width
                            height: set_languageIcon.height
                            anchors{
                                top:set_uaIcon.bottom
                                left: parent.left
                            }
                            onClicked: {
                                if(currentLanguage === "zh" ){
                                    serverFinder.loadFile("qrc:/img/zh_yszc.html");  //loadFile("zh_yszc.txt");
                                } else{
                                    serverFinder.loadFile("qrc:/img/en_yszc.html");  //loadFile("en_yszc.txt");
                                }
                                // mainPage.visible=false;
                                // policyRectangle.visible=true;
                                // currentPage="policy"
                                stackLayout_more.currentIndex = moreDialog.policyPageIndex
                                set_title_text.text=currentLanguage === "zh" ? qsTr("隐私政策"): qsTr("Privacy Policy")
                            }
                        }
                    }
                    //版权信息区域
                    Rectangle {
                        width: set_connect.width
                        height: set_connect.height*7 / 62
                        //x: set_connect.width*30/ 1274
                        y: set_main.height+set_main.y
                        color: "transparent"
                        //版权信息
                        Text {
                            anchors.centerIn: parent
                            text:currentLanguage === "zh" ? qsTr("Copyright© 2024 光速视觉(北京)科技有限公司(QHYCCD)版权所有")
                                                          : qsTr("Copyright© 2024 Light Speed Vision (Beijing) Co., Ltd.(QHYCCD). All Rights Reserved.")
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            color: "white"
                            font.pixelSize: aspectRatio>1.7 ?12:18  //12//aspectRatio>1.7 ? Screen.width * 0.025 : Screen.width * 0.02 // // 宽屏设备、平板或方屏设备20
                        }
                    }
                }
                //帮助页面1
                Rectangle{
                    id:helpRectangle
                    width: parent.width*0.9
                    height: parent.height
                    anchors.centerIn: parent
                    color: "transparent"
                    // 使用 ScrollView 使文本内容可以滚动
                    ScrollView {
                        anchors.fill: parent//width: parent.width
                        clip: true  // 如果文本超出区域，则不显示
                            Text {
                                text:currentLanguage === "zh" ?
                                         qsTr("1、确保设备通电开机.\n 明确您的使用方式.\n2、盒子热点模式：需确保手机连接设备发出的热点WiFi信号.\n3、局域网模式：确保手机和设备连接同域的WLAN")
                                       :qsTr("1、Ensure that your devices are power on. \n Select the connection mode. \n2、StarMaster Pro Wi-Fi Mode: Ensure your phone is connected to the StarMaster Pro's Wi-Fi hotspot.\n3、WLAN Mode: Ensure both your phone and StarMaster Pro are connected to the same WLAN.")
                                font.pixelSize: aspectRatio>1.7 ?18:24//20
                                color: "white"
                                wrapMode: Text.Wrap
                                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                anchors.left: parent.left
                                anchors.right: parent.right
                            }
                    }
                }
                //关于页面2
                Rectangle{
                    id:aboutRectangle
                    width: parent.width*0.9
                    height: parent.height
                    anchors.centerIn: parent
                    color: "transparent"
                    // 使用 ScrollView 使文本内容可以滚动
                    ScrollView {
                        anchors {
                            top: parent.top
                            bottom: downloadStatus.top  // 关键：留出底部空间给进度条
                        }
                        width: parent.width
                        contentWidth: parent.width
                        contentHeight: innerColumn.implicitHeight
                        clip: true  // 如果文本超出区域，则不显示
                        // 设置一个 Column 用来管理文本内容
                        Column {//ColumnLayout Column
                            id:innerColumn
                            width: parent.width//anchors.fill:parent
                            spacing: 10
                            Text {
                                text: currentLanguage === "zh" ? "应用名称: "+ appName:"APP Name:" + appName
                                font.pixelSize: aspectRatio>1.7 ?16:24//18
                                color: "white"
                                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter  // 设置标题的文本水平居中
                            }
                            Text {
                                text:currentLanguage === "zh" ? "版本: "+appVersion : "Version : "+appVersion
                                font.pixelSize: aspectRatio>1.7 ?16:24
                                color: "white"
                                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                width: parent.width// Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter  // 设置标题的文本水平居中
                            }
                            Text {
                                textFormat: Text.RichText
                                text:currentLanguage === "zh"
                                     ? "备案号: <a href='https://beian.miit.gov.cn'><font color='#006EFF'> 京ICP备18042925号-2A</a>"
                                     : "ICP Registration No.: <a href='https://beian.miit.gov.cn'><font color='#006EFF'>京ICP备18042925号-2A</a> "
                                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                font.pixelSize:aspectRatio>1.7 ?16:24
                                color: "white"
                                // color: "#006EFF"
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter  // 设置标题的文本水平居中
                                onLinkActivated: {
                                    Qt.openUrlExternally(link)
                                }
                            }
                            Text {
                                text:currentLanguage === "zh" ?
                                         qsTr("    该APP版本\n     - 新增定位的获取与显示。\n     - 增加手机时间、WIFI名称的获取与显示。\n ") //   - 增加更新包（设备版本需与更新包匹配）的下载与传输到设备功能。     - Added update package download for the StarMaster Pro (requires version compatibility).
                                       :qsTr("    This APP version\n     - Added location access and display.  \n     - Added phone time and Wi-Fi name  to get and display.  \n")
                                font.pixelSize: aspectRatio>1.7 ?16:24
                                color: "white"
                                width: parent.width  // 必须设置宽度才能换行
                                wrapMode: Text.Wrap
                                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            }
                        }
                    }
                    Column {
                        id: downloadStatus
                        width: parent.width
                        // height: childrenRect.height  // 高度由子项决定，不强制约束
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10  // 距离底部 20px
                        spacing: 5
                        visible: true //false //true
                        RowLayout {
                            width: parent.width
                            spacing: 10
                            Item {
                                Layout.fillWidth: true
                            }
                            Button{
                                id: btn_download
                                property url downloadUrl: "https://www.qhyccd.com/file/repository/latestSoftAndDirver/Driver/QHYCamerasDriver202506031303.zip"
                                //"https://www.qhyccd.com/file/repository/latestSoftAndDirver/Driver/QHYCamerasDriver202506031303.zip"
                                Layout.preferredWidth:aspectRatio>1.7 ? aboutRectangle.width*280/1274:aboutRectangle.width*210/1274//aboutRectangle.width*280/1274
                                Layout.preferredHeight:aspectRatio>1.7 ? btn_set_back.height*1.5:btn_set_back.height//btn_set_back.height*1.5
                                Image {
                                    id:download_btn
                                    source: "transparent"
                                }
                                background: Image {
                                    id:btn_Img_download
                                    source: "qrc:/img/Btn_bg_scan.png";     // anchors.fill: parent
                                }
                                // 按钮文字部分
                                Text {
                                    id:btn_downloadText
                                    text:currentLanguage === "zh" ? qsTr("下载设备更新包"): qsTr("Download update zip")
                                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                    font.pixelSize: aspectRatio>1.7 ?16:20
                                    color: "white"              // anchors.centerIn: parent.Center
                                    // anchors.verticalCenter: parent.verticalCenter
                                    // anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.centerIn: parent
                                }
                                onClicked: {
                                    console.log("Download--- button clicked");
                                    serverFinder.startDownload(downloadUrl)
                                    progressText.visible=true
                                    downloadStatusText.visible=true
                                    btn_set_back.enabled=false;
                                    btn_Img_set_back.opacity=0.1
                                    btn_clear.enabled=false;
                                    btn_Img_clear.opacity=0.3
                                }
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            //清除缓存按钮
                            Button{
                                id: btn_clear
                                visible:false// true //false
                                Layout.preferredWidth:aboutRectangle.width*180/1274
                                Layout.preferredHeight: btn_set_back.height*1.5  // 直接引用 btn_update_scan 的高度
                                Layout.alignment: Qt.AlignRight
                                Layout.rightMargin: parent.width * 30 / 520
                                Image {
                                    id:clear_btn
                                    source: "transparent"
                                }
                                background: Image {
                                    id:btn_Img_clear
                                    source: "qrc:/img/Btn_bg_scan.png";     // anchors.fill: parent
                                }
                                // 按钮文字部分
                                Text {
                                    id:btn_clearText
                                    text:currentLanguage === "zh" ? qsTr("清除缓存"): qsTr("Clear cache")
                                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                    font.pixelSize: aspectRatio>1.7 ?16:20
                                    color: "white"
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                onClicked: {
                                    console.log("Clear--- button clicked");
                                    serverFinder.clearCache();
                                    // btn_set_back.enabled=false;
                                    // btn_Img_set_back.opacity=0.1
                                }
                            }
                        }
                        ProgressBar {
                            id: downloadProgress
                            width: parent.width
                            height: 8
                            from: 0
                            to: 1
                            value:0
                            background: Rectangle {
                                color: "#303030"  //lightgray #303030深灰色背景
                                radius: 3
                            }
                            contentItem: Rectangle {
                                id:contentItem_downloadProgress
                                visible: false
                                width:(downloadProgress.value <= 0) ? 0 : downloadProgress.visualPosition * parent.width
                                height: parent.height
                                color: "#2196F3"  // 蓝色进度
                                radius: 3
                            }
                        }
                        // 使用 RowLayout 让两个 Text 水平排列，并自动调整宽度
                        RowLayout {
                            width: parent.width
                            spacing: 10
                            Text {
                                id: progressText
                                visible: false //true
                                horizontalAlignment: Text.AlignLeft  // 左对齐
                                text:""
                                color: "white"
                                font.pixelSize: aspectRatio>1.7 ?16:24
                                elide: Text.ElideRight   // 如果空间不足，省略右侧内容
                            }
                            Text {
                                id: downloadStatusText
                                visible:false //true
                                Layout.fillWidth: true  // 占据剩余空间
                                horizontalAlignment: Text.AlignHCenter
                                text:""
                                color: "white"
                                font.pixelSize: aspectRatio>1.7 ?16:24
                                elide: Text.ElideRight   // 如果空间不足，省略右侧内容
                            }
                        }
                    }
                    // 监听 serverFinder 的信号，当查找完成时更新按钮文字
                    Connections {
                        target: serverFinder
                        function onDownloadFinished(filePath) {
                            console.log("Download finished:", filePath)
                            // downloadStatusText.text =currentLanguage === "zh" ? "下载完成："+ filePath : "Download finished:"+ filePath
                            btn_download.enabled=true
                            // stackLayout_more.currentIndex = moreDialog.aboutPageIndex
                            stackLayout_more.currentIndex = moreDialog.updatePageIndex
                            sendProgressText.text =""
                            sendStatusText.text=""
                            sendProgressText.visible=false
                            sendStatusText.visible=false
                            btn_clear.enabled=true;
                            btn_Img_clear.opacity=1
                        }
                        function onDownloadErrorOccurred (error) {
                            console.log("Download error:", error)
                            downloadStatusText.text =currentLanguage === "zh" ? "下载错误: " + error: "Error: " + error
                            downloadStatusText.visible = true;
                            btn_download.enabled=true
                            btn_set_back.enabled=true;
                            btn_Img_set_back.opacity=1
                            btn_clear.enabled=true;
                            btn_Img_clear.opacity=1
                        }
                        function onProgressChanged (progress, bytesReceived, bytesTotal) {
                            console.log("Download Progress:", progress)
                            contentItem_downloadProgress.visible=true
                            downloadProgress.value = progress;
                            progressText.text =Math.round(progress * 100) + "% (" +
                                        formatFileSize(bytesReceived) + " / " +
                                        formatFileSize(bytesTotal) + ")";
                            btn_download.enabled=false
                            downloadStatusText.text=""
                        }
                        function onStatusChanged() {
                            console.log("Download Status:", serverFinder.status)
                            if(serverFinder.status==="Downloading")
                            {
                                downloadStatusText.text =currentLanguage === "zh" ? "下载中..." : "Downloading..."                                
                            }
                        }
                    }
                }
                //更新页面3
                Rectangle {
                    id: updateRectangle
                    width: parent.width*0.95
                    height: parent.height
                    anchors.centerIn: parent
                    color: "transparent"
                    ScrollView {
                        anchors {
                            top: parent.top
                        }
                        width: parent.width
                        contentWidth: parent.width
                        contentHeight: updateColumn.implicitHeight
                        clip: true  // 如果文本超出区域，则不显示
                        // 设置一个 Column 用来管理文本内容
                        Column {
                            id:updateColumn
                            width: parent.width//anchors.fill:parent
                            spacing: 5
                            Text {
                                text:currentLanguage === "zh" ? qsTr("更新包下载成功"): qsTr("Update package downloaded successfully")
                                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                color: "white"
                                font.pixelSize: aspectRatio>1.7 ?16:24
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter  // 设置标题的文本水平居中
                            }
                            Text {
                                id:downlodPathtext
                                width: parent.width
                                font.pixelSize:aspectRatio>1.7 ?16:18
                                wrapMode: Text.Wrap
                                text:""
                                color: "white"
                                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            }
                            RowLayout {
                                width: parent.width
                                Text {
                                    id:updateListText
                                    text:currentLanguage === "zh" ? qsTr("请选择更新设备继续下一步"): qsTr("Select Update Device to proceed")
                                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                    color: "white"
                                    font.pixelSize: aspectRatio>1.7 ?16:24
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignHCenter  // 设置标题的文本水平居中
                                }
                                //更新页面的扫描按钮
                                Button{
                                    id: btn_update_scan
                                    Layout.preferredWidth: intoBtn.width  // 显式引用
                                    Layout.preferredHeight: intoBtn.height
                                    Layout.rightMargin: parent.width*60/520
                                    Image {
                                        id:update_scan_btn
                                        anchors.fill: parent
                                        source: "transparent"
                                    }
                                    background: Image {
                                        id:btn_Img_update_scan
                                        source: "qrc:/img/Btn_bg_scan.png";
                                        anchors.fill: parent
                                    }
                                    // 按钮文字部分
                                    Text {
                                        id:btn_update_scanText
                                        text:currentLanguage === "zh" ? qsTr("扫描"): qsTr("Scan")
                                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                        font.pixelSize: aspectRatio>1.7 ?16:20
                                        color: "white"
                                        anchors.centerIn: parent
                                    }
                                    onClicked: {
                                        ipList=""
                                        selectedIp=""
                                        sendBtn.enabled=false
                                        intoBtn.enabled=false
                                        btn_Img_update_scan.opacity=0.5//透明
                                        elapsedTime = 0;
                                        btn_update_scanText.text=currentLanguage === "zh" ? qsTr("0"): qsTr("0")
                                        btn_update_scan.enabled=false;
                                        btn_set_back.enabled=false;
                                        listUpdate.enabled=false
                                        timer.start();  // 开始计时器
                                        serverFinder.findServerAddress(3000);  // 设置超时时间为 3000 毫秒
                                        btn_Img_set_back.opacity=0.1
                                        sendProgressText.text=""
                                        sendStatusText.text=""
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        width: parent.width*0.3
                        height: parent.height -updateColumn.height- sendBtn.height - sendStatus.height-20
                        color: "transparent"
                        anchors {
                            top: updateColumn.bottom
                            bottom: sendBtn.top
                            bottomMargin: 5
                            horizontalCenter: parent.horizontalCenter
                        }
                        ScrollView {
                            clip: true  // 如果文本超出区域，则不显示
                            width: parent.width
                            height: parent.height
                            contentHeight: listUpdate.implicitHeight
                            z:1
                            Text {
                                id: listUpdate
                                textFormat: Text.RichText
                                wrapMode: Text.Wrap
                                text:""
                                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                                font.pixelSize: aspectRatio>1.7 ?20:24//20
                                width: parent.width
                                height:implicitHeight
                                anchors.centerIn: parent
                                visible: ipList.length > 0
                                onLinkActivated:(link) =>{
                                                    selectedIp = link;// 更新选中的 IP 地址
                                                    updateIPlistshow_color();
                                                    sendBtn.enabled=true
                                                }
                            }
                        }
                    }
                    //发送更新包按钮
                    Button {
                        id: sendBtn
                        enabled:selectedIp!== "" && serverFinder.currentFilePath !== ""
                        width:parent.width*180/1274
                        height:aspectRatio>1.7 ? parent.height*80/750 : parent.height*50/750
                        anchors {
                            bottom: sendStatus.top
                            bottomMargin: 5
                            left: parent.left
                            leftMargin:parent.width*60/520
                        }
                        Image {
                            id:btn_sendBtn
                            anchors.fill: parent
                            source: "transparent"
                        }
                        background: Image {
                            id:btn_Img_sendBtn
                            source:sendBtn.enabled ? "qrc:/img/IP_Btn_enable.png" : "qrc:/img/IP_Btn_disable.png";
                            fillMode: Image.Stretch
                            anchors.fill: parent
                        }
                        Text{
                            text: currentLanguage === "zh" ? qsTr("发送更新包"): qsTr("Send")
                            color: "white"
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            font.pixelSize: aspectRatio>1.7 ?16:20
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            // intoBtn.enabled=true//test
                            intoBtn.enabled=false
                            sendBtn.enabled=false
                            btn_Img_sendBtn.opacity=0.5
                            btn_update_scan.enabled=false;
                            btn_Img_update_scan.opacity=0.5
                            btn_set_back.enabled=false;
                            btn_Img_set_back.opacity=0.1
                            listUpdate.enabled=false

                            console.log("用户发送更新包到:", selectedIp);
                            // 确保有选中的IP和文件路径
                            if (selectedIp && serverFinder.currentFilePath) {
                                console.log("用户发送更新包：",serverFinder.currentFilePath);

                                serverFinder.startUpload("http://" + selectedIp + ":8000", serverFinder.currentFilePath)
                                // 调用发送文件的方法
                                // var uploadUrl = "http://192.168.2.45:8000"//"http://"+selectedIp+":8080/upload"  // 替换为实际上传URL
                                // serverFinder.startUpload(uploadUrl, serverFinder.currentFilePath)
                                // 可以添加发送状态提示
                                sendProgressText.text = currentLanguage === "zh" ? "(0%)" : "(0%)";
                                sendProgressText.visible = true;
                                sendStatusText.visible = true;
                                sendStatusText.text = currentLanguage === "zh" ? "正在发送文件到 " + selectedIp: "Sending file to " + selectedIp;
                            }
                        }
                    }
                    //进入设备页面按钮
                    Button {
                        id: intoBtn
                        enabled:false
                        width:parent.width*180/1274
                        height:aspectRatio>1.7 ? parent.height*80/750 : parent.height*50/750//parent.height*80/750
                        anchors {
                            bottom: sendStatus.top
                            bottomMargin: 5
                            right: parent.right
                            rightMargin:parent.width*60/520
                        }
                        Image {
                            id:btn_intoBtn
                            anchors.fill: parent
                            source: "transparent"
                        }
                        background: Image {
                            id:btn_Img_intoBtn
                            source:intoBtn.enabled ? "qrc:/img/IP_Btn_enable.png" : "qrc:/img/IP_Btn_disable.png";
                            fillMode: Image.Stretch
                            anchors.fill: parent
                        }
                        Text{
                            text: currentLanguage === "zh" ? qsTr("进入设备") : qsTr("Into")
                            color: "white"
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            font.pixelSize: aspectRatio>1.7 ?16:20
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            console.log("用户进入设备界面去更新");
                            webViewURL.hasErrorOccurred=false
                            stackLayout_more.currentIndex = moreDialog.mainPageIndex
                            moreDialog.visible=false
                            //更新显示打开选中IP网页
                            updateIPlistshow_color();
                            webDialog.visible=true
                            webViewURL.url = "http://" + selectedIp + ":8080";
                            elapsedTime = 0;  // 重置计时
                            timer.start();  // 开始计时器
                        }
                    }
                    Column {
                        id: sendStatus
                        width: parent.width
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10  // 距离底部 20px
                        spacing: 5
                        visible: true
                        ProgressBar {
                            id: sendProgress
                            width: parent.width
                            height: 8
                            from: 0
                            to: 1
                            value:0
                            background: Rectangle {
                                color: "#303030"  //lightgray #303030深灰色背景
                                radius: 3
                            }
                            contentItem: Rectangle {
                                id:contentItem_sendProgress
                                visible: false
                                width:(sendProgress.value <= 0) ? 0 : sendProgress.visualPosition * parent.width
                                height: parent.height
                                color: "#2196F3"  // 蓝色进度
                                radius: 3
                            }
                        }
                        // 使用 RowLayout 让两个 Text 水平排列，并自动调整宽度
                        RowLayout {
                            width: parent.width
                            spacing: 5
                            Text {
                                id: sendProgressText
                                visible: false //true//
                                horizontalAlignment: Text.AlignLeft  // 左对齐
                                text:""
                                color: "white"
                                font.pixelSize: aspectRatio>1.7 ?16:22
                                elide: Text.ElideRight   // 如果空间不足，省略右侧内容
                            }
                            Text {
                                id: sendStatusText
                                visible:false //true//
                                Layout.fillWidth: true  // 占据剩余空间
                                horizontalAlignment: Text.AlignHCenter
                                text:""
                                color: "white"
                                font.pixelSize: aspectRatio>1.7 ?16:22
                                elide: Text.ElideRight   // 如果空间不足，省略右侧内容
                            }
                        }
                    }
                    // 监听 serverFinder 的信号，当查找完成时更新按钮文字
                    Connections {
                        target: serverFinder
                        function onWifiInfoChanged()
                        {
                            if(stackLayout_more.currentIndex === moreDialog.updatePageIndex){
                                console.log("Upload onWifiInfoChanged is:", serverFinder.wifiInfo)
                                wifitext.text="WiFi: "+serverFinder.wifiInfo
                                btn_update_scan.clicked()
                            }
                        }
                        function onServerAddressesFound(addresses){
                            if(stackLayout_more.currentIndex === moreDialog.updatePageIndex)
                            {
                                btn_update_scanText.text = currentLanguage === "zh" ? qsTr("扫描"): qsTr("Scan");
                                updateListText.text = currentLanguage === "zh" ? qsTr("请选择更新设备继续下一步"): qsTr("Select Update Device to proceed")
                                timer.stop();  // 停止计时器
                                elapsedTime = 0;  // 重置计时
                                ipList = addresses
                                updateIPlistshow_color();
                                btn_update_scan.enabled=true;
                                btn_set_back.enabled=true;
                                listUpdate.enabled=true
                                btn_Img_set_back.opacity=1
                                btn_Img_update_scan.opacity=1
                            }
                        }
                        function onErrorOccurred(error) {
                            if(stackLayout_more.currentIndex === moreDialog.updatePageIndex)//(updateRectangle.visible)
                            {
                                btn_update_scanText.text = currentLanguage === "zh" ? qsTr("扫描"): qsTr("Scan");
                                updateListText.text = currentLanguage === "zh" ? qsTr("设备扫描错误"):qsTr("Scan Error")
                                timer.stop();  // 停止计时器
                                elapsedTime = 0;  // 重置计时
                                ipList=""
                                updateIPlistshow_color();
                                btn_update_scan.enabled=true;
                                btn_set_back.enabled=true;
                                listUpdate.enabled=true
                                btn_Img_set_back.opacity=1
                                btn_Img_update_scan.opacity=1
                            }
                        }
                        function onUploadFinished(response) {
                            if(stackLayout_more.currentIndex === moreDialog.updatePageIndex){
                                console.log("Upload finished:", response)
                                sendStatusText.text = currentLanguage === "zh" ? "上传完成" : "Upload completed"
                                sendProgress.value = 1
                                intoBtn.enabled = true
                                sendBtn.enabled = false
                                btn_Img_sendBtn.opacity=0.5
                                btn_update_scan.enabled=true
                                // btn_Img_update_scan.opacity=1
                                listUpdate.enabled=false
                                btn_set_back.enabled=true;
                                // btn_Img_set_back.opacity=1
                            }
                        }
                        function onUploadProgressChanged(progress, bytesSent, bytesTotal) {
                            if(stackLayout_more.currentIndex === moreDialog.updatePageIndex){
                                console.log("Upload Progress:", progress,bytesSent,bytesTotal)
                                contentItem_sendProgress.visible=true
                                sendProgress.value = progress;
                                sendProgressText.text = Math.round(progress * 100) + "% (" +
                                            formatFileSize(bytesSent) + " / " +
                                            formatFileSize(bytesTotal) + ")"
                                sendBtn.enabled=false
                                btn_Img_sendBtn.opacity=0.5
                                intoBtn.enabled=false
                                btn_update_scan.enabled=false;
                                btn_Img_update_scan.opacity=0.5
                                btn_set_back.enabled=false;
                                btn_Img_set_back.opacity=0.1
                                listUpdate.enabled=false
                            }
                        }
                        function onUploadErrorOccurred(error) {
                            if(stackLayout_more.currentIndex === moreDialog.updatePageIndex){
                                console.log("Upload error:", error)
                                sendStatusText.text = currentLanguage === "zh" ? "上传错误: " + error : "Upload error: " + error
                                sendBtn.enabled = true
                                btn_Img_sendBtn.opacity=1
                                btn_update_scan.enabled=true;
                                btn_Img_update_scan.opacity=1
                                btn_set_back.enabled=true;
                                btn_Img_set_back.opacity=1
                                listUpdate.enabled=true
                                // selectedIp=""
                                intoBtn.enabled=false
                            }
                        }
                    }
                }
                //用户协议页面4
                Rectangle{
                    id:agreeRectangle
                    width: parent.width*0.95
                    height: parent.height
                    anchors.centerIn: parent
                    color: "transparent"
                    /**/
                    // 使用 ScrollView 使文本内容可以滚动
                    ScrollView {
                        width: parent.width
                        height: parent.height
                        contentWidth: parent.width
                        contentHeight: nameyh.implicitHeight
                        clip: true  // 如果文本超出区域，则不显示
                        Text {
                            id: nameyh
                            width: parent.width  // 文本宽度绑定到 ScrollView 的内容宽度
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            font.pixelSize: aspectRatio>1.7 ?16:24  // 添加字体大小
                            color: "white"
                            wrapMode: Text.Wrap  // 允许文本换行//width: parent.width*0.8  // 设置文本宽度，避免超出
                            text: serverFinder.fileContent
                        }
                    }
                    /*
                    WebView{
                        id:webViewyhxy
                        width: parent.width
                        height: parent.height
                        anchors.fill: parent
                        settings.allowFileAccess: true  // 允许加载本地文件
                    }*/
                }
                //隐私政策页面5
                Rectangle{
                    id:policyRectangle
                    width: parent.width*0.95
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter//水平居中
                    color: "transparent"
                    // 使用 ScrollView 使文本内容可以滚动
                    ScrollView {
                        width: parent.width
                        height: parent.height
                        contentWidth: parent.width// 限制内容宽度与 ScrollView 一致
                        contentHeight: nameys.implicitHeight
                        clip: true  // 如果文本超出区域，则不显示
                        Text {
                            id: nameys
                            width: parent.width  // 文本宽度绑定到 ScrollView 的内容宽度
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            font.pixelSize: aspectRatio>1.7 ?16:24  // 添加字体大小
                            color: "white"
                            wrapMode: Text.Wrap
                            text: serverFinder.fileContent
                        }
                    }
                }
            }
        }

        // 确保每次打开时重置到主页面
        onVisibleChanged: {
            if (visible) {
                stackLayout_more.currentIndex = moreDialog.mainPageIndex
                set_title_text.text = currentLanguage === "zh" ? qsTr("设置") : qsTr("Set up")
            }
        }
    }
    // 读取本地文件的辅助函数
    function readLocalFile(path) {
        var file = new XMLHttpRequest();
        file.open("GET", Qt.resolvedUrl("file://" + path), false); // 同步读取
        file.send();
        return file.status === 200 ? file.response : null;
    }

    function formatFileSize(bytes) {
        if (bytes < 1024) return bytes + " B";
        else if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB";
        else if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(1) + " MB";
        else return (bytes / (1024 * 1024 * 1024)).toFixed(1) + " GB";
    }

    //定位与时间信息页面
    Rectangle {
        id: locationDialog
        visible: false
        anchors.fill: parent
        color:  "transparent"
        // 当 visible 从 false 变成 true 时触发
        onVisibleChanged: {
            if (visible) {
                console.log("locationDialog定位页面显示")
                info_title_text.text=currentLanguage === "zh" ? qsTr("时间与定位"):qsTr("Time and Location")
                updateTime()
                positionSource.active = true
                positionSource.update()
            }
        }
        //信息标题栏
        Rectangle {//1334*70  (0,0)
            id: info_title
            width:parent.width
            height:aspectRatio>1.7?parent.height*7/75:parent.height*5/75
            x:0
            y:0
            color:  "transparent"
            Image {
                id:_bg_title
                anchors.fill: parent // 图像填充整个窗口
                source: "qrc:/img/Scan_title.png"
                opacity:1
            }
            //返回按钮
            Button{//17*30   (30,20)
                id:btn__back
                width: parent.width*47/1334
                height: parent.height
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                }
                background: Rectangle {
                    color: "transparent" // 背景色设置为透明
                }
                Image { //id: btn_back_icon
                    source: "qrc:/img/Btn_back.png"
                    width: title.width*0.013//30 // 图标的大小
                    height: title.height*3/7//30
                    anchors {
                        right: parent.right // 图标靠右
                        verticalCenter: parent.verticalCenter // 图标垂直居中//bottom: parent.bottom // 图标靠下
                        margins: 5 // 适当设置边距，使图标不紧贴按钮边缘
                    }
                }
                onClicked: {
                    //info_title_text.text=currentLanguage === "zh" ? qsTr("时间与定位"):qsTr("Time and Location")
                    locationDialog.visible=false;
                    startDialog.visible=true;
                }
            }
            //时间与定位 信息标题文字
            Text {  //anchors.verticalCenter: parent.verticalCenter //垂直居中
                id:info_title_text
                anchors.centerIn: parent//anchors.fill: parent     //x: parent.height*0.7
                text: currentLanguage === "zh" ? qsTr("时间与定位"):qsTr("Time and Location")
                font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                color: "white"
                font.pixelSize:aspectRatio>1.7 ?16:24
            }
        }
        //信息内容栏：经纬度、时间
        Rectangle {//1274*620  (30,100)
            id:info_connect
            width: parent.width*1274/1334
            height: aspectRatio>1.7?parent.height*62/75:parent.height*66/75
            x: parent.width*30/1334
            y:aspectRatio>1.7?parent.height*10/75:parent.height*7/75//parent.height*10/75
            color:  "transparent"
            // 设置背景图
            Image {
                source: "qrc:/img/Set_bg.png"
                anchors.fill: parent
                fillMode: Image.Stretch // 拉伸模式//opacity:1
            }
            //时间\经纬度显示
            Rectangle {//520*411  (center)
                id: timeConncet
                color:  "transparent"
                width: aspectRatio>1.7?parent.width*700/1274:parent.width*500/1274
                height:  aspectRatio>1.7?parent.height*500/620:parent.height*300/620
                anchors.centerIn: parent
                Image {
                    anchors.fill: parent // 图像填充整个窗口
                    source: "qrc:/img/IP_ImgBg.png"
                    fillMode: Image.Stretch
                    opacity:1
                }
                //时间显示文本
                Rectangle {//500*100 (700*500)
                    width: parent.width*5/7
                    height:parent.height*1/5//4/25
                    x:parent.width*100/700
                    y:parent.height*25/500
                    anchors.horizontalCenter: parent.horizontalCenter//水平居中
                    color:"transparent"
                    Image {
                        anchors.fill: parent // 图像填充整个窗口
                        source: "qrc:/img/IP_input.png"
                        fillMode: Image.Stretch
                        opacity:1
                    }
                    Text {
                        anchors.centerIn: parent
                        font.pixelSize:aspectRatio>1.7 ?18:22
                        text:currentTime
                        color: "grey"
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto" //visible: locationInput.text.trim() === "" // 当输入框为空时显示
                    }
                }
                //纬度显示文本
                Rectangle {//500*100 (700*500)
                    width: parent.width*5/7
                    height:parent.height**1/5//4/25
                    x:parent.width*100/700
                    y:parent.height*150/500//130/500
                    anchors.horizontalCenter: parent.horizontalCenter//水平居中
                    color:"transparent"
                    Image {
                        anchors.fill: parent // 图像填充整个窗口
                        source: "qrc:/img/IP_input.png"
                        fillMode: Image.Stretch
                        opacity:1
                    }
                    Text {
                        id:locationLat
                        anchors.centerIn: parent
                        font.pixelSize:aspectRatio>1.7 ?18:22
                        text:currentLat === 0?(currentLanguage === "zh" ? qsTr("纬度:未获取") : qsTr("Lat.:Not acquired")):(currentLanguage === "zh" ? qsTr("纬度:"+currentLat): qsTr("Lat.:"+currentLat))
                        color: "grey"
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto" //visible: locationInput.text.trim() === "" // 当输入框为空时显示
                    }
                }
                //经度显示文本
                Rectangle {//500*100 (700*500)
                    width: parent.width*5/7
                    height:parent.height*1/5//4/25
                    x:parent.width*100/700
                    y:parent.height*250/500//210/500
                    anchors.horizontalCenter: parent.horizontalCenter//水平居中
                    color:"transparent"
                    Image {
                        anchors.fill: parent // 图像填充整个窗口
                        source: "qrc:/img/IP_input.png"
                        fillMode: Image.Stretch
                        opacity:1
                    }
                    Text {
                        id:locationLong
                        anchors.centerIn: parent
                        font.pixelSize:aspectRatio>1.7 ?18:22
                        text:currentLong === 0?(currentLanguage === "zh" ? qsTr("经度：未获取") : qsTr("Long.:Not acquired")):(currentLanguage === "zh" ? qsTr("经度:"+currentLong): qsTr("Long.:"+currentLong))
                        color: "grey"
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto" //visible: locationInput.text.trim() === "" // 当输入框为空时显示
                    }
                }
               /* //海拔显示文本
                Rectangle {//500*100 (700*500)
                    width: parent.width*5/7
                    height:parent.height*4/25
                    x:parent.width*100/700
                    y:parent.height*290/500
                    anchors.horizontalCenter: parent.horizontalCenter//水平居中
                    color:"transparent"
                    Image {
                        anchors.fill: parent // 图像填充整个窗口
                        source: "qrc:/img/IP_input.png"
                        fillMode: Image.Stretch
                        opacity:1
                    }
                    Text {
                        id:locationAlt
                        anchors.centerIn: parent
                        font.pixelSize:aspectRatio>1.7 ?18:22
                        text:currentAlt === 0?(currentLanguage === "zh" ? qsTr("海拔:未获取") : qsTr("Alt.:Not acquired")):(currentLanguage === "zh" ? qsTr("海拔:"+currentAlt): qsTr("Alt.:"+currentAlt))
                        color: "grey"
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    }
                }*/

                //显示WiFi名称
                Rectangle {//500*100 (700*500)
                    width: parent.width*5/7
                    height:parent.height*1/5//4/25
                    x:parent.width*100/700
                    y:parent.height*375/500//395/500
                    anchors.horizontalCenter: parent.horizontalCenter//水平居中
                    color:"transparent"
                    Image {
                        anchors.fill: parent // 图像填充整个窗口
                        source: "qrc:/img/IP_input.png"
                        fillMode: Image.Stretch
                        opacity:1
                    }
                    Text {
                        id:wifitext
                        anchors.centerIn: parent
                        text:""
                        font.pixelSize: aspectRatio>1.7 ?18:22
                        color: "grey"
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    }
                }
                /*
                // //刷新按钮
                // Button {
                //     id: refreshButton
                //     visible: false
                //     width: parent.width*2/7
                //     height:parent.height*80/500
                //     y:parent.height*375/500
                //     anchors {
                //         left: parent.left
                //         leftMargin:parent.width*100/700
                //     }
                //     Image {
                //         id:btn_refresh
                //         anchors.fill: parent
                //         source: "transparent"
                //     }
                //     background: Image {
                //         id:btn_Img_refresh
                //         source: "qrc:/img/IP_Btn_enable.png";
                //         fillMode: Image.Stretch//fillMode: Image.PreserveAspectFit
                //         anchors.fill: parent
                //     }
                //     Text{
                //         text: currentLanguage === "zh" ? qsTr("刷新"): qsTr("Refresh")
                //         color: "white"
                //         font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                //         font.pixelSize: aspectRatio>1.7 ?16:20//Screen.width * 0.025
                //         anchors.centerIn: parent
                //     }
                //     onClicked: {
                //         updateTime()               //permissionRequester.requestPermissions() // 重新请求权限
                //         positionSource.update()
                //     }
                // }*/
                /*
                // //经纬度时间等信息上传服务端
                // Button {
                //     id: uploadButton
                //     visible: false
                //     width: parent.width*2/7
                //     height:parent.height*8/50
                //     y:parent.height*375/500
                //     anchors {
                //         right: parent.right
                //         rightMargin:parent.width*100/700
                //     }
                //     Image {
                //         id:btn_upload
                //         anchors.fill: parent
                //         source: "transparent"
                //     }
                //     background: Image {
                //         id:btn_Img_upload
                //         source: "qrc:/img/IP_Btn_enable.png";
                //         fillMode: Image.Stretch//fillMode: Image.PreserveAspectFit
                //         anchors.fill: parent
                //     }
                //     Text{
                //         text: currentLanguage === "zh" ? qsTr("上传"): qsTr("Upload")
                //         color: "white"
                //         font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                //         font.pixelSize: aspectRatio>1.7 ?16:20//Screen.width * 0.025
                //         anchors.centerIn: parent
                //     }
                //     onClicked: {
                //         //ToDo传递给服务端--经纬度、时间
                //     }
                // }
*/
            }
        }
   }


    function updateIPlistshow_color(){
        // 更新 listContent 的文本，改变选中 IP 的颜色
        var updatedText=""      //var linkText = currentLanguage === "zh" ? qsTr("虚拟设备"):qsTr("Virtual device")
        //var virColor = (selectedIp === "8.211.156.247") ? "white" : "#255db7"; // black如果选中虚拟设备
        if (ipList.length === 0) {
            scan_endText.text=currentLanguage === "zh" ? qsTr("未找到实体设备"):qsTr("No Physical Devices Detected")
        } else {
            // 改变虚拟设备的颜色          //updatedText +=qsTr("<a href='demo' style='color:" +virColor + "'>" +linkText +"</a><br>")
            scan_endText.text=currentLanguage === "zh" ? qsTr("已识别设备列表"):qsTr("Devices Detected")
            ipList.forEach(function(ip,index){// 改变设备列表IP 的颜色
                var color = (ip === selectedIp) ? "white" : "#006EFF"; // #255db7black选中 IP 的颜色
                updatedText += "<a href='" + ip + "' style='color:" + color + "'>" + ip + "</a>";
                // 如果不是最后一个元素，添加 <br> 换行符
                if (index < ipList.length - 1) {updatedText += "<br>";}
            });
        }
        listContent.text = updatedText; // 更新列表内容
        listUpdate.text =updatedText;
    }

    function validateIP(ip) {
        // 简单的IPv4地址校验
        var ipRegExp = /^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$/;
        //var ipRegExp = /^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\:(0-9|[1-9][0-9]{1,4})$/;
        return ipRegExp.test(ip);
    }

    //网页
    Rectangle {
        id: webDialog
        visible: false
        width: parent.width
        height: parent.height
        anchors.fill: parent
        color:  "transparent"
        // 返回按钮（位于WebView的顶部）
        Button {
            id:btn_web_back
            width: parent.width*47/1334
            height: aspectRatio>1.7?parent.height*7/75:parent.height*5/75
            anchors {
                top: parent.top
                left: parent.left
            }
            //visible: false // 初始时隐藏返回按钮，直到网页加载完
            z: 2  // 确保按钮位于WebView之上
            background: Rectangle {
                color: "transparent" // 背景色设置为透明
            }
            Image {
                id: btn_Img_web_back
                source: "qrc:/img/Btn_back.png"
                width: parent.width*17/47
                height: parent.height*3/7
                anchors {
                    right: parent.right // 图标靠右
                    verticalCenter: parent.verticalCenter // 图标垂直居中//bottom: parent.bottom // 图标靠下
                    margins: 5 // 适当设置边距，使图标不紧贴按钮边缘
                }
            }
            onClicked: {
                webViewURL.stop();
                webViewURL.visible = false;  // 隐藏 WebView
                webDialog.visible = false;  // 隐藏对话框
                scanDialog.visible=true;
                scanDialog.enabled=true;
                elapsedTime = 0;  // 重置计时
                timer.stop();  // 停止计时器
                btn_scanText.text = currentLanguage === "zh" ? qsTr("扫描"): qsTr("Scan");
                btn_scan.enabled = true;
                btn_Img_scan.opacity=1;
                btn_scan_back.enabled=true;
                btn_Img_scan_back.opacity=1;
                //isStopped = true;// 设置 isStopped 为 true，表示已经主动停止加载
                webFailRectangle.visible=false;
            }
        }
        Text{
            id:bgroundText
            font.family: (Qt.platform.os === "ios") ?"PingFang SC":"Roboto"//iOS默认中文字体
            font.pixelSize: aspectRatio>1.7 ?12:18//确保不设置时各平台字体大小一致
            x: parent.width / 22
            anchors.bottom: parent.bottom  // 底部对齐父容器的底部
            padding: 20 // 给文本添加一些内边距，使其不紧贴边界
            text: currentLanguage === "zh" ?qsTr("正在加载中···"):qsTr("Loading...") // 初始文本
            color: "white"
            visible: true // 初始时显示进度文本
        }
        //网页显示 WebView  WebEngineView不可用
        WebView{
            id:webViewURL
            width: parent.width
            height: parent.height
            anchors.fill: parent
            z: 1//anchors.centerIn: parent//anchors.fill: parent//
            visible: false // 初始化时先隐藏 WebView
            property bool hasErrorOccurred: false// 新增标志变量，用于记录是否已经处理过错误
            // 监听 loadProgress 信号，更新进度
            onLoadProgressChanged: {
                console.log("onLoadProgressChanged :", webViewURL.url,"xx%:",webViewURL.loadProgress,"hasErrorOccurred:",webViewURL.hasErrorOccurred)//,"Loading changed - Status:",loadRequest.status
                if(!timer.running)
                {
                    bgroundText.text=currentLanguage === "zh" ? qsTr("页面刷新中···" +" ("+webViewURL.loadProgress+"%)"): qsTr("Refreshing..." +" ("+webViewURL.loadProgress+"%)")
                }
                if(webViewURL.loadProgress<74){
                    webViewURL.visible = false;
                    console.log("onLoadProgressChanged :",webViewURL.loadProgress)
                }else{
                    console.log("onLoadProgressChanged   hasErrorOccurred:",webViewURL.hasErrorOccurred)
//                    bgText.text+=qsTr(webViewURL.loadProgress+">74 ")//+isStopped                    
                    if (!webViewURL.hasErrorOccurred) { // 仅当未处理过错误时才检查
                        webViewURL.runJavaScript('
                            var title = document.title;
                            title;  // 返回标题供外部判断  //百度 QUARCS QHYCCD  // return "APP_msg"
                        ', function(result) {
                                if (result && result.includes("QUARCS")) {
                                    webViewURL.runJavaScript(`
                                        window.currentTime = "${currentTime}";
                                        window.currentLat = ${currentLat};
                                        window.currentLong = ${currentLong};
                                        window.currentLanguage= "${currentLanguage}";
                                        window.wifiname= "${serverFinder.wifiInfo}";
                                    `);
                                    if (webViewURL.loadProgress===100){
                                        webViewURL.runJavaScript('
                                            window.qtObj = {
                                                showMessage: function(msg) {
                                                    alert("收到Vue消息:"+ msg);
                                                },
                                                getMyValue: function() {
                                                    return JSON.stringify({
                                                        type: "APP_msg",
                                                        time:window.currentTime,
                                                        lat:window.currentLat,
                                                        lon:window.currentLong,
                                                        language:window.currentLanguage,
                                                        wifiname:window.wifiname,
                                                    });
                                                }
                                            }
                                            window.qtObjInjected = true;
                                            console.log("Injected qtObj:", window.qtObj);
                                        ');
                                        elapsedTime = 0;  // 重置计时
                                        timer.stop();  // 停止计时器
                                        bgroundText.text=currentLanguage === "zh" ? qsTr("加载成功"): qsTr("Load success")
                                        console.log("onLoadProgressChanged :",webViewURL.loadProgress,"success")
                                        webViewURL.visible = true
                                        webViewURL.height = parent.height
                                        webViewURL.y = 0
                                        serverFinder.findClose();
                                    }
                                }
                                else {
                                    if (!webViewURL.hasErrorOccurred) {
                                        webViewURL.hasErrorOccurred = true; // 标记已处理错误
                                        bgroundText.text=currentLanguage === "zh" ? qsTr("加载失败"): qsTr("Load failure")
                                        console.log("onLoadProgressChanged :",webViewURL.loadProgress,"failure")
                                        var errorMsgip = currentLanguage === "zh" ?
                                                    qsTr("请检查IP地址是否正确"):
                                                    qsTr("Please Check the IP address")
                                        webFailRectangle.errorDetail = errorMsgip; // 更新错误详情
                                        webFailRectangle.visible = true;
                                        // webSocket.active = false;
                                    }
                                }
                        });
                    }else{
                        elapsedTime = 0;  // 重置计时
                        timer.stop();  // 停止计时器
                    }
                }
            }

            onLoadingChanged:function(loadRequest){
                console.log(
                            "Loading changed - Status:", loadRequest.status,
                            "Error:", loadRequest.error,
                            "URL:", loadRequest.url
                            )
                var errorMsg="";
                if (loadRequest.status===3) {
                    console.error("onLoadingChanged status=3", loadRequest.errorString)
                    // console.log("1 - Before assignment"); // 调试点1
                    errorMsg = currentLanguage === "zh" ?
                                qsTr("连接超时 (错误代码: %1)").arg(loadRequest.errorString) :
                                qsTr("Connection timed out (Error code: %1)").arg(loadRequest.errorString);
                    webFailRectangle.errorDetail = errorMsg; // 更新错误详情
                    // console.log("2 - After assignment  Error detail set:", errorMsg); // 调试输出
                    webFailRectangle.visible = true;
                }
                else if (loadRequest.error) {
                    console.log("加载失败:", loadRequest.errorString);
                    errorMsg = currentLanguage === "zh" ?
                                qsTr("加载失败 (错误代码: %1)\n 请重试").arg(loadRequest.errorString) :
                                qsTr("Load Failed(Error code: %1)\n Please try again").arg(loadRequest.errorString);
                    webFailRectangle.errorDetail = errorMsg; // 更新错误详情
                    webFailRectangle.visible = true;
                }
            }

        }
        Connections {
            target: serverFinder
            function onServerClose() {
                console.log("onServerClose html->quit")
                timer.stop();  // 停止计时器
                elapsedTime = 0;  // 重置计时
                scanDialog.visible=true;
                webDialog.visible=false;
            }
        }
        onVisibleChanged: {
            if (visible) {
                bgroundText.text=currentLanguage === "zh" ?qsTr("正在加载中···"):qsTr("Loading...")
                elapsedTime = 0;  // 重置计时
                timer.start();  // 开始计时器
                scanDialog.visible=false;
            }
        }
    }

    //加载页面失败提示
    Rectangle {
        id: webFailRectangle
        property string errorDetail: ""
        visible: false
        anchors.fill: parent
        color:  "transparent"
        Image {
            id:bg_webFail
            anchors.fill: parent
            source: "qrc:/img/IP_bg.png"//scan_IPbg   Scan_result
            fillMode: Image.Stretch // 拉伸模式//  fillMode: Image.PreserveAspectFit//
            opacity:1
        }
        Rectangle {
            id: webFailConncet
            color:  "transparent"
            width: parent.width*520/1334
            height: parent.height*411/750
            anchors.centerIn: parent
            Image {            //id:bg_IP
                anchors.fill: parent // 图像填充整个窗口
                source: "qrc:/img/IP_ImgBg.png"
                fillMode: Image.Stretch
                opacity:1
            }
            //标题
            Rectangle {
                id:failTitle            //anchors.horizontalCenter: parent.horizontalCenter//水平居中//anchors.verticalCenter: wifiModeIcon.verticalCenter //垂直居中
                width: parent.width
                height: parent.height*80/411
                color:  "transparent"
                Text {
                    text:currentLanguage === "zh" ? qsTr("错误提示"): qsTr("Error Message")//连接失败Connection Failed
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    color: "white"
                    font.pixelSize:aspectRatio>1.7 ?16:24
                    anchors.centerIn: parent
                }
            }
            //分割线
            Rectangle {
                id:webFailLine            //anchors.horizontalCenter: parent.horizontalCenter//水平居中
                width: parent.width-2
                height: 1
                anchors{
                    left:parent.left
                    right: parent.right
                    leftMargin: 1
                    rightMargin: 1
                }
                y: parent.height*80/411
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: "qrc:/img/IP_line.png"
                    fillMode: Image.Stretch
                }
            }
            //提示内容
            Rectangle {
                width: parent.width*500/520
                height:parent.height*230/411
                x:parent.width*10/52
                y:parent.height*90/411
                anchors.horizontalCenter: parent.horizontalCenter//水平居中
                color:"transparent"
                ScrollView {
                    clip: true  // 如果文本超出区域，则不显示
                    anchors.fill: parent
                        Text {
                            id: errorContentText
                            wrapMode: Text.Wrap  // 允许文本换行
                            text:{return (webFailRectangle.errorDetail ? webFailRectangle.errorDetail : "");}
                            font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                            font.pixelSize: aspectRatio>1.7 ?16:24
                            anchors.left: parent.left
                            anchors.right: parent.right//horizontalAlignment: Text.AlignHCenter  // 设置标题的文本水平居中
                            color: "white"
                        }
                }
            }
            //按钮
            Rectangle {
                id: closeButton
                width:parent.width-2
                height:parent.height*77/411
                y:parent.height*332/411
                anchors.horizontalCenter: parent.horizontalCenter // 水平居中
                radius: 5  // 圆角半径
                color: "#006EFF"
                Button {
                    anchors.fill: parent
                    background: Rectangle {
                        color: "transparent"
                    }
                    Text{
                        text: currentLanguage === "zh" ? qsTr("关闭"): qsTr("Exit")//已知晓Dismiss
                        color: "white"
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                        font.pixelSize: aspectRatio>1.7 ?16:24
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        webFailRectangle.visible = false
                        webDialog.enabled=true
                        webDialog.visible=false
                        scanDialog.visible=true
                        scanDialog.enabled=true

                        btn_scan.clicked()//避免更换wifi后列表不更新问题
                    }
                }
            }
        }

        onVisibleChanged: {
            if(visible){
                elapsedTime = 0;  // 重置计时
                timer.stop();
                webViewURL.visible = false;
                webDialog.enabled=false;
                scanDialog.enabled=false;
            }
        }
    }

    //仅提示页面
    Rectangle {
        id: tipRectangle
        property string errorDetail: ""
        visible: false
        anchors.fill: parent
        color:  "transparent"
        Image {
            id:bg_tip
            anchors.fill: parent
            source: "qrc:/img/IP_bg.png"//scan_IPbg   Scan_result
            fillMode: Image.Stretch // 拉伸模式//  fillMode: Image.PreserveAspectFit//
            opacity:1
        }
        Rectangle {
            id: tipConncet
            color:  "transparent"
            width: parent.width*520/1334
            height: parent.height*411/750
            anchors.centerIn: parent
            Image {            //id:bg_IP
                anchors.fill: parent // 图像填充整个窗口
                source: "qrc:/img/IP_ImgBg.png"
                fillMode: Image.Stretch
                opacity:1
            }
            //标题
            Rectangle {
                id:tipTitle
                width: parent.width
                height: parent.height*80/411
                color:  "transparent"
                Text {
                    text:currentLanguage === "zh" ? qsTr("提示"): qsTr("Tip")
                    font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                    color: "white"
                    font.pixelSize:aspectRatio>1.7 ?16:24
                    anchors.centerIn: parent
                }
            }
            //分割线
            Rectangle {
                id:tipLine 
                width: parent.width-2
                height: 1
                anchors{
                    left:parent.left
                    right: parent.right
                    leftMargin: 1
                    rightMargin: 1
                }
                y: parent.height*80/411
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: "qrc:/img/IP_line.png"
                    fillMode: Image.Stretch
                }
            }
            //提示内容
            Rectangle {
                width: parent.width*500/520
                height:parent.height*230/411
                x:parent.width*10/52
                y:parent.height*90/411
                anchors.horizontalCenter: parent.horizontalCenter//水平居中
                color:"transparent"
                ScrollView {
                    clip: true  // 如果文本超出区域，则不显示
                    anchors.fill: parent
                    Text {
                        id: tipContentText
                        wrapMode: Text.Wrap  // 允许文本换行
                        text:{return (tipRectangle.errorDetail ? tipRectangle.errorDetail : "");}

                            //tipRectangle.errorDetail
                            /*{// 优先显示错误详情（如果有）
                                var baseText = currentLanguage === "zh" ?
                                            qsTr("1、主动中断连接时可重新点击进行连接 \n2、因IP无效加载失败时请输入正确的设备 IP\n3、盒子热点方式:重新连接设备发出的热点WiFi\n4、局域网方式:重新连接设备所连接的同局域网的WLAN\n5、其他情况可重新打开软件或重启手机") :
                                            qsTr("1、The connection is actively interrupted.Click to reconnect.\n2、Loading failed due to an invalid IP.  Please enter the correct StarMaster Pro IP.\n
3、StarMaster Pro Wi-Fi Mode: Reconnect your phone to the StarMaster Pro's Wi-Fi hotspot.\n4、WLAN Mode: Reconnect your phone and StarMaster Pro to the same WLAN. \n
5、If other issues occur, you can reopen the software or restart the phone. ");
                                return (webFailRectangle.errorDetail ? webFailRectangle.errorDetail + "\n\n" : "") + baseText;
                            }*/
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                        font.pixelSize: aspectRatio>1.7 ?16:24
                        anchors.left: parent.left
                        anchors.right: parent.right
                        color: "white"
                    }
                }
            }
            //按钮
            Rectangle {
                id: knowButton
                width:parent.width-2
                height:parent.height*77/411
                y:parent.height*332/411
                anchors.horizontalCenter: parent.horizontalCenter // 水平居中
                radius: 5  // 圆角半径
                color: "#006EFF"
                Button {
                    anchors.fill: parent
                    background: Rectangle {
                        color: "transparent"
                    }
                    Text{
                        text: currentLanguage === "zh" ? qsTr("已知晓"): qsTr("Got it")//已知晓Dismiss
                        color: "white"
                        font.family: (Qt.platform.os === "ios") ? "PingFang SC" : "Roboto"
                        font.pixelSize:aspectRatio>1.7 ?16:24
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        //更新显示打开选中IP网页
                        tipRectangle.visible = false
                        updateIPlistshow_color();
                        webViewURL.visible=true
                        // webSocket.url = "ws://" + selectedIp + ":8600/";
                        // webSocket.active = true;
                    }
                }
            }
        }
    }
    
    function saveLanguageSettings() {
        // 保存当前语言设置
        languageSettings.language = currentLanguage
    }

    // 更新时间函数
    function updateTime() {
        var date = new Date()
        //currentTime = date.toLocaleTimeString(Qt.locale(), "yyyy-MM-dd:hh:mm:ss")
        var curDate = date.toLocaleDateString(Qt.locale(), "yyyy-MM-dd")
        var curTime = date.toLocaleTimeString(Qt.locale(), "hh:mm:ss")
        currentTime = curDate + ":" + curTime  // 中间用空格分隔
    }


}


