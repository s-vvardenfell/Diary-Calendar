#ifndef SQLCONVERSATIONMODEL_H
#define SQLCONVERSATIONMODEL_H
#include <QSqlTableModel>
#include <QList>
#include <QObject>
#include <QDateTime>
#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>
#include <QSqlQuery>
#include <calendarevent.h>

class Tasks_DataBase : public QSqlTableModel
{
    Q_OBJECT

public:
    Tasks_DataBase(QObject *parent = nullptr);

    Q_PROPERTY(int mUserID READ userID WRITE setUserID NOTIFY userIDChanged)

    Q_INVOKABLE void setName(QString name); //getting username from qml
    Q_INVOKABLE void setUserID(int uid);
    Q_INVOKABLE int userID();

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const override;//base class method redefinition
    Q_INVOKABLE QHash<int, QByteArray> roleNames() const override; //base class method redefinition

    Q_INVOKABLE void createTask(const QString &task, const QString &note,
                                 const QString &date, const int isImportant); //calls in qml to create a new record in the table

    Q_INVOKABLE QList<QObject*> eventsForDate(const QDate &date); //returns list of CalendarEvent objects for qml calendar


private:
    int mUserID; //user id in the table (is used in updateModel())
    QString mUserName; //user name in the table (is used in updateModel())

public slots:
    void updateModel(); //updates model after call
    int getId(int row); //gets task-id from qml
    bool removeRecord(const int id); //removes record in the table

    void updateCalendarSlot(); //calls in qml, reload calendar elements
signals:
    void userIDChanged(const int uid); //signal for setUserID

    void changeMonthsSign(); //signal for updateCalendarSlot()
};

#endif // SQLCONVERSATIONMODEL_H
