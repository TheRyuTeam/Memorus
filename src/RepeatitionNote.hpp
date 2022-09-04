#pragma once
#include "Note.hpp"
#include "Repetition.h"



class RepetitionNote : public Note
{
	Q_OBJECT
	Q_PROPERTY(QList<Repetition*> repetitions READ repetitions CONSTANT)

public:
	using Note::Note;

	explicit RepetitionNote(const QString& file, const QString& name, const QString& path, const QDateTime& creation, const QList<Repetition*>& repetitions, QObject* parent = nullptr);

	inline bool isRepeating() const override final;

	inline const QList<Repetition*> repetitions() const;

	virtual Q_INVOKABLE void repeat(Repetition* repetition);
	inline Q_INVOKABLE void repeatNow(bool success);

	QJsonObject toJsonObject() const override;

signals:
	void repeated();

private:
	QList<Repetition*> _repetitions;
};

inline bool RepetitionNote::isRepeating() const
{
	return true;
}

inline const QList<Repetition*> RepetitionNote::repetitions() const
{
	return _repetitions;
}

inline void RepetitionNote::repeatNow(bool success)
{
	repeat(new Repetition(QDateTime::currentDateTime(), success));
}



class IntervalRepetiotionNote : public RepetitionNote
{
	Q_OBJECT
	Q_PROPERTY(QDateTime lastRepetition READ lastRepetition WRITE setLastRepetition NOTIFY lastRepetitionChanged)

public:
	explicit IntervalRepetiotionNote(QObject* parent = nullptr);
	explicit IntervalRepetiotionNote(const QString& file, const QString& name, const QString& path, const QDateTime& creation,
							const QDateTime& lastRepetition, QObject* parent = nullptr)
		: RepetitionNote(file, name, path, creation, parent)
		, _lastRepetition(lastRepetition)
	{
	}

	void repeat(Repetition* repetition) override;

	inline const QDateTime& lastRepetition() const;
	void setLastRepetition(const QDateTime& lastRepetition);

	inline QString repetitionType() const override;

	QJsonObject toJsonObject() const override;

signals:
	void lastRepetitionChanged();

private:
	QDateTime _lastRepetition;
};

inline const QDateTime& IntervalRepetiotionNote::lastRepetition() const
{
	return _lastRepetition;
}

inline QString IntervalRepetiotionNote::repetitionType() const
{
	return "interval";
}



