import QtQuick 2.3
import QtQuick.Window 2.2

Window {
    visible: true
    width: 300
    height: 400

    Rectangle {
        id: gameArea
        property int cellSize: 20
        property int cellsX: 10
        property int cellsY: 20
        width: cellSize * cellsX
        height: cellSize * cellsY
        color: 'black'
        focus: true

        Item {
            id: block
            x: gameArea.cellsX / 2 * gameArea.cellSize
            Rectangle {
                width: gameArea.cellSize
                height: gameArea.cellSize
                color: 'yellow'
            }
        }
        Timer {
            id: tick
            interval: 1000
            running: true
            repeat: true
            onTriggered: block.y += gameArea.cellSize
        }
        Keys.onPressed: {
            if (event.key == Qt.Key_Left) {
                block.x -= gameArea.cellSize
            }
            else if (event.key == Qt.Key_Right) {
                block.x += gameArea.cellSize
            }
            else if (event.key == Qt.Key_Down) {
                // Drop
                tick.interval = 10
            }
        }
    }
    Text {
        anchors.left: gameArea.right
        text: 'SCORE: '
    }
}
