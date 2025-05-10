//
//  Array+Extensions.swift
//  BimaruKit
//

extension Array where Element: Hashable {

    func counted() -> [Element: Int] {
        reduce(into: [:]) { result, element in
            let count = result[element]

            if let count {
                result[element] = count + 1
            } else {
                result[element] = 1
            }
        }
    }
}

extension Array where Element: Equatable {

    func replace(_ element: Element, with replacement: Element) -> [Element] {
        map { $0 == element ? replacement : $0 }
    }
}

extension Array {

    enum SearchDirection {
        case forward
        case backward
    }

    func countMatches(from index: Int, direction: SearchDirection, where predicate: (Element) -> Bool) -> Int {
        guard indices.contains(index) else { return 0 }

        var count = 0
        var currentIndex = index

        while indices.contains(currentIndex), predicate(self[currentIndex]) {
            count += 1
            currentIndex += (direction == .forward ? 1 : -1)
        }

        return count
    }
}
