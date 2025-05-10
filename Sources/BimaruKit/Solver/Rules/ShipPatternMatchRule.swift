//
//  ShipPatternMatchRule.swift
//  BimaruKit
//

import Foundation

struct ShipPatternMatchRule: SolvingRule {

    private let kernels: [GridKernel]

    init() {
        var kernels: [GridKernel] = []

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "resolve_undetermined_middle")

            kernel.target.setCell(at: KernelPosition.vertical, to: Tile.allShips)
            kernel.target.setCell(at: .center, to: .ship(.undetermined))

            kernel.replacement.setCell(at: .center, to: .ship(.middle))

            return kernel.withRotatedVersions()
        }())

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "resolve_undetermined_ship_edge")

            kernel.target.top = Tile.allShips
            kernel.target.center = [.ship(.undetermined)]
            kernel.target.bottom = [.water]

            kernel.replacement.center = .ship(.bottom)

            return kernel.withRotatedVersions()
        }())

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "resolve_undetermined_submarine")

            kernel.target.setCell(at: KernelPosition.cardinals, to: .water)
            kernel.target.setCell(at: .center, to: .ship(.undetermined))

            kernel.replacement.center = .ship(.single)

            return [kernel]
        }())

//        kernels.append(contentsOf: {
//            var kernel = GridKernel(name: "resolve_undetermined_edge")
//
//            kernel.target.setCell(at: KernelPosition.cardinals, to: .water)
//            kernel.target.setCell(at: .center, to: .ship(.undetermined))
//            kernel.target.setCell(at: .bottom, to: Tile.allShips)
//
//            kernel.replacement.center = .ship(.top)
//
//            return kernel.withRotatedVersions()
//        }())

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "extend_ship_edge")

            kernel.target.setCell(at: KernelPosition.cardinals, to: .water)
            kernel.target.setCell(at: .center, to: .ship(.top))
            kernel.target.setCell(at: .bottom, to: .blank)

            kernel.replacement.bottom = .ship(.undetermined)

            return kernel.withRotatedVersions()
        }())

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "extend_ship_middle")

            kernel.target.setCell(at: KernelPosition.horizontal, to: .blank)
            kernel.target.setCell(at: .top, to: .water)
            kernel.target.setCell(at: .center, to: .ship(.middle))

            kernel.replacement.setCell(at: KernelPosition.horizontal, to: .ship(.undetermined))

            return kernel.withRotatedVersions()
        }())

        self.kernels = kernels
    }

    func solve(grid: inout TileGrid, rowHints: [Int], columnHints: [Int], ships: [Ship]) {
        for cell in grid.shipCells {
            solve(grid: &grid, position: cell.position)
        }
    }

    private func solve(grid: inout TileGrid, position: Position) {
        for kernel in kernels {
            if kernel.replace(grid: &grid, position: position) {
                return
            }
        }
    }
}
