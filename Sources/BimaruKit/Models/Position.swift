//
//  Position.swift
//  BimaruKit
//

// MARK: - Position

public struct Position: Hashable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Position {

    func offset(x offsetX: Int, y offsetY: Int) -> Position {
        Position(x: x + offsetX, y: y + offsetY)
    }

    func offset(n: Int, isRow: Bool) -> Position {
        offset(x: isRow ? n : 0,
               y: isRow ? 0 : n)
    }

    var left: Position {
        offset(x: -1, y: 0)
    }

    var right: Position {
        offset(x: 1, y: 0)
    }

    var top: Position {
        offset(x: 0, y: -1)
    }

    var bottom: Position {
        offset(x: 0, y: 1)
    }
}

extension Position {

    func endPoint(ship: Ship, horizontal: Bool) -> Position {
        offset(x: horizontal ? (ship.size - 1) : 0,
               y: horizontal ? 0 : (ship.size - 1))
    }

    func positions(for ship: Ship, horizontal: Bool) -> [Position] {
        (0 ..< ship.size).map { i in
            offset(n: i, isRow: horizontal)
        }
    }

    func adjacentPositions(for ship: Ship, horizontal: Bool) -> [Position] {
        let n = horizontal ? y : x

        var positions: [Position] = []

        for i in [-1, 0, 1] {
            for j in -1 ... ship.size {
                positions.append(offset(x: horizontal ? j : i,
                                        y: horizontal ? i : j))
            }
        }

        return positions
    }
}
