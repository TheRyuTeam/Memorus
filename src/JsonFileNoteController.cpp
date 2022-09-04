#include "JsonFileNoteController.h"
#include <QFile>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonParseError>



JsonFileNoteController::JsonFileNoteController(QObject *parent):
	NoteController(parent)
	, _file()
	, _saved(false)
{
	connect(this, &NoteController::notesChanged, this, [this]() {
		_saved = false;
	});
}

JsonFileNoteController::~JsonFileNoteController()
{
	save();
}

void JsonFileNoteController::setFile(const QString& file)
{
	if (_file == file)
		return;

	_file = file;

	QFile f(_file);
	if (!f.open(QFile::ReadOnly))
	{
		emit error("Can not read file " + file);
		return;
	}

	QJsonParseError err;
	auto doc = QJsonDocument::fromJson(f.readAll(), &err);
	if (err.error)
	{
		emit error(err.errorString());
		return;
	}

	auto notesRef = doc.object()["notes"];
	if (!notesRef.isArray())
	{
		emit error("Expected array as'note' value");
		return;
	}

	auto notes = notesRef.toArray();
	for (auto&& p: notes)
	{
		if (!p.isObject())
		{
			emit error("Expected object as note");
			return;
		}

		auto note = Note::fromJsonObject(p.toObject());
		if (note)
			add(note);
	}
	_saved = true;
}

void JsonFileNoteController::save()
{
	{
		QFile f(_file);
		if (!f.open(QFile::WriteOnly))
		{
			emit error("Can not open file" + _file);
			return;
		}

		QJsonArray jsonNotes;
		for (const auto& note: notes())
		{
			if (note)
				jsonNotes.append(note->toJsonObject());
		}

		QJsonObject root;
		root["notes"] = jsonNotes;

		QJsonDocument doc;
		doc.setObject(root);
		f.write(doc.toJson());
	}

	_saved = true;
	emit fileSaved();
}
