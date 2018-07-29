import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.11
import QtWebSockets 1.1

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("DongyaoApp")

    LoadFrame{
        anchors.fill: parent
        z:100
        visible: true
    }

    header: ToolBar{
        id:toolBar
        contentHeight:30
        Text {
            id: ttitle
            text: qsTr("FLOOR1")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                setList.visible = false
                taskList.visible = false
            }
        }

        ToolButton {
            id: setButton
            text: qsTr("库位")
            onClicked: {
                taskList.visible = false
                setList.visible = !setList.visible
            }

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10

        }

        ToolButton {
            id: taskButton
            text: "任务"
            onClicked: {
                setList.visible = false
                taskList.visible = !taskList.visible
            }

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: setButton.left
            anchors.rightMargin: 10
        }

        ToolButton {
            id: configButton
            text: "\u2630"
            onClicked: {
                setList.visible = false
                taskList.visible = false
                adminPwdInput.open()
            }

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: taskButton.left
            anchors.rightMargin: 10
        }
    }

    Item{
        id:setList
        anchors.right: parent.right
        anchors.top:toolBar.bottom
        width:80
        visible: false
        z:10
        Column{
            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为空")
                    anchors.centerIn: parent
                }

                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }

            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为原材料")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }
            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为包材")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }
            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为空栈板")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }
            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为成品")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }
            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为垃圾")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }
        }
    }

    Item{
        id:taskList
        anchors.right: parent.right
        anchors.top:toolBar.bottom
        anchors.rightMargin: 20
        width:80
        visible: false
        z:10
        Column{
            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为A")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }

            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为B")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }
            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为C")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }
            Rectangle{
                width: 80
                height: 30
                Text {
                    text: qsTr("设置为D")
                    anchors.centerIn: parent
                }
                border.color: "gray"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    //hoverEnabled : true
                    onEntered: {
                        parent.color = "#E5F3FF"
                    }
                    onExited: {
                        parent.color = "white"
                    }
                }
            }
        }
    }

    Popup {
        z:30
        id: adminPwdInput
        width:pwdInput.width*2
        height:pwdInput.height*2.5
        parent:window.contentItem
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 200
            color: "grey"
        }

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
                        configSet.open();
                    }
                }
            }

        }

        enter: Transition {
            NumberAnimation { property: "scale"; from: 0.0; to: 1.0 ;duration: 200}
        }
    }

    Rectangle{
        color:"red"
        anchors.fill: parent





    }

    SwipeView{
        id: swipeView
        anchors.fill: parent
        onCurrentIndexChanged: {
            if(currentIndex == 0){
                ttitle.text = "FLOOR1"
            }else if(currentIndex == 1){
                ttitle.text = "FLOOR2"
            }else if(currentIndex == 2){
                ttitle.text = "FLOOR3"
            }else if(currentIndex == 0){
                ttitle.text = qsTr("任务")
            }

            setList.visible = false
            taskList.visible = false
        }

        Floor1{
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setList.visible = false
                    taskList.visible = false
                }
            }
        }
        Floor2{
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setList.visible = false
                    taskList.visible = false
                }
            }
        }
        Floor3{
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setList.visible = false
                    taskList.visible = false
                }
            }
        }
        Task{
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setList.visible = false
                    taskList.visible = false
                }
            }
        }
    }
}
