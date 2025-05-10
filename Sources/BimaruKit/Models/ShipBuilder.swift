//
//  ShipBuilder.swift
//  BimaruKit
//

// MARK: - Carrier

public struct Carrier {

    public let count: Int

    public init(_ count: Int = 1) {
        self.count = count
    }
}

// MARK: - Battleship

public struct Battleship {

    public let count: Int

    public init(_ count: Int = 1) {
        self.count = count
    }
}

// MARK: - Cruiser

public struct Cruiser {

    public let count: Int

    public init(_ count: Int = 1) {
        self.count = count
    }
}

// MARK: - Destroyer

public struct Destroyer {

    public let count: Int

    public init(_ count: Int = 1) {
        self.count = count
    }
}

// MARK: - Submarine

public struct Submarine {

    public let count: Int

    public init(_ count: Int = 1) {
        self.count = count
    }
}

// MARK: - ShipsBuilder

@resultBuilder
public struct ShipsBuilder {

    public static func buildBlock(_ components: [Ship]...) -> [Ship] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: Ship) -> [Ship] {
        [expression]
    }

    public static func buildExpression(_ expression: Carrier) -> [Ship] {
        Array(repeating: .carrier, count: expression.count)
    }

    public static func buildExpression(_ expression: Battleship) -> [Ship] {
        Array(repeating: .battleship, count: expression.count)
    }

    public static func buildExpression(_ expression: Cruiser) -> [Ship] {
        Array(repeating: .cruiser, count: expression.count)
    }

    public static func buildExpression(_ expression: Destroyer) -> [Ship] {
        Array(repeating: .destroyer, count: expression.count)
    }

    public static func buildExpression(_ expression: Submarine) -> [Ship] {
        Array(repeating: .submarine, count: expression.count)
    }

    public static func buildEither(first component: [Ship]) -> [Ship] {
        component
    }

    public static func buildEither(second component: [Ship]) -> [Ship] {
        component
    }
}
