import QtQuick 2.0
import QtQuick.Controls 2.4
import "./AgvLineCreate.js" as AgvLineCreator;
Page {
    id:floorTemp
    property int myid:0;
    property string myname:"";
    property real scaleX: 1.0
    property real scaleY: 1.0

    clip: true
    property real scaleScale: 2.0//控制放大的大小，这里放大两倍

    Rectangle{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        width: titleLabel.width*2
        height: titleLabel.height*1.5
        color: "#A7A7A7A0"
        Text{
            id:titleLabel
            text: floorTemp.myname
            font.pointSize: 30
            font.bold: true
            anchors.centerIn: parent
            color: "white"
        }
        z:20
    }

    //右上角恢复原样按钮
    Rectangle{
        z:20
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.topMargin: 4
        anchors.top: parent.top
        width: 40
        height: 40
        radius: 20
        color: "#A7A7A7A0"
        visible:(floorFlickable.state ===  "notfullscreen")
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(floorFlickable.state ===  "notfullscreen"){
                    floorFlickable.state = "fullscreen"
                }
                mouse.accepted = true
            }
        }
    }

    // Create a flickable to floorFlickable a large image.
    Flickable {
        id: floorFlickable
        width: floorTemp.width
        height: floorTemp.height
        contentWidth: floorTemp.width
        contentHeight: floorTemp.height

        property int notFullScreenX: 0
        property int notFullScreenY: 0

        property real scaleXX: 1.0  //用于计算所有线路的点位?//TODO
        property real scaleYY: 1.0  //用于计算所有线路的点位?//TODO

        state: "fullscreen"
        states:[
            State {
                name: "fullscreen"
                PropertyChanges { target: bkg_picture;width:floorTemp.width;height:floorTemp.height;}
                PropertyChanges { target: floorFlickable;contentWidth:floorTemp.width;contentHeight:floorTemp.height;contentX:0;contentY:0;scaleXX:floorTemp.scaleX;scaleYY:floorTemp.scaleY}
            },
            State {
                name: "notfullscreen"
                PropertyChanges { target: bkg_picture;width:floorTemp.width*floorTemp.scaleScale;height:floorTemp.height*floorTemp.scaleScale;}
                PropertyChanges { target: floorFlickable;contentWidth:floorTemp.width*floorTemp.scaleScale;contentHeight:floorTemp.height*floorTemp.scaleScale;contentX:floorFlickable.notFullScreenX;contentY:floorFlickable.notFullScreenY;scaleXX:floorTemp.scaleX*floorTemp.scaleScale;scaleYY:floorTemp.scaleY*floorTemp.scaleScale}
            }
        ]
        transitions: Transition {
            NumberAnimation { properties: "scale"; duration: 400 }
            NumberAnimation { properties: "width"; duration: 400 }
            NumberAnimation { properties: "height"; duration: 400 }
            NumberAnimation { properties: "contentWidth"; duration: 400 }
            NumberAnimation { properties: "contentHeight"; duration: 400 }
            NumberAnimation { properties: "contentX"; duration: 400 }
            NumberAnimation { properties: "contentY"; duration: 400 }
        }

        Image {
            id: bkg_picture
            source: "image://bkgs/"+floorTemp.myid

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(floorFlickable.state ===  "fullscreen"){

                        var tempX = mouse.x * floorTemp.scaleScale
                        var tempY = mouse.y * floorTemp.scaleScale

                        if(tempX<floorTemp.width/2)tempX = floorTemp.width/2;
                        if(tempX>floorTemp.width*floorTemp.scaleScale - floorTemp.width/2)tempX=floorTemp.width*floorTemp.scaleScale - floorTemp.width/2
                        if(tempY<floorTemp.height/2)tempY = floorTemp.height/2;
                        if(tempY>floorTemp.height*floorTemp.scaleScale - floorTemp.height/2)tempY=floorTemp.height*floorTemp.scaleScale - floorTemp.height/2

                        //计算X、Y
                        floorFlickable.notFullScreenX = (tempX - floorTemp.width/2)
                        floorFlickable.notFullScreenY = (tempY - floorTemp.height/2)

                        floorFlickable.state = "notfullscreen"
                    }
                }
            }


        }
    }



    //载入其他数据
    Component.onCompleted: {

        //1.載入背景图片 picture已经载入，要求必须有背景图片
        //要求必须存在背景图片。并且路径站点都包含在背景图片内
        //获取背景图片的设置高度
        floorTemp.scaleX = msgCenter.getBkgWidth(myid)/floorTemp.width
        floorTemp.scaleY = msgCenter.getBkgHeight(myid)/floorTemp.height
        floorFlickable.scaleXX = floorTemp.scaleX
        floorFlickable.scaleYY = floorTemp.scaleY

        //2.载入线路[站点不显示]
        var paths = msgCenter.getFloorsLines(myid);
        for(var ii = 0;ii<paths.length;++ii){
            AgvLineCreator.startX = paths[ii].startX;
            AgvLineCreator.startY = paths[ii].startY;
            AgvLineCreator.endX = paths[ii].endX;
            AgvLineCreator.endY = paths[ii].endY;
            AgvLineCreator.p1x = paths[ii].p1x;
            AgvLineCreator.p1y = paths[ii].p1y;
            AgvLineCreator.p2x = paths[ii].p2x;
            AgvLineCreator.p2y = paths[ii].p2y;
            AgvLineCreator.type = paths[ii].type;
            AgvLineCreator.myid = paths[ii].myid;
            AgvLineCreator.createLineObject();
        }


        //3.载入车辆


        //4.载入库位信息


    }
}
