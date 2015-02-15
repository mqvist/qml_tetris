import QtQuick 2.3
import QtQuick.Window 2.2
import "game.js" as Game

Window {
    visible: true
    width: 300
    height: 400

    Rectangle {
        id: gameField
        property int cellSize: 20
        property int cols: 10
        property int rows: 20
        width: cellSize * cols
        height: cellSize * rows
        color: 'black'
        focus: true

        Cell {
            id: block
            col: gameField.cols / 2
            row: gameField.rows
            maxRow: gameField.rows
            cellSize: gameField.cellSize
            color: 'yellow'
            visible: true
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
                if (col < gameField.cols)
                    col += 1
            }
            function down() {
                if (row > 1 && Game.isCellFree(row - 1, col))
                    row -= 1
                else {
                    Game.fillCell(row, col, color)
                    reset()
                }
            }
            function drop() {
                blockTimer.interval = 10
            }
            function reset() {
                col = gameField.cols / 2
                row = gameField.rows
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
    Component.onCompleted: Game.init(gameField);
}
