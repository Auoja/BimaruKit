//
//  TileGrid.swift
//  BimaruKit
//

import Foundation

public struct TileGrid: Hashable {

    private(set) var storage: [Tile]

    public let gridSize: Int

    public init(size: Int) {
        self.gridSize = size
        self.storage = Array(repeating: .blank, count: size * size)
    }

    private init(size: Int, storage: [Tile]) {
        self.gridSize = size
        self.storage = storage
    }

    public static var empty: TileGrid {
        TileGrid(size: 0)
    }

    public func isValid(n: Int) -> Bool {
        n >= 0 && n < gridSize
    }

    public func isValid(x: Int, y: Int) -> Bool {
        isValid(n: x) && isValid(n: y)
    }

    public func get(x: Int, y: Int) -> Tile {
        guard isValid(x: x, y: y) else { return .water }

        let index = y * gridSize + x
        return storage[index]
    }

    public func row(_ n: Int) -> [Tile] {
        guard isValid(n: n) else {
            return Array(repeating: .water, count: gridSize)
        }

        let start = n * gridSize
        let range = start ..< (start + gridSize)

        return Array(storage[range])
    }

    public mutating func setRow(_ n: Int, tiles: [Tile]) {
        guard isValid(n: n), tiles.count == gridSize else { return }

        let start = n * gridSize
        let range = start ..< (start + gridSize)

        storage.replaceSubrange(range, with: tiles)
    }

    public func column(_ n: Int) -> [Tile] {
        guard isValid(n: n) else {
            return Array(repeating: .water, count: gridSize)
        }

        return (0 ..< gridSize).map { i in
            storage[i * gridSize + n]
        }
    }

    public mutating func setColumn(_ n: Int, tiles: [Tile]) {
        guard isValid(n: n), tiles.count == gridSize else { return }

        for (index, tile) in tiles.enumerated() {
            storage[index * gridSize + n] = tile
        }
    }

    mutating public func set(x: Int, y: Int, tile: Tile) {
        guard isValid(x: x, y: y) else { return }

        let index = y * gridSize + x
        storage[index] = tile
    }

    mutating public func clear() {
        storage = Array(repeating: .blank, count: gridSize * gridSize)
    }

    public func forEachCell(body: (Cell) -> Void) {
        for (index, tile) in storage.enumerated() {
            let x = index % gridSize
            let y = index / gridSize
            body(Cell(x: x, y: y, tile: tile))
        }
    }

    public func forEachLine(body: (Bool, Int, [Tile]) -> Void) {
        for n in 0 ..< gridSize {
            body(true, n, row(n))
            body(false, n, column(n))
        }
    }

    public func forEachUnfinishedLine(body: (Bool, Int, [Tile]) -> Void) {
        forEachLine { isRow, lineIndex, tiles in
            if tiles.contains(.blank) {
                body(isRow, lineIndex, tiles)
            }
        }
    }
}
