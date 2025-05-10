//
//  PuzzlePreferences.swift
//  BimaruKit
//

import Foundation

public struct PuzzlePreferences: Equatable {
    public let size: Int
    public let ships: [Ship]
    public let isSymmetric: Bool

    public init(size: Int, ships: [Ship], isSymmetric: Bool) {
        self.size = size
        self.ships = ships
        self.isSymmetric = isSymmetric
    }
}
