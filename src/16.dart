import '../aoc_solver.dart';
import "package:a_star/a_star.dart";

void main(List<String> _args) {
  final solver = A16()
    ..ignoreTests = false
    ..doLogging = true;
  solver.main();
}

class A16 extends AOCSolver<String> {
  @override
  String get day => '16';

  @override
  String parse(String input) => input;

  @override
  String computeA(String input) {
    final lines = input.split('\n');
    final walls = <List<bool>>[];
    (int, int)? end;
    (int, int)? start;
    for (int y = 0; y < lines.length; y++) {
      final row = <bool>[];
      for (int x = 0; x < lines[y].length; x++) {
        switch(lines[y][x]) {
          case '#':
            row.add(true);
          default:
            row.add(false);
        }
        if (lines[y][x] == 'E') {
          end = (x,y);
        } else if (lines[y][x] == 'S') {
          start = (x,y);
        }
      }
      walls.add(row);
    }
    
    final initialMaze = MazeState(walls, end!, start!.$1, start!.$2);

    List<List<AStarNode<MazeState>>> unfinishedPaths = [[aStar(initialMaze)!]];
    final finishedPaths = [];
    while(unfinishedPaths.isNotEmpty) {
      final next = <List<AStarNode<MazeState>>>[];
      for (final p in unfinishedPaths) {
        final e = p.last;
        final nextA = e.expand().toList();
        if(nextA.isEmpty) {
          finishedPaths.add(p);
        } else {
          for (final x in nextA) {

            next.add(<AStarNode<MazeState>>[]
              ..addAll(p.toList())
                ..add(x));
          }
        }
      }
      unfinishedPaths = next;
    }
    num bestScore = 1000000000;
    for(final res in finishedPaths.map((e) => e.map((x) => x.state).toList())) {
      int rotations = 0;
      (int, int) dir = (0,-1);
      for (int i = 1; i < res.length; i++) {
        if ((res[i].x - res[i-1].x, res[i].y - res[i-1].y) != dir) {
          rotations += 1;
          log(dir);
          dir = (res[i].x - res[i-1].x, res[i].y - res[i-1].y);
        }
      }
      if ((rotations * 1000 + res.length) < bestScore) bestScore = (rotations * 1000 + res.length);
    }
    

    return bestScore.toString();
  }

  @override
  String computeB(String input) {
    throw UnimplementedError();
  }
}

class MazeState extends AStarState<MazeState> {
  final List<List<bool>> walls;
  final (int, int) end;

  final int x;
  final int y;

  const MazeState(this.walls, this.end, this.x, this.y, {super.depth = 0});

  @override
  Iterable<MazeState> expand() => [
    if (!walls[y+1][x])
      MazeState(walls, end, x, y + 1, depth: depth + 1),  // down
    if (!walls[y-1][x])
      MazeState(walls, end, x, y - 1, depth: depth + 1),  // up
    if (!walls[y][x+1])
      MazeState(walls, end, x + 1, y, depth: depth + 1),  // right
    if (!walls[y][x-1])
      MazeState(walls, end, x - 1, y, depth: depth + 1),  // left
  ];

  @override
  double heuristic() => ((end.$1 - x).abs() + (end.$2 - y).abs()).toDouble();

  @override
  String hash() => "($x, $y)";

  @override
  bool isGoal() => x == end.$1 && y == end.$2;
}
