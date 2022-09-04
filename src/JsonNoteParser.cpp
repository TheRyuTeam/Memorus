#include "JsonNoteParser.h"
#include <QJsonObject>



JsonNoteParser::JsonNoteParser(QObject *parent):
	QObject(parent)
{
}

bool JsonNoteParser::hasParser(const QString& repetitionType) const
{
	return _parsers.constFind(repetitionType) != _parsers.cend();
}

void JsonNoteParser::setParser(const QString& repetitionType, ConverterType parser)
{
	_parsers[repetitionType] = parser;
}

Note* JsonNoteParser::parse(const QJsonObject& obj)
{
	auto jsonType = obj["repetitionType"];
	if (!jsonType.isString())
	{
		emit error("Expected string as repetitionType");
		return nullptr;
	}

	auto type = jsonType.toString();
	auto it = _parsers.constFind(type);
	if (it == _parsers.cend())
	{
		emit error("Unregistered type '" + type + "'");
		return nullptr;
	}

	return it.value()(obj);
}
