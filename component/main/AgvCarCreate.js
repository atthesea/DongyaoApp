var initX;
var initY;
var lastStation;
var nowStation;
var key;
var name;


var componentCar;
var spriteCar;

function createCarObject() {
    componentCar = Qt.createComponent("AgvCar.qml");
    if (componentCar.status == Component.Ready)
        finishCreationCar();
    else
        componentCar.statusChanged.connect(finishCreationCar);
}

function finishCreationCar() {
    if (componentCar.status == Component.Ready) {
        spriteCar = componentCar.createObject(mapRect, {"name":name,"key":key ,"initX":initX,"initY":initY,"lastStation":lastStation,"nowStation":nowStation});
        if (spriteCar == null) {
            // Error Handling
            console.log("Error creating agvCar");
        }
    } else if (componentCar.status == Component.Error) {
        // Error Handling
        console.log("Error loading component:", componentCar.errorString());
    }
}
