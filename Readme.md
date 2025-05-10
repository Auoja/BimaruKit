# BimaruKit

### Usage

```Swift
@ShipsBuilder var ships: [Ship] {
    Carrier()
    Battleship()
    Cruiser(2)
    Destroyer(4)
    Submarine(4)
}

let preferences = PuzzlePreferences(size: 12,
                                     ships: ships,
                                     isSymmetric: false)

let puzzle = BimaruKit.generate(preferences: preferences)
```

This will generate a guaranteed solveable puzzle (as long as the ships you provide fits inside the grid)
