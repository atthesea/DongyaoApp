import QtQuick 2.0

Canvas {
    //对外接口四个
    property int startX:0;
    property int startY:0;
    property int endX:0;
    property int endY:0;
    property int key: 0

    x:0;
    y:0;
    width:parent.width;
    height:parent.height;
    onPaint: {
        var ctx = getContext("2d");
        ctx.strokeStyle="green"
        ctx.clearRect(0,0,width,height);
        ctx.moveTo(startX,startY);
        ctx.lineTo(endX,endY);
        ctx.stroke();
    }

    onStartXChanged: {
        requestPaint()
    }
    onStartYChanged: {
        requestPaint()
    }
    onEndXChanged: {
        requestPaint()
    }
    onEndYChanged: {
        requestPaint()
    }
}
