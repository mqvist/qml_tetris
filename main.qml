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
            property variant cellOffsets
            property string color
            Cell {
                row: parent.row + parent.cellOffsets[0][0]
                col: parent.col + parent.cellOffsets[0][1]
                maxRow: gameField.rows
                cellSize: gameField.cellSize
                color: parent.color
            }
            Cell {
                row: parent.row + parent.cellOffsets[1][0]
                col: parent.col + parent.cellOffsets[1][1]
                maxRow: gameField.rows
                cellSize: gameField.cellSize
                color: parent.color
            }
            Cell {
                row: parent.row + parent.cellOffsets[2][0]
                col: parent.col + parent.cellOffsets[2][1]
                maxRow: gameField.rows
                cellSize: gameField.cellSize
                color: parent.color
            }
            Cell {
                row: parent.row + parent.cellOffsets[3][0]
                col: parent.col + parent.cellOffsets[3][1]
                maxRow: gameField.rows
                cellSize: gameField.cellSize
                color: parent.color
            }
            states: [
                State {
                    name: 'I'
                    PropertyChanges { target: block; color: 'cyan'; cellOffsets: [[0, 0], [0, 1], [0, 2], [0, 3]] }
                },
                State {
                    name: 'O';
                    PropertyChanges { target: block; color: 'yellow'; cellOffsets: [[0, 0], [0, 1], [-1, 0], [-1, 1]] }
                },
                State {
                    name: 'T';
                    PropertyChanges { target: block; color: 'purple'; cellOffsets: [[0, 0], [0, 1], [0, 2], [-1, 1]] }
                },
                State {
                    name: 'J';
                    PropertyChanges { target: block; color: 'blue'; cellOffsets: [[0, 0], [0, 1], [0, 2], [-1, 2]] }
                },
                State {
                    name: 'L';
                    PropertyChanges { target: block; color: 'orange'; cellOffsets: [[0, 0], [0, 1], [0, 2], [-1, 0]] }
                },
                State {
                    name: 'S';
                    PropertyChanges { target: block; color: 'green'; cellOffsets: [[0, 1], [0, 2], [-1, 0], [-1, 1]] }
                },
                State {
                    name: 'Z';
                    PropertyChanges { target: block; color: 'red'; cellOffsets: [[0, 0], [0, 1], [-1, 1], [-1, 2]] }
                }
            ]
            Component.onCompleted: reset()
            Timer {
                id: blockTimer
                repeat: true
                onTriggered: block.down()
            }
            function left() {
                if (Game.canBlockMove(block, 0, -1))
                    col -= 1
            }
            function right() {
                if (Game.canBlockMove(block, 0, 1))
                    col += 1
            }
            function down() {
                if (Game.canBlockMove(block, -1, 0))
                    row -= 1
                else {
                    blockTimer.running = false
                    Game.fillCells(block)
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
                blockTimer.interval = 750
                blockTimer.running = true
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
