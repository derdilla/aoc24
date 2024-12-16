import '../aoc_solver.dart';
import 'dart:math' as math;

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

        List<DirectionedFence> horrSides = [];
        List<DirectionedFence> vertSides = [];
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
            toVisit.add((y,x-1));
          } else {
            vertSides.addOrExpand(y, x-1, x);
          }
          if (y - 1 >= 0 && grid[y-1][x] == grid[y][x]) {
            toVisit.add((y-1,x));
          } else {
            horrSides.addOrExpand(x, y-1, y);
          }
          if (x + 1 < grid[0].length && grid[y][x+1] == grid[y][x]) {
            toVisit.add((y,x+1));
          } else {
            vertSides.addOrExpand(y, x+1, x);
          }
          if (y + 1 < grid.length && grid[y+1][x] == grid[y][x]) {
            toVisit.add((y+1,x));
          } else {
            horrSides.addOrExpand(x, y+1, y);
          }
          //log(toVisit);
        }

        // Duplicates can be created when finding a connecting piece after creating two edges
        // fix this by deduplicating
        final uniqueHorr = horrSides;//.mergeFences();
        final uniqueVert = vertSides;//.mergeFences();
        log('-----');
        for (final x in uniqueHorr) {
          log('horr ${x.aboveY}: ${x.leftmostFenceX}-${x.rightmostFenceX}');
        }
        for (final x in uniqueVert) {
          log('vert ${x.aboveY}: ${x.leftmostFenceX}-${x.rightmostFenceX}');
        }
        log('(${uniqueHorr.length} + ${uniqueVert.length}) * $area = ${((uniqueHorr.length + uniqueVert.length) * area)}');
        sum += (uniqueHorr.length + uniqueVert.length) * area;
      }
  }
  // 835625
  return sum.toString();
  }
}

class DirectionedFence {
  DirectionedFence(this.aboveY, this.belowY, this.leftmostFenceX, this.rightmostFenceX);

  int aboveY;
  int belowY;
  int leftmostFenceX;
  int rightmostFenceX;
  
  bool tryExpand(int x, int sideAY, int sideBY) {
    if ((sideAY == aboveY && sideBY == belowY)
      || (sideAY == belowY && sideBY == aboveY)) {
        if (x <= rightmostFenceX && x >= leftmostFenceX) return true;
        if (x == leftmostFenceX - 1) {
          leftmostFenceX -= 1;
          return true;
        }
        if (x == rightmostFenceX + 1) {
          rightmostFenceX += 1;
          return true;
        }
    }
    return false;
  }
}

extension on List<DirectionedFence> {
  void addOrExpand(int x, int sideAY, int sideBY) {
    for (final e in this) {
      if (e.tryExpand(x, sideAY, sideBY)) return;
    }
    add(DirectionedFence(sideAY, sideBY, x, x));
  }

  List<DirectionedFence> mergeFences() {
    Map<String, List<DirectionedFence>> groupedFences = {};

    for (final fence in this) {
      String key = '${fence.aboveY},${fence.belowY}';
      groupedFences.putIfAbsent(key, () => []).add(fence);
    }

    List<DirectionedFence> mergedFences = [];

    for (final group in groupedFences.values) {
      group.sort((a, b) => a.leftmostFenceX.compareTo(b.leftmostFenceX));

      List<DirectionedFence> mergedGroup = [];

      for (final fence in group) {
        if (mergedGroup.isEmpty ||
            mergedGroup.last.rightmostFenceX < (fence.leftmostFenceX - 1)) {
          mergedGroup.add(fence);
        } else {
          mergedGroup.last.rightmostFenceX =
              fence.rightmostFenceX > mergedGroup.last.rightmostFenceX
                  ? fence.rightmostFenceX
                  : mergedGroup.last.rightmostFenceX;
        }
      }

      mergedFences.addAll(mergedGroup);
    }
    return mergedFences;
  }
}
