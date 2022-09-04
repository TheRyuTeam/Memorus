#include "NoteController.h"
#include <QDebug>
#include <QFile>



NoteController::NoteController(QObject *parent)
	: QObject(parent)
	, _notes()
{
}

NoteController::NoteController(const QVector<Note*>& notes, QObject* parent)
	: QObject(parent)
	, _notes(notes)
{
}

NoteController::~NoteController()
{
	for (auto&& note: _notes)
		delete note;
}

void NoteController::setNotes(const QVector<Note*>& notes)
{
	_notes = notes;
	emit notesChanged();
}

void NoteController::create(const QString& name, const QString& path, const QString& text)
{
	QFile file("somerandomnote.txt");
	if (!file.open(QFile::WriteOnly | QFile::Text))
		return;

	file.write(("Name: " + name + "\nPath: " + path + "\nText: " + text).toLocal8Bit());
	file.close();
}

void NoteController::add(Note* note)
{
	if (!note || has(note))
		return;

	_notes.append(note);
	emit noteAdded(note);
}

void NoteController::remove(int index)
{
	if (_notes.empty() || _notes.count() <= index)
		return;

	auto removedNote = _notes.at(index);
	_notes.remove(index);
	emit noteRemoved(removedNote);
}

int NoteController::find(Note* note) const
{
	return _notes.indexOf(note);
}

bool NoteController::has(Note* note) const
{
	return find(note) != -1;
}

void NoteController::run()
{
	for (int i = 0; i < _notes.count(); ++i)
	{
		auto& tmp = _notes[i];
		if (tmp)
			qDebug() << tmp->toString();
	}
}
