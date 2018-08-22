import QtQuick 2.0
import QtQuick.Controls 2.4

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

//        transitions: Transition {
//            NumberAnimation { properties: "scale"; duration: 400 }
//            NumberAnimation { properties: "width"; duration: 400 }
//            NumberAnimation { properties: "height"; duration: 400 }
//            NumberAnimation { properties: "contentWidth"; duration: 400 }
//            NumberAnimation { properties: "contentHeight"; duration: 400 }
//            NumberAnimation { properties: "contentX"; duration: 400 }
//            NumberAnimation { properties: "contentY"; duration: 400 }
//        }

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
                    console.log("========================================================   START")
                    console.log("========================================================clear width=",lineAndAgvCanvas.width)
                    console.log("========================================================clear height=",lineAndAgvCanvas.height)
                    ctx.save();
                    ctx.clearRect(0, 0, lineAndAgvCanvas.width, lineAndAgvCanvas.height);
                    //draw lines
                    var paths = msgCenter.getDrawPaths();
                    for(var ii = 0;ii<paths.length;++ii)
                    {
                        var path = paths[ii];
                        if(path.floor === floorTemp.myid){
                            console.log("================================================ii="+ii)
                            ctx.strokeStyle=path.color;
                            ctx.moveTo(path.startX/floorFlickable.scaleXX,path.startY/floorFlickable.scaleYY);
                            console.log("move to="+path.startX/floorFlickable.scaleXX+","+path.startY/floorFlickable.scaleYY)
                            if(path.type === 0){
                                ctx.lineTo(path.endX/floorFlickable.scaleXX,path.endY/floorFlickable.scaleYY);
                                console.log("line to="+path.endX/floorFlickable.scaleXX+","+path.endY/floorFlickable.scaleYY)
                            }else if(path.type === 1){
                                ctx.quadraticCurveTo(path.p1x/floorFlickable.scaleXX,path.p1y/floorFlickable.scaleYY,path.endX/floorFlickable.scaleXX,path.endY/floorFlickable.scaleYY);
                                console.log("quadratic to="+path.p1x/floorFlickable.scaleXX+","+path.p1y/floorFlickable.scaleYY+"  "+path.endX/floorFlickable.scaleXX+","+path.endY/floorFlickable.scaleYY)
                            }else if(path.type === 2){
                                console.log("quadratic to="+path.p1x/floorFlickable.scaleXX+","+path.p1y/floorFlickable.scaleYY+"  "+path.p2x/floorFlickable.scaleXX+","+path.p2y/floorFlickable.scaleYY+"  "+path.endX/floorFlickable.scaleXX+","+path.endY/floorFlickable.scaleYY)
                                ctx.bezierCurveTo(path.p1x/floorFlickable.scaleXX,path.p1y/floorFlickable.scaleYY,path.p2x/floorFlickable.scaleXX,path.p2y/floorFlickable.scaleYY,path.endX/floorFlickable.scaleXX,path.endY/floorFlickable.scaleYY);
                            }
                            ctx.stroke();
                        }
                    }
                    ctx.restore();
                    console.log("======================================================== END")
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

    onWidthChanged: {
        floorTemp.scaleX = msgCenter.getBkgWidth(myid)/floorTemp.width
//        console.log("floorTemp.scaleX="+floorTemp.scaleX)
//        console.log("width================================"+floorTemp.width)
        lineAndAgvCanvas.requestPaint()
    }
    onHeightChanged:{
        floorTemp.scaleY = msgCenter.getBkgHeight(myid)/floorTemp.height
        console.log("floorTemp.scaleY="+floorTemp.scaleY)
        console.log("height================================"+floorTemp.height)
        lineAndAgvCanvas.requestPaint()
    }

}
