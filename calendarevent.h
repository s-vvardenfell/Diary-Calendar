#ifndef CALENDAREVENT_H
#define CALENDAREVENT_H

#include <QObject>
#include <QDate>
#include <QString>

//will be used in Tasks_DataBase::eventsForDate
class CalendarEvent : public QObject
{
    Q_OBJECT
public:
    explicit CalendarEvent(QObject *parent = nullptr);


    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString note READ note WRITE setNote NOTIFY noteChanged)


    QString name() const;
    void setName(const QString &name);


    QDate date() const;
    void setDate(const QDate &startDate);

    QString note() const;
    void setNote(const QString &note);

signals:
    void nameChanged(const QString &name);
    void dateChanged(const QDate &startDate);
    void noteChanged(const QString &note);


private:
    QString mName;
    QDate mDate;
    QString mNote;

};

#endif // CALENDAREVENT_H
