import QtQuick 2.0

Item {
    property int col
    property int row
    property int maxRow
    property int cellSize
    property alias color: rect.color
    x: (col - 1) * cellSize
    y: (maxRow - row) * cellSize
    visible: false

    Rectangle {
        id: rect
        width: parent.cellSize
        height: parent.cellSize
        visible: parent.visible
    }
}
