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

        Item {
            id: block
            property int col: gameField.cols / 2
            property int row: gameField.rows
            property string color: 'yellow'
            state: 'I'
            Cell {
                id: cell1
                row: parent.row
                maxRow: gameField.rows
                cellSize: gameField.cellSize
                color: parent.color
                visible: true
            }
            Cell {
                id: cell2
                row: parent.row
                maxRow: gameField.rows
                cellSize: gameField.cellSize
                color: parent.color
                visible: true
            }
            Cell {
                id: cell3
                row: parent.row
                maxRow: gameField.rows
                cellSize: gameField.cellSize
                color: parent.color
                visible: true
            }
            Cell {
                id: cell4
                row: parent.row
                maxRow: gameField.rows
                cellSize: gameField.cellSize
                color: parent.color
                visible: true
            }
            states: [
                State {
                    name: 'I'
                    PropertyChanges { target: block; color: 'light blue' }
                    PropertyChanges { target: cell1; col: parent.col; row: parent.row }
                    PropertyChanges { target: cell2; col: parent.col + 1; row: parent.row }
                    PropertyChanges { target: cell3; col: parent.col + 2; row: parent.row }
                    PropertyChanges { target: cell4; col: parent.col + 3; row: parent.row }
                },
                State {
                    name: 'O';
                    PropertyChanges { target: block; color: 'yellow' }
                    PropertyChanges { target: cell1; col: parent.col; row: parent.row }
                    PropertyChanges { target: cell2; col: parent.col + 1; row: parent.row }
                    PropertyChanges { target: cell3; col: parent.col; row: parent.row + 1}
                    PropertyChanges { target: cell4; col: parent.col + 1; row: parent.row + 1 }
                },
                State {
                    name: 'T';
                    PropertyChanges { target: block; color: 'purple' }
                    PropertyChanges { target: cell1; col: parent.col; row: parent.row }
                    PropertyChanges { target: cell2; col: parent.col + 1; row: parent.row }
                    PropertyChanges { target: cell3; col: parent.col + 2; row: parent.row }
                    PropertyChanges { target: cell4; col: parent.col + 1; row: parent.row + 1 }
                },
                State {
                    name: 'J';
                    PropertyChanges { target: block; color: 'blue' }
                    PropertyChanges { target: cell1; col: parent.col; row: parent.row }
                    PropertyChanges { target: cell2; col: parent.col + 1; row: parent.row }
                    PropertyChanges { target: cell3; col: parent.col + 2; row: parent.row }
                    PropertyChanges { target: cell4; col: parent.col + 2; row: parent.row + 1 }
                },
                State {
                    name: 'L';
                    PropertyChanges { target: block; color: 'orange' }
                    PropertyChanges { target: cell1; col: parent.col; row: parent.row }
                    PropertyChanges { target: cell2; col: parent.col + 1; row: parent.row }
                    PropertyChanges { target: cell3; col: parent.col + 2; row: parent.row }
                    PropertyChanges { target: cell4; col: parent.col; row: parent.row + 1 }
                },
                State {
                    name: 'S';
                    PropertyChanges { target: block; color: 'green' }
                    PropertyChanges { target: cell1; col: parent.col + 1; row: parent.row }
                    PropertyChanges { target: cell2; col: parent.col + 2; row: parent.row }
                    PropertyChanges { target: cell3; col: parent.col; row: parent.row + 1 }
                    PropertyChanges { target: cell4; col: parent.col + 1; row: parent.row + 1 }
                },
                State {
                    name: 'Z';
                    PropertyChanges { target: block; color: 'red' }
                    PropertyChanges { target: cell1; col: parent.col; row: parent.row }
                    PropertyChanges { target: cell2; col: parent.col + 1; row: parent.row }
                    PropertyChanges { target: cell3; col: parent.col + 1; row: parent.row + 1 }
                    PropertyChanges { target: cell4; col: parent.col + 2; row: parent.row + 1 }
                }
            ]

            Timer {
                id: blockTimer
                interval: 1000
                running: true
                repeat: true
                onTriggered: block.down()
            }
            function left() {
                if (col > 1 && Game.isCellFree(row, col - 1))
                    col -= 1
            }
            function right() {
                if (col < gameField.cols && Game.isCellFree(row, col + 1))
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
                state = states[Math.floor(Math.random() * states.length)].name
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
