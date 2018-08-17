import QtQuick 2.0

Rectangle{
    //对外接口，初始位置，初始的上一个站点和当前站点
    property int initX: 0
    property int initY: 0
    property var name: ""

    id:agvcar
    property var carPaths: []
    property var agvAnimations: []//所有线路的动画，都保存在这里，根据线路的key来取
    visible: true
    width: 25
    height: 15
    color: "red"
    transformOrigin: Item.Center
    Rectangle{
        id:agvcarheadTemp
        width: 7
        height: 7
        anchors.verticalCenter: agvcar.verticalCenter
        anchors.right: agvcar.right
        radius: 7
        color: "white"
    }
    Text {
        id: nameText
        text: qsTr("")+agvcar.name;
        anchors.verticalCenter: agvcar.verticalCenter
        anchors.left: agvcar.left
        color: "black"
        //font.pixelSize: 5
    }
    x:agvcar.initX - agvcar.width/2
    y:agvcar.initY - agvcar.height/2

//    //执行线路
//    function doPath(pathkey){
//        for(var i=0;i<agvcar.agvAnimations.length;++i){
//            if(agvcar.agvAnimations[i].key == pathkey){
//                agvcar.agvAnimations[i].start();
//            }else{
//                agvcar.agvAnimations[i].stop();
//            }
//        }
//    }

//    //TODO:如果是真实情况，这个站点的通知，如果遇到下一个 是真实的station。那么什么都不做，知道通知到了这个rfid的站点。(如果很快到了这个站点怎么办呢？？)
//    //删除之前的站点，说明已经到了！！！！！！
//    function oneAnimationStopped(key)
//    {
//        for(var k=0;k<agvlines.length;++k)
//        {
//            var tline = agvlines[k];
//            if(tline.key == key){
//                agvTaskCenter.carArriveStation(agvcar.key, tline.endStation);
//            }
//        }
//    }

//    Connections{
//        target:agvCenter
//        onStartAgvAnimation:{
//            //console.log("agvkey="+agvKey+" linekey="+lineKey)
//            //console.log("agvcar.key="+agvcar.key);
//            if(agvcar.key == agvKey){
//                //console.log("jinlai le ")
//                //是我这辆车执行动画，动画的key是lineKey
//                agvcar.doPath(lineKey)
//            }
//        }
//    }
}
