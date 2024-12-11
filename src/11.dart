import '../aoc_solver.dart';

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
  String computeA(String input) {
    List<String> sto = input.split(' ');
    List<String> nextSo = [];
    for (int i = 0; i < 75; i++) {
      log(i);
      for (final s in sto) {
        if (int.parse(s) == 0) {
          nextSo.add('1');
        } else if (s.length % 2 == 0) {
          log(s);
          log(s.substring(0, s.length ~/ 2));
          log(s.substring( s.length ~/ 2, s.length));
          nextSo.add(int.parse(s.substring(0, s.length ~/ 2)).toString());
          nextSo.add(int.parse(s.substring( s.length ~/ 2, s.length)).toString());
        } else {
          nextSo.add((int.parse(s) * 2024).toString());
        }
      }
      sto = nextSo;
      nextSo = [];
    }
    return sto.length.toString();
  }

  @override
  String computeB(String input) {
    throw UnimplementedError();
  }
}
