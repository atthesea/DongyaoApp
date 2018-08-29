import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtWebSockets 1.1

import "./component/main" as MAIN
import "./component/admin" as ADMIN
import "./component/load" as LOAD
import "./component/common" as COMMON

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("DongyaoApp")

    property bool hasInitLoad: false
    property bool hasInitAdmin: false
    property bool hasInitMain: false

    //主界面
    MAIN.MainPage{
        id: mainpage
        anchors.fill: parent
        visible: false
    }

    //載入界面
    LOAD.LoadPage{
        id: loadpage
        anchors.fill: parent
        visible: false
    }

    //管理员界面
    ADMIN.AdminPage{
        id:adminpage
        anchors.fill: parent
        visible: false
    }

    //显示提示语
    Rectangle{
        id:toastRect
        color: "#1C1C1CD8"
        visible: false
        anchors.centerIn: parent
        width: toast.width*4
        height: toast.height*2
        z:100
        Text {
            id: toast
            text: qsTr("")
            font.pixelSize: 35
            font.bold: true
            color: "white"
            anchors.centerIn: parent
            function show(str){
                toast.text = str;
                toastRect.visible = true;
            }
            Timer{
                interval: 3000
                repeat: true
                running: toastRect.visible
                onTriggered: {
                    toastRect.visible = false;
                }
            }
        }
    }

    function showLoading(){
        loadpage.visible =  true;
        mainpage.visible = false;
        adminpage.visible = false;
        if(!window.hasInitLoad){
            loadpage.init();
            window.hasInitLoad = true
        }
    }

    function showAdmin(){
        loadpage.visible =  true;
        mainpage.visible = false;
        adminpage.visible = false;
        if(!window.hasInitAdmin){
            adminpage.init();
            window.hasInitAdmin = true
        }
    }

    function showMain(){
        loadpage.visible =  false;
        mainpage.visible = true;
        adminpage.visible = false;
        if(!window.hasInitMain){
            mainpage.init();
            window.hasInitMain = true
        }
    }

    function showToast(str){
        toast.show(str);
    }

    Component.onCompleted: {
        showLoading();
    }

}
