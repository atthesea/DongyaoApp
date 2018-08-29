import QtQuick 2.0
import QyhCustomComponent 1.0

Rectangle {
    id:storageTextItem
    //radius:10

    color: "#138FF0"

    property var storageData: null
    property bool isSeleted: false

    signal seletedChanged(string store_no,string storage_no,bool sss)

    //位置和大小
    width: mainWindow.storage_width
    height: mainWindow.storage_height
    x:storageData.x
    y:storageData.y
    z:7

    Text{
        id:showText
        anchors.centerIn: parent
        font.family: "Times New Roman"
        font.pixelSize: parent.width > parent.height ? parent.height * .6 : parent.width * .6
        color: "white";
        styleColor: "white";
        smooth: true
    }

    Component.onCompleted: {
        if(storageData.storage_type === StorageData.STORAGE_TYPE_NULL){
            showText.text = qsTr("空");
        }else if(storageData.storage_type === StorageData.STORAGE_TYPE_MATERIAL){
            showText.text = qsTr("原");
        }else if(storageData.storage_type === StorageData.STORAGE_TYPE_PACKING){
            showText.text = qsTr("包");
        }else if(storageData.storage_type === StorageData.STORAGE_TYPE_TRAY){
            showText.text = qsTr("板");
        }else if(storageData.storage_type === StorageData.STORAGE_TYPE_GARBAGE){
            showText.text = qsTr("垃");
        }else if(storageData.storage_type === StorageData.STORAGE_TYPE_PRODUCT){
            showText.text = qsTr("成");
        }
    }

    Rectangle{
        color: "red"
        x:0
        y:0
        width: parent.width/4
        height: 2
        visible: storageTextItem.isSeleted
    }

    Rectangle{
        color: "red"
        x:0
        y:0
        height: parent.width/4
        width: 2
        visible: storageTextItem.isSeleted
    }

    Rectangle{
        color: "red"
        x:parent.width*3/4
        y:0
        width: parent.width/4
        height: 2
        visible: storageTextItem.isSeleted
    }

    Rectangle{
        color: "red"
        x:parent.width-2
        y:0
        width: 2
        height: parent.width/4
        visible: storageTextItem.isSeleted
    }


    Rectangle{
        color: "red"
        x:0
        y:parent.width*3/4
        width: 2
        height: parent.width/4
        visible: storageTextItem.isSeleted
    }

    Rectangle{
        color: "red"
        x:0
        y:parent.height-2
        width: parent.width/4
        height: 2
        visible: storageTextItem.isSeleted
    }


    Rectangle{
        color: "red"
        x:parent.width-2
        y:parent.height*3/4
        width: 2
        height: parent.width/4
        visible: storageTextItem.isSeleted
    }

    Rectangle{
        color: "red"
        x:parent.width*3/4
        y:parent.height-2
        width: parent.width/4
        height: 2
        visible: storageTextItem.isSeleted
    }

    MouseArea{
        anchors.fill: parent
        onClicked:{
            storageTextItem.isSeleted = !storageTextItem.isSeleted;
            storageTextItem.seletedChanged(storageTextItem.storageData.store_no,storageTextItem.storageData.storage_no,storageTextItem.isSeleted)
        }
    }
    function updateItem(_store_no, _storage_no, _storage_type)
    {
        if(storageData.store_no === _store_no && storageData.storage_no === _storage_no){
            console.log("after:"+_store_no+","+_storage_no+","+_storage_type);
            storageData.storage_type = _storage_type;
            if(storageData.storage_type === StorageData.STORAGE_TYPE_NULL){
                showText.text = qsTr("空");
            }else if(storageData.storage_type === StorageData.STORAGE_TYPE_MATERIAL){
                showText.text = qsTr("原");
            }else if(storageData.storage_type === StorageData.STORAGE_TYPE_PACKING){
                showText.text = qsTr("包");
            }else if(storageData.storage_type === StorageData.STORAGE_TYPE_TRAY){
                showText.text = qsTr("板");
            }else if(storageData.storage_type === StorageData.STORAGE_TYPE_GARBAGE){
                showText.text = qsTr("垃");
            }else if(storageData.storage_type === StorageData.STORAGE_TYPE_PRODUCT){
                showText.text = qsTr("成");
            }
        }
    }

    Connections{
        target: g_serverConnection
        onSig_set_storage_type:{
            updateItem(store_no, storage_no, storage_type)
        }
    }
    Connections{
        target: newMainFrame
        onSig_update_storage_type:{
            updateItem(store_no, storage_no, storage_type)
        }
    }
}
