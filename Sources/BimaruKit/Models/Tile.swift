//
//  Tile.swift
//  BimaruKit
//

// MARK: - Tile

public enum Tile: Identifiable, Hashable, CaseIterable {
    case blank
    case water
    case ship(ShipSection)

    public var id: String {
        String(describing: self)
    }

    public static var allCases: [Tile] {
        [.blank, .water] + ShipSection.allCases.flatMap { [.ship($0)] }
    }

    public static var allShips: Set<Tile> {
        Set(ShipSection.allCases.map { .ship($0) })
    }

    public var isShip: Bool {
        switch self {
        case .blank: false
        case .water: false
        case .ship: true
        }
    }

    public var isWater: Bool {
        switch self {
        case .blank: false
        case .water: true
        case .ship: false
        }
    }

    public var isBlank: Bool {
        switch self {
        case .blank: true
        case .water: false
        case .ship: false
        }
    }

    public func rotate() -> Tile {
        switch self {
        case .blank: .blank
        case .water: .water
        case .ship(let section): .ship(section.rotate())
        }
    }
}

// MARK: - ShipSection

public enum ShipSection: String, Hashable, CaseIterable, Identifiable {
    case middle
    case single
    case top
    case right
    case left
    case bottom
    case undetermined

    public var id: String { rawValue }

    public func rotate() -> ShipSection {
        switch self {
        case .middle: .middle
        case .single: .single
        case .top: .right
        case .right: .bottom
        case .bottom: .left
        case .left: .top
        case .undetermined: .undetermined
        }
    }
}
