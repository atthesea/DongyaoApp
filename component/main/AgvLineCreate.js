var startX;
var startY;
var endX;
var endY;
var p1x;
var p1y;
var p2x;
var p2y;
var type;
var myid;



var componentLine;
var spriteLine;

function createLineObject() {
    componentLine = Qt.createComponent("AgvLine.qml");
    if (componentLine.status === Component.Ready)
        finishCreationLine();
    else
        componentLine.statusChanged.connect(finishCreationLine);
}

function finishCreationLine() {
    if (componentLine.status === Component.Ready) {
        spriteLine = componentLine.createObject(bkg_picture, {"startX" : startX,"startY" : startY,"endX" : endX,"endY" : endY,"p1x" : p1x,"p1y" : p1y,"p2x" : p2x,"p2y" : p2y,"type" : type,"myid" : myid});
        if (spriteLine === null) {
            // Error Handling
            console.log("Error creating agvline");
        }
    } else if (componentLine.status === Component.Error) {
        // Error Handling
        console.log("Error loading component:", componentLine.errorString());
    }
}
