#include "Repetition.h"
#include <QJsonObject>
#include "Note.hpp"



Repetition::Repetition(QObject *parent):
	QObject(parent),
	_dateTime(),
	_success()
{
}

Repetition::Repetition(const QDateTime& dateTime, bool success, QObject* parent):
	QObject(parent),
	_dateTime(dateTime),
	_success(success)
{
}

void Repetition::setDateTime(const QDateTime& dateTime)
{
	_dateTime = dateTime;
	emit dateTimeChanged();
}

void Repetition::setSuccess(bool success)
{
	_success = success;
	emit successChanged();
}

Repetition* Repetition::fromJsonObject(const QJsonObject& obj)
{
	auto dateTime = QDateTime::fromString(obj.value("dateTime").toString(), DateTimeFormat);
	auto jsonSuccess = obj.value("success");
	if (dateTime == QDateTime() || !jsonSuccess.isBool())
		return nullptr;

	return new Repetition(dateTime, jsonSuccess.toBool());
}

QJsonObject Repetition::toJsonObject() const
{
	QJsonObject obj;
	obj["dateTime"] = _dateTime.toString(DateTimeFormat);
	obj["success"] = _success;
	return obj;
}

