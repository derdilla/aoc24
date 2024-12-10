import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A10()
    ..ignoreTests = false
    ..doLogging = true;
  solver.main();
}

class A10 extends AOCSolver<String> {
  @override
  String get day => '10';

  @override
  String parse(String input) => input;

  @override
  String computeA(String input) {
    final lines = input.split("\n");
    List<(int, int)> potTrailheads = [];
    for (int i = 0; i < lines.length; i++) {
      for (var j = 0; j < lines[0].length; j++) {
        if (lines[i].split('')[j] == '0') {
          potTrailheads.add((i,j));
        }
      }
    }

    int sum = 00;
    for (final a in potTrailheads) {
      sum += pCount(lines, [a]);
    }

    return sum.toString();
  }

  int pCount(List<String> map, List<(int, int)> pose) {
    List<(int, int)> poses = pose;
    
    List<(int, int)> nextPoses = [];
    for (var i = 1; i <= 9; i++) {
      log(poses);
      String search = i.toString();
      for (final pos in poses) {
        if (pos.$1 > 0                  && map[pos.$1 - 1].split('')[pos.$2] == search) nextPoses.add((pos.$1-1, pos.$2));
        if (pos.$1 + 1 < map.length     && map[pos.$1 + 1].split('')[pos.$2] == search) nextPoses.add((pos.$1+1, pos.$2));
        if (pos.$2 > 0                  && map[pos.$1].split('')[pos.$2 - 1] == search) nextPoses.add((pos.$1, pos.$2-1));
        if (pos.$2 + 1 < map[0].length  && map[pos.$1].split('')[pos.$2 + 1] == search) nextPoses.add((pos.$1, pos.$2 +1));
      }
      poses = nextPoses;
      nextPoses = [];
    }
    return Set.from(poses).length;
  }

  @override
  String computeB(String input) {
    final lines = input.split("\n");
    List<(int, int)> potTrailheads = [];
    for (int i = 0; i < lines.length; i++) {
      for (var j = 0; j < lines[0].length; j++) {
        if (lines[i].split('')[j] == '0') {
          potTrailheads.add((i,j));
        }
      }
    }

    return pCount2(lines, potTrailheads).toString();
  }

  int pCount2(List<String> map, List<(int, int)> pose) {
    List<(int, int)> poses = pose;
    
    List<(int, int)> nextPoses = [];
    for (var i = 1; i <= 9; i++) {
      log(nextPoses);
      String search = i.toString();
      for (final pos in poses) {
        if (pos.$1 > 0                  && map[pos.$1 - 1].split('')[pos.$2] == search) nextPoses.add((pos.$1-1, pos.$2));
        if (pos.$1 + 1 < map.length     && map[pos.$1 + 1].split('')[pos.$2] == search) nextPoses.add((pos.$1+1, pos.$2));
        if (pos.$2 > 0                  && map[pos.$1].split('')[pos.$2 - 1] == search) nextPoses.add((pos.$1, pos.$2-1));
        if (pos.$2 + 1 < map[0].length  && map[pos.$1].split('')[pos.$2 + 1] == search) nextPoses.add((pos.$1, pos.$2 +1));
      }
      poses = nextPoses;
      nextPoses = [];
    }
    return poses.length;
  }
}
