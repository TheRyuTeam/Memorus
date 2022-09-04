#include "RepeatitionNote.hpp"
#include <QJsonObject>
#include <QJsonArray>



RepetitionNote::RepetitionNote(const QString& file, const QString& name, const QString& path, const QDateTime& creation, const QList<Repetition*>& repetitions, QObject* parent):
	Note(file, name, path, creation, parent),
	_repetitions(repetitions)
{
}

void RepetitionNote::repeat(Repetition* repetition)
{
	if (!repetition)
		return;

	for (auto&& r: _repetitions)
	{
		if (r == repetition)
			return;

		if (r->dateTime() == repetition->dateTime())
		{
			r->setSuccess(repetition->success());
			return;
		}
	}

	_repetitions.append(repetition);
	emit repeated();
}

QJsonObject RepetitionNote::toJsonObject() const
{
	auto obj = Note::toJsonObject();

	QJsonArray arr;
	for (auto&& repetition: _repetitions)
	{
		if (repetition)
			arr.append(repetition->toJsonObject());
	}
	obj["repetitions"] = arr;

	return obj;
}




IntervalRepetiotionNote::IntervalRepetiotionNote(QObject* parent):
	RepetitionNote(parent)
	, _lastRepetition()
{
}

void IntervalRepetiotionNote::repeat(Repetition* repetition)
{
	if (!repetition)
		return;

	_lastRepetition = repetition->dateTime();
	RepetitionNote::repeat(repetition);
	emit lastRepetitionChanged();
}

void IntervalRepetiotionNote::setLastRepetition(const QDateTime& lastRepetition)
{
	_lastRepetition = lastRepetition;
	emit lastRepetitionChanged();
}

QJsonObject IntervalRepetiotionNote::toJsonObject() const
{
	auto obj = RepetitionNote::toJsonObject();
	obj["lastRepetition"] = _lastRepetition.toString(DateTimeFormat);

	return obj;
}
