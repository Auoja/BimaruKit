//
//  Target.swift
//  BimaruKit
//

struct Target: Kernel, Hashable {

    var cells: [Set<Tile>]

    init() {
        self.cells = Array(repeating: [], count: 9)
    }

    func rotated() -> Target {
        let rotatedCells = [
            cells[6], cells[3], cells[0],
            cells[7], cells[4], cells[1],
            cells[8], cells[5], cells[2]
        ].map {
            Set($0.map { $0.rotate() })
        }

        var target = Target()
        target.cells = rotatedCells
        return target
    }

    mutating func setCell(at position: KernelPosition, to tile: Tile) {
        setCell(at: position, to: [tile])
    }

    mutating func setCell(at position: KernelPosition, not tile: Tile) {
        setCell(at: position, not: [tile])
    }

    mutating func setCell(at position: KernelPosition, not tiles: Set<Tile>) {
        let targetTiles = Set(Tile.allCases).subtracting(tiles)
        setCell(at: position, to: targetTiles)
    }

    mutating func setCell(at positions: [KernelPosition], not tile: Tile) {
        setCell(at: positions, to: [tile])
    }

    mutating func setCell(at positions: [KernelPosition], not tiles: Set<Tile>) {
        let targetTiles = Set(Tile.allCases).subtracting(tiles)
        for position in positions {
            setCell(at: position, to: targetTiles)
        }
    }

    mutating func setCell(at positions: [KernelPosition], to tile: Tile) {
        for position in positions {
            setCell(at: position, to: tile)
        }
    }
}
