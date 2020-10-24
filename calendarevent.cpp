#include "calendarevent.h"

CalendarEvent::CalendarEvent(QObject *parent) : QObject(parent)
{

}

QString CalendarEvent::name() const
{
    return mName;
}

void CalendarEvent::setName(const QString &name)
{
    if (name != mName) {
        mName = name;
        emit nameChanged(mName);
    }
}

QDate CalendarEvent::date() const
{
    return mDate;
}

void CalendarEvent::setDate(const QDate &startDate)
{
    if (startDate != mDate) {
        mDate = startDate;
        emit dateChanged(mDate);
    }
}

QString CalendarEvent::note() const
{
    return mNote;
}

void CalendarEvent::setNote(const QString &note)
{
    if (note != mNote) {
        mNote = note;
        emit noteChanged(mNote);
    }

}


