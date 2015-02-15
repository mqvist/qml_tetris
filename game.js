var cells;
var cellComponent = Qt.createComponent("Cell.qml");

function init(gameField) {
    console.log("init")
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
                            'color' : 'black'
                        });
        }
    }
}

function isCellFree(row, col) {
    console.log("isCellFree", row, col);
    return !cells[row-1][col-1].visible;
}

function fillCell(row, col, color) {
    console.log('fillCell', row, col, color);
    cells[row-1][col-1].color = color;
    cells[row-1][col-1].visible = true;
}
