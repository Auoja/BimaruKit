//
//  TooLongShipRule.swift
//  BimaruKit
//

struct TooLongShipRule: SolvingRule {

    func solve(grid: inout TileGrid, rowHints: [Int], columnHints: [Int], ships: [Ship]) {
        guard
            let largestShip = grid.largestUnfoundShip(in: ships),
            largestShip != .submarine else { return }

        var gaps: [Position] = []

        grid.forEachUnfinishedLine { isRow, lineIndex, tiles in
            let cells = tiles.enumerated().map { index, tile in
                Cell(x: isRow ? index : lineIndex,
                     y: isRow ? lineIndex : index,
                     tile: tile)
            }

            let segments = cells
                .split { cell in
                    cell.tile.isWater
                }
                .map { cells in
                    Array(cells)
                }
                .filter { cells in
                    cells.count > largestShip.size && cells.contains(where: { $0.tile.isBlank || $0.tile.isShip })
                }

            for cells in segments {
                for (index, cell) in cells.enumerated() {
                    guard cell.tile.isBlank else { continue }

                    let beforeGapSize = cells.countMatches(from: index, direction: .backward) { $0.tile.isShip }
                    let afterGapSize = cells.countMatches(from: index, direction: .forward) { $0.tile.isShip }

                    if beforeGapSize + afterGapSize + 1 > largestShip.size {
                        gaps.append(cell.position)
                    }
                }
            }
        }

        grid.set(positions: gaps, tile: .water)
    }
}
