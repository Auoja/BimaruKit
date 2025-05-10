//
//  BimaruSolver.swift
//  BimaruKit
//

import Foundation

// MARK: - BimaruSolver

enum BimaruSolver {

    static func solve(grid: TileGrid,
                      ships: [Ship],
                      rowHints: [Int],
                      columnHints: [Int]) -> TileGrid {
        let solver = Solver(grid: grid,
                            ships: ships,
                            rowHints: rowHints,
                            columnHints: columnHints)

        return solver.solve(stopAtProgress: false)
    }
}

// MARK: - Solver

private final class Solver {

    private let rowHints: [Int]
    private let columnHints: [Int]
    private let ships: [Ship]

    private var grid: TileGrid

    private let rules: [any SolvingRule] = [
        FinishSolvedLinesRule(),
        WrapFoundShipsInWaterRule(),
        ShipPatternMatchRule(),
        ExpandLoneMiddleShipRule(),
        TooLongShipRule(),
        UncappedShipRule(),
        FitLargestShipRule()
    ]

    init(grid: TileGrid,
         ships: [Ship],
         rowHints: [Int],
         columnHints: [Int]) {
        self.ships = ships
        self.rowHints = rowHints
        self.columnHints = columnHints
        self.grid = grid
    }

    // MARK: Public

    func solve(stopAtProgress: Bool) -> TileGrid {
        while true {
            let progress = performSolvingSteps()

            guard progress else { break }

            if stopAtProgress {
                break
            }
        }

        return grid
    }

    // MARK: Private

    private func performSolvingSteps() -> Bool {
        for rule in rules {
            let previousState = grid

            rule.solve(grid: &grid,
                       rowHints: rowHints,
                       columnHints: columnHints,
                       ships: ships)

            if previousState != grid {
                return true
            }
        }

        return false
    }
}
