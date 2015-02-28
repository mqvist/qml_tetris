import QtQuick 2.0

Block {
    property var game
    property alias speed: blockTimer.interval
    property string nextState

    signal gameOver
    signal newState(string state, string nextState)

    id: root
    Component.onCompleted: {
        nextState = randomState()
        reset()
    }
    Timer {
        id: blockTimer
        repeat: true
        running: false
        onTriggered: root.down()
    }
    function left() {
        if (game.canBlockMove(root, 0, -1))
            col -= 1
    }
    function right() {
        if (game.canBlockMove(root, 0, 1))
            col += 1
    }
    function down() {
        if (game.canBlockMove(root, 1, 0)) {
            row += 1
        }
        else {
            stop()
            game.freezeBlock(root)
            reset()
        }
    }
    function drop() {
        blockTimer.interval = 10
    }
    function rotate() {
        rotateCCW()
        if (!game.canBlockMove(root, 0, 0))
            rotateCW()
    }
    function stop() {
        blockTimer.running = false
    }
    function restart() {
        blockTimer.restart()
    }
    function reset() {
        col = gameField.cols / 2
        row = 1
        cellOffsetListIndex = 0
        state = nextState
        if (game.canBlockMove(root, 0, 0)) {
            nextState = randomState()
            newState(state, nextState)
            blockTimer.interval = 1000 * Math.pow(4.0/5.0, gameField.level)
            restart()
        }
        else
            gameOver()
    }
    function randomState() {
        return states[Math.floor(Math.random() * states.length)].name
    }
}
