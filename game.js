var cells;
var rowCounts;
var cellComponent = Qt.createComponent("Cell.qml");
var gameField;

function init(_gameField) {
    console.log("init");
    gameField = _gameField;
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
    rowCounts = new Array(gameField.rows);
    for (var i = 0; i < gameField.rows; i++) {
        rowCounts[i] = 0;
    }
}

function reset(_gameField) {
    console.log('reset');
    gameField = _gameField;
    for (var i = 0; i < gameField.rows; i++)
        for (var j = 0; j < gameField.cols; j++)
            cells[i][j].visible = false;
    for (var i = 0; i < gameField.rows; i++)
        rowCounts[i] = 0;
}

function isCellFree(row, col) {
    //console.debug("isCellFree", row, col);
    if (row > gameField.rows)
        return false;
    else if (col < 1 || col > gameField.cols)
        return false;
    else if (row < 1)
        return true;
    return !cells[row-1][col-1].visible;
}

function canBlockMove(block, rowDelta, colDelta) {
    for (var i = 0; i < 4; i++) {
        var cellOffset = block.cellOffsets[i];
        var row = block.row + cellOffset[0] + rowDelta;
        var col = block.col + cellOffset[1] + colDelta;
        if (!isCellFree(row, col))
            return false;
    }
    return true;
}

function killRow(row) {
    console.log('killRow', row);
    for (var i = row - 1; i > 0; i--) {
        for (var j = 0; j < gameField.cols; j++) {
            cells[i][j].color = cells[i-1][j].color;
            cells[i][j].visible = cells[i-1][j].visible;
            rowCounts[i] = rowCounts[i-1];
        }
    }
}

function fillCell(row, col, color) {
    cells[row-1][col-1].color = color;
    cells[row-1][col-1].visible = true;
    rowCounts[row-1] += 1;
}

function freezeBlock(block) {
    for (var i = 0; i < 4; i++) {
        var cellOffset = block.cellOffsets[i];
        var row = block.row + cellOffset[0];
        var col = block.col + cellOffset[1];
        fillCell(row, col, block.color);
    }
    // Check for full rows
    var rowsKilled = 0;
    for (row = gameField.rows; row >= 1;) {
        if (rowCounts[row-1] === gameField.cols) {
            killRow(row);
            rowsKilled += 1;
        }
        else
            row--;
    }
    if (rowsKilled)
        gameField.rowsKilled(rowsKilled);
}

function scoreKilledRows(level, rows) {
    switch (rows) {
    case 1:
        return 40 * (level + 1);
    case 2:
        return 100 * (level + 1);
    case 3:
        return 300 * (level + 1);
    case 4:
        return 1200 * (level + 1);
    }
}


