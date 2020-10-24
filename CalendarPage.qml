import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.1
import Qt.labs.calendar 1.0
import QtQuick.Dialogs 1.2
import Tasks_DataBase 1.0

import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0


Page
{
    id: cldrPage

    Connections
    {
        target: m_model
        onChangeMonthsSign:
        {
            calendar.__selectNextMonth();
            calendar.__selectPreviousMonth();
        }
    }

    Flow
    {
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10
        layoutDirection: Qt.LeftToRight

        Calendar
        {
            id: calendar
            width: (parent.width > parent.height ? parent.width * 0.6 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.6 - parent.spacing : parent.height)

            frameVisible: true
            weekNumbersVisible: true
            selectedDate:  new Date(Date.now())
            focus: true

            style: CalendarStyle
            {
                dayDelegate: Item
                {
                    readonly property color sameMonthDateTextColor: "black"
                    readonly property color selectedDateColor: "#3778d0"
                    readonly property color selectedDateTextColor: "white"
                    readonly property color differentMonthDateTextColor: "lightgrey"
                    readonly property color invalidDatecolor: "red"

                    Rectangle
                    {
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.selected ? selectedDateColor : "transparent"
                        anchors.margins: styleData.selected ? -2 : 0
                    }

                    Image
                    {
                        visible: m_model.eventsForDate(styleData.date).length > 0
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: -1
                        width: parent.width*0.3
                        height: width
                        source: "qrc:/star.png"

                    }

                    Label
                    {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid)
                            {
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected)
                                {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }

                    }
                }
            }
        }



        Component// header for eventsListView
        {
            id: eventListHeader

            Row
            {
                id: eventDateRow
                width: parent.width
                height: eventDayLabel.height
                spacing: 10

                Label
                {
                    id: eventDayLabel
                    text: calendar.selectedDate.getDate()
                    font.pointSize: 35
                }

                Column//month and year
                {
                    height: eventDayLabel.height

                    Label
                    {
                        text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                        font.pointSize: 18
                    }

                    Label
                    {
                        text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                              + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
                        font.pointSize: 12
                    }
                }
            }
        }



        Rectangle//shows day-info and tasks for each day
        {
            width: (parent.width > parent.height ? parent.width * 0.4 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.5 - parent.spacing : parent.height)
            border.color: Qt.darker(color, 1.2)

            ListView
            {
                id: eventsListView
                spacing: 4
                clip: true
                header: eventListHeader
                anchors.fill: parent
                anchors.margins: 10
                model: m_model.eventsForDate(calendar.selectedDate)

                delegate: Rectangle
                {
                    width: eventsListView.width
                    height: eventItemColumn.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image
                    {
                        anchors.top: parent.top
                        anchors.topMargin: 4
                        width: 20
                        height: width
                        source: "qrc:/star.png"
                    }

                    Rectangle
                    {
                        width: parent.width
                        height: 1
                        color: "#eee"
                    }

                    Column
                    {
                        id: eventItemColumn
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        height: timeLabel.height + nameLabel.height + 8

                        Label
                        {
                            id: nameLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: modelData.name
                        }

                        Label
                        {
                            id: timeLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: modelData.date.toLocaleDateString(calendar.locale, Locale.ShortFormat)
                            color: "#aaa"
                        }

                        Label
                        {
                            id: descrLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: modelData.note
                            color: "#aaa"
                        }
                    }
                }
            }
        }
    }
}
