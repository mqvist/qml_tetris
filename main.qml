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
            property int col: gameField.cellsX / 2
            property int row: gameField.cellsY
            x: (col - 1 )* gameField.cellSize
            y: (gameField.cellsY - row) * gameField.cellSize
            Rectangle {
                width: gameField.cellSize
                height: gameField.cellSize
                color: 'yellow'
            }
            Timer {
                id: blockTimer
                interval: 1000
                running: true
                repeat: true
                onTriggered: block.down()
            }
            function left() {
                if (col > 1)
                    col -= 1
            }
            function right() {
                if (col < gameField.cellsX)
                    col += 1
            }
            function down() {
                if (row > 1)
                    row -= 1
                else
                    reset()
            }
            function drop() {
                blockTimer.interval = 10
            }
            function reset() {
                col = gameField.cellsX / 2
                row = gameField.cellsY
                blockTimer.interval = 1000
            }

        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Left) {
                block.left()
            }
            else if (event.key === Qt.Key_Right) {
                block.right()
            }
            else if (event.key === Qt.Key_Down) {
                block.drop()
            }
        }
    }
    Text {
        anchors.left: gameField.right
        text: 'SCORE: '
    }
}
