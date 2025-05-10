//
//  GridKernel.swift
//  BimaruKit
//

struct GridKernel: Hashable {

    var name: String
    var target = Target()
    var replacement = Replacement()

    func rotated() -> GridKernel {
        let rotatedTarget = target.rotated()
        let rotatedReplacement = replacement.rotated()

        return GridKernel(name: "\(name)_rotated",
                          target: rotatedTarget,
                          replacement: rotatedReplacement)
    }

    func withRotatedVersions() -> [GridKernel] {
        let rotated1 = self.rotated()
        let rotated2 = rotated1.rotated()
        let rotated3 = rotated2.rotated()

        return Array(Set([self, rotated1, rotated2, rotated3]))
    }

    @discardableResult
    func replace(grid: inout TileGrid, position: Position) -> Bool {
        var replacements: [Cell] = []

        for kernelPosition in KernelPosition.allCases {
            let offset = kernelPosition.offset
            let tiles = target.cell(at: kernelPosition)

            let gridPosition = position.offset(x: offset.x, y: offset.y)
            let gridTile = grid.get(position: gridPosition)

            if tiles.isEmpty || tiles.contains(gridTile) {
                if let replacementTile = replacement.cell(at: kernelPosition) {
                    replacements.append(Cell(position: gridPosition, tile: replacementTile))
                }
            } else {
                return false
            }
        }

        for replacement in replacements {
            grid.set(cell: replacement)
        }

        return true
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(target)
        hasher.combine(replacement)
    }
}
