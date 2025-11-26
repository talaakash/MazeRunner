class MazeGenerator {

    let cols: Int
    let rows: Int

    var grid: [[Int]]

    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        self.grid = Array(repeating: Array(repeating: 1, count: cols), count: rows)
    }

    func generate() -> [[Int]] {
        carve(r: 0, c: 0)
        return grid
    }

    func carve(r: Int, c: Int) {
        grid[r][c] = 0

        var dirs = [(0,1),(1,0),(0,-1),(-1,0)]
        dirs.shuffle()

        for (dr, dc) in dirs {
            let nr = r + dr*2
            let nc = c + dc*2

            if nr >= 0, nr < rows, nc >= 0, nc < cols, grid[nr][nc] == 1 {
                grid[r + dr][c + dc] = 0
                carve(r: nr, c: nc)
            }
        }
    }
}
