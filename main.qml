import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.11
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

    StackView{
        id: stack
        initialItem: mainpage
        anchors.fill: parent
    }

    Component {
        id: mainpage

        MAIN.MainPage{

        }
    }

    Component{
        id: loadpage
        LOAD.LoadPage{

        }
    }

    Component{
        id:adminpage
        ADMIN.AdminPage{

        }
    }

    Component.onCompleted: {
        stack.push(loadpage);
    }

    function showAdmin()
    {
        stack.push(adminpage);
    }

    function showMain()
    {
        stack.push(mainpage);
    }
}
