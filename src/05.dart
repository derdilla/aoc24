import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A05()
    ..ignoreTests = false
    ..doLogging = false;
  solver.main();
}

class A05 extends AOCSolver<PagePrintingInfo> {
  @override
  String get day => '05';

  @override
  PagePrintingInfo parse(String input) {
    final sects = input.split('##');
    log(sects.length);
    final rules = sects[0].split('\n').map((e) => e.split('|').map((e)=> int.parse(e)).toList());
    final updates =sects[1].split('\n').map((e) => e.split(',').map((e)=> int.parse(e)).toList());

    return PagePrintingInfo(rules.toList(), updates.toList());
  }

  @override
  String computeA(PagePrintingInfo input) {
    // gather correct
    final correctOrderedUpdates = <List<int>>[];
    for (final u in input.updates) {
      bool isOk = true;
      for (final r in input.rules) {
        if (r.every((e) => u.contains(e))) { // list applies
          int lastIdx = -1;
          for (final e in r) {
            final idx = u.indexOf(e);
            if (idx < lastIdx) isOk = false;
            lastIdx = idx;
          }
        }
      }


      if (isOk) {
        correctOrderedUpdates.add(u);
      }
    }

    // addd centers
    int sum = 0;
    for (final u in correctOrderedUpdates) {
      sum += u[u.length ~/ 2];
    }
    return sum.toString();
  }

  @override
  String computeB(PagePrintingInfo input) {
    // gather incorrect
    final incorrectOrderedUpdates = <List<int>>[];
    for (final u in input.updates) {
      bool isOk = true;
      for (final r in input.rules) {
        if (r.every((e) => u.contains(e))) { // list applies
          int lastIdx = -1;
          for (final e in r) {
            final idx = u.indexOf(e);
            if (idx < lastIdx) isOk = false;
            lastIdx = idx;
          }
        }
      }


      if (!isOk) {
        incorrectOrderedUpdates.add(u);
      }
    }

    // fix
    final fixed = <List<int>>[];
    for (List<int> u in incorrectOrderedUpdates) {
      final applyingRuls = input.rules.where((r) => r.every((e) => u.contains(e)));

      log(_hasWronOrder(input.rules, u));
      while (_hasWronOrder(input.rules, u)) {
        for (final r in input.rules) {
          if (r.every((e) => u.contains(e))) { // list applies
            if (u.indexOf(r[0]) >= u.indexOf(r[1])) {
              final tmp = u[u.indexOf(r[0])];
              u[u.indexOf(r[0])] = u[u.indexOf(r[1])];
              u[u.indexOf(r[1])] = tmp;
            }
          }
        }
      }
      fixed.add(u);
    }
    log(fixed);

    // addd centers
    int sum = 0;
    for (final u in fixed) {
      sum += u[u.length ~/ 2];
    }
    return sum.toString();
  }

}

bool _hasWronOrder(List<List<int>> rules, List<int> u) {
  bool isOk = false;
  for (final r in rules) {
    if (r.every((e) => u.contains(e))) { // list applies
      int lastIdx = -1;
      for (final e in r) {
        final idx = u.indexOf(e);
        if (idx < lastIdx) isOk = true;
        lastIdx = idx;
      }
    }
  }
  return isOk;
}

class PagePrintingInfo {
  List<List<int>> rules;
  List<List<int>> updates;

  PagePrintingInfo(this.rules, this.updates);
}
