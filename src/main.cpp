#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "DocumentHandler.h"
#include "Note.hpp"
#include "RepeatitionNote.hpp"
#include "JsonFileNoteController.h"



int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;
	qmlRegisterType<DocumentHandler>("Memorus.Controls", 1, 0, "DocumentHandler");
	qmlRegisterType<Note>("Memorus.Controls", 1, 0, "Note");
	qmlRegisterType<NoteController>("Memorus.Controls", 1, 0, "NoteController");
	qmlRegisterType<JsonFileNoteController>("Memorus.Controls", 1, 0, "JsonFileNoteController");
	qmlRegisterSingletonType(QUrl("qrc:/qml/items/Style/Style.qml"), "Memorus.Style", 1, 0, "Style");

	const QUrl url(QStringLiteral("qrc:/qml/Memorus.qml"));
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
					 &app, [url](QObject *obj, const QUrl &objUrl) {
		if (!obj && url == objUrl)
			QCoreApplication::exit(-1);
	}, Qt::QueuedConnection);
	engine.load(url);

	return app.exec();
}
