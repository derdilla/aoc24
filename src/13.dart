import '../aoc_solver.dart';
import 'dart:math' as math;

void main(List<String> _args) {
  final solver = A13()
    ..ignoreTests = false
    ..doLogging = false;
  solver.main();
}

class A13 extends AOCSolver<List<MachineConfig>> {
  @override
  String get day => '13';

  @override
  List<MachineConfig> parse(String input) {
    final blocks = input.split('\n\n');
    //log(input);
    final machines = <MachineConfig>[];
    for (final block in blocks) {
      final lines = block.split('\n').toList();

      final partsA = lines[0].split(', Y+');
      log(partsA);
      final aDeltaX = int.parse(partsA[0].split('A: X+')[1]);
      final aDeltaY = int.parse(partsA[1]);

      final partsB = lines[1].split(', Y+');
      log(partsB);
      final bDeltaX = int.parse(partsB[0].split('B: X+')[1]);
      final bDeltaY = int.parse(partsB[1]);

      final partsPos = lines[2].split(': X=');
      log(partsPos);
      final x = int.parse(partsPos[1].split(', Y=')[0]);
      final y = int.parse(partsPos[1].split(', Y=')[1]);
      machines.add(MachineConfig(x, y, aDeltaX, aDeltaY, bDeltaX, bDeltaY));
    }
    log(machines);
    return machines;
  }

  @override
  String computeA(List<MachineConfig> input) {
    int sum = 0;
    for (final m in input) {
      final List<int> valid = <int>[];

      for (int b = 0; b <= m.y; b++) {
        if (b * m.bDeltaY > m.y || b * m.bDeltaX > m.x) break;
        for (int a = 0; a <= m.x; a++) {
          if (a == 38 && b == 86) {
            log(m);
          }
          //log((a,b));
          // if (x * m.aDeltaX + y*m.bDeltaX > m.x) break;
          // if (y * m.aDeltaY + y*m.bDeltaY > m.y) break;
          if (a*m.aDeltaX + b*m.bDeltaX != m.x) continue;
          if (a*m.aDeltaY + b*m.bDeltaY != m.y) continue;
          valid.add(3*a+b);
        }
      }

      log(valid);

      if (valid.isNotEmpty) {
        valid.sort();
        sum += valid.first;
      }
    }
    return sum.toString();
  }

  @override
  String computeB(List<MachineConfig> input) {
    // Add 10000000000000

    // With x btn A presses an y btn B presses:
    // X-coords: a*x + b*y = c
    // Y-coords: d*x + e*y = f
    //
    // => x = (b*f - c*e)/(b*d-a*e)
    // => y = (cd-af)/(bd-ae)
    int sum = 0;
    for (final m in input) {
      m.x += 10000000000000;
      m.y += 10000000000000;

      final divisor = (m.bDeltaX * m.aDeltaY) - (m.aDeltaX * m.bDeltaY);
      final aPresses = (m.bDeltaX * m.y - m.x * m.bDeltaY) / divisor;
      final bPresses = (m.x*m.aDeltaY - m.aDeltaX*m.y) / divisor;

      if (aPresses == aPresses.toInt()
        && bPresses == bPresses.toInt()) {
          sum += 3 * aPresses.toInt() + bPresses.toInt();
      }
    }
    return sum.toString();
  }
}

class MachineConfig {
  // Button A: X+17, Y+86
  //Button B: X+84, Y+37
  // Prize: X=7870, Y=6450
  int x;
  int y;

  int aDeltaX;
  int aDeltaY;

  int bDeltaX;
  int bDeltaY;

  MachineConfig(this.x, this.y, this.aDeltaX, this.aDeltaY, this.bDeltaX, this.bDeltaY);

  String toString() {
    return '(x:$x, y:$y, aDeltaX:$aDeltaX, aDeltaY:$aDeltaY, bDeltaX:$bDeltaX, bDeltaY:$bDeltaY)';
  }
}

int gcd(int a, int b) {
  final initA = a;
  final initB = b;
  while (b != 0) {
    var t = b;
    b = a % t;
    a = t;
  }
  return a;
}