#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "storagedata.h"
#include "task.h"
#include "global.h"

int main(int argc, char *argv[])
{
    qApp->setOrganizationName("HRG");
    qApp->setApplicationName("DongYaoApp");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<StorageData>( "QyhCustomComponent", 1, 0, "StorageData");
    qmlRegisterType<Task>( "QyhCustomComponent", 1, 0, "Task");


    QQmlApplicationEngine engine;
    QQmlContext *ctxt = engine.rootContext();
    ctxt->setContextProperty("g_config", &g_config);
    ctxt->setContextProperty("g_wmsConnection", &g_wmsConnection);
    ctxt->setContextProperty("msgCenter", &msgCenter);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
