import QtQuick 2.0

Rectangle {
    id:loadRect
    AnimatedImage {
        id: animated;
        source: "qrc:/gif/loading.gif";
        anchors.centerIn: parent
    }
    Text {
        id: name
        text: qsTr("LOADING config...")
        anchors.horizontalCenter: animated.horizontalCenter
        anchors.top: animated.bottom
    }

    Component.onCompleted: {
        g_config.load()
    }

    Connections{
        target: g_config
        onLoadFail:{
            //载入失败
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
            loadRect.visible = false;
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
