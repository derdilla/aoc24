import '../aoc_solver.dart';
import 'dart:math' as math;
import 'dart:io';

void main(List<String> _args) {
  final solver = A14()
    ..ignoreTests = true
    ..doLogging = true;
  solver.main();
}

class A14 extends AOCSolver<RobotArena> {
  @override
  String get day => '14';

  @override
  RobotArena parse(String input) {
    final lines = input.split('\n');
    
    final robots = <Robot>[];
    for (final l in lines) {
      final pos = l.split(' v=')[0].split('p=')[1].split(',');
      final vel = l.split(' v=')[1].split(',');
      robots.add(Robot(
        int.parse(pos[0]),
        int.parse(pos[1]),
        int.parse(vel[0]),
        int.parse(vel[1]),
      ));
    }

    return RobotArena(robots, 101, 103);//11, 7);//101, 103);
  }

  @override
  String computeA(RobotArena input) {
    
    for (int i = 0; i < 100; i++) input.tick();
    input.debugPrintArena();
    log(input.robots.length);

    final quads = input.getPerQuadrant();
    log(quads);
    int prod = 1;
    for (final x in quads) {
      prod *= x;
    }
    // 224554908
    return prod.toString();
  }

  @override
  String computeB(RobotArena input) {
    String out = '';
    for (int i = 0; i < 10000; i++)  {
      input.tick();
      if (i % 101 == 78) {
        // My the first few 100 of my data
        // looked kinda periodic at that interval
        out += ('\ni=$i\n');
        out += input.debugPrintArena();}
      }
    File('14b-2.out').writeAsStringSync(out);
     
    return 'scroll to 6643 :3 (add one cause i is idx)';
  }
}

class RobotArena {
  List<Robot> robots;
  int width;
  int height;

  RobotArena(this.robots, this.width, this.height);

  void tick() {
    for (final r in robots) {
      r.tick(width, height);
    }
  }

  List<int> getPerQuadrant() {
    int topLSum = 0;
    int topRSum = 0;
    int btmRSum = 0;
    int btmLSum = 0;
    
    for(final r in robots) {
      //print('pos: ${(r.x, r.y)}, vel: ${(r.vX, r.vY)}');
      if (r.x < width ~/ 2 && r.y < height ~/ 2) {
        //print('TL: ${r.x}, ${r.y}');
        topLSum += 1;
      } else if (r.x < width ~/ 2 && r.y > height ~/ 2) {
        //print('BL: ${r.x}, ${r.y}');
        btmLSum += 1;
      } else if (r.x > width ~/ 2 && r.y > height ~/ 2) {
        btmRSum += 1;
        //print('BR: ${r.x}, ${r.y}');
      } else if (r.x > width ~/ 2 && r.y < height ~/ 2) {
        topRSum += 1;
        //print('TR: ${r.x}, ${r.y}');
      } else {
        print('pos: ${(r.x, r.y)}, vel: ${(r.vX, r.vY)}');
      }
    }

    return [topLSum, topRSum, btmLSum, btmRSum];
  }

  String debugPrintArena() {
    String out = '';
    for (int y = 0; y < height; y++) {
      String line = '';
      for (int x = 0; x < width; x++) {
        final count = robots.where((e) => e.x == x && e.y == y).length;
        line += (count == 0) ? ' ' : '#'; //count.toString();
        //if (x == width ~/ 2) line += ' ';
      }
      out += (line) + '\n';
      //if(y == height ~/ 2) print('');
    }
    return out;
  }
}

class Robot {
  int x;
  int y;

  int vX;
  int vY;

  Robot(this.x, this.y, this.vX, this.vY);

  void tick(int width, int height) {
    x += vX + width;
    x %= width;
    y += vY + height;
    y %= height;
  }
}
