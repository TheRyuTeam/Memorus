#pragma once
#include "Note.hpp"
#include <QObject>
#include <QVector>



class NoteController : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QVector<Note*> notes MEMBER _notes READ notes WRITE setNotes NOTIFY notesChanged)

public:
	explicit NoteController(QObject *parent = nullptr);
	explicit NoteController(const QVector<Note*>& notes, QObject* parent = nullptr);

	virtual ~NoteController();

	inline const QVector<Note*>& notes() const;
	void setNotes(const QVector<Note*>& notes);

	Q_INVOKABLE void create(const QString& name, const QString& path, const QString& text);

	Q_INVOKABLE void add(Note* note);
	Q_INVOKABLE void remove(int index);
	Q_INVOKABLE int find(Note* note) const;
	Q_INVOKABLE bool has(Note* note) const;

	Q_INVOKABLE void run();

	Q_INVOKABLE void emitAll()
	{
		for (auto&& note : _notes)
			emit noteAdded(note);
	}

signals:
	void notesChanged();
	void noteAdded(Note* addedNote);
	void noteRemoved(Note* removedNote);

private:
	QVector<Note*> _notes;
};

inline const QVector<Note*>& NoteController::notes() const
{
	return _notes;
}

