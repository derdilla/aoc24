import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A06()
    ..ignoreTests = false
    ..doLogging = true;
  solver.main();
}

class A06 extends AOCSolver<GuardMap> {
  @override
  String get day => '06';

  @override
  GuardMap parse(String input) {
    List<(int, int)> obscacles = [];
    (int, int) guardPos = (0,0);
    Dir facing = Dir.up;

    final lines = input.split('\n');
    for (int x = 0; x < lines.first.length; x++) {
      for (int y = 0; y < lines.length; y++) {
        switch (lines[y][x]) {
          case '#': 
            obscacles.add((x,y));
          case '^':
            assert(guardPos == (0,0));
            guardPos = (x,y);
            facing = Dir.up;
        }
      }
    }

    return GuardMap(facing, guardPos, obscacles, lines.first.length, lines.length);
  }

  @override
  String computeA(GuardMap input) {
    List<(int, int, Dir)> path = [];
    Set<(int,int)> poses = Set();
    while (!path.contains((input.guardPos.$1, input.guardPos.$2, input.facing))
      && input.guardPos.$1 < input.maxX
      && input.guardPos.$2 < input.maxY
      && input.guardPos.$1 >= 0
      && input.guardPos.$2 >= 0
    ) {
      path.add((input.guardPos.$1, input.guardPos.$2, input.facing));
      poses.add(input.guardPos);
      switch (input.facing) {
        case Dir.up:
          if (input.obscacles.contains((input.guardPos.$1, input.guardPos.$2 - 1))) {
            input.facing = Dir.right;
          } else {
            input.guardPos = (input.guardPos.$1, input.guardPos.$2 - 1);
          }
        case Dir.left:
          if (input.obscacles.contains((input.guardPos.$1 -1, input.guardPos.$2))) {
            input.facing = Dir.up;
          } else {
            input.guardPos = (input.guardPos.$1 -1 , input.guardPos.$2);
          }
        case Dir.right:
          if (input.obscacles.contains((input.guardPos.$1 +1 , input.guardPos.$2))) {
            input.facing = Dir.down;
          } else {
            input.guardPos = (input.guardPos.$1 + 1, input.guardPos.$2);
          }
        case Dir.down:
          if (input.obscacles.contains((input.guardPos.$1, input.guardPos.$2 + 1))) {
            input.facing = Dir.left;
          } else {
            input.guardPos = (input.guardPos.$1, input.guardPos.$2 + 1);
          }
      }
    }

    log(poses);
    log(path);
    return poses.length.toString();
  }

  @override
  String computeB(GuardMap input) {
    List<(int, int, Dir)> path = [];
    Set<(int,int)> possibleObstructions = Set();

    int i = 0;
    while (!path.contains((input.guardPos.$1, input.guardPos.$2, input.facing))
      && input.guardPos.$1 < input.maxX
      && input.guardPos.$2 < input.maxY
      && input.guardPos.$1 >= 0
      && input.guardPos.$2 >= 0
    ) {
      log(i);
      i++;
      path.add((input.guardPos.$1, input.guardPos.$2, input.facing));
      switch (input.facing) {
        case Dir.up:
          if (getsBackOnTrack(input, (input.guardPos.$1, input.guardPos.$2, Dir.right), path, (input.guardPos.$1, input.guardPos.$2 - 1))) {
            possibleObstructions.add((input.guardPos.$1, input.guardPos.$2 - 1));
          }

          if (input.obscacles.contains((input.guardPos.$1, input.guardPos.$2 - 1))) {
            input.facing = Dir.right;
          } else {
            input.guardPos = (input.guardPos.$1, input.guardPos.$2 - 1);
          }
        case Dir.left:
          if (getsBackOnTrack(input, (input.guardPos.$1, input.guardPos.$2, Dir.up), path, (input.guardPos.$1 -1, input.guardPos.$2))) {
            possibleObstructions.add((input.guardPos.$1 - 1, input.guardPos.$2));
          }

          if (input.obscacles.contains((input.guardPos.$1 -1, input.guardPos.$2))) {
            input.facing = Dir.up;
          } else {
            input.guardPos = (input.guardPos.$1 -1 , input.guardPos.$2);
          }
        case Dir.right:
          if (getsBackOnTrack(input, (input.guardPos.$1, input.guardPos.$2, Dir.down), path, (input.guardPos.$1 +1 , input.guardPos.$2))) {
            possibleObstructions.add((input.guardPos.$1 + 1, input.guardPos.$2));
          }

          if (input.obscacles.contains((input.guardPos.$1 +1 , input.guardPos.$2))) {
            input.facing = Dir.down;
          } else {
            input.guardPos = (input.guardPos.$1 + 1, input.guardPos.$2);
          }
        case Dir.down:
        if (getsBackOnTrack(input, (input.guardPos.$1, input.guardPos.$2, Dir.left), path, (input.guardPos.$1, input.guardPos.$2 + 1))) {
            possibleObstructions.add((input.guardPos.$1, input.guardPos.$2 + 1));
          }

          if (input.obscacles.contains((input.guardPos.$1, input.guardPos.$2 + 1))) {
            input.facing = Dir.left;
          } else {
            input.guardPos = (input.guardPos.$1, input.guardPos.$2 + 1);
          }
      }
    }

    log(possibleObstructions);
    log(path);
    print('res potentially - 1');
    return possibleObstructions.length.toString(); // 1844 too high
  }

  bool getsBackOnTrack(GuardMap input, (int, int, Dir) pos, List<(int, int, Dir)> prevPath, (int, int) newObstacle) {
    input = GuardMap(pos.$3, (pos.$1, pos.$2), input.obscacles, input.maxX, input.maxY);

    List<(int, int, Dir)> path = [];
    while (input.guardPos.$1 < input.maxX
      && input.guardPos.$2 < input.maxY
      && input.guardPos.$1 >= 0
      && input.guardPos.$2 >= 0
    ) {
      if (prevPath.contains((input.guardPos.$1, input.guardPos.$2, input.facing))) return true;
      if (path.contains((input.guardPos.$1, input.guardPos.$2, input.facing))) return true;
      
      path.add((input.guardPos.$1, input.guardPos.$2, input.facing));
      switch (input.facing) {
        case Dir.up:
          if (input.obscacles.contains((input.guardPos.$1, input.guardPos.$2 - 1))) {
            input.facing = Dir.right;
          } else {
            input.guardPos = (input.guardPos.$1, input.guardPos.$2 - 1);
          }
        case Dir.left:
          if (input.obscacles.contains((input.guardPos.$1 -1, input.guardPos.$2))) {
            input.facing = Dir.up;
          } else {
            input.guardPos = (input.guardPos.$1 -1 , input.guardPos.$2);
          }
        case Dir.right:
          if (input.obscacles.contains((input.guardPos.$1 +1 , input.guardPos.$2))) {
            input.facing = Dir.down;
          } else {
            input.guardPos = (input.guardPos.$1 + 1, input.guardPos.$2);
          }
        case Dir.down:
          if (input.obscacles.contains((input.guardPos.$1, input.guardPos.$2 + 1))) {
            input.facing = Dir.left;
          } else {
            input.guardPos = (input.guardPos.$1, input.guardPos.$2 + 1);
          }
      }
    }

    return false;

  }

}

class GuardMap {
  // top left: 0,0 (x,y)
  List<(int, int)> obscacles;
  (int, int) guardPos;
  Dir facing;
  int maxY;
  int maxX;

  GuardMap(this.facing, this.guardPos, this.obscacles, this.maxX, this.maxY);
}

enum Dir {
  up,
  left,
  right,
  down,
}