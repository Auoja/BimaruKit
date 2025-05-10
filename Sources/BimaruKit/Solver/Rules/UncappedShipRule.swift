//
//  UncappedShipRule.swift
//  BimaruKit
//

struct UncappedShipRule: SolvingRule {

    func solve(grid: inout TileGrid, rowHints: [Int], columnHints: [Int], ships: [Ship]) {
        guard
            let largestShip = grid.largestUnfoundShip(in: ships),
            largestShip != .submarine else { return }

        var candidates: [Position?] = []

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

            for cells in segments {
                let shipSegments = Array(cells.split { $0.tile.isBlank })

                for shipSegment in shipSegments {
                    if shipSegment.count == largestShip.size {
                        let start = shipSegment.first?.position.offset(n: -1, isRow: isRow)
                        let end = shipSegment.last?.position.offset(n: 1, isRow: isRow)

                        candidates.append(contentsOf: [start, end])
                    }
                }
            }
        }

        grid.set(positions: candidates.compactMap { $0 }, tile: .water)
    }
}
