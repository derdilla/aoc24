import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A12()
    ..ignoreTests = false
    ..doLogging = true;
  solver.main();
}

class A12 extends AOCSolver<String> {
  @override
  String get day => '12';

  @override
  String parse(String input) => input;

  @override
  String computeA(String input) {
    final grid = input.split('\n').map((e) => e.split('').toList()).toList();
    final visited = List.generate(
      grid.length,
      (_) => List.filled(grid[0].length, false),
    );

    int sum = 0;

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        if (visited[i][j]) continue;

        int sides = 0;
        int area = 0;
        List<(int, int)> toVisit = [(i,j)];
        while (toVisit.isNotEmpty) {
          (int, int) node = toVisit.removeLast();

          int x = node.$2;
          int y = node.$1;
          // log('${node}: ${visited[y][x]}');
          if (visited[y][x]) continue;
          visited[y][x] = true;

          area += 1;
          sides += 4;
          if (x - 1 >= 0 && grid[y][x-1] == grid[y][x]) {
            sides -= 1;
            toVisit.add((y,x-1));
          }
          if (y - 1 >= 0 && grid[y-1][x] == grid[y][x]) {
            sides -= 1;
            toVisit.add((y-1,x));
          }
          if (x + 1 < grid[0].length && grid[y][x+1] == grid[y][x]) {
            sides -= 1;
            toVisit.add((y,x+1));
          }
          if (y + 1 < grid.length && grid[y+1][x] == grid[y][x]) {
            sides -= 1;
            toVisit.add((y+1,x));
          }
          log(toVisit);
        }
        log('sides: $sides area: $area');
        sum += sides * area;
      }
  }
  return sum.toString();

    // final sides = {};
    // final counts = {};
    // final tiles = input.split('\n').map((e) => e.split('').toList()).toList();
    // for (int y = 0; y<tiles.length; y++) {
    //   for (int x = 0; x < tiles[0].length; x++) {
    //     if (!counts.containsKey(tiles[y][x])) {
    //       counts[tiles[y][x]] = 0;
    //       sides[tiles[y][x]] = 0;
    //     }
    //     counts[tiles[y][x]] += 1;
    //     int ses = 4;
    //     if (x - 1 >= 0 && tiles[y][x-1] == tiles[y][x]) ses--;
    //     if (y - 1 >= 0 && tiles[y-1][x] == tiles[y][x]) ses--;
    //     if (x + 1 < tiles.length && tiles[y][x+1] == tiles[y][x]) ses--;
    //     if (y + 1 < tiles.length && tiles[y+1][x] == tiles[y][x]) ses--;
    //     sides[tiles[y][x]] += ses;
    //   }
    // }

    // num sum = 0;
    // for (final k in sides.keys) {
    //   sum += sides[k] * counts[k];
    // }

    // return sum.toString();
  }

  @override
  String computeB(String input) {
    final grid = input.split('\n').map((e) => e.split('').toList()).toList();
    final visited = List.generate(
      grid.length,
      (_) => List.filled(grid[0].length, false),
    );

    int sum = 0;

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        if (visited[i][j]) continue;

        Set<(int,int,int,int)> sides = Set(); // sides between 2 x/y coords: x,x,y,y
        int area = 0;
        List<(int, int)> toVisit = [(i,j)];
        while (toVisit.isNotEmpty) {
          (int, int) node = toVisit.removeLast();

          int x = node.$2;
          int y = node.$1;
          // log('${node}: ${visited[y][x]}');
          if (visited[y][x]) continue;
          visited[y][x] = true;

          area += 1;
          if (x - 1 >= 0 && grid[y][x-1] == grid[y][x]) {
            sides.add((x-1,x,0,0));
            sides.add((x,x-1,0,0));
            toVisit.add((y,x-1));
          }
          if (y - 1 >= 0 && grid[y-1][x] == grid[y][x]) {
            sides.add((0,0,y-1,y));
            sides.add((0,0,y,y-1));
            toVisit.add((y-1,x));
          }
          if (x + 1 < grid[0].length && grid[y][x+1] == grid[y][x]) {
            sides.add((x+1,x,0,0));
            sides.add((x,x+1,0,0));
            toVisit.add((y,x+1));
          }
          if (y + 1 < grid.length && grid[y+1][x] == grid[y][x]) {
            sides.add((0,0,y+1,y));
            sides.add((0,0,y,y+1));
            toVisit.add((y+1,x));
          }
          log(toVisit);
        }
        log('sides: $sides area: $area');
        sum += (sides.length ~/ 2) * area;
      }
  }
  return sum.toString();
  }
}
