var cells;
var cellComponent = Qt.createComponent("Cell.qml");
var gameField;

function init(_gameField) {
    console.log("init")
    gameField = _gameField
    cells = new Array(gameField.rows);
    for (var i = 0; i < gameField.rows; i++) {
        cells[i] = new Array(gameField.cols);
        for (var j = 0; j < gameField.cols; j++) {
            cells[i][j] = cellComponent.createObject(
                        gameField,
                        {
                            'row' : i + 1,
                            'col' : j + 1,
                            'maxRow' : gameField.rows,
                            'cellSize' : gameField.cellSize,
                            'visible' : false
                        });
        }
    }
}

function isCellFree(row, col) {
    //console.debug("isCellFree", row, col);
    if (row < 1 || row > gameField.rows)
        return false;
    else if (col < 1 || col > gameField.cols)
        return false;
    return !cells[row-1][col-1].visible;
}

function canBlockMove(block, rowDelta, colDelta) {
    console.log('canBlockMove')
    for (var i = 0; i < 4; i++) {
        var cellOffset = block.cellOffsets[i];
        var row = block.row + cellOffset[0] + rowDelta;
        var col = block.col + cellOffset[1] + colDelta;
        if (!isCellFree(row, col))
            return false;
    }
    return true;
}

function fillCell(row, col, color) {
    console.log('fillCell', row, col, color);
    cells[row-1][col-1].color = color;
    cells[row-1][col-1].visible = true;
}

function freezeBlock(block) {
    console.debug('fixBlock');
    for (var i = 0; i < 4; i++) {
        var cellOffset = block.cellOffsets[i];
        var row = block.row + cellOffset[0];
        var col = block.col + cellOffset[1];
        fillCell(row, col, block.color);
    }
}

