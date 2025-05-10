//
//  WrapFoundShipsInWaterRule.swift
//  BimaruKit
//

import Foundation

struct WrapFoundShipsInWaterRule: SolvingRule {

    private let kernels: [GridKernel]

    init() {
        var kernels: [GridKernel] = []

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "surround_submarines")
            kernel.target.center = [.ship(.single)]
            kernel.replacement.setCell(at: KernelPosition.surrounding, to: .water)
            return [kernel]
        }())

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "surround_ship_edges")
            kernel.target.center = [.ship(.top)]

            kernel.replacement.setCell(at: KernelPosition.surrounding, to: .water)
            kernel.replacement.clearCell(at: .bottom)

            return kernel.withRotatedVersions()
        }())

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "surround_all_ships")
            kernel.target.center = Tile.allShips
            kernel.replacement.setCell(at: KernelPosition.diagonals, to: .water)
            return [kernel]
        }())

        self.kernels = kernels
    }

    // MARK: Public

    func solve(grid: inout TileGrid, rowHints: [Int], columnHints: [Int], ships: [Ship]) {
        grid.forEachCell { cell in
            if cell.tile.isShip {
                solve(grid: &grid, cell: cell)
            }
        }
    }

    // MARK: Private

    private func solve(grid: inout TileGrid, cell: Cell) {
        for kernel in kernels {
            if kernel.replace(grid: &grid, position: cell.position) {
                return
            }
        }
    }
}
