import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id:floorTemp
    property int myid:0;
    property string myname:"";
    property int originWidth: 1024
    property real originHeight: 768

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
        //        radius: 20
        color: "#A7A7A7A0"
        visible:(floorFlickable.state ===  "notfullscreen")

        Rectangle{
            width: 10
            height: 1
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 2
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 2
            color: "white"
        }
        Rectangle{
            width: 1
            height: 10
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 2
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 2
            color: "white"
        }
        Rectangle{
            width: 10
            height: 1
            anchors.top: parent.verticalCenter
            anchors.topMargin: 2
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 2
            color: "white"
        }
        Rectangle{
            width: 1
            height: 10
            anchors.top: parent.verticalCenter
            anchors.topMargin: 2
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 2
            color: "white"
        }

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

        state: "fullscreen"
        states:[
            State {
                name: "fullscreen"
                PropertyChanges { target: bkg_picture;width:floorTemp.width;height:floorTemp.height;}
                PropertyChanges { target: floorFlickable;contentWidth:floorTemp.width;contentHeight:floorTemp.height;contentX:0;contentY:0}
            },
            State {
                name: "notfullscreen"
                PropertyChanges { target: bkg_picture;width:floorTemp.width*floorTemp.scaleScale;height:floorTemp.height*floorTemp.scaleScale;}
                PropertyChanges { target: floorFlickable;contentWidth:floorTemp.width*floorTemp.scaleScale;contentHeight:floorTemp.height*floorTemp.scaleScale;contentX:floorFlickable.notFullScreenX;contentY:floorFlickable.notFullScreenY}
            }
        ]

        onStateChanged: {
            lineAndAgvCanvas.requestPaint();
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

            Canvas{
                id:lineAndAgvCanvas
                width: parent.width
                height: parent.height
                x:0
                y:0

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.clearRect(0, 0, lineAndAgvCanvas.width, lineAndAgvCanvas.height);
                    //draw lines
                    var paths = msgCenter.getDrawPaths();
                    for(var ii = 0;ii<paths.length;++ii)
                    {
                        var path = paths[ii];
                        if(path.floor === floorTemp.myid){
                            ctx.beginPath();
                            ctx.strokeStyle=path.color;
                            ctx.moveTo(path.startX*lineAndAgvCanvas.width/floorTemp.originWidth,path.startY*lineAndAgvCanvas.height/floorTemp.originHeight);
                            if(path.type === 0){
                                ctx.lineTo(path.endX*lineAndAgvCanvas.width/floorTemp.originWidth,path.endY*lineAndAgvCanvas.height/floorTemp.originHeight);
                            }else if(path.type === 1){
                                ctx.quadraticCurveTo(path.p1x*lineAndAgvCanvas.width/floorTemp.originWidth,path.p1y*lineAndAgvCanvas.height/floorTemp.originHeight,path.endX*lineAndAgvCanvas.width/floorTemp.originWidth,path.endY*lineAndAgvCanvas.height/floorTemp.originHeight);
                            }else if(path.type === 2){
                                ctx.bezierCurveTo(path.p1x*lineAndAgvCanvas.width/floorTemp.originWidth,path.p1y*lineAndAgvCanvas.height/floorTemp.originHeight,path.p2x*lineAndAgvCanvas.width/floorTemp.originWidthpath.p2y*lineAndAgvCanvas.height/floorTemp.originHeight,path.endX*lineAndAgvCanvas.width/floorTemp.originWidth,path.endY*lineAndAgvCanvas.height/floorTemp.originHeight);
                            }
                            ctx.stroke();
                            ctx.moveTo(path.endX*lineAndAgvCanvas.width/floorTemp.originWidth,path.endY*lineAndAgvCanvas.height/floorTemp.originHeight);
                            ctx.closePath();
                        }
                    }

                    //                    //draw Agvs
                    //                    var agvs = msgCenter.getDrawAgvs();
                    //                    for(var kk = 0;kk<agvs.length;++kk)
                    //                    {
                    //                        var agv = agvs[kk];
                    //                        if(agv.floorid === floorTemp.myid){
                    //                            //TODO
                    //                            ctx.stroke();
                    //                        }
                    //                    }

                    ctx.restore();

                }

                Connections{
                    target: msgCenter
                    onSig_update_agv_lines:{
                        lineAndAgvCanvas.requestPaint()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        originWidth = msgCenter.getBkgWidth(myid);
        originHeight = msgCenter.getBkgHeight(myid);
    }

    onWidthChanged: {
        lineAndAgvCanvas.requestPaint()
    }
    onHeightChanged:{
        lineAndAgvCanvas.requestPaint()
    }

}
