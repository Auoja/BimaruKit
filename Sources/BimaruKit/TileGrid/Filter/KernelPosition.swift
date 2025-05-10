//
//  KernelPosition.swift
//  BimaruKit
//

enum KernelPosition: Int, CaseIterable {
    case topLeft = 0
    case top = 1
    case topRight = 2

    case left = 3
    case center = 4
    case right = 5

    case bottomLeft = 6
    case bottom = 7
    case bottomRight = 8

    var offset: (x: Int, y: Int) {
        switch self {
        case .topLeft: (-1, -1)
        case .top: (0, -1)
        case .topRight: (1, -1)
        case .left: (-1, 0)
        case .center: (0, 0)
        case .right: (1, 0)
        case .bottomLeft: (-1, 1)
        case .bottom: (0, 1)
        case .bottomRight: (1, 1)
        }
    }

    static let surrounding: [KernelPosition] = [.topLeft, .top, .topRight, .left, .right, .bottomLeft, .bottom, .bottomRight]

    static let diagonals: [KernelPosition] = [.topLeft, .topRight, .bottomLeft, .bottomRight]

    static let cardinals: [KernelPosition] = [.top, .left, .right, .bottom]

    static let horizontal: [KernelPosition] = [.left, .right]

    static let vertical: [KernelPosition] = [.top, .bottom]
}
