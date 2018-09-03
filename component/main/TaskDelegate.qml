import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

ItemDelegate {
    id: delegate
    checkable: true

    contentItem: ColumnLayout {
        spacing: 10

        RowLayout{
            RowLayout{
                Rectangle{
                    id:statusRect
                    width: 10
                    height: 10
                    color: "red"
                    radius: 5
                }
                Label {
                    id:statusLabel
                    text: qsTr("")
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            Label {
                text:qsTr("任务:")+modelData.discribe
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("优先级:")+modelData.priority
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
        GridLayout {
            id: grid
            visible: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 10

            Label {
                text: qsTr("ID:")
                Layout.leftMargin: 60
            }

            Label {
                text: ""+ modelData.myid
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("AGV:")
                Layout.leftMargin: 60
            }

            Label {
                text: ""+modelData.excuteAgv
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("产生时间:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.produceTime
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("开始执行时间:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.doTime
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("完成时间:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.doneTime
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("取消时间:")
                Layout.leftMargin: 60
            }

            Label {
                text:modelData.cancelTime
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("出错时间:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.errorTime
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("出错代码:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.errorCode
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("出错原因:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.errorInfo
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("是否取消:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.isCancel?qsTr("已取消"):qsTr("未取消")
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }

    Component.onCompleted: {
        if(modelData.status === -3){
            statusLabel.text = qsTr("状态:不存在")
            statusRect.color = "grey"
        }else if(modelData.status === -2){
            statusLabel.text = qsTr("状态:待执行")
            statusRect.color = "grey"
        }else if(modelData.status === -1){
            statusLabel.text = qsTr("状态:正在执行")
            statusRect.color = "green"
        }else if(modelData.status === 0){
            statusLabel.text = qsTr("状态:已完成")
            statusRect.color = "blue"
        }else if(modelData.status === 1){
            statusLabel.text = qsTr("状态:失败")
            statusRect.color = "yellow"
        }else if(modelData.status === 2){
            statusLabel.text = qsTr("状态:已取消")
            statusRect.color = "yellow"
        }
    }
}
