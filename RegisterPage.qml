import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.1

import Tasks_DataBase 1.0

Page
{
    id: page2
    visible: false
    title: "Super Calendar 5000"

    Keys.onReturnPressed:
    {
        regBtn.clicked()
    }

    Popup
    {
        id: ppup
        anchors.centerIn: parent
        height: parent.height*0.1
        width: parent.width*0.5
        Text
        {
            anchors.centerIn: parent
            text: qsTr("Success")
            font.pointSize: 10
        }

    }

    Button
    {
        id: regBtn
        visible: text.length>0
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: defMargin
        text: "Finish registration"
        focus: true

        onActiveFocusChanged:
        {
            rectRegBtn.border.width = activeFocus ? 2 : 1
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
            id: rectRegBtn
            implicitWidth: 100
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            border.color: regBtn.down ? "#1ec4c1" : "#2b5278"
            border.width: 1
            radius: 10
        }


        enabled: (userNameReg.text.length < 4 || userEmailReg.text.length < 4
                  ||userPassReg.text.length < 4 || userPassConfReg.text.length < 4
                  ||(userPassReg.text!=userPassConfReg.text)
                  ) ? false : true


        onClicked:
        {

            App.getUserRegDataFromQML(userNameReg.text, userEmailReg.text,
                                      userPassReg.text, userPassConfReg.text,
                                      chb1.checked, chb2.checked);
            
            App.registerUser();
            
            if(App.isTrue_reg())
            {
                stackView.pop();
                ppup.open()
            }
            /*
            else
                console.log("Some mistake")*/

        }
    }


    Keys.onEscapePressed:
    {
        popPage();
    }
    
    
    ColumnLayout
    {
        id: userDatePage
        anchors.fill: parent
        anchors.margins: defMargin
        spacing: defMargin
        
        ColumnLayout
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 200
            Layout.minimumWidth: 200
            

            Label
            {
                text: "Please register yourself"
                font.pointSize: 14
                font.bold: true
            }
            
            Item
            {
                height: 10
            }
            
            Label
            {
                text: "Username"
            }
            
            TextField
            {
                id: userNameReg
                placeholderText: "Enter your username"
                selectByMouse: true
                Layout.fillWidth: true
                validator: RegExpValidator { regExp: /[a-zA-Z0-9@_-. ]{1,20}/ }

                onActiveFocusChanged:
                {
                    rectU.border.width = activeFocus ? 3 : 2
                }

                background: Rectangle
                {
                    id: rectU
                    border.color: userNameReg.text.length < 4 ? "red" : "#2b5278"
                    implicitHeight: page2.height*0.1
                    radius: 10
                    border.width: 2
                }


            }
            
            Label
            {
                text: "Email"
            }
            
            TextField
            {
                id: userEmailReg
                placeholderText: "Enter your email"
                selectByMouse: true
                Layout.fillWidth: true
                validator: RegExpValidator { regExp: /[a-zA-Z0-9@_-.]{1,20}/ }

                onActiveFocusChanged:
                {
                    rectMail.border.width = activeFocus ? 3 : 2
                }

                background: Rectangle
                {
                    id: rectMail

                    border.color: userEmailReg.text.length < 4 ? "red" : "#2b5278"
                    implicitHeight: page2.height*0.1
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
                id: userPassReg
                selectByMouse: true
                echoMode: TextInput.Password
                placeholderText: "Enter your password"
                Layout.fillWidth: true
                validator: RegExpValidator { regExp: /[a-zA-Z0-9@_-.]{1,20}/ }

                onActiveFocusChanged:
                {
                    rectPas1.border.width = activeFocus ? 3 : 2
                }

                background: Rectangle
                {
                    id: rectPas1
                    border.color: userPassReg.text.length < 4 ? "red" : "#2b5278"
                    implicitHeight: page2.height*0.1
                    radius: 10
                    border.width: 2
                }
            }
            
            Label
            {
                text: "Confirm password"
            }
            
            TextField
            {
                id: userPassConfReg
                selectByMouse: true
                echoMode: TextInput.Password
                placeholderText: "Enter your password"
                Layout.fillWidth: true
                validator: RegExpValidator { regExp: /[a-zA-Z0-9@_-.]{1,20}/ }

                onActiveFocusChanged:
                {
                    rectPas2.border.width = activeFocus ? 3 : 2
                }

                background: Rectangle
                {
                    id: rectPas2
                    border.color: userPassConfReg.text.length < 4 ? "red" : "#2b5278"
                    implicitHeight: page2.height*0.1
                    radius: 10
                    border.width: 2
                }
            }
            
            CheckBox
            {
                id: chb1
                checked: true
                text: "Я согласен получать спам-рассылку."

            }
            
            CheckBox
            {
                id: chb2
                checked: true
                text: "Я согласен на обработку моих персональных данных <br> третьими и четвертыми лицами, а так же пятыми."
            }
            
            Item
            {
                Layout.fillHeight: true
            }
              
        }
    }

    /////////////////////for flags: Qt.FramelessWindowHint//////////////////////////////

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
