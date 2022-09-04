#include "Note.hpp"
#include <QFile>
#include <QJsonObject>



Note::Note(QObject* parent):
	QObject(parent),
	_file(),
	_name(),
	_path(),
	_creation(QDateTime::currentDateTime())
{
}

Note::Note(const QString& file, const QString& name, const QString& path, const QDateTime& creation, QObject* parent):
	QObject(parent),
	_file(file),
	_name(name),
	_path(path),
	_creation(creation)
{
}

QString Note::text()
{
	QFile file(_file);
	if (!file.open(QFile::ReadOnly | QFile::Text))
	{
		emit error("Can not open file " + _file);
		return "";
	}

	return file.readAll();
}

void Note::setText(const QString& text)
{
	setTextWithErrorHandle(text);
}

int Note::setTextWithErrorHandle(const QString& text)
{
	QFile file(_file);
	if (!file.open(QFile::WriteOnly | QFile::Text))
	{
		emit error("Can not open file " + _file);
		return -1;
	}

	int res = file.write(text.toLocal8Bit());
	if (res != text.size())
	{
		emit error("Some error occured while writing in " + _file);
		return -2;
	}

	emit textSaved();
	return 0;
}

QString Note::toString() const
{
	return name() + " {\n\t" + path() + "\n\t" + isRepeating() + "\n\t" + creation().toString(DateTimeFormat) + "\n}";
}

QJsonObject Note::toJsonObject() const
{
	QJsonObject obj;
	obj["repetitionType"] = repetitionType();
	obj["file"] = file();
	obj["name"] = name();
	obj["path"] = path();
	obj["creation"] = creation().toString(DateTimeFormat);
	return obj;
}

Note* Note::fromJsonObject(const QJsonObject& obj, QObject* parent)
{
	auto file = obj.value("file").toString();
	if (file.isEmpty())
		return nullptr;

	auto name = obj.value("name").toString();
	if (name.isEmpty())
		return nullptr;

	auto path = obj.value("path").toString();
	if (path.isEmpty())
		return nullptr;

	auto creation = QDateTime::fromString(obj.value("creation").toString(), DateTimeFormat);
	if (creation == QDateTime())
		return nullptr;

	return new Note(file, name, path, creation, parent);
}
