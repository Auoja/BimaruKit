//
//  ShipSectionResolver.swift
//  BimaruKit
//

import Foundation

struct ShipSectionResolver {

    private let kernels: [GridKernel]

    init() {
        var kernels: [GridKernel] = []

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "resolve_submarine")

            kernel.target.setCell(at: KernelPosition.cardinals, to: .water)
            kernel.target.setCell(at: .center, to: Tile.allShips)

            kernel.replacement.center = .ship(.single)

            return [kernel]
        }())

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "resolve_edge")

            kernel.target.setCell(at: .top, to: .water)
            kernel.target.setCell(at: .center, to: Tile.allShips)
            kernel.target.setCell(at: .bottom, to: Tile.allShips)

            kernel.replacement.center = .ship(.top)

            return kernel.withRotatedVersions()
        }())

        kernels.append(contentsOf: {
            var kernel = GridKernel(name: "resolve_middle")

            kernel.target.setCell(at: .top, to: Tile.allShips)
            kernel.target.setCell(at: .center, to: Tile.allShips)
            kernel.target.setCell(at: .bottom, to: Tile.allShips)

            kernel.replacement.center = .ship(.middle)

            return kernel.withRotatedVersions()
        }())

        self.kernels = kernels
    }

    // MARK: Public

    func resolve(grid: inout TileGrid, locked: Set<Position>) {
        for cell in grid.shipCells where !locked.contains(cell.position) {
            solve(grid: &grid, position: cell.position)
        }
    }

    // MARK: Private

    private func solve(grid: inout TileGrid, position: Position) {
        for kernel in kernels {
            if kernel.replace(grid: &grid, position: position) {
                return
            }
        }
    }
}
