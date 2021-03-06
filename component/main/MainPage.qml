import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import "../common" as COMMON
import "./FloorCreate.js" as FloorCreator;

Rectangle {
    id:mainPage
    property var floors:[]
    property var taskpage: null
    property int setBtnX: setBtn.x
    property int taskBtnX: taskBtn.x+taskBtn.width
    property int currentShowFloorIndex: 0

    signal setBtnClick();
    signal taskBtnClick();
    signal currentShowChanged();

    COMMON.QyhHeader{
        id:toolBar

        COMMON.SettingsIcon {
            id:settingBtn
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

        //两个链接状态的显示
        Text {
            id: wmsLabel
            text: qsTr("WMS")
            anchors.verticalCenter: name.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        StatusIndicator {
            id:wmsStatus
            active: g_wmsConnection.getIsConnect()
            color: "green"
            anchors.verticalCenter: wmsLabel.verticalCenter
            anchors.left: wmsLabel.right
            anchors.leftMargin: 10
            Connections{
                target: g_wmsConnection
                onSig_connect:{
                    wmsStatus.active = true
                }
                onSig_disconnect:{
                    wmsStatus.active = false
                }
            }
        }

        Text {
            id: dispatchLabel
            text: qsTr("DISPATCH")
            anchors.verticalCenter: wmsLabel.verticalCenter
            anchors.left: wmsStatus.right
            anchors.leftMargin: 40
        }
        StatusIndicator{
            id:dispatchStatus
            active: msgCenter.getIsConnect()
            color: "green"
            anchors.verticalCenter: wmsLabel.verticalCenter
            anchors.left: dispatchLabel.right
            anchors.leftMargin: 10
        }

        Text {
            id: name
            text: qsTr("MAIN")
            anchors.centerIn: parent
        }


        //TODO:set btn
        Rectangle{
            id:setBtn
            width: setBtnText.width*1.2
            height: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: taskBtn.left
            anchors.rightMargin: 20
            Text {
                id: setBtnText
                text: qsTr("库位设置成▽")
                anchors.centerIn: parent
            }
            color: "#00000000"
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setBtn.color = "#4E505A"
                }
                onReleased: {
                    setBtn.color = "#00000000"
                    mainPage.setBtnClick();
                }
            }
            onXChanged: {
                mainPage.setBtnX = x;
            }
        }

        //TODO:task btn
        Rectangle{
            id:taskBtn
            width: taskBtnText.width*1.2
            height: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: settingBtn.left
            anchors.rightMargin: 20
            Text {
                id: taskBtnText
                text: qsTr("任务▽")
                anchors.centerIn: parent
            }
            color: "#00000000"
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    taskBtn.color = "#4E505A"
                }
                onReleased: {
                    taskBtn.color = "#00000000"
                    mainPage.taskBtnClick();
                }
            }
            onXChanged: {
                mainPage.taskBtnX =  taskBtn.x+taskBtn.width
            }
            onWidthChanged: {
                mainPage.taskBtnX =  taskBtn.x+taskBtn.width
            }
        }
    }

    Popup {
        id: adminPwdInput
        parent: mainPage
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

    SwipeView{
        y:40
        width: parent.width
        height: parent.height-40
        id:floorsSwipeView
        Task{
            id:taskpage
        }
        onCurrentIndexChanged: {
            mainPage.currentShowFloorIndex = currentIndex;
            mainPage.currentShowChanged();
        }
    }

    function init(){
        var floors = msgCenter.getFloors();
        for(var ii = 0;ii<floors.length;++ii){
            FloorCreator.myname = floors[ii].name;
            FloorCreator.myid = floors[ii].myId;
            FloorCreator.pageIndex = ii+1;//task page is index 0
            FloorCreator.createFloorObject();
            if(g_config.getFloorid() === floors[ii].name)
            {
                floorsSwipeView.currentIndex = ii+1;
            }
        }

        //        taskpage.init();
    }

    Connections{
        target: msgCenter
        onSig_connection_connected:{
            dispatchStatus.active = true;
        }

        onSig_connection_disconnected:{
            dispatchStatus.active = false;
        }
    }

    Connections{
        target:g_wmsConnection
        onSig_connect:{
            wmsStatus.active = true;
        }

        onSig_disconnect:{
            wmsStatus.active = false;
        }
    }
}
