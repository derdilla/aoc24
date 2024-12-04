import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A04()
    ..ignoreTests = false
    ..doLogging = false;
  solver.main();
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

  // Counts xmasses by the amount of xes, allowing letter sharing
  int _countXmasInWord(String word) {
    int count = 0;
    int last = word.indexOf("XMAS", 0);
    while(last >= 0) {
      count++;
      last = word.indexOf("XMAS", last + 1);
    }
    return count;
  }

  @override
  String computeB(List<List<String>> input) {
    // TODO: implement computeB
    throw UnimplementedError();
  }

  @override
  String solveB(String input) {
    int count = 0; 

    final rows = input.split('\n');
    final chars = rows.map((e) => e.split('')).toList();
    for(int y = 1; y < rows.length - 1; y++) {
      for(int x = 1; x < chars.first.length - 1; x++) {
        if (chars[y][x] == 'A'
          && chars[y-1][x-1] == 'M'
          && chars[y+1][x-1] == 'M'
          && chars[y-1][x+1] == 'S'
          && chars[y+1][x+1] == 'S') {
            count++;
          }
        else if (chars[y][x] == 'A'
          && chars[y-1][x-1] == 'S'
          && chars[y+1][x-1] == 'S'
          && chars[y-1][x+1] == 'M'
          && chars[y+1][x+1] == 'M') {
            count++;
          }  else if (chars[y][x] == 'A'
          && chars[y-1][x-1] == 'M'
          && chars[y+1][x-1] == 'S'
          && chars[y-1][x+1] == 'M'
          && chars[y+1][x+1] == 'S') {
            count++;
          } else if (chars[y][x] == 'A'
          && chars[y-1][x-1] == 'S'
          && chars[y+1][x-1] == 'M'
          && chars[y-1][x+1] == 'S'
          && chars[y+1][x+1] == 'M') {
            count++;
          }
      }
    }
    return count.toString();
  }

}
