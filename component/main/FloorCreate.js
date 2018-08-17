var myid;
var name;

var componetFloor;
var spriteFloor;

function createFloorObject() {
    componetFloor = Qt.createComponent("Floor.qml");
    if (componetFloor.status === Component.Ready)
        finishCreationFloor();
    else
        componetFloor.statusChanged.connect(finishCreationFloor);
}

function finishCreationFloor() {
    if (componetFloor.status === Component.Ready) {
        spriteFloor = componetFloor.createObject(swipeView, {"myid":myid ,"name": name});
        if (spriteFloor === null) {
            // Error Handling
            console.log("Error creating Floor");
        }
    } else if (componetFloor.status === Component.Error) {
        // Error Handling
        console.log("Error loading component:", componetFloor.errorString());
    }
}

