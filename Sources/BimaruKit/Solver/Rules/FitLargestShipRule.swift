//
//  FitLargestShipRule.swift
//  BimaruKit
//

struct FitLargestShipRule: SolvingRule {

    private struct Candidate {
        let position: Position
        let isRow: Bool
        let tiles: [Tile]
        let budget: Int

        func numberOfShipsThatCanFit(_ ship: Ship) -> Int {
            let budgetBased = budget / ship.size
            let sizeBased = 1 + ((tiles.count - ship.size) / ship.size + 1)
            return min(budgetBased, sizeBased)
        }
    }

    func solve(grid: inout TileGrid, rowHints: [Int], columnHints: [Int], ships: [Ship]) {
        let unfoundShips = grid.unfoundShips(in: ships)

        guard let largestShip = unfoundShips.first, largestShip != .submarine else { return }

        let numberOfShipsToPlace = unfoundShips.filter { $0 == largestShip }.count

        let candidates = calculateCandidates(grid: grid,
                                             rowHints: rowHints,
                                             columnHints: columnHints,
                                             largestShip: largestShip,
                                             numberOfShipsToPlace: numberOfShipsToPlace)

        guard let candidates else { return }

        for candidate in candidates {
            let isRow = candidate.isRow
            let margin = candidate.tiles.count - largestShip.size
            let index = isRow ? candidate.position.x : candidate.position.y

            let start = index + margin
            let end = index + candidate.tiles.count - 1 - margin

            for i in 0 ... grid.gridSize {
                if i >= start, i <= end {
                    let position = Position(x: candidate.isRow ? i : candidate.position.x,
                                            y: candidate.isRow ? candidate.position.y : i)

                    let isEdge = i == start || i == end

                    if grid.get(position: position).isBlank {
                        grid.set(position: position, tile: isEdge ? .ship(.undetermined) : .ship(.middle))
                    }
                }
            }
        }
    }

    private func calculateCandidates(grid: TileGrid,
                                     rowHints: [Int],
                                     columnHints: [Int],
                                     largestShip: Ship,
                                     numberOfShipsToPlace: Int) -> [Candidate]? {
        var totalPlaces: Int = 0
        var candidates: [Candidate] = []

        grid.forEachUnfinishedLine { isRow, lineIndex, tiles in
            let hint = isRow ? rowHints[lineIndex] : columnHints[lineIndex]
            let currentHint = tiles.filter(\.isShip).count
            let lineBudget = hint - currentHint

            if hint >= largestShip.size {
                var candidateTiles: [Tile] = []

                for (index, tile) in (tiles + [.water]).enumerated() {
                    switch tile {
                    case .water:
                        if candidateTiles.count >= largestShip.size, candidateTiles.contains(.blank) {
                            let startIndex = index - candidateTiles.count
                            let position = Position(x: isRow ? startIndex : lineIndex,
                                                    y: isRow ? lineIndex : startIndex)

                            let budget = lineBudget + candidateTiles.filter(\.isShip).count

                            let candidate = Candidate(position: position,
                                                      isRow: isRow,
                                                      tiles: candidateTiles,
                                                      budget: budget)

                            if budget >= largestShip.size {
                                candidates.append(candidate)
                                totalPlaces += candidate.numberOfShipsThatCanFit(largestShip)

//                                if totalPlaces > numberOfShipsToPlace {
//                                    return nil
//                                }
                            }
                        }
                        candidateTiles = []

                    case .ship, .blank:
                        candidateTiles.append(tile)
                    }
                }
            }
        }

        // Just for now
        if totalPlaces > numberOfShipsToPlace {
            return nil
        }

        if numberOfShipsToPlace == totalPlaces {
            return candidates
        } else {
            return nil
        }
    }
}
