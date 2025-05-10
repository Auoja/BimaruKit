//
//  FinishSolvedLinesRule.swift
//  BimaruKit
//

import Foundation

struct FinishSolvedLinesRule: SolvingRule {

    func solve(grid: inout TileGrid, rowHints: [Int], columnHints: [Int], ships: [Ship]) {
        let size = grid.gridSize

        var replacements: [(isRow: Bool, lineIndex: Int, tiles: [Tile])] = []

        grid.forEachLine { isRow, index, tiles in
            let hint = isRow ? rowHints[index] : columnHints[index]

            var blankCount = 0
            var waterCount = 0
            var shipCount = 0

            for tile in tiles {
                switch tile {
                case .blank: blankCount += 1
                case .water: waterCount += 1
                case .ship: shipCount += 1
                }
            }

            let fillTile: Tile? = if blankCount == 0 {
                    nil
                } else if shipCount == hint {
                    .water
                } else if waterCount == size - hint {
                    .ship(.undetermined)
                } else {
                    nil
                }

            if let fillTile {
                let replacementTiles = tiles.replace(.blank, with: fillTile)
                replacements.append((isRow: isRow, lineIndex: index, tiles: replacementTiles))
            }
        }

        for (isRow, index, tiles) in replacements {
            if isRow {
                grid.setRow(index, tiles: tiles)
            } else {
                grid.setColumn(index, tiles: tiles)
            }
        }
    }
}
