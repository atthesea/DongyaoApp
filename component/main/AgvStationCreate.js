var stationX;
var stationY;
var stationName;
var stationCtype;

var componentStation;
var spriteStation;

function createStationObject() {
    componentStation = Qt.createComponent("AgvStation.qml");
    if (componentStation.status === Component.Ready)
        finishCreationStation();
    else
        componentStation.statusChanged.connect(finishCreationStation);
}

function finishCreationStation() {
    if (componentStation.status === Component.Ready) {
        spriteStation = componentStation.createObject(mapRect, {"cx": stationX, "cy": stationY,"name": stationName,"ctype": stationCtype});
        if (spriteStation === null) {
            // Error Handling
            console.log("Error creating agvstation");
        }
    } else if (componentStation.status === Component.Error) {
        // Error Handling
        console.log("Error loading component:", componentStation.errorString());
    }
}
