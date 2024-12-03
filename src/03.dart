import '../aoc_solver.dart';

void main(List<String> _args) {
  final solver = A03()
    ..doLogging = false;
  solver.main();
}

class A03 extends AOCSolver<String> {
  @override
  String parse(String input) => input;

  @override
  String computeA(String input) {
    final regex = RegExp(r"mul\(([0-9]*),([0-9]*)\)");
    final matches = regex.allMatches(input);
    log(matches.map((e) => e.groups([0,1,2])));
    
    int sumOfProducts = 0;
    for (final m in matches) {
      final left = int.parse(m.group(1)!);
      final right = int.parse(m.group(2)!);
      log('+ $left * $right');
      sumOfProducts += (left * right);
    }

    return sumOfProducts.toString();
  }

  @override
  String computeB(String input) {
    final regex = RegExp(r"(?:do\(\))|(?:don't\(\))|mul\(([0-9]*),([0-9]*)\)");
    final matches = regex.allMatches(input);
    log(matches.map((e) => e.groups([0])));
    
    int sumOfProducts = 0;
    bool ignore = false;
    for (final m in matches) {
      if(m.group(0) == 'do()') {
        ignore = false;
        log('Disable Ignore');
        continue;
      } else if(m.group(0) == "don't()") {
        ignore = true;
        log('Enable Ignore');
        continue;
      } 


      final left = int.parse(m.group(1)!);
      final right = int.parse(m.group(2)!);
      if (!ignore) {
        log('+ $left * $right');
        sumOfProducts += (left * right);
      } else {
        log('ignore $left * $right ');
      }
      
    }

    return sumOfProducts.toString();
  }

  @override
  String get day => '03';
}
