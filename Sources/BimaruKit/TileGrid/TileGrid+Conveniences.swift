//
//  TileGrid+Conveniences.swift
//  BimaruKit
//

import Foundation

// MARK: - Lines

public extension TileGrid {

    func line(n: Int, isRow: Bool) -> [Tile] {
        isRow ? row(n) : column(n)
    }

    mutating func setLine(n: Int, isRow: Bool, tiles: [Tile]) {
        isRow ? setRow(n, tiles: tiles) : setColumn(n, tiles: tiles)
    }
}

// MARK: - Hints

public extension TileGrid {

    var rowHints: [Int] {
        (0 ..< gridSize).map { y in
            row(y).filter(\.isShip).count
        }
    }

    var columnHints: [Int] {
        (0 ..< gridSize).map { x in
            column(x).filter(\.isShip).count
        }
    }

    func hint(n: Int, isRow: Bool) -> Int {
        if isRow {
            row(n).filter(\.isShip).count
        } else {
            column(n).filter(\.isShip).count
        }
    }

    func isLineComplete(n: Int, isRow: Bool) -> Bool {
        if isRow {
            !row(n).contains(where: \.isBlank)
        } else {
            !column(n).contains(where: \.isBlank)
        }
    }
}

// MARK: - Position

public extension TileGrid {

    func isValid(position: Position) -> Bool {
        isValid(x: position.x, y: position.y)
    }

    func get(position: Position) -> Tile {
        get(x: position.x, y: position.y)
    }

    mutating func set(position: Position, tile: Tile) {
        set(positions: [position], tile: tile)
    }

    mutating func set(positions: [Position], tile: Tile) {
        for position in positions {
            set(x: position.x, y: position.y, tile: tile)
        }
    }
}

public extension TileGrid {

    func incorrectPositions(_ other: TileGrid, isStrict: Bool = true) -> [Position] {
        zip(cells, other.cells).compactMap { lhsCell, rhsCell in
                switch (lhsCell.tile, rhsCell.tile) {
                case (.ship(let lhsSection), .ship(let rhsSection)):
                    if isStrict {
                        rhsSection == lhsSection ? nil : lhsCell.position
                    } else {
                        nil
                    }
                case (.water, .water): nil
                case (.blank, .blank): nil
                default: lhsCell.position
                }
        }
    }
}

// MARK: - Cells

public extension TileGrid {

    var cells: [Cell] {
        storage.enumerated().map { index, tile in
            let x = index % gridSize
            let y = index / gridSize
            return Cell(x: x, y: y, tile: tile)
        }
    }

    var shipCells: [Cell] {
        cells.filter { $0.tile.isShip }
    }

    var waterCells: [Cell] {
        cells.filter { $0.tile.isWater }
    }

    var blankCells: [Cell] {
        cells.filter { $0.tile.isBlank }
    }

    var revealedCells: [Cell] {
        cells.filter { !$0.tile.isBlank }
    }

    func cells(n: Int, isRow: Bool) -> [Cell] {
        if isRow {
            row(n).enumerated().map { i, tile in
                Cell(x: i, y: n, tile: tile)
            }
        } else {
            column(n).enumerated().map { i, tile in
                Cell(x: n, y: i, tile: tile)
            }
        }
    }

    func cell(at position: Position) -> Cell {
        Cell(position: position, tile: get(position: position))
    }

    func cell(x: Int, y: Int) -> Cell {
        Cell(x: x, y: y, tile: get(x: x, y: y))
    }

    mutating func set(cell: Cell) {
        set(cells: [cell])
    }

    mutating func set(cells: [Cell]) {
        for cell in cells {
            set(position: cell.position, tile: cell.tile)
        }
    }
}

// MARK: - Ship

public extension TileGrid {

    func canInsert(ship: Ship, position: Position, horizontal: Bool) -> Bool {
        let endPoint = position.endPoint(ship: ship, horizontal: horizontal)

        guard isValid(position: endPoint) else { return false }

        let adjacentPositions = position.adjacentPositions(for: ship, horizontal: horizontal)

        return adjacentPositions.allSatisfy { position in
            !get(position: position).isShip
        }
    }

    @discardableResult
    mutating func insert(ship: Ship, position: Position, horizontal: Bool) -> Bool {
        guard canInsert(ship: ship, position: position, horizontal: horizontal) else { return false }

        for (index, position) in position.positions(for: ship, horizontal: horizontal).enumerated() {
            let section: ShipSection = if ship.size == 1 {
                    .single
                } else if index == 0 {
                    horizontal ? .left : .top
                } else if index == ship.size - 1 {
                    horizontal ? .right : .bottom
                } else {
                    .middle
                }

            set(position: position, tile: .ship(section))
        }

        return true
    }

    var foundShips: [Ship] {
        var foundShips: [Ship] = []

        forEachLine { isRow, _, tiles in
            var size = 0
            var startedWithWater = true

            for tile in tiles + [.water] {
                if tile == .ship(.single) {
                    if isRow {
                        foundShips.append(.submarine)
                    }
                    continue
                }

                switch tile {
                case .water:
                    if size > 1, let ship = Ship(size: size) {
                        foundShips.append(ship)
                    }
                    size = 0
                    startedWithWater = true
                case .blank:
                    size = 0
                    startedWithWater = false
                case .ship:
                    size += startedWithWater ? 1 : 0
                }
            }
        }

        return foundShips.sorted()
    }

    func unfoundShips(in ships: [Ship]) -> [Ship] {
        var undetectedShips = ships

        for ship in foundShips {
            if let index = undetectedShips.firstIndex(of: ship) {
                undetectedShips.remove(at: index)
            }
        }

        return undetectedShips.sorted()
    }

    func unfoundShipsWithCount(in ships: [Ship]) -> [Ship: Int] {
        let shipsWithCount = ships.counted()
        let foundShipsWithCount = foundShips.counted()

        return ships.reduce(into: [:]) { result, ship in
            let targetCount = shipsWithCount[ship] ?? 0
            let foundCount = foundShipsWithCount[ship] ?? 0

            result[ship] = targetCount - foundCount
        }
    }

    func largestUnfoundShip(in ships: [Ship]) -> Ship? {
        unfoundShips(in: ships).first
    }
}
