//
//  SolvingRule.swift
//  BimaruKit
//

// MARK: - SolvingRule

protocol SolvingRule {

    var name: String { get }

    func solve(grid: inout TileGrid, rowHints: [Int], columnHints: [Int], ships: [Ship])
}

extension SolvingRule {

    var name: String { String(describing: Self.self) }
}
