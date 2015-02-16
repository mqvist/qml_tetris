import QtQuick 2.0

Item {
    property int col
    property int row
    property int maxRow
    property int cellSize
    property alias color: rect.color
    x: (col - 1) * cellSize
    y: (maxRow - row) * cellSize

    Rectangle {
        id: rect
        width: parent.cellSize
        height: parent.cellSize
        border.width: 1
        radius: parent.cellSize / 10
    }
}
