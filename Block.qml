import QtQuick 2.0

Item {
    id: block
    property int col
    property int row
    property var cellOffsetList
    property int cellOffsetListIndex: 0
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
    function rotateCW() {
        var index = block.cellOffsetListIndex + block.cellOffsetList.length - 1
        index %= block.cellOffsetList.length
        cellOffsetListIndex = index
    }
    function rotateCCW() {
        var index = block.cellOffsetListIndex + 1
        index %= block.cellOffsetList.length
        cellOffsetListIndex = index
    }
}
