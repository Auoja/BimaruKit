//
//  Cell.swift
//  BimaruKit
//

public struct Cell: Hashable {
    public let position: Position
    public let tile: Tile

    public init(position: Position, tile: Tile) {
        self.position = position
        self.tile = tile
    }

    public init(x: Int, y: Int, tile: Tile) {
        self.init(position: Position(x: x, y: y),
                  tile: tile)
    }
}
