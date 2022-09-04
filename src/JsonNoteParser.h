#pragma once
#include "Note.hpp"
#include <functional>
#include <QMap>



class JsonNoteParser : public QObject
{
	Q_OBJECT

public:
	using ConverterType = std::function<Note*(const QJsonObject&)>;

	explicit JsonNoteParser(QObject *parent = nullptr);

	bool hasParser(const QString& repetitionType) const;
	void setParser(const QString& repetitionType, ConverterType parser);

	Note* parse(const QJsonObject& obj);

signals:
	void error(const QString& msg);

private:
	QMap<QString, ConverterType> _parsers;
};

