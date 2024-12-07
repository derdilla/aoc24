import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A06()
    ..ignoreTests = false
    ..doLogging = false;
  solver.main();
}

class A06 extends AOCSolver<List<(int, List<int>)>> {
  @override
  String get day => '07';

  @override
  List<(int, List<int>)> parse(String input) {
    final eqs = <(int, List<int>)>[];
    for (final line in input.split('\n')) {
      final elements = line.split(': ');
      final res = int.parse(elements[0]);
      final numbers = elements[1].split(' ').map((e) => int.parse(e));
      eqs.add((res, numbers.toList()));
    }
    return eqs;
  }
  
  @override
  String computeA(List<(int, List<int>)> input) {
    int validNumsSum = 0;
    for (final (res, eq) in input) {
      List<int> availableResults = <int>[];
      for(final e in eq) {
        if (availableResults.isEmpty) {
          availableResults.add(e);
          continue;
        }
        final oldRes = availableResults;
        availableResults = [];
        for (final oldE in oldRes) {
          availableResults.add(oldE + e);
          availableResults.add(oldE * e);
        }
      }

      if (availableResults.contains(res)) {
        log(res);
        validNumsSum += res;
      }
    }
    return validNumsSum.toString();
  }

  @override
  String computeB(List<(int, List<int>)> input) {
    int validNumsSum = 0;
    for (final (res, eq) in input) {
      List<int> availableResults = <int>[];
      for(final e in eq) {
        if (availableResults.isEmpty) {
          availableResults.add(e);
          continue;
        }
        final oldRes = availableResults;
        availableResults = [];
        for (final oldE in oldRes) {
          availableResults.add(oldE + e);
          availableResults.add(oldE * e);
          availableResults.add(int.parse(oldE.toString() + e.toString()));
        }
      }

      if (availableResults.contains(res)) {
        log(res);
        validNumsSum += res;
      }
    }
    return validNumsSum.toString();
  }

  
}