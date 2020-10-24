#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtSql>

#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>
#include "users_data_base.h"
#include "tasks_data_base.h"


int main(int argc, char *argv[])
{


    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);


    Users_DataBase db;
    engine.rootContext()->setContextProperty("App", &db);

    qmlRegisterType<Tasks_DataBase>("Tasks_DataBase", 1, 0, "Tasks_DataBase");

    engine.load(url);

    return app.exec();
}
