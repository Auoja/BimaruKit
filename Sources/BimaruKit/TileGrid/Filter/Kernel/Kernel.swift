//
//  Kernel.swift
//  BimaruKit
//

// MARK: - Kernel

protocol Kernel {

    associatedtype T

    var cells: [T] { get set }

    func rotated() -> Self
}

extension Kernel {

    mutating func setCell(at position: KernelPosition, to cell: T) {
        cells[position.rawValue] = cell
    }

    mutating func setCell(at positions: [KernelPosition], to tile: T) {
        for position in positions {
            setCell(at: position, to: tile)
        }
    }

    func cell(at position: KernelPosition) -> T {
        cells[position.rawValue]
    }
}

extension Kernel {

    var topLeft: T {
        get { cell(at: .topLeft) }
        set { setCell(at: .topLeft, to: newValue) }
    }

    var top: T {
        get { cell(at: .top) }
        set { setCell(at: .top, to: newValue) }
    }

    var topRight: T {
        get { cell(at: .topRight) }
        set { setCell(at: .topRight, to: newValue) }
    }

    var left: T {
        get { cell(at: .left) }
        set { setCell(at: .left, to: newValue) }
    }

    var center: T {
        get { cell(at: .center) }
        set { setCell(at: .center, to: newValue) }
    }

    var right: T {
        get { cell(at: .right) }
        set { setCell(at: .right, to: newValue) }
    }

    var bottomLeft: T {
        get { cell(at: .bottomLeft) }
        set { setCell(at: .bottomLeft, to: newValue) }
    }

    var bottom: T {
        get { cell(at: .bottom) }
        set { setCell(at: .bottom, to: newValue) }
    }

    var bottomRight: T {
        get { cell(at: .bottomRight) }
        set { setCell(at: .bottomRight, to: newValue) }
    }
}
