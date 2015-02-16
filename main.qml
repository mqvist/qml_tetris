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
        property int score: 0
        property int totalRowsKilled: 0
        property int level: totalRowsKilled / 10
        width: cellSize * cols
        height: cellSize * rows
        color: 'black'
        focus: true

        Item {
            id: block
            property int col: gameField.cols / 2
            property int row: gameField.rows
            property var cellOffsetList
            property int cellOffsetListIndex
            property var cellOffsets: cellOffsetList[cellOffsetListIndex]
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
                    PropertyChanges {
                        target: block
                        color: 'cyan'
                        cellOffsetList: [[[0, 0], [0, 1], [0, 2], [0, 3]], [[1, 1], [0, 1], [-1, 1], [-2, 1]]]
                    }
                },
                State {
                    name: 'O';
                    PropertyChanges {
                        target: block
                        color: 'yellow'
                        cellOffsetList: [[[0, 0], [0, 1], [-1, 0], [-1, 1]]]
                    }
                },
                State {
                    name: 'T';
                    PropertyChanges {
                        target: block
                        color: 'purple'
                        cellOffsetList: [[[0, 0], [0, 1], [0, 2], [-1, 1]], [[0, 2], [0, 1], [1, 1], [-1, 1]], [[0, 0], [0, 1], [0, 2], [1, 1]], [[0, 0], [0, 1], [1, 1], [-1, 1]]]
                    }
                },
                State {
                    name: 'J';
                    PropertyChanges {
                        target: block
                        color: 'blue'
                        cellOffsetList: [[[0, 0], [0, 1], [0, 2], [-1, 2]], [[1, 1], [0, 1], [-1, 1], [1, 2]], [[0, 0], [0, 1], [0, 2], [1, 0]], [[1, 1], [0, 1], [-1, 1], [-1, 0]]]
                    }
                },
                State {
                    name: 'L';
                    PropertyChanges {
                        target: block
                        color: 'orange'
                        cellOffsetList: [[[0, 0], [0, 1], [0, 2], [-1, 0]], [[1, 1], [0, 1], [-1, 1], [-1, 2]], [[0, 0], [0, 1], [0, 2], [1, 2]], [[1, 1], [0, 1], [-1, 1], [1, 0]]]
                    }
                },
                State {
                    name: 'S';
                    PropertyChanges {
                        target: block
                        color: 'green'
                        cellOffsetList: [[[0, 1], [0, 2], [-1, 0], [-1, 1]], [[0, 1], [0, 2], [1, 1], [-1, 2]]]
                    }
                },
                State {
                    name: 'Z';
                    PropertyChanges {
                        target: block
                        color: 'red'
                        cellOffsetList: [[[0, 0], [0, 1], [-1, 1], [-1, 2]], [[0, 0], [0, 1], [-1, 0], [1, 1]]]
                    }
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
                    Game.freezeBlock(block)
                    reset()
                }
            }
            function drop() {
                blockTimer.interval = 10
            }
            function rotate() {
                var oldIndex = block.cellOffsetListIndex
                var index = block.cellOffsetListIndex + 1
                index %= block.cellOffsetList.length
                block.cellOffsetListIndex = index
                if (!Game.canBlockMove(block, 0, 0))
                    block.cellOffsetListIndex = oldIndex
            }
            function reset() {
                col = gameField.cols / 2
                row = gameField.rows
                cellOffsetListIndex = 0
                state = states[Math.floor(Math.random() * states.length)].name
                blockTimer.interval = 1000 - gameField.level * 100
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
            else if (event.key === Qt.Key_Space) {
                block.drop()
            }
            else if (event.key === Qt.Key_Up) {
                block.rotate()
            }
        }
        function scoreKilledRows(rows) {
            switch (rows) {
            case 1:
                score += 40 * (level + 1)
                break
            case 2:
                score += 100 * (level + 1)
                break
            case 3:
                score += 300 * (level + 1)
                break
            case 4:
                score += 1200 * (level + 1)
                break
            }
            totalRowsKilled += rows
        }
    }
    Column {
        anchors.left: gameField.right
        Text {
            text: 'SCORE: ' + gameField.score
        }
        Text {
            text: 'LEVEL: ' + gameField.level
        }
        Text {
            text: 'ROWS: ' + gameField.totalRowsKilled
        }
        Text {
            text: 'SPEED: ' + blockTimer.interval
        }
    }
    Component.onCompleted: Game.init(gameField);
}
