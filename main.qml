import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("DongyaoApp")

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
            }
        }

        ToolButton {
            id: setButton
            text: qsTr("库位")
            onClicked: {
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
                    text: qsTr("设置为A")
                    anchors.centerIn: parent
                }
                border.width: 1
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
            }
        }
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
        }

        Floor1{
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setList.visible = false
                }
            }
        }
        Floor2{
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setList.visible = false
                }
            }
        }
        Floor3{
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setList.visible = false
                }
            }
        }
        Task{
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    setList.visible = false
                }
            }
        }
    }

}
