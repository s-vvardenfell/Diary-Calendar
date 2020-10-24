#include "tasks_data_base.h"



Tasks_DataBase::Tasks_DataBase(QObject *parent) :
    QSqlTableModel(parent)
{
    mUserID=0; //set user id to 0 means no rows selected before login
    setTable("to_do_list");
    setSort(2, Qt::AscendingOrder);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}

void Tasks_DataBase::setName(QString name)
{
    mUserName=name;
}

void Tasks_DataBase::setUserID(int uid)
{
    if (uid != mUserID)
    {
        mUserID = uid;
        emit userIDChanged(mUserID);
    }
}

int Tasks_DataBase::userID()
{
    return mUserID;
}

//base class method redefinition
QVariant Tasks_DataBase::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
    {
        return QSqlTableModel::data(index, role);
    }


    const QSqlRecord sqlRecord = record(index.row());
    return sqlRecord.value(role - Qt::UserRole);
}

//base class method redefinition
QHash<int, QByteArray> Tasks_DataBase::roleNames() const
{
    QHash<int, QByteArray> names;
    names[Qt::UserRole ] = "taskID";//starts with UserRole
    names[Qt::UserRole + 1] = "task";
    names[Qt::UserRole + 2] = "note";
    names[Qt::UserRole + 3] = "date";
    names[Qt::UserRole + 4] = "isImportant";
    names[Qt::UserRole + 5] = "userID";

    return names;
}

//creates new record in the table
void Tasks_DataBase::createTask(const QString &task, const QString &note,
                                       const QString &date, const int isImportant)
{
    QSqlRecord newRecord = record();
    newRecord.setValue("task", task);
    newRecord.setValue("note", note);
    newRecord.setValue("date", date);
    newRecord.setValue("isImportant", isImportant);
    newRecord.setValue("userID", mUserID);

    if (!insertRecord(rowCount(), newRecord)) {
        qWarning() << "Failed to create task:" << lastError().text();
        return;
    }

    submitAll();

}

//returns list of events for qml calendar
QList<QObject *> Tasks_DataBase::eventsForDate(const QDate &date)
{
    QList<QObject*> events;

    if(mUserID==0)
        return events;

    const QString queryStr = QString::fromLatin1(
                "SELECT * FROM to_do_list WHERE '%1' == date AND '%2' == userID;"
                ).arg(date.toString("dd-MM-yyyy")).arg(mUserID);

    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query eventsForDate(const QDate &date) failed");

    while (query.next())
    {
        CalendarEvent *event = new CalendarEvent(this);
        event->setName(query.value("task").toString());

        QString strDate(query.value("date").toString());
        QDate taskDate = QDate::fromString(strDate,"dd-MM-yyyy");
        event->setDate(taskDate);

        QString strNote(query.value("note").toString());
        event->setNote(strNote);

        events.append(event);
    }

    return events;


}

//updates tes model with a new selection
void Tasks_DataBase::updateModel()
{
    QSqlQuery query;
    QSqlRecord rec;

    query.prepare( "SELECT userID FROM user_list WHERE name = :name;");//gets user id using user name mUserName
    query.bindValue(":name", mUserName);
    if (!query.exec())
        qFatal("SELECT userID FROM user_list query sendMessage failed: %s", qPrintable(query.lastError().text()));

    rec = query.record();
    query.next();
    mUserID = query.value(rec.indexOf("userID")).toInt();

    query.prepare( "SELECT * FROM to_do_list WHERE userID = :id;");//gets data using user id
    query.bindValue(":id", mUserID);

    if (!query.exec())
        qFatal("to_do_list SELECT query updateModel() failed: %s", qPrintable(query.lastError().text()));

    setQuery(query);
    if (lastError().isValid())
        qFatal("Cannot set query on SqlConVerastionModel: %s", qPrintable(lastError().text()));
}

//gets row id for remove
int Tasks_DataBase::getId(int row)
{
    return this->data(this->index(row, 0), Qt::UserRole).toInt();
}

//removes record using row id
bool Tasks_DataBase::removeRecord(const int id)
{

    QSqlQuery query;

    query.prepare("DELETE FROM to_do_list WHERE taskID= :ID ;");
    query.bindValue(":ID", id);

    if(!query.exec())
    {
        qFatal("Error delete row: %s", qPrintable(lastError().text()));
        return false;
    } else {
        return true;
    }

}

//some crutch to make calendar update itself
void Tasks_DataBase::updateCalendarSlot()
{
    emit changeMonthsSign();
}



