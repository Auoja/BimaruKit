//
//  BimaruRevealer.swift
//  BimaruKit
//

// MARK: - BimaruRevealer

enum BimaruRevealer {

    static func revealedCells(solution: TileGrid, preferences: PuzzlePreferences) -> [Cell] {
        var revealedCells: [Cell] = []
        var solved = false

        while !solved {
            solved = bestCellsToReveal(solution: solution,
                                       revealedCells: &revealedCells,
                                       preferences: preferences)
        }

        return revealedCells
    }
}

private extension BimaruRevealer {

    static func bestCellsToReveal(solution: TileGrid,
                                  revealedCells: inout [Cell],
                                  preferences: PuzzlePreferences) -> Bool {
        let rowHints = solution.rowHints
        let columnHints = solution.columnHints

        var puzzle = TileGrid(size: solution.gridSize)
        var maxCellsSolved = 0
        var bestPositions: [Set<Position>] = []
        var isSolved: Bool = false

        let blankCells: [Cell] = {
            if revealedCells.isEmpty {
                return puzzle.blankCells
            } else {
                let solutionAttempt = BimaruSolver.solve(grid: puzzle,
                                                         ships: preferences.ships,
                                                         rowHints: rowHints,
                                                         columnHints: columnHints)
                return solutionAttempt.blankCells
            }
        }()

        for cell in blankCells {
            let positions: Set<Position> = if preferences.isSymmetric {
                    cell.position.symmetricPositions(n: solution.gridSize)
                } else {
                    [cell.position]
                }

            let answers = positions.map { position in
                solution.cell(at: position)
            }

            puzzle.clear()
            puzzle.set(cells: answers + revealedCells)

            let solutionAttempt = BimaruSolver.solve(grid: puzzle,
                                                     ships: preferences.ships,
                                                     rowHints: rowHints,
                                                     columnHints: columnHints)

            let cellsSolved = solutionAttempt.revealedCells.count

            if cellsSolved > maxCellsSolved {
                maxCellsSolved = cellsSolved
                bestPositions = []
            }

            if cellsSolved == maxCellsSolved {
                bestPositions.append(positions)
            }

            if solutionAttempt == solution {
                isSolved = true
                break
            }
        }

        if let positions = bestPositions.randomElement() {
            for position in positions {
                let cell = solution.cell(at: position)
                revealedCells.append(cell)
            }
        }

        return isSolved
    }
}

// MARK: Position

private extension Position {

    func symmetricPositions(n: Int) -> Set<Position> {
        [
            self,
            Position(x: n - 1 - y,
                     y: x),
            Position(x: n - 1 - x,
                     y: n - 1 - y),
            Position(x: y,
                     y: n - 1 - x)
        ]
    }
}
