import QtQuick 2.3
import QtQuick.Window 2.2

Window {
    visible: true
    width: 300
    height: 400

    Rectangle {
        id: gameField
        property int cellSize: 20
        property int cellsX: 10
        property int cellsY: 20
        width: cellSize * cellsX
        height: cellSize * cellsY
        color: 'black'
        focus: true

        Item {
            id: block
            x: gameField.cellsX / 2 * gameField.cellSize
            Rectangle {
                width: gameField.cellSize
                height: gameField.cellSize
                color: 'yellow'
            }
        }
        Timer {
            id: tick
            interval: 1000
            running: true
            repeat: true
            onTriggered: block.y += gameField.cellSize
        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Left) {
                block.x -= gameField.cellSize
            }
            else if (event.key === Qt.Key_Right) {
                block.x += gameField.cellSize
            }
            else if (event.key === Qt.Key_Down) {
                // Drop
                tick.interval = 10
            }
        }
    }
    Text {
        anchors.left: gameField.right
        text: 'SCORE: '
    }
}
