//
//  BimaruGenerator.swift
//  BimaruKit
//

import Foundation

enum BimaruGenerator {

    enum Error: Swift.Error {
        case failedToPlace
    }

    // MARK: Public

    static func generateBoard(preferences: PuzzlePreferences) -> TileGrid {
        var grid = TileGrid(size: preferences.size)

        for ship in preferences.ships {
            do {
                try placeShip(ship, in: &grid)
            } catch {
                print(error)
                return generateBoard(preferences: preferences)
            }
        }

        for cell in grid.blankCells {
            grid.set(position: cell.position, tile: .water)
        }

        return grid
    }

    // MARK: Private

    private static func placeShip(_ ship: Ship, in grid: inout TileGrid) throws {
        var placed = false

        var positionsAndOrientations: [(position: Position, horizontal: Bool)] = grid.blankCells
            .flatMap { cell in
                [(cell.position, true), (cell.position, false)]
            }.shuffled()

        while !placed, !positionsAndOrientations.isEmpty {
            let positionsAndOrientation = positionsAndOrientations.removeLast()
            let position = positionsAndOrientation.position
            let horizontal = positionsAndOrientation.horizontal

            placed = grid.insert(ship: ship, position: position, horizontal: horizontal)
        }

        if !placed {
            throw Error.failedToPlace
        }
    }
}
