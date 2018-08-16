import QtQuick 2.0
import QtQuick.Controls 2.4
import "../common" as COMMON


Page {
    header: ToolBar{
        id:toolBar
        contentHeight:30

        COMMON.SettingsIcon {
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //TODO
                }
            }
        }

        //两个链接状态的显示



        Text {
            id: name
            text: qsTr("MAIN")
            anchors.centerIn: parent
        }
    }



}
