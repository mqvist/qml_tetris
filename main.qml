import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import "game.js" as Game

Window {
    visible: true
    width: 300
    height: 400
    color: 'black'

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
        signal rowsKilled (int rows)
        Block {
            id: gameBlock
            Component.onCompleted: reset()
            Timer {
                id: blockTimer
                repeat: true
                onTriggered: gameBlock.down()
            }
            function left() {
                if (Game.canBlockMove(gameBlock, 0, -1))
                    col -= 1
            }
            function right() {
                if (Game.canBlockMove(gameBlock, 0, 1))
                    col += 1
            }
            function down() {
                if (Game.canBlockMove(gameBlock, -1, 0))
                    row -= 1
                else {
                    blockTimer.running = false
                    Game.freezeBlock(gameBlock)
                    reset()
                }
            }
            function drop() {
                blockTimer.interval = 10
            }
            function rotate() {
                rotateCCW()
                if (!Game.canBlockMove(gameBlock, 0, 0))
                    rotateCW()
            }
            function reset() {
                col = gameField.cols / 2
                row = gameField.rows
                cellOffsetListIndex = 0
                state = nextBlock.state
                nextBlock.state = states[Math.floor(Math.random() * states.length)].name
                if (Game.canBlockMove(gameBlock, 0, 0)) {
                    blockTimer.interval = 1000 * Math.pow(4.0/5.0, gameField.level)
                    blockTimer.running = true
                }
            }
        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Left) {
                gameBlock.left()
            }
            else if (event.key === Qt.Key_Right) {
                gameBlock.right()
            }
            else if (event.key === Qt.Key_Down) {
                gameBlock.down()
            }
            else if (event.key === Qt.Key_Space) {
                gameBlock.drop()
            }
            else if (event.key === Qt.Key_Up) {
                gameBlock.rotate()
            }
        }
        onRowsKilled: {
            totalRowsKilled += rows
            score += Game.scoreKilledRows(level, rows)
        }
    }
    ColumnLayout {
        spacing: 2
        anchors.left: gameField.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        Rectangle {
            color: 'black'
            border.color: 'blue'
            border.width: 2
            radius: 10
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Column {
                anchors.fill: parent
                anchors.margins: 5
                Text {
                    text: 'SCORE: ' + gameField.score
                    color: 'white'
                }
                Text {
                    text: 'LEVEL: ' + gameField.level
                    color: 'white'
                }
                Text {
                    text: 'ROWS: ' + gameField.totalRowsKilled
                    color: 'white'
                }
                Text {
                    text: 'SPEED: ' + blockTimer.interval
                    color: 'white'
                }
            }
        }
        Rectangle {
            color: 'black'
            border.color: 'blue'
            border.width: 2
            radius: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
            Column {
                anchors.fill: parent
                anchors.margins: 5
                Text {
                    text: 'NEXT'
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'white'
                }
                Block {
                    id: nextBlock
                    col: 1
                    row: 19
                    Component.onCompleted: reset()
                    function reset() {
                        cellOffsetListIndex = 0
                        state = states[Math.floor(Math.random() * states.length)].name
                    }
                }

            }
        }
    }
    Component.onCompleted: Game.init(gameField);
}
