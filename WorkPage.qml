import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.1
import Qt.labs.calendar 1.0

import Tasks_DataBase 1.0




Page
{
    Connections
    {
        target: App
        onSendUNameToQmlForHeaderSignl: page3.title = text;
    }

    id: page3
    visible: false
    title: ""

    function openCreateTaskDialog()
    {
        dialogCreate.open();
    }


    Keys.onEscapePressed:
    {
        popPage();
    }


/////////////////////NEW TASK Popup/////////////////////////
    Popup
    {

        width: 300
        height: 200
        anchors.centerIn: parent
        id: dialogCreate

        ColumnLayout
        {
            width: parent.width
            height: parent.height

            TextField
            {

                id: tf1
                Layout.fillWidth: true
                Layout.fillHeight: true
                placeholderText: "Enter your task"
                selectByMouse: true

                background: Rectangle
                {
                    border.color: tf1.text=="" ? "red" : "#2b5278"
                }

            }


            TextField
            {

                id: tf2
                Layout.fillWidth: true
                Layout.fillHeight: true
                placeholderText: "Enter note"
                selectByMouse: true
                background: Rectangle
                {
                    border.color: tf2.text=="" ? "red" : "#2b5278"
                }

            }



            RowLayout
            {
                id: rl

                TextField
                {
                    id: tf3
                    Layout.fillWidth: true
                    validator: RegExpValidator { regExp: /[0-9]{0,2}/ }
                    placeholderText: "Day"
                    selectByMouse: true

                    background: Rectangle
                    {
                        border.color: tf3.text.length <2 ? "red" : "#2b5278"
                    }

                }

                TextField
                {
                    id: tf4
                    Layout.fillWidth: true
                    validator: RegExpValidator { regExp: /[0-9]{2,2}/ }
                    placeholderText: "Month"
                    selectByMouse: true
                    background: Rectangle
                    {
                        border.color: tf4.text.length <2 ? "red" : "#2b5278"
                    }

                }

                TextField
                {
                    id: tf5
                    Layout.fillWidth: true
                    validator: RegExpValidator { regExp: /[0-9]{0,4}/ }
                    placeholderText: "Year"
                    selectByMouse: true
                    background: Rectangle
                    {
                        border.color: tf5.text.length <4 ? "red" : "#2b5278"
                    }

                }

                CheckBox
                {
                    id: isImpCh
                    anchors.margins: defMargin/2
                    checked: false
                    text: "Important"

                    indicator: Rectangle {
                              implicitWidth: 26
                              implicitHeight: 26
                              x: isImpCh.leftPadding
                              y: parent.height / 2 - height / 2



                              radius: 3
                              border.color: isImpCh.down ? "#1ec4c1" : "#0E1621"

                              Rectangle {
                                  width: 14
                                  height: 14

                                  x: 6
                                  y: 6
                                  radius: 2
                                  color: isImpCh.down ? "#1ec4c1" : "#2b5278"
                                  visible: isImpCh.checked
                              }
                          }

                }

            }

            RowLayout
            {
                height: 10
                Layout.fillWidth: true

                Button
                {
                    id: okBtn
                    text: "OK"
                    implicitHeight: dialogCreate.height*0.1
                    implicitWidth: dialogCreate.width*0.45

                    contentItem: Text {

                        text: okBtn.text
                        font: okBtn.font
                        opacity: enabled ? 1.0 : 0.3
                        color: okBtn.down ? "#1ec4c1" : "#2b5278"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        opacity: enabled ? 1 : 0.3
                        border.color: okBtn.down ? "#1ec4c1" : "#2b5278"
                        border.width: 1
                        radius: 10
                    }

                    onClicked:
                    {
                        m_model.createTask(tf1.text, tf2.text,
                                              tf3.text+"-"+tf4.text+"-"+tf5.text,
                                            isImpCh.checked);
                        m_model.updateModel();
                        dialogCreate.close();
                        m_model.updateCalendarSlot();
                        tf1.text=""; tf2.text=""; tf3.text=""; tf4.text=""; tf5.text="";
                        isImpCh.UnChecked;

                    }


                }

                Button
                {
                    id: cnclBtn
                    text: "Cancel"
                    implicitHeight: dialogCreate.height*0.1;
                    implicitWidth: dialogCreate.width*0.45

                    contentItem: Text {

                        text: cnclBtn.text
                        font: cnclBtn.font
                        opacity: enabled ? 1.0 : 0.3
                        color: cnclBtn.down ? "#1ec4c1" : "#2b5278"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        opacity: enabled ? 1 : 0.3
                        border.color: cnclBtn.down ? "#1ec4c1" : "#2b5278"
                        border.width: 1
                        radius: 10
                    }

                    onClicked:
                    {
                        dialogCreate.close();
                        tf1.text=""; tf2.text=""; tf3.text=""; tf4.text=""; tf5.text="";
                        isImpCh.UnChecked;
                    }


                }
            }



        }
    }


///////////////////////////////CALENDAR AND LISTVIEW//////////////////////

    ColumnLayout
    {
        id: functionalPAge
        anchors.fill: parent

        anchors.margins: defMargin
        spacing: defMargin
        
        ColumnLayout
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 200
            Layout.minimumWidth: 200
            
            SwipeView
            {
                id: swipeView
                Layout.fillHeight: true
                Layout.fillWidth: true
                currentIndex: tabBar.currentIndex
                
                
                CalendarPage {
                    id: cldPage
                }
                
                
                Page
                {


                        ListView {
                            id: listView
                            anchors.fill: parent
                            verticalLayoutDirection: ListView.BottomToTop
                            spacing: 12
                            ScrollBar.vertical: ScrollBar {}

                            model: m_model

                            delegate: Item
                            {
                                id: delegItem
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.margins: defMargin*2

                                height: lblText.contentHeight + 2*defMargin + lblTime.height

                                Dialog
                                {
                                    id: detailedD
                                    width: 200
                                    height: 150

                                    title: qsTr("Note")
                                    standardButtons: StandardButton.Ok | StandardButton.Cancel

                                    TextArea
                                    {
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        text: model.note
                                        id: detailedDTF
                                        background: Rectangle
                                        {
                                            border.color: detailedDTF.enabled ? "#2b5278" : "transparent"
                                            border.width: 2
                                        }
                                    }
                                }

                                MouseArea
                                {
                                    anchors.fill: parent
                                    onDoubleClicked:
                                    {
                                        detailedD.open()
                                    }
                                }



                                Rectangle {
                                    id: rectBubble
                                    color: win.bubbleColor
                                    anchors.fill: parent
                                    radius: 5

                                    Text {
                                        id: lblText
                                        anchors.top: parent.top
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.margins: defMargin
                                        font.pointSize: 11
                                        color: win.textColor
                                        wrapMode: Text.WordWrap
                                        text: model.task
                                    }

                                    Text {
                                        id: lblTime
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.margins: defMargin
                                        color: textColor
                                        text: model.date=="--"?"":model.date


                                    }

                                    CheckBox
                                    {
                                        id: isImpCh2
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.margins: defMargin/2
                                        checked: model.isImportant
                                        indicator: Rectangle {
                                                  implicitWidth: 26
                                                  implicitHeight: 26
                                                  x: isImpCh2.leftPadding
                                                  y: parent.height / 2 - height / 2



                                                  radius: 3
                                                  border.color: isImpCh2.down ? "#1ec4c1" : "#0E1621"

                                                  Rectangle {
                                                      width: 14
                                                      height: 14

                                                      x: 6
                                                      y: 6
                                                      radius: 2
                                                      color: isImpCh2.down ? "#1ec4c1" : "#2b5278"
                                                      visible: isImpCh2.checked
                                                  }
                                              }

                                    }

                                    Button
                                    {
                                        id: isDoneBtn
                                        height: isImpCh2.height
                                        width: isImpCh2.width
                                        anchors.right: isImpCh2.left
                                        anchors.top: parent.top
                                        anchors.margins: defMargin
                                        text: "DONE"

                                        contentItem: Text {

                                            text: isDoneBtn.text
                                            font: isDoneBtn.font
                                            opacity: enabled ? 1.0 : 0.3
                                            color: isDoneBtn.down ? "#1ec4c1" : "#2b5278"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            elide: Text.ElideRight
                                        }

                                        background: Rectangle {
                                            implicitWidth: 100
                                            implicitHeight: 40
                                            opacity: enabled ? 1 : 0.3
                                            border.color: isDoneBtn.down ? "#1ec4c1" : "#2b5278"
                                            border.width: 1
                                            radius: 2
                                        }

                                        onClicked:
                                        {
                                            m_model.removeRecord(m_model.getId(listView.indexAt(delegItem.x,delegItem.y)))
                                            m_model.updateCalendarSlot();
                                            m_model.updateModel();


                                        }

                                    }

                                }

                            }
                             
                        }

                }
                
            }
            
            
            Item
            {
                height: 20
            }
            
            
            
        }
        
    }



    footer: TabBar
    {
        id: tabBar
        currentIndex: swipeView.currentIndex
        
        TabButton {
            text: qsTr("Shifts Calendar")
        }

        TabButton {
            text: qsTr("Task Manager")
        }
        
    }
    

/////////////////////for flags: Qt.FramelessWindowHint///////////////////

//    MouseArea //не цепляется за футер
//    {
//        id: botArea
//        height: 5
//        anchors.bottom: parent.bottom
//        anchors.left: parent.left
//        anchors.right: parent.right

//        Rectangle
//        {
//            color: "yellow"
//            anchors.fill: parent
//        }

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
//            console.log("workpage scalling")
//        }

//        onMouseXChanged:
//        {
//            var dx = mouseX - prevX
//            win.setX(win.x+dx)
//            win.setWidth(win.width-dx)
//        }
//    }
}
