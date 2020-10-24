#ifndef USERS_DATABASE_H
#define USERS_DATABASE_H

#include <QObject>
#include <QSql>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlRecord>
#include <QFile>



class Users_DataBase : public QObject
{
    Q_OBJECT
public:
    explicit Users_DataBase(QObject *parent = nullptr);

private:
    QSqlDatabase db;

    bool openDataBase();
    void closeDataBase();

    //members for login and registration
    QString userNameReg, emailReg, userPassReg, userConfPassReg;
    QString userNameLog, userPassLog;
    QString userNameForHeader;

    bool isChb1Checked, isChb2Checked;
    bool m_login_successful;
    bool m_register_successful;

public:
    Q_INVOKABLE void authorizeUser();
    Q_INVOKABLE bool isTrue_login();
    Q_INVOKABLE bool isTrue_reg();
    Q_INVOKABLE void registerUser();

    void connectToDataBase();
    bool createTable();
public slots:

    //slots for login and registration - get data from qml
    void getUserRegDataFromQML(QString, QString, QString, QString, bool, bool);
    void getUserLoginDataFromQML(QString, QString);

    void sendUNameToQmlForHeaderSlt();//send text for header

signals:
    void sendUNameToQmlForHeaderSignl(QString text);

};

#endif // USERS_DATABASE_H
