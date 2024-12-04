import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A04()
    ..ignoreTests = false
    ..doLogging = true;
  solver.main();
  // print(solver._countXmasInWord('word'));
  // print(solver._countXmasInWord('XMAS'));
  // print(solver._countXmasInWord('XXMAS'));
  // print(solver._countXmasInWord('XMASXMAS'));
  // print(solver._countXmasInWord('XMXMAS'));
}

class A04 extends AOCSolver<List<List<String>>> {
  @override
  String get day => '04';

  @override
  List<List<String>> parse(String input) {
    final interpretations = <List<String>>[];
    
    final lines = input.split("\n");
    interpretations.add(lines); // normal rows
    interpretations.add(['----']);
    interpretations.add(lines.map((e) => e.split('').reversed.join()).toList()); // reversed rows

    final columns = <String>[];
    for (int colIdx = 0; colIdx < lines.first.length; colIdx++) {
      String col = '';
      String revCol = '';
      for (int lineIdx = 0; lineIdx < lines.length; lineIdx++) {
        col += lines[lineIdx][colIdx];
      }
      columns.add(col);
    }
    interpretations.add(['----']);
    interpretations.add(columns);
    interpretations.add(['----']);
    interpretations.add(columns.map((e) => e.split('').reversed.join()).toList());

    // top left to bottom right
    final tlbr = <String>[];
    final trbl = <String>[];
    for (int rowIdx = 0; rowIdx < lines.length; rowIdx++) {
      for (int colIdx = 0; colIdx < lines.first.length; colIdx++) {
        if (tlbr.length <= rowIdx + colIdx) {
          tlbr.insert(rowIdx + colIdx, '');
          trbl.insert(rowIdx + colIdx, '');
        }
        tlbr[rowIdx + colIdx] += lines[rowIdx][colIdx];
        trbl[rowIdx + colIdx] += lines[rowIdx][lines.first.length - colIdx - 1];
      }
    }
    interpretations.add(['----']);
    interpretations.add(tlbr);
    interpretations.add(['----']);
    interpretations.add(tlbr.map((e) => e.split('').reversed.join()).toList()); // brtl
    interpretations.add(['----']);
    interpretations.add(trbl);
    interpretations.add(['----']);
    interpretations.add(trbl.map((e) => e.split('').reversed.join()).toList()); // bltr

    return interpretations;
  }
  
  @override
  String computeA(List<List<String>> input) {
    log(input);
    int count = 0;
    for (final interpretation in input) {
      for (final w in interpretation) {
        final c = _countXmasInWord(w);
        log('$w: $c');
        count += c;
      }
    }
    return count.toString();
  }

  // count XMASes without sharing letters
  int _countXmasInWord(String word) {
    final puzzles = <String>[];
    for (final letter in word.split('')) {
      if(letter == 'X') {
        puzzles.add(letter);
      } else if(letter == 'M') {
        final i = puzzles.indexWhere((e) => e.endsWith('X'));
        if (i >= 0) {
          puzzles[i] += letter;
        }
      } else if(letter == 'A') {
        final i = puzzles.indexWhere((e) => e.endsWith('M'));
        if (i >= 0) {
          puzzles[i] += letter;
        }
      } else if(letter == 'S') {
        final i = puzzles.indexWhere((e) => e.endsWith('A'));
        if (i >= 0) {
          puzzles[i] += letter;
        }
      }
    }

    return puzzles.where((e) => e == 'XMAS').length;
  }

  // Counts xmasses by the amount of xes, allowing letter sharing
  int _countXmasInWordOld(String word) {
    // State goes to 1 for x, 2 for m, 3>a for highest letter seen in order
    int state = 0;
    int leadingXCount = 0;
    int? recursedXmases = null;
    for (int i = 0; i < word.length; i++) {
      final letter = word[i];
      if ((state == 0 || state == 1) && letter == 'X') {
        leadingXCount += 1;
        state = 1;
      } else if (letter == 'X' && recursedXmases == null) {
        recursedXmases = _countXmasInWord(word.substring(i - 1));
      } else if ((state == 1 || state == 2) && letter == 'M') {
        state = 2;
      } else if ((state == 2 || state ==3) && letter == 'A') {
        state = 3;
      } else if ((state == 3 || state == 4) && letter == 'S') {
        // No new xmass findable by this invocation
        if (recursedXmases == null && i < (word.length - 3)) {
          recursedXmases = _countXmasInWord(word.substring(i - 1));
        }
        return leadingXCount + (recursedXmases ?? 0);
      }
    }
    return 0; // state 4 never reached
  }

  @override
  String computeB(List<List<String>> input) {
    // TODO: implement computeB
    throw UnimplementedError();
  }

}
