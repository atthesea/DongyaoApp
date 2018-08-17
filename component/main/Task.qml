import QtQuick 2.0
import QtQuick.Controls 2.4
import "../common" as COMMON

Item{
    id:taskView
    anchors.fill: parent
    //右上角有个返回按钮

    COMMON.QyhButton {
        id: backButton
        label: qsTr("Back")
        rotation: 3
        x: parent.width - backButton.width - 6
        y: -backButton.height - 8
        visible: Qt.platform.os !== "android"
    }
    NumberAnimation {
        target: backButton
        property: "y"
        duration: 200
        easing.type: Easing.InOutQuad
        from:-backButton.height - 8
        to:6
        loops: 1
        running:taskView.visible
    }
}
