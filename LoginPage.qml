import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.1
import Qt.labs.calendar 1.0

import Tasks_DataBase 1.0


Page
{
    id: page1
    title: "Super Calendar 5000"

    Popup
    {
        id: popWrAnsw
        anchors.centerIn: parent
        height: page1.height*0.35
        width: page1.width

        Label
        {
            anchors.centerIn: parent
            text: "WRONG PASSWORD"
        }
    }


    Keys.onEscapePressed:
    {
        stackView.pop()
    }


    Keys.onReturnPressed:
    {
        regBtn.activeFocus ? regBtn.clicked() :lgnBtn.clicked()

    }



    
    ColumnLayout
    {
        id: loGeneral
        anchors.fill: parent
        anchors.margins: defMargin
        spacing: defMargin

        
        ColumnLayout
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 200
            Layout.minimumWidth: 200
            


            Item
            {
                Layout.fillHeight: true
            }

            Label
            {
                text: "Please login or register yourself"
                font.pointSize: 14
                font.bold: true
            }

            Item
            {
                height: 20
            }

            Label
            {
                text: "Username"
            }

            TextField
            {
                id: userNameLog
                focus: true
                placeholderText: "Enter your username"
                selectByMouse: true

                onActiveFocusChanged:
                {
                    rectName.border.width = activeFocus ? 3 : 2
                }

                Layout.fillWidth: true
                validator: RegExpValidator { regExp: /[a-zA-Z0-9@_-. ]{1,20}/ }

                background: Rectangle
                {
                    id: rectName
                    border.color: userNameLog.text.length < 4 ? "red" : "#2b5278"
                    implicitHeight: page1.height*0.1
                    radius: 10
                    border.width: 2
                }

            }

            Label
            {
                text: "Password"
            }

            TextField
            {
                id: userPassLog
                selectByMouse: true

                onActiveFocusChanged:
                {
                    rectPas.border.width = activeFocus ? 3 : 2
                }

                echoMode: TextInput.Password
                placeholderText: "Enter your password"
                Layout.fillWidth: true
                validator: RegExpValidator { regExp: /[a-zA-Z0-9@_-.]{1,20}/ }

                background: Rectangle
                {
                    id: rectPas
                    border.color: userPassLog.text.length < 4 ? "red" : "#2b5278"
                    implicitHeight: page1.height*0.1
                    radius: 10
                    border.width: 2
                }

            }

            Item
            {
                Layout.fillHeight: true
            }
            
            
            
        }
        
        RowLayout
        {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            
            Item
            {
                Layout.fillHeight: true
                
            }
            
            Button
            {
                id: lgnBtn
                text:"Login"
                activeFocusOnTab: true

                onActiveFocusChanged:
                {
                    rectLog.border.width = activeFocus ? 2 : 1
                }

                contentItem: Text
                {

                    text: lgnBtn.text
                    font: lgnBtn.font
                    opacity: enabled ? 1.0 : 0.3
                    color: lgnBtn.down ? "#1ec4c1" : "#2b5278"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle
                {
                    id: rectLog
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    border.color: lgnBtn.down ? "#1ec4c1" : "#2b5278"
                    border.width: 1
                    radius: 10
                }

                enabled: (userNameLog.text.length < 4|| userPassLog.text.length < 4) ? false : true

                onClicked:
                {

                    App.getUserLoginDataFromQML(userNameLog.text, userPassLog.text);
                    m_model.setName(userNameLog.text);
                    App.authorizeUser();

                    if(App.isTrue_login())
                    {
                        stackView.push(page3)
                        userNameLog.text = "";
                        userPassLog.text = "";
                        App.sendUNameToQmlForHeaderSlt();
                        m_model.updateModel();
                        m_model.updateCalendarSlot();

                    }
                    else
                    {
                        popWrAnsw.open()
                    }
                }



            }
            
            Button
            {
                id: regBtn
                text:"Register"
                activeFocusOnTab: true
                onActiveFocusChanged:
                {
                    rectReg.border.width = activeFocus ? 2 : 1
                }

                contentItem: Text
                {

                    text: regBtn.text
                    font: regBtn.font
                    opacity: enabled ? 1.0 : 0.3
                    color: regBtn.down ? "#1ec4c1" : "#2b5278"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle
                {
                    id: rectReg
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    border.color: regBtn.down ? "#1ec4c1" : "#2b5278"
                    border.width: 1
                    radius: 10
                }


                onClicked:
                {
                    stackView.push(page2)
                }
            }

            Item
            {
                Layout.fillHeight: true

            }
        }

        Label {
            Layout.alignment: Qt.AlignRight
            id: lbl2
            horizontalAlignment: Text.AlignRight
            text: qsTr("Created by Sergey Chagin, Saint Petersburg, Russia \nContact: s.vvardenfell@yandex.ru")

        }
    }

//////////////for flags: Qt.FramelessWindowHint/////////////////////////////////////


//    MouseArea
//    {
//        id: botArea
//        height: 5
//        anchors.bottom: parent.bottom
//        anchors.left: parent.left
//        anchors.right: parent.right

//        cursorShape: Qt.SizeVerCursor

//        onPressed:
//        {
//            prevY = mouseY
//        }

//        onMouseYChanged:
//        {
//            var dy = mouseY - prevY
//            win.setHeight(win.height+dy)
//        }
//    }

//    MouseArea
//    {
//        id: rightArea
//        width: 5

//        anchors.top: parent.top
//        anchors.bottom: parent.bottom
//        anchors.right: parent.right

//        cursorShape: Qt.SizeHorCursor

//        onPressed:
//        {
//            prevX = mouseX
//        }

//        onMouseXChanged:
//        {
//            var dx = mouseX - prevX
//            win.setWidth(win.width+dx)
//        }
//    }

//    MouseArea
//    {
//        id: leftArea
//        width: 5
//        anchors.bottom: parent.bottom
//        anchors.left: parent.left
//        anchors.top: parent.top

//        cursorShape: Qt.SizeHorCursor

//        onPressed:
//        {
//            prevX = mouseX
//        }

//        onMouseXChanged:
//        {
//            var dx = mouseX - prevX
//            win.setX(win.x+dx)
//            win.setWidth(win.width-dx)
//        }
//    }


////////////////LEFT_BOT RIGHT_BOT//////////////////////////

//    MouseArea
//    {
//        id: rightBottom
//        width: 10
//        height: 10

//        Rectangle
//        {
//            anchors.fill: parent
//            color: "red"
//        }

//        anchors.bottom: parent.bottom
//        anchors.right: parent.right


//        cursorShape: Qt.SizeFDiagCursor
//        onPressed:
//        {
//            prevX = mouseX
//            prevY = mouseY
//        }

//        onMouseXChanged:
//        {
//            var dx = mouseX - prevX
//            win.setWidth(win.width+dx)

//            var dy = mouseY - prevY
//            win.setHeight(win.height+dy)
//        }
//    }

//    MouseArea
//    {
//        id: leftBottom

//        width: 10
//        height: 10

//        Rectangle
//        {
//            anchors.fill: parent
//            color: "red"
//        }

//        anchors.bottom: parent.bottom
//        anchors.left: parent.left

//        cursorShape: Qt.SizeBDiagCursor

//        onPressed:
//        {
//            prevX = mouseX
//            prevY = mouseY
//        }

//        onMouseXChanged:
//        {
//            var dx = mouseX - prevX
//            win.setX(win.x+dx)
//            win.setWidth(win.width-dx)

//            var dy = mouseY - prevY
//            win.setHeight(win.height+dy)
//        }
//    }

}
