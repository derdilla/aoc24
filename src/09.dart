//import 'dart:math';

import '../aoc_solver.dart';

void main() {
  final solver = A09()
    ..ignoreTests = false
    ..doLogging = false;
  solver.main();
}

class A09 extends AOCSolver<String> {
  @override
  String get day => '09';

  @override
  String parse(String e) => e;

  @override
  String computeA(String inp) {
    List<String> split = inp.split('');
    List<int> input = [];
    bool isEmpty = false;
    for (var i = 0; i < split.length; i++) {
      final c = isEmpty ? -1 : (i ~/ 2);
      for (var k = 0; k < int.parse(split[i]); k++) {
        input.add(c);
      }
      isEmpty = !isEmpty;
    }

    if (input.length < 50) log(input);
    List<int> data = input;
    int i = input.length - 1;
    while (input.indexOf(-1) < i /* contains free space before */) {
      if(input[i] != '.') {
        int k = data.indexOf(-1);
        data[k] = input[i];
        data[i] = -1;
      }
      i -= 1;
    }

    int res = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i] == -1) continue;
      res += i* data[i];
    }
    return res.toString();
  }

  @override
  String computeB(String input) {
    List<String> split = input.split('');
    List<List<int>> tmp = [];
    bool isEmpty = false;
    for (var i = 0; i < split.length; i++) {
      final c = isEmpty ? -1 : (i ~/ 2);
      List<int> l = [];
      for (var k = 0; k < int.parse(split[i]); k++) {
        l.add(c);
      }
      tmp.add(l);
      isEmpty = !isEmpty;
    }
    log(tmp);

    for (var i = tmp.length - 1; i >= 0; i--) {
      if (tmp[i].isEmpty || tmp[i][0] < 0) continue;
      for (var j = 0; j < i; j++) {
        if (tmp[j].length >= tmp[i].length && tmp[j].isNotEmpty && tmp[j][0] == -1) {
          final subl = tmp[j].sublist(tmp[i].length, tmp[j].length);
          tmp[j] = subl;
          tmp.insert(j, tmp[i]);
          //i += 1;
          final newl = <int>[];
          for (int g = 0; g < tmp[i+1].length; g++) {
            newl.add(-2);
          }
          tmp[i+1] = newl;
          break;
          
        }
      }
    }
    log(tmp);

    final concat = [];
    for (var a in tmp) {
      for (var b in a) {
        concat.add(b);
      }
    }

    log('00992111777.44.333....5555.6666.....8888..');
    log(concat.map((e) => (e < 0) ? '.' : e.toString()).join(''));
    

    int res = 0;
    for (var i = 0; i < concat.length; i++) {
      if (concat[i] <= -1) continue;
      res += (i * concat[i]).toInt();
    }
    return res.toString();
  }
}

// class FileBlock {
//   int size;
//   int id;
// }
