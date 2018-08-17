import QtQuick 2.0

Canvas {
    //对外接口s
    property int cx:0;
    property int cy:0;
    property string name:"未定义";
    property int ctype:1;//1是空站点（线路拐点） 2是rfid点  3是实际站点

    x:0
    y:0
    width: parent.width
    height: parent.height
    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0,0,width,height);
        ctx.beginPath();
        ctx.arc(cx,cy,2,0,2*Math.PI,true);
        if(ctype ==1){

        }else if(ctype == 2){
            ctx.fillStyle="blue";
            ctx.fill();
        }else if(ctype == 3){
            ctx.fillStyle="red";
            ctx.fill();
        }
        if(name.trim().length>0){
            ctx.font = "14px 微软雅黑";
            ctx.fillText(name,cx+6,cy-6);
        }
        ctx.stroke();
    }

    onCxChanged: {
        requestPaint();
    }
    onCyChanged: {
        requestPaint();
    }
    onCtypeChanged: {
        requestPaint();
    }
    onNameChanged: {
        requestPaint();
    }
}




