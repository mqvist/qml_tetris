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
        state: 'RUNNING'
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
                if (Game.canBlockMove(gameBlock, 1, 0))
                    row += 1
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
                row = 1
                cellOffsetListIndex = 0
                state = nextBlock.state
                nextBlock.random()
                if (Game.canBlockMove(gameBlock, 0, 0)) {
                    blockTimer.interval = 1000 * Math.pow(4.0/5.0, gameField.level)
                    blockTimer.running = true
                }
                else
                    gameField.state = 'GAMEOVER'
            }
        }
        Keys.onPressed: {
            if (state !== 'RUNNING')
                return
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
        Text {
            id: gameOverText
            text: "Game Over"
            font.pointSize: 32
            style: Text.Outline
            anchors.centerIn: parent
            color: 'white'
            z: 10
        }
        states: [
            State {
                name: 'RUNNING'
                PropertyChanges { target: gameOverText; visible: false }
            },
            State {
                name: 'GAMEOVER'
                PropertyChanges { target: gameOverText; visible: true }
            }
        ]
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
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'white'
                }
                Text {
                    text: 'LEVEL: ' + gameField.level
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'white'
                }
                Text {
                    text: 'ROWS: ' + gameField.totalRowsKilled
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'white'
                }
                Text {
                    text: 'SPEED: ' + blockTimer.interval
                    anchors.horizontalCenter: parent.horizontalCenter
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
            Layout.preferredHeight: 80
            Text {
                id: next
                text: 'NEXT'
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'white'
            }
            Block {
                id: nextBlock
                col: 1
                row: 1
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 5
                Component.onCompleted: random()
                function random() {
                    cellOffsetListIndex = 0
                    state = states[Math.floor(Math.random() * states.length)].name
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
            Text {
                text: 'HIGHSCORES'
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'white'
            }
        }
    }
    Component.onCompleted: Game.init(gameField);
}
