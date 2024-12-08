import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A08()
    ..ignoreTests = false
    ..doLogging = true;
  solver.main();
}

class A08 extends AOCSolver<(List<List<(int,int)>>, int, int)> {
  @override
  String get day => '08';

  // List of same-freq antena poses 
  @override
  (List<List<(int,int)>>, int, int) parse(String input) {
    final map = <String, List<(int, int)>>{};

    final lines = input.split('\n');
    for (var y = 0; y < lines.length; y++) {
      for (var x = 0; x < lines[0].length; x++) {
        final char = lines[y].split('')[x];
        if (char == '.') continue;
        if (!map.containsKey(char)) {
          map[char] = [];
        }
        map[char]!.add((x,y));
      }
    }
    log(map);
    return (map.values.toList(), lines.first.length, lines.length);
  }

  @override
  String computeA((List<List<(int,int)>>, int, int) input) {
    int width = input.$2;
    int height = input.$3; 

    Set<(int, int)> antis = Set();
    
    for (final antenas in input.$1) {
      for (var a = 0; a < antenas.length; a++) {
        for (var b = 0; b < antenas.length; b++) {
          if (a == b) continue;
          final last = antenas[a];
          final next = antenas[b];
          final difference = (next.$1 - last.$1, next.$2 - last.$2); // from last to next
          final nextAnti = (next.$1 + difference.$1, next.$2 + difference.$2);
          final prevAnti = (last.$1 - difference.$1, last.$2 - difference.$2);
          // log(prevAnti);
          // log(nextAnti);
          if(nextAnti.$1 >= 0 && nextAnti.$1 < width 
            && nextAnti.$2 >= 0 && nextAnti.$2 < height) {
              antis.add(nextAnti);
          }
          if(prevAnti.$1 >= 0 && prevAnti.$1 < width 
            && prevAnti.$2 >= 0 && prevAnti.$2 < height) {
              antis.add(prevAnti);
          }
        }
      }
    }
    //log(antis);
    return antis.length.toString();
  }

  @override
  String computeB((List<List<(int,int)>>, int, int) input) {
    int width = input.$2;
    int height = input.$3; 

    Set<(int, int)> antis = Set();
    
    for (final antenas in input.$1) {
      for (var a = 0; a < antenas.length; a++) {
        for (var b = 0; b < antenas.length; b++) {
          if (a == b) continue;
          final last = antenas[a];
          final next = antenas[b];
          for (var i = -80; i < 80; i++) {
            final difference = (i * (next.$1 - last.$1), i * (next.$2 - last.$2)); // from last to next
            final nextAnti = (next.$1 + difference.$1, next.$2 + difference.$2);
            final prevAnti = (last.$1 - difference.$1, last.$2 - difference.$2);
            // log(prevAnti);
            // log(nextAnti);
            if(nextAnti.$1 >= 0 && nextAnti.$1 < width 
              && nextAnti.$2 >= 0 && nextAnti.$2 < height) {
                antis.add(nextAnti);
            }
            if(prevAnti.$1 >= 0 && prevAnti.$1 < width 
              && prevAnti.$2 >= 0 && prevAnti.$2 < height) {
                antis.add(prevAnti);
            }
          }
        }
      }
    }
    //log(antis);
    return antis.length.toString();
  }
}
