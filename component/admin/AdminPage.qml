import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

Page {
    //三个配置，一个确认 一个取消按钮
    GridLayout{
        anchors.centerIn: parent
        columns: 2
        Text {
            text: qsTr("Floor:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        ComboBox{
            id:floor_cbb_input
            model: ["floor1", "floor2", "floor3_wq","floor3_wb"]
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
        }
        Text {
            text: qsTr("WMS IP:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        TextField{
            id:wms_ip_input
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
        }
        Text {
            text: qsTr("WMS PORT:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        TextField{
            id:wms_port_input
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
        }

        Text {
            text: qsTr("DISPATCH IP:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        TextField{
            id:dispatch_ip_input
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
        }
        Text {
            text: qsTr("DISPATCH PORT:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        TextField{
            id:dispatch_port_input
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
        }

        Button{
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            text: "OK"
            onClicked: {
                g_config.setWms_ip(wms_ip_input.text)
                g_config.setWms_port(parseInt(wms_port_input.text))
                g_config.setFloor(floor_cbb_input.currentText)
                g_config.save()
                tipDilog.title = qsTr("请重启程序，使改变生效")
                tipDilog.open()
            }
        }
        Button{
            text: "Cancel"
            onClicked: configSet.close()
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
        }
    }

    Component.onCompleted: {
        var f = g_config.getFloor()
        if(f === "floor1")
            floor_cbb_input.currentIndex = 0;
        else if(f === "floor2")
            floor_cbb_input.currentIndex = 1;
        else if(f === "floor3_wq")
            floor_cbb_input.currentIndex = 2;
        else if(f === "floor3_wb")
            floor_cbb_input.currentIndex = 3;

        wms_ip_input.text = g_config.getWms_ip();
        wms_port_input.text = g_config.getWms_port();
        dispatch_ip_input.text = g_config.getDispatch_ip();
        dispatch_port_input.text = g_config.getDispatch_port();
    }



}
