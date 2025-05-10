//
//  BimaruKit.swift
//  BimaruKit
//

import Foundation

public enum BimaruKit {

    public static func generate(preferences: PuzzlePreferences) -> Puzzle {
        let solution = BimaruGenerator.generateBoard(preferences: preferences)
        let revealedCells = BimaruRevealer.revealedCells(solution: solution, preferences: preferences)

        return Puzzle(solution: solution,
                      ships: preferences.ships,
                      rowHints: solution.rowHints,
                      columnHints: solution.columnHints,
                      revealedCells: revealedCells)
    }
}
