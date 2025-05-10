//
//  Puzzle.swift
//  BimaruKit
//

import Foundation

public struct Puzzle: Identifiable, Hashable {
    public let id = UUID()
    public let solution: TileGrid
    public let ships: [Ship]
    public let rowHints: [Int]
    public let columnHints: [Int]
    public let revealedCells: [Cell]

    public var size: Int { solution.gridSize }

    public init(solution: TileGrid,
                ships: [Ship],
                rowHints: [Int],
                columnHints: [Int],
                revealedCells: [Cell]) {
        self.solution = solution
        self.ships = ships
        self.rowHints = rowHints
        self.columnHints = columnHints
        self.revealedCells = revealedCells
    }

    public static var empty: Puzzle {
        Puzzle(solution: .empty,
               ships: [],
               rowHints: [],
               columnHints: [],
               revealedCells: [])
    }
}
