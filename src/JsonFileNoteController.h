#pragma once
#include "NoteController.h"



class JsonFileNoteController : public NoteController
{
	Q_OBJECT
	Q_PROPERTY(QString file READ file WRITE setFile NOTIFY fileChanged)
	Q_PROPERTY(bool saved MEMBER _saved NOTIFY fileSaved)

public:
	explicit JsonFileNoteController(QObject *parent = nullptr);

	~JsonFileNoteController();

	inline const QString file() const;
	void setFile(const QString& file);

	Q_INVOKABLE void save();

signals:
	void fileChanged();
	void fileSaved();

	void error(const QString& msg);

private:
	QString _file;
	bool _saved;
};

inline const QString JsonFileNoteController::file() const
{
	return _file;
}
