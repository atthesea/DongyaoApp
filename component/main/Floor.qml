import QtQuick 2.0
import QtQuick.Controls 2.4

Flickable {
    id:floorFlickable
    property int myid:0;
    property string myname:"";

    //控制图像铺满屏幕的比例
    property real myXScale: 1.0
    property real myYScale: 1.0

    //地图原本的计算原点
    property int myOriginX: 0
    property int myOriginY: 0

    //地图原本的图像宽度、高度[数据库保存的那个]
    //该宽高经过myXScale和myYScale后，铺满屏幕
    property int imgWidth: 100
    property int imgHeight: 100

    //放大后的缩放比例，也是最大的放大到多少
    property real enlargeXScale: 2.0*myXScale
    property real enlargeYScale: 2.0*myYScale

    anchors.fill: parent

    Label {
        text: myname
        font.pixelSize: 35
        z:1
    }

    Rectangle{
        anchors.fill: parent
        id:viewRectangle



    }


    Component.onCompleted: {

        //1.載入背景图片
        //根据楼层是否包含背景图片，载入背景图片


        //2.载入站点、线路


        //3.载入车辆


        //4.载入库位信息


    }



}
