import QtQuick 2.9
import QtQuick.Controls 2.2
import QyhCustomComponent 1.0

Page {
    id:floorTemp
    property int myid:0;
    property string myname:"";
    property int pageIndex: 0

    property int originWidth: 1024
    property real originHeight: 768

    property int storage_rect_width: 40
    property int storage_rect_height: 40

    property bool canNull: false
    property bool canRaw: false
    property bool canPack: false
    property bool canTray: false
    property bool canTrash: false
    property bool canProduct: false

    clip: true
    property real scaleScale: 2.0//控制放大的大小，这里放大两倍

    property variant storages: []

    //set ComboBox
    Rectangle{
        y:0
        x:mainPage.setBtnX
        width: 180
        height: 48*6
        color: "red"
        z:50
        id:setMenu
        visible: false
        Rectangle{
            id:setMenuNull
            border.width: 1
            border.color: "#383A41"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 48
            color: floorTemp.canNull?"black":"grey"
            Text {
                anchors.centerIn: parent
                text: qsTr("空")
                //font.bold: true
                font.pixelSize: 15
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    if(floorTemp.canNull){
                        setMenuNull.color = "#4E505A"
                    }
                }
                onReleased: {
                    if(floorTemp.canNull){
                        setMenuNull.color = "black"
                        confirmChanged(0)
                    }
                }
            }
        }
        Rectangle{
            id:setMenuRaw
            border.width: 1
            border.color: "#383A41"
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: setMenuNull.bottom
            color: floorTemp.canRaw?"black":"grey"
            Text {
                anchors.centerIn: parent
                text: qsTr("原材料")
                //font.bold: true
                font.pixelSize: 15
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    if(floorTemp.canRaw){
                        setMenuRaw.color = "#4E505A"
                    }
                }
                onReleased: {
                    if(floorTemp.canRaw){
                        setMenuRaw.color = "black"
                        //TODO:
                        confirmChanged(1)
                    }
                }
            }
        }
        Rectangle{
            id:setMenuPack
            border.width: 1
            border.color: "#383A41"
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: setMenuRaw.bottom
            color: floorTemp.canPack?"black":"grey"
            Text {
                anchors.centerIn: parent
                text: qsTr("包材")
                //font.bold: true
                font.pixelSize: 15
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    if(floorTemp.canPack){
                        setMenuPack.color = "#4E505A"
                    }
                }
                onReleased: {
                    if(floorTemp.canPack){
                        setMenuPack.color = "black"
                        confirmChanged(2)
                    }
                }
            }
        }
        Rectangle{
            id:setMenuTray
            border.width: 1
            border.color: "#383A41"
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: setMenuPack.bottom
            color: floorTemp.canTray?"black":"grey"
            Text {
                anchors.centerIn: parent
                text: qsTr("空栈板")
                //font.bold: true
                font.pixelSize: 15
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    if(floorTemp.canTray){
                        setMenuTray.color = "#4E505A"
                    }
                }
                onReleased: {
                    if(floorTemp.canTray){
                        setMenuTray.color = "black"
                        //TODO:
                        confirmChanged(3)
                    }
                }
            }
        }
        Rectangle{
            id:setMenuTrash
            border.width: 1
            border.color: "#383A41"
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: setMenuTray.bottom
            color: floorTemp.canTrash?"black":"grey"
            Text {
                anchors.centerIn: parent
                text: qsTr("垃圾")
                //font.bold: true
                font.pixelSize: 15
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    if(floorTemp.canTrash){
                        setMenuTrash.color = "#4E505A"
                    }
                }
                onReleased: {
                    if(floorTemp.canTrash){
                        setMenuTrash.color = "black"
                        confirmChanged(4)
                    }
                }
            }
        }
        Rectangle{
            id:setMenuProduct
            border.width: 1
            border.color: "#383A41"
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: setMenuTrash.bottom
            color: floorTemp.canProduct?"black":"grey"
            Text {
                anchors.centerIn: parent
                text: qsTr("成品")
                //font.bold: true
                font.pixelSize: 15
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    if(floorTemp.canProduct){
                        setMenuProduct.color = "#4E505A"
                    }
                }
                onReleased: {
                    if(floorTemp.canProduct){
                        setMenuProduct.color = "black"
                        confirmChanged(5)
                    }
                }
            }
        }
    }

    ListView{
        y:0
        x:mainPage.taskBtnX-width
        id:taskListView
        width: 180
        height: 48*6
        visible: false
        interactive:false
        z:50
        delegate: Rectangle{
            id:rectTempId
            width: 180
            height: 48
            color: "black"
            border.width: 1
            border.color: "#383A41"
            Text {
                anchors.centerIn: parent
                text: model.modelData.task_discribe
                font.pixelSize: 15
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    rectTempId.color = "#4E505A"
                }
                onReleased: {
                    rectTempId.color = "black"
                    //TODO:
                    if(!g_wmsConnection.isConnected()){
                        window.showToast(qsTr("WMS服务期尚未连接,请检查网络！"))
                        return;
                    }

                    //OLD:
                    //g_wmsConnection.sendTask(model.modelData.from, model.modelData.to, model.modelData.task_store_type)
                    g_wmsConnection.sendTask(model.modelData.from, model.modelData.to, model.modelData.task_store_type)

//                    //NEW:
//                    for(var kk = 0;kk<floorTemp.storages.length;++kk){
//                        if(floorTemp.storages[kk].isSelected){
//                            //TODO: g_wmsConnection.setStorageType(floorTemp.storages[kk].store_no, floorTemp.storages[kk].storage_no, _storage_type);
//                        }
//                    }

                }
            }
        }
    }


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
                    setMenu.visible = false
                    taskListView.visible = false
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
            lineCanvas.requestPaint();
            agvCanvas.requestPaint();
            storageCanvas.requestPaint();
        }

        Image {
            id: bkg_picture
            source: "image://bkgs/"+floorTemp.myid

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(setMenu.visible|| taskListView.visible){
                        setMenu.visible = false
                        taskListView.visible = false
                        return ;
                    }

                    var clickStorage = false;
                    for(var kk = 0;kk<floorTemp.storages.length;++kk)
                    {
                        if(mouse.x >= floorTemp.storages[kk].x*agvCanvas.width/floorTemp.originWidth
                                &&mouse.x<=floorTemp.storages[kk].x*agvCanvas.width/floorTemp.originWidth+storage_rect_width*agvCanvas.width/floorTemp.originWidth
                                &&mouse.y >= floorTemp.storages[kk].y*agvCanvas.height/floorTemp.originHeight
                                &&mouse.y<=floorTemp.storages[kk].y*agvCanvas.height/floorTemp.originHeight+storage_rect_height*agvCanvas.height/floorTemp.originHeight
                                ){
                            clickStorage = true;
                            floorTemp.storages[kk].isSelected = !floorTemp.storages[kk].isSelected;
                            break;
                        }
                    }
                    if(clickStorage)return;

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
                z:1
                id:lineCanvas
                width: parent.width
                height: parent.height
                x:0
                y:0

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.clearRect(0, 0, lineCanvas.width, lineCanvas.height);
                    //draw lines
                    var paths = msgCenter.getDrawPaths();
                    for(var ii = 0;ii<paths.length;++ii)
                    {
                        var path = paths[ii];
                        if(path.floor === floorTemp.myid){
                            ctx.beginPath();
                            ctx.strokeStyle=path.color;
                            ctx.moveTo(path.startX*lineCanvas.width/floorTemp.originWidth,path.startY*lineCanvas.height/floorTemp.originHeight);
                            if(path.type === 0){
                                ctx.lineTo(path.endX*lineCanvas.width/floorTemp.originWidth,path.endY*lineCanvas.height/floorTemp.originHeight);
                            }else if(path.type === 1){
                                ctx.quadraticCurveTo(path.p1x*lineCanvas.width/floorTemp.originWidth,path.p1y*lineCanvas.height/floorTemp.originHeight,path.endX*lineCanvas.width/floorTemp.originWidth,path.endY*lineCanvas.height/floorTemp.originHeight);
                            }else if(path.type === 2){
                                ctx.bezierCurveTo(path.p1x*lineCanvas.width/floorTemp.originWidth,path.p1y*lineCanvas.height/floorTemp.originHeight,path.p2x*lineCanvas.width/floorTemp.originWidthpath.p2y*lineCanvas.height/floorTemp.originHeight,path.endX*lineCanvas.width/floorTemp.originWidth,path.endY*lineCanvas.height/floorTemp.originHeight);
                            }
                            ctx.stroke();
                            ctx.moveTo(path.endX*lineCanvas.width/floorTemp.originWidth,path.endY*lineCanvas.height/floorTemp.originHeight);
                            ctx.closePath();
                        }
                    }
                    ctx.restore();
                }
            }

            Canvas{
                id:agvCanvas
                width: parent.width
                height: parent.height
                property int initWidth: 42
                property int initHeight: 18
                x:0
                y:0
                z:2
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    //draw Agvs
                    var agvs = msgCenter.getDrawAgvs();
                    //if(agvs.length<=0)console.log("agvs length =" + agvs.length);
                    ctx.clearRect(0,0,agvCanvas.width,agvCanvas.height)
                    for(var kk = 0;kk<agvs.length;++kk)
                    {
                        var agv = agvs[kk];
                        //console.log("agv.floorid="+agv.floorid)
                        if(agv.floorid === floorTemp.myid){
                            ctx.translate((agv.x + agvCanvas.initWidth/2)*agvCanvas.width/floorTemp.originWidth,(agv.y + agvCanvas.initHeight/2)*agvCanvas.height/floorTemp.originHeight)
                            ctx.rotate(agv.theta*Math.PI/180);
                            if(floorFlickable.state === "fullscreen")
                                ctx.drawImage("qrc:/image/agv.png",0,0,agvCanvas.initWidth*agvCanvas.width/floorTemp.originWidth,agvCanvas.initHeight*agvCanvas.height/floorTemp.originHeight);
                            else
                                ctx.drawImage("qrc:/image/agv.png",0,0,agvCanvas.initWidth*agvCanvas.width/floorTemp.originWidth,agvCanvas.initHeight*agvCanvas.height/floorTemp.originHeight);
                            ctx.rotate(-agv.theta*Math.PI/180);
                            ctx.translate(-(agv.x + agvCanvas.initWidth/2)*agvCanvas.width/floorTemp.originWidth,-(agv.y + agvCanvas.initHeight/2)*agvCanvas.height/floorTemp.originHeight)
                        }
                    }
                    ctx.restore();
                }
            }

            Canvas{
                id:storageCanvas
                width: parent.width
                height: parent.height
                x:0
                y:0
                z:3

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.clearRect(0,0,storageCanvas.width,storageCanvas.height)

                    for(var kk = 0;kk<floorTemp.storages.length;++kk)
                    {
                        var imgurl = "qrc:/image/type_null.png";

                        if(floorTemp.storages[kk].storage_type === StorageData.STORAGE_TYPE_NULL){
                            imgurl = "qrc:/image/type_null.png";
                        }else if(floorTemp.storages[kk].storage_type === StorageData.STORAGE_TYPE_MATERIAL){
                            imgurl = "qrc:/image/type_raw.png";
                        }else if(floorTemp.storages[kk].storage_type === StorageData.STORAGE_TYPE_PACKING){
                            imgurl = "qrc:/image/type_pack.png";
                        }else if(floorTemp.storages[kk].storage_type === StorageData.STORAGE_TYPE_TRAY){
                            imgurl = "qrc:/image/type_tray.png";
                        }else if(floorTemp.storages[kk].storage_type === StorageData.STORAGE_TYPE_GARBAGE){
                            imgurl = "qrc:/image/type_trash.png";
                        }else if(floorTemp.storages[kk].storage_type === StorageData.STORAGE_TYPE_PRODUCT){
                            imgurl = "qrc:/image/type_product.png";
                        }

                        ctx.drawImage(imgurl,floorTemp.storages[kk].x*agvCanvas.width/floorTemp.originWidth+2,floorTemp.storages[kk].y*agvCanvas.height/floorTemp.originHeight+2,storage_rect_width*agvCanvas.width/floorTemp.originWidth-4,storage_rect_height*agvCanvas.height/floorTemp.originHeight-4)
                        //ctx.restore();
                        if(floorTemp.storages[kk].isSelected){
                            ctx.lineWidth = 2;
                            ctx.strokeStyle = "red"
                            ctx.beginPath();
                            ctx.rect(floorTemp.storages[kk].x*agvCanvas.width/floorTemp.originWidth,floorTemp.storages[kk].y*agvCanvas.height/floorTemp.originHeight,storage_rect_width*agvCanvas.width/floorTemp.originWidth,storage_rect_height*agvCanvas.height/floorTemp.originHeight);
                            ctx.closePath();
                        }else{
                            ctx.lineWidth = 0;
                            ctx.strokeStyle = "#00000000"
                        }

                        ctx.stroke()
                    }
                    ctx.restore();
                }
            }
        }
    }

    function slot_StoragesChanged(){
        storageCanvas.requestPaint();
    }

    function slot_StorageSelectChanged()
    {
        storageCanvas.requestPaint();

        //TODO:
        var canNull = true;
        var canRaw = true;
        var canTray = true;
        var canPack = true;
        var canTrash = true;
        var canProduct = true;

        var selectStorageLength = 0;
        for(var kk = 0;kk<floorTemp.storages.length;++kk){
            if(floorTemp.storages[kk].isSelected){
                selectStorageLength+=1;
                if(!floorTemp.storages[kk].canbe_null)
                {
                    canNull = false;
                }
                if(!floorTemp.storages[kk].canbe_raw)
                {
                    canRaw = false;
                }
                if(!floorTemp.storages[kk].canbe_pack)
                {
                    canPack = false;
                }
                if(!floorTemp.storages[kk].canbe_tray)
                {
                    canTray = false;
                }
                if(!floorTemp.storages[kk].canbe_trash)
                {
                    canTrash = false;
                }
                if(!floorTemp.storages[kk].canbe_product)
                {
                    canProduct = false;
                }
            }
        }

        if(selectStorageLength === 0){
            floorTemp.canNull = false;
            floorTemp.canRaw = false;
            floorTemp.canTray = false;
            floorTemp.canPack = false;
            floorTemp.canTrash = false;
            floorTemp.canProduct = false;
        }else{
            floorTemp.canNull = canNull;
            floorTemp.canRaw = canRaw;
            floorTemp.canTray = canTray;
            floorTemp.canPack = canPack;
            floorTemp.canTrash = canTrash;
            floorTemp.canProduct = canProduct;
        }
    }

    function confirmChanged(_storage_type)
    {
        if(!g_wmsConnection.isConnected()){
            window.showToast(qsTr("WMS服务期尚未连接,请检查网络！"))
            return;
        }

        for(var kk = 0;kk<floorTemp.storages.length;++kk){
            if(floorTemp.storages[kk].isSelected){
                g_wmsConnection.setStorageType(floorTemp.storages[kk].store_no, floorTemp.storages[kk].storage_no, _storage_type);
            }
        }
    }

    Component.onCompleted:
    {
        originWidth = msgCenter.getBkgWidth(myid);
        originHeight = msgCenter.getBkgHeight(myid);

        //获取每个方格的大小//
        storage_rect_width = g_config.getStorage_width();
        storage_rect_height = g_config.getStorage_height();

        //获取方格列表//动态创建所有方格
        if(g_config.getFloorid() === myid)
        {
            floorTemp.storages = g_config.getStorageDatas();

            for(var i=0;i<floorTemp.storages.length;++i)
            {
                floorTemp.storages[i].storage_typeChanged.connect(slot_StoragesChanged);
                floorTemp.storages[i].isSelectedChanged.connect(slot_StoragesChanged);
                floorTemp.storages[i].isSelectedChanged.connect(slot_StorageSelectChanged);
            }

            //获取可选任务列表
            taskListView.model = g_config.getTasks();
        }
    }

    onWidthChanged: {
        lineCanvas.requestPaint()
        agvCanvas.requestPaint()
        storageCanvas.requestPaint()
    }
    onHeightChanged:{
        lineCanvas.requestPaint()
        agvCanvas.requestPaint()
        storageCanvas.requestPaint()
    }

    Connections{
        target: msgCenter
        onSig_update_agv_lines:{
            lineCanvas.requestPaint()
            agvCanvas.requestPaint()
        }
    }

    Connections{
        target: mainPage
        onSetBtnClick:{
            if(floorTemp.pageIndex === mainPage.currentShowFloorIndex){
                taskListView.visible = false;
                setMenu.visible = !setMenu.visible
            }
        }
        onTaskBtnClick:{
            if(floorTemp.pageIndex === mainPage.currentShowFloorIndex){
                setMenu.visible = false;
                taskListView.visible = !taskListView.visible
            }
        }
        onCurrentShowChanged:{
            if(floorTemp.pageIndex !== mainPage.currentShowFloorIndex){
                setMenu.visible = false
                taskListView.visible = false
            }
        }
    }

}
