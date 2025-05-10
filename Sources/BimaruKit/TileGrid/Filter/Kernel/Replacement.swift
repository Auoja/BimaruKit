//
//  Replacement.swift
//  BimaruKit
//

struct Replacement: Kernel, Hashable {

    var cells: [Tile?]

    init() {
        self.cells = Array(repeating: nil, count: 9)
    }

    func rotated() -> Replacement {
        let rotatedCells = [
            cells[6], cells[3], cells[0],
            cells[7], cells[4], cells[1],
            cells[8], cells[5], cells[2]
        ].map { tile in
            tile?.rotate()
        }

        var replacement = Replacement()
        replacement.cells = rotatedCells
        return replacement
    }

    mutating func clearCell(at position: KernelPosition) {
        setCell(at: position, to: nil)
    }
}
