//
//  BimaruResolver.swift
//  BimaruKit
//

// MARK: - BimaruResolver

public enum BimaruResolver {

    public static func resolve(grid: inout TileGrid, locked: Set<Position> = []) {
        let safetyLimit = 10
        var counter = 0

        while counter < safetyLimit {
            let progress = resolveStep(grid: &grid, locked: locked)
            counter += 1

            guard progress else { break }
        }
    }
}

private extension BimaruResolver {

    static func resolveStep(grid: inout TileGrid, locked: Set<Position>) -> Bool {
        let previousState = grid

        let resolver = ShipSectionResolver()

        var startGrid = grid

        for cell in grid.shipCells where !locked.contains(cell.position) {
            startGrid.set(position: cell.position, tile: .ship(.undetermined))
        }

        resolver.resolve(grid: &startGrid, locked: locked)

        grid = startGrid

        return previousState != grid
    }
}
