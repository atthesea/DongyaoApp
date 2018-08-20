import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import "../common" as COMMON


Rectangle {
    id:loadpageTemp
    signal loadfinish();

    COMMON.QyhHeader{
        id:toolBar

        COMMON.SettingsIcon {
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    pwdInput.text = ""
                    adminPwdInput.open()
                }
            }
        }
    }

    Popup {
        id: adminPwdInput
        parent: loadpageTemp
        width: pwdInput.width*2
        height: pwdInput.height*1.5
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)

        Rectangle{
            color: "grey"
            width: pwdInput.width*2
            height: pwdInput.height*1.5
            anchors.centerIn: parent

            RowLayout{
                anchors.centerIn: parent
                Text {
                    text: qsTr("请输入管理员密码:")
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
                }
                TextField{
                    echoMode:TextInput.Password
                    id:pwdInput
                    maximumLength: 20
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
                    onTextChanged: {
                        if(pwdInput.text === g_config.getAdmin_pwd()){
                            adminPwdInput.close();
                            window.showAdmin()
                        }
                    }
                }
            }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 ;duration: 400}
        }
    }

    AnimatedImage {
        id: animated;
        source: "qrc:/gif/loading.gif";
        anchors.centerIn: parent
    }

    Text {
        id: name
        font.pixelSize: 24
        font.bold: true
        text: qsTr("LOADING config...")
        anchors.horizontalCenter: animated.horizontalCenter
        anchors.top: animated.bottom
    }

    function init(){
        console.debug("load page init")
        g_config.load()
    }

    Connections{
        target: g_config
        onLoadFail:{
            name.text = qsTr("load config fail!!!!")
        }
        onLoadSuccess:{
            name.text = qsTr("connect to dispatch server...")
            msgCenter.init();
        }
    }
    Connections
    {
        target: msgCenter
        onSig_connection_disconnected:{
            name.text = qsTr("lost connect from dispatch server...")
        }
        onSig_connection_connected:{
            name.text = qsTr("connected and login to dispatch server...")
            msgCenter.login(g_config.getUsername(),g_config.getUserpwd())
        }
        onLoginSuccess:{
            name.text = qsTr("load map from dispatch server...")
            msgCenter.mapLoad();
        }
        onMapGetSuccess:{
            name.text = qsTr("sub agv position from dispatch server...")
            msgCenter.subAgvPosition();
        }
        onSubAgvPositionSuccess:{
            name.text = qsTr("sub agv status from dispatch server...")
            msgCenter.subAgvStatus();
        }
        onSubAgvStatusSuccess:{
            name.text = qsTr("sub task info from dispatch server...")
            msgCenter.subTask();
        }
        onSubTaskSuccess:{
            name.text = qsTr("finish ...")
            window.showMain()
        }

        onErr:{
            name.text = qsTr("err："+info)
        }
        onTip:{
            name.text = tipstr
        }
        onSendRequestFail:{
            name.text = qsTr("err：send request fail")
        }
        onWaitResponseTimeOut:{
            name.text = qsTr("err：wait for response time out")
        }
    }
}
