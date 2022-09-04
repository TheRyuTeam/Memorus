#pragma once
#include <QObject>
#include <QDateTime>



class Repetition : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QDateTime dateTime READ dateTime WRITE setDateTime NOTIFY dateTimeChanged)
	Q_PROPERTY(bool success READ success WRITE setSuccess NOTIFY successChanged)

public:
	explicit Repetition(QObject* parent = nullptr);
	explicit Repetition(const QDateTime& dateTime, bool success, QObject* parent = nullptr);

	inline const QDateTime& dateTime() const;
	void setDateTime(const QDateTime& dateTime);

	inline bool success() const;
	void setSuccess(bool success);

	inline static Repetition now(bool success, QObject* parent = nullptr);

	static Repetition* fromJsonObject(const QJsonObject& obj);
	QJsonObject toJsonObject() const;

signals:
	void dateTimeChanged();
	void successChanged();

private:
	QDateTime _dateTime;
	bool _success;
};



inline const QDateTime& Repetition::dateTime() const
{
	return _dateTime;
}

inline bool Repetition::success() const
{
	return _success;
}

inline Repetition Repetition::now(bool success, QObject* parent)
{
	return Repetition(QDateTime::currentDateTime(), success, parent);
}
