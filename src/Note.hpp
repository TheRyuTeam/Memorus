#pragma once
#include <QObject>
#include <QDateTime>


constexpr const char* DateTimeFormat = "dd.MM.yyyy hh.mm.ss";



class Note : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QString file MEMBER _file WRITE setFile NOTIFY fileChanged)
	Q_PROPERTY(QString name MEMBER _name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QString path MEMBER _path WRITE setPath RESET resetPath NOTIFY pathChanged)
	Q_PROPERTY(QDateTime creation MEMBER _creation WRITE setCreation RESET resetCreation NOTIFY creationChanged)
	Q_PROPERTY(bool isRepeating READ isRepeating CONSTANT)
	Q_PROPERTY(QString text READ text WRITE setText NOTIFY textSaved)

public:
	explicit Note(QObject* parent = nullptr);
	explicit Note(const QString& file, const QString& name, const QString& path, const QDateTime& creation, QObject* parent = nullptr);

	inline const QString& file() const;
	inline void setFile(const QString& file);

	inline const QString& name() const;
	inline void setName(const QString& name);

	inline const QString& path() const;
	inline void setPath(const QString& path);
	inline void resetPath();

	inline const QDateTime& creation() const;
	inline void setCreation(const QDateTime& creation);
	inline void resetCreation();

	inline virtual bool isRepeating() const;

	QString text();
	void setText(const QString& text);

	Q_INVOKABLE int setTextWithErrorHandle(const QString& text);

	virtual QString toString() const;
	inline virtual QString repetitionType() const;

	virtual QJsonObject toJsonObject() const;

	static Note* fromJsonObject(const QJsonObject& obj, QObject* parent = nullptr);

signals:
	void fileChanged(const QString& newFile);
	void nameChanged(const QString& newName);
	void pathChanged(const QString& newPath);
	void creationChanged(const QDateTime& creation);
	void textSaved();

	void error(const QString& msg);

private:
	QString _file;
	QString _name;
	QString _path;
	QDateTime _creation;
};



inline const QString& Note::file() const
{
	return _file;
}

inline void Note::setFile(const QString& file)
{
	if (_file == file)
		return;

	_file = file;
	emit fileChanged(file);
}

inline const QString& Note::name() const
{
	return _name;
}

inline void Note::setName(const QString& name)
{
	if (_name == name)
		return;

	_name = name;
	emit nameChanged(_name);
}

inline const QString& Note::path() const
{
	return _path;
}

inline void Note::setPath(const QString& path)
{
	if (_path == path)
		return;

	_path = path;
	emit pathChanged(_path);
}

inline void Note::resetPath()
{
	if (_path.isEmpty())
		return;

	_path.clear();
	emit pathChanged(_path);
}

inline const QDateTime& Note::creation() const
{
	return _creation;
}

inline void Note::setCreation(const QDateTime& creation)
{
	if (_creation == creation)
		return;

	_creation = creation;
	emit creationChanged(_creation);
}

inline void Note::resetCreation()
{
	setCreation(QDateTime::currentDateTime());
}

inline bool Note::isRepeating() const
{
	return false;
}

inline QString Note::repetitionType() const
{
	return "none";
}
