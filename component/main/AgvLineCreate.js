var lineStartX;
var lineStartY;
var lineEndX;
var lineEndY;
var lineKey;


var componentLine;
var spriteLine;

function createLineObject() {
    componentLine = Qt.createComponent("AgvLine.qml");
    if (componentLine.status == Component.Ready)
        finishCreationLine();
    else
        componentLine.statusChanged.connect(finishCreationLine);
}

function finishCreationLine() {
    if (componentLine.status == Component.Ready) {
        spriteLine = componentLine.createObject(mapRect, {"key":lineKey ,"startX": lineStartX, "startY": lineStartY,"endX":lineEndX,"endY":lineEndY});
        if (spriteLine == null) {
            // Error Handling
            console.log("Error creating agvline");
        }
    } else if (componentLine.status == Component.Error) {
        // Error Handling
        console.log("Error loading component:", componentLine.errorString());
    }
}
