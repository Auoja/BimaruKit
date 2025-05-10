//
//  Ship.swift
//  BimaruKit
//

// MARK: - Ship

public enum Ship: Int, Comparable, Identifiable, CaseIterable {
    case carrier = 5
    case battleship = 4
    case cruiser = 3
    case destroyer = 2
    case submarine = 1

    public var id: String { String(describing: self) }

    public static func < (lhs: Ship, rhs: Ship) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
}

public extension Ship {

    var size: Int { rawValue }

    init?(size: Int) {
        self.init(rawValue: size)
    }
}
