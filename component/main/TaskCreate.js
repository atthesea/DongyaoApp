var myid;
var name;

var componetTask;
var spriteTask;

function createTaskObject() {
    componetTask = Qt.createComponent("Task.qml");
    if (componetTask.status === Component.Ready)
        finishCreationTask();
    else
        componetTask.statusChanged.connect(finishCreationTask);
}

function finishCreationTask() {
    if (componetTask.status === Component.Ready) {
        spriteTask = componetTask.createObject(swipeView, {"myid":myid ,"name": name});
        if (spriteTask === null) {
            // Error Handling
            console.log("Error creating Task");
        }
    } else if (componetTask.status === Component.Error) {
        // Error Handling
        console.log("Error loading component:", componetTask.errorString());
    }
}

