#include "users_data_base.h"

Users_DataBase::Users_DataBase(QObject *parent) : QObject(parent)
{
    connectToDataBase();
}

bool Users_DataBase::openDataBase()
{

    db = QSqlDatabase::addDatabase("QSQLITE");

    db.setDatabaseName("C:/DB/Calendar5001.db");
    db.setUserName("Mardekaimer");
    db.setHostName("Mardekaimer-HP");
    db.setPassword("123456");

    if(db.open()){
        return true;
    } else {
        return false;
    }
}


void Users_DataBase::closeDataBase()
{
    db.close();
}

void Users_DataBase::connectToDataBase()
{
    if(QFile("C:/DB/Calendar5001.db").exists())
    {
        if(!openDataBase())
        qFatal("Cannot open Database");

        if(!createTable())
        qFatal("Cannot create table");

    }
    else
    {
        qFatal("Database does not exist");
    }
}

//create tables
bool Users_DataBase::createTable()
{

    QSqlQuery query;
    QString db_input;

    if (!QSqlDatabase::database().tables().contains("user_list"))//create table with users
    {

        db_input = "PRAGMA foreign_keys=on;";
        if(!query.exec(db_input))
        {
                qWarning() << "Unable to PRAGMA foreign_keys=on" << query.lastError();
                return false;
        }

        db_input = "CREATE TABLE user_list ( "
                   "userID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
                   "name VARCHAR(20), "
                   "password VARCHAR(12), "
                   "email VARCHAR(20), "
                   "conf_mailing INTEGER, "
                   "conf_pers_data INTEGER);";
        if(!query.exec(db_input))
        {
                qWarning() << "Unable to create a user_list" << query.lastError();
                return false;
        }
    }

    if (!QSqlDatabase::database().tables().contains("to_do_list"))//create table with tasks
    {


        db_input = "CREATE TABLE to_do_list ( "
                   "taskID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
                   "task VARCHAR(50), "
                   "note VARCHAR(200), "
                   "date VARCHAR(20), "
                   "isImportant INTEGER, "
                   "userID INTEGER NOT NULL, "
                   "FOREIGN KEY (userID) REFERENCES user_list (userID) ON DELETE CASCADE);";

        if(!query.exec(db_input))
        {
                qWarning() << "Unable to create a to_do_list" << query.lastError();
                return false;
        }
    }


    return true;

}

//compare text data from qml with table records
void Users_DataBase::authorizeUser()
{

    QString str_q = "SELECT * FROM user_list WHERE name= '%1';";
    QString db_input = str_q.arg(userNameLog);
    QString base_name, base_pass;

    QSqlQuery query;
    QSqlRecord rec;

    if(!query.exec(db_input))
    {
        qWarning() << "Unable to execute query - exiting" << query.lastError() << " : " << query.lastQuery();
    }

    rec = query.record();
    query.next();

    userNameForHeader = base_name = query.value(rec.indexOf("name")).toString();
    base_pass = query.value(rec.indexOf("password")).toString();

    if(base_name!=userNameLog || base_pass!=userPassLog || userNameLog=="" || userPassLog=="")
    {
        m_login_successful = false;//is used in qml
    }
    else
    {
        m_login_successful = true;//is used in qml
    }

}

bool Users_DataBase::isTrue_login()
{
    return m_login_successful;
}

bool Users_DataBase::isTrue_reg()
{
    return m_register_successful;
}

//create new record in user table
void Users_DataBase::registerUser()
{

    if(userPassReg==userConfPassReg)
    {

        QSqlQuery query;

        QString str_q = "INSERT INTO user_list (name, password, email, "
                        "conf_mailing, conf_pers_data)"
                               "VALUES ('%1', '%2', '%3', %4, %5);";
        QString db_input = str_q.arg(userNameReg)
                                    .arg(userPassReg)
                                    .arg(emailReg)
                                    .arg(isChb1Checked)
                                    .arg(isChb2Checked);

        if(!query.exec(db_input))
        {
            qWarning() << "Unable to insert data"  << query.lastError() << " : " << query.lastQuery();
        }
        else
        {
            m_register_successful=true;
        }
    }
    else
    {
        //qWarning() << "Confirm password coorectly";
        m_register_successful=false;
    }

}

//get user data on registration page qml
void Users_DataBase::getUserRegDataFromQML(QString s1, QString s2, QString s3, QString s4, bool b1, bool b2 )
{
    userNameReg = s1;
    emailReg = s2;
    userPassReg = s3;
    userConfPassReg = s4;
    isChb1Checked = b1;
    isChb2Checked = b2;

}

//get user data on logib page qml
void Users_DataBase::getUserLoginDataFromQML(QString s1, QString s2)
{
    userNameLog = s1;
    userPassLog = s2;
}

//text for header
void Users_DataBase::sendUNameToQmlForHeaderSlt()
{
    emit sendUNameToQmlForHeaderSignl(userNameForHeader);
}



