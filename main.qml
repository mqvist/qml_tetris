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
        property int score
        property int totalRowsKilled
        property int level: totalRowsKilled / 10
        width: cellSize * cols
        height: cellSize * rows
        color: 'black'
        focus: true
        state: ''

        signal rowsKilled (int rows)

        GameBlock {
            id: gameBlock
            game: Game
            onGameOver: gameField.state = 'GAMEOVER'
        }

        Keys.onPressed: {
            if (state === '') {
                if (event.key === Qt.Key_Left)
                    gameBlock.left()
                else if (event.key === Qt.Key_Right)
                    gameBlock.right()
                else if (event.key === Qt.Key_Down) {
                    gameBlock.stop()
                    gameBlock.down()
                    gameBlock.restart()
                }
                else if (event.key === Qt.Key_Space)
                    gameBlock.drop()
                else if (event.key === Qt.Key_Up)
                    gameBlock.rotate()
                else if (event.key === Qt.Key_P)
                    pauseGame()
            }
            else if (state === 'PAUSED') {
                if (event.key === Qt.Key_P)
                    resumeGame()
            }
            else if (state == 'GAMEOVER') {
                if (event.key === Qt.Key_N)
                    newGame()
            }
        }
        onRowsKilled: {
            totalRowsKilled += rows
            score += Game.scoreKilledRows(level, rows)
        }
        Column {
            id: gameOverMessage
            anchors.centerIn: parent
            visible: false
            opacity: 0.0
            z: 10
            Behavior on opacity { NumberAnimation { duration: 2000 } }
            Text {
                text: "Game Over"
                font.pointSize: 32
                style: Text.Outline
                color: 'white'
            }
            Text {
                text: "Press n for new game"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 12
                style: Text.Outline
                color: 'white'
            }
        }
        Column {
            id: pauseMessage
            anchors.centerIn: parent
            visible: false
            opacity: 0.0
            z: 10
            Behavior on opacity { NumberAnimation { duration: 1000 } }
            Text {
                text: "Game Paused"
                font.pointSize: 32
                style: Text.Outline
                color: 'white'
            }
            Text {
                text: "Press p to continue"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 12
                style: Text.Outline
                color: 'white'
            }
        }
        states: [
            State {
                name: 'PAUSED'
                PropertyChanges { target: pauseMessage; visible: true; opacity: 1.0 }
            },
            State {
                name: 'GAMEOVER'
                PropertyChanges { target: gameOverMessage; visible: true; opacity: 1.0}
                PropertyChanges { target: gameBlock; visible: false }
            }
        ]
    }
    ColumnLayout {
        spacing: 2
        anchors { left: gameField.right; top: parent.top; bottom: parent.bottom; right: parent.right }
        Rectangle {
            color: 'black'
            border { color: 'blue'; width: 2 }
            radius: 10
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Column {
                anchors {fill: parent; margins: 5 }
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
                    text: 'SPEED: ' + gameBlock.speed
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'white'
                }
            }
        }
        Rectangle {
            color: 'black'
            border { color: 'blue'; width: 2 }
            radius: 10
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Text {
                id: next
                text: 'NEXT'
                anchors { top: parent.top; topMargin: 5; horizontalCenter: parent.horizontalCenter }
                color: 'white'
            }
            Block {
                id: nextBlock
                col: 1
                row: 1
                anchors { centerIn: parent; verticalCenterOffset: 5 }
                Connections {
                    target: gameBlock
                    onNewState: nextBlock.state = nextState
                }
            }
        }
        Rectangle {
            color: 'black'
            border { color: 'blue'; width: 2 }
            radius: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
            Text {
                text: 'HIGHSCORES'
                anchors { top: parent.top; topMargin: 5; horizontalCenter: parent.horizontalCenter }
                color: 'white'
            }
        }
    }
    Component.onCompleted: Game.init(gameField);
    function newGame() {
        Game.reset(gameField)
        gameField.score = 0
        gameField.totalRowsKilled = 0
        gameField.state = ''
        gameBlock.reset()
    }
    function pauseGame() {
        gameBlock.stop()
        gameField.state = 'PAUSED'
    }
    function resumeGame() {
        gameBlock.restart()
        gameField.state = ''
    }
}
