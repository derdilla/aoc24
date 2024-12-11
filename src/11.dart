import '../aoc_solver.dart';
import 'dart:math';

void main(List<String> _args) {
  final solver = A11()
    ..ignoreTests = true
    ..doLogging = true;
  solver.main();
}

class A11 extends AOCSolver<String> {
  @override
  String get day => '11';

  @override
  String parse(String input) => input;

  @override
  String computeA(String input) => input
    .split(' ')
    .map(int.parse)
    .map((e) => recCount(e, 25))
    .fold(0, (acc, x) => acc + x)
    .toString();

  @override
  String computeB(String input) => input
    .split(' ')
    .map(int.parse)
    .map((e) => recCount(e, 75))
    .fold(0, (acc, x) => acc + x)
    .toString();


  final cache = <(int, int), int>{};
  int recCount(int i, int n) {
    if (cache[(i,n)] != null) return cache[(i,n)]!;
    if (n == 0) return 1;

    int res = 0;
    if (i == 0) {
      res = recCount(1, n-1);
    } else if (((log(i) / log(10)).floor() + 1) % 2 == 1) {
      res = recCount(i * 2024, n - 1);
    } else {
      final digitCount = ((log(i) / log(10)).floor() + 1);
      res = (recCount(i ~/ pow(10, digitCount ~/ 2).toInt(), n - 1) + 
          recCount(i % pow(10, digitCount ~/ 2).toInt(), n - 1));
    }

    cache[(i,n)] = res;
    return res;
  }
}
