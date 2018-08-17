import QtQuick 2.0

Canvas {
    property int angle:90;
    property bool clockwise:true;
    property int startX:0;
    property int startY:0;
    property int endX:0;
    property int endY:0;
    property int key: 0

    property int centerX:0;//这个是个计算值，不可以被外力改变
    property int centerY:0;//这个是个计算值，不可以被外力改变
    property int radius:0;//这个是个计算值，不可以被外力改变
    property int midX:0;//这个是个计算值，不可以被外力改变
    property int midY:0;//这个是个计算值，不可以被外力改变
    x:0;
    y:0;
    width:parent.width;
    height:parent.height;
    onPaint: {
        var ctx = getContext("2d");
        ctx.strokeStyle="green"
        ctx.clearRect(0,0,width,height);
        ctx.beginPath();
        ctx.moveTo(startX,startY);        
        ctx.arcTo(midX,midY,endX,endY,radius);
        ctx.stroke();
    }

    function redraw(){
        var mmangle = angle*Math.PI/180; //假设这是一个90°的圆弧 就是π/2
        var ab = Math.sqrt(((endX-startX)*(endX-startX) +(endY-startY)*(endY-startY)));
        radius = Math.floor(Math.abs(ab/2/Math.sin(mmangle/2)));

        if(clockwise){
            midX = startX+Math.floor(radius*Math.tan(mmangle/2)*Math.cos(Math.atan2(endY-startY,endX-startX)-mmangle/2))
            midY = startY+Math.floor(radius*Math.tan(mmangle/2)*Math.sin(Math.atan2(endY-startY,endX-startX)-mmangle/2))

            centerX = startX+Math.floor(radius*Math.cos(Math.atan2(endY-startY,endX-startX)+(Math.PI - mmangle)/2))
            centerY = startY+Math.floor(radius*Math.sin(Math.atan2(endY-startY,endX-startX)+(Math.PI - mmangle)/2))
        }else{
            midX = startX+Math.floor(radius*Math.tan(mmangle/2)*Math.cos(Math.atan2(endY-startY,endX-startX)+mmangle/2))
            midY = startY+Math.floor(radius*Math.tan(mmangle/2)*Math.sin(Math.atan2(endY-startY,endX-startX)+mmangle/2))

            centerX = startX+Math.floor(radius*Math.cos(Math.atan2(endY-startY,endX-startX)-(Math.PI - mmangle)/2))
            centerY = startY+Math.floor(radius*Math.sin(Math.atan2(endY-startY,endX-startX)-(Math.PI - mmangle)/2))
        }
//        console.log("paint==============")
//        console.log("angle="+angle)
//        console.log("startX="+startX)
//        console.log("startY="+startY)
//        console.log("endX="+endX)
//        console.log("endY="+endY)
//        console.log("midX="+midX)
//        console.log("midY="+midY)
//        console.log("centerX="+centerX)
//        console.log("centerY="+centerY)
//        console.log("radius="+radius)
        requestPaint();
    }

    onClockwiseChanged: {
        redraw();
    }

    onAngleChanged: {
        //要求是>20 && <150
        if(angle<20||angle>150)angle=90;
        redraw();
    }


    onStartXChanged: {
        redraw();
    }
    onEndXChanged: {
        redraw();
    }
    onStartYChanged: {
        redraw();
    }
    onEndYChanged: {
        redraw();
    }

}


