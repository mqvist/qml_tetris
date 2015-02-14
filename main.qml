import QtQuick 2.3
import QtQuick.Window 2.2

Window {
    visible: true
    width: 300
    height: 400
    Rectangle {
        id: gameArea
        width: 200
        height: 400
        color: 'black'

        Item {
            id: block
            x: 100
            Rectangle {
                width: 10
                height: 10
                color: 'yellow'
            }
        }
        Timer {
            interval: 1000;
            running: true
            repeat: true
            onTriggered: block.y += 10
        }
    }
}
