import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.1
import Qt.labs.calendar 1.0

import Tasks_DataBase 1.0


ApplicationWindow
{
    Tasks_DataBase{id: m_model}

    id: win
    visible: true
    width: 350
    height: 500
    title: qsTr("Super Calendar 5000")

    //flags: Qt.FramelessWindowHint

    property int defMargin: 10

    readonly property color panelColor: "#17212B"
    readonly property color bubbleColor: "#2b5278"
    readonly property color bgColor: "#0E1621"
    readonly property color textColor: "black"

    property int prevX;
    property int prevY;


    function popPage()
    {
        stackView.pop();
    }


    ///////////////////////HEADER////////////////////
    header: ToolBar
    {
        id: head
        height: win.height*0.05

        background:
        Rectangle
        {
            anchors.fill: parent
            color: "#2b5278"

//////////////for flags: Qt.FramelessWindowHint//////////////

//            MouseArea
//            {
//                anchors.fill: parent

//                onPressed:
//                {
//                    prevX = mouseX
//                    prevY = mouseY
//                }

//                onMouseXChanged:
//                {
//                    var dx = mouseX-prevX
//                    win.setX(win.x+dx)
//                }

//                onMouseYChanged:
//                {
//                    var dy = mouseY-prevY
//                    win.setY(win.y+dy)
//                }

//            }

//            MouseArea
//            {
//                id: topArea
//                height: 5
//                anchors.top: parent.top
//                anchors.left: parent.left
//                anchors.right: parent.right

//                cursorShape: Qt.SizeVerCursor

//                onPressed:
//                {
//                    prevY = mouseY
//                }

//                onMouseYChanged:
//                {
//                    var dy = mouseY - prevY
//                    win.setY(win.y+dy)
//                    win.setHeight(win.height-dy)
//                }
//            }

//            MouseArea
//            {
//                id: rightTop
//                width: 10
//                height: 10

//                Rectangle
//                {
//                    anchors.fill: parent
//                    color: "red"
//                }

//                anchors.top: parent.top
//                anchors.right: parent.right


//                cursorShape: Qt.SizeBDiagCursor
//                onPressed:
//                {
//                    prevX = mouseX
//                    prevY = mouseY
//                }

//                onMouseXChanged:
//                {
//                    var dx = mouseX - prevX
//                    win.setWidth(win.width+dx)

//                    var dy = mouseY - prevY
//                    win.setY(win.y+dy)
//                    win.setHeight(win.height-dy)
//                }
//            }

//            MouseArea
//            {
//                id: leftTop

//                width: 10
//                height: 10

//                Rectangle
//                {
//                    anchors.fill: parent
//                    color: "red"
//                }

//                anchors.top: parent.top
//                anchors.left: parent.left


//                cursorShape: Qt.SizeFDiagCursor

//                onPressed:
//                {
//                    prevX = mouseX
//                    prevY = mouseY
//                }

//                onMouseXChanged:
//                {
//                    var dx = mouseX - prevX
//                    win.setX(win.x+dx)
//                    win.setWidth(win.width-dx)

//                    var dy = mouseY - prevY
//                    win.setY(win.y+dy)
//                    win.setHeight(win.height-dy)
//                }
//            }
        }

        ToolButton
        {
            id: btnExit
            text: "<"
            visible: stackView.depth>1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: defMargin
            height: parent.height
            onClicked:
            {
                stackView.pop(page1);
                m_model.mUserID=0;
            }
        }

        Text
        {
            text: stackView.currentItem.title
            anchors.centerIn: parent
            font.pointSize: 16

        }

        ToolButton
        {
            id: btnNewTask
            text: "+"
            //visible: stackView.depth>1 && stackView.currentItem != page2
            visible: stackView.currentItem == page3
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: defMargin
            height: parent.height

            Component.onCompleted:
            {
                btnNewTask.clicked.connect(page3.openCreateTaskDialog)
            }

        }

    }

///////////////////////STACKVIEW////////////////////

    StackView
    {
        id: stackView
        anchors.fill: parent
        initialItem: page1
    }


    LoginPage {
        id: page1
    }


    RegisterPage {
        id: page2
    }


    WorkPage {
        id: page3

    }


}


