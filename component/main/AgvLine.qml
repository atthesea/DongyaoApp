import QtQuick 2.0

Canvas {
    //对外接口四个
    property int startX:0;
    property int startY:0;
    property int endX:0;
    property int endY:0;
    property int p1x:0;
    property int p1y:0;
    property int p2x:0;
    property int p2y:0;
    property int type:0;
    property int myid:0;

    //TODO:默认不可见，当车辆占用时可见
    visible: true

    x:0;
    y:0;
    width:parent.width;
    height:parent.height;

    onPaint: {
        var ctx = getContext("2d");
        ctx.strokeStyle="green"
        ctx.clearRect(0,0,width,height);
        ctx.moveTo(startX,startY);

        if(type === 0){
            ctx.lineTo(endX,endY);
        }else if(type === 1){
            ctx.quadraticCurveTo(p1x,p1y,endX,endY);
        }else if(type === 2){
            ctx.bezierCurveTo(p1x,p1y,p2x,p2y,endX,endY);
        }
        ctx.stroke();
    }

}
