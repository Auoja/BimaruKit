//
//  ExpandLoneMiddleShipRule.swift
//  BimaruKit
//

import Foundation

struct ExpandLoneMiddleShipRule: SolvingRule {

    func solve(grid: inout TileGrid, rowHints: [Int], columnHints: [Int], ships: [Ship]) {
        grid.forEachCell { cell in
            let rowHint = rowHints[cell.position.y]
            let columnHint = columnHints[cell.position.x]

            if cell.tile == .ship(.middle) {
                if rowHint < 3 {
                    grid.set(position: cell.position.left, tile: .water)
                    grid.set(position: cell.position.right, tile: .water)
                    if grid.get(position: cell.position.top).isBlank {
                        grid.set(position: cell.position.top, tile: .ship(.undetermined))
                    }
                    if grid.get(position: cell.position.bottom).isBlank {
                        grid.set(position: cell.position.bottom, tile: .ship(.undetermined))
                    }
                }

                if columnHint < 3 {
                    grid.set(position: cell.position.top, tile: .water)
                    grid.set(position: cell.position.bottom, tile: .water)
                    if grid.get(position: cell.position.left).isBlank {
                        grid.set(position: cell.position.left, tile: .ship(.undetermined))
                    }
                    if grid.get(position: cell.position.right).isBlank {
                        grid.set(position: cell.position.right, tile: .ship(.undetermined))
                    }
                }
            }
        }
    }
}
