import 'dart:io';

int task1(String input) {
  final regex = RegExp(r"mul\(([0-9]*),([0-9]*)\)");
  final matches = regex.allMatches(input);
  print(matches.map((e) => e.groups([0,1,2])));
  
  int sumOfProducts = 0;
  for (final m in matches) {
    final left = int.parse(m.group(1)!);
    final right = int.parse(m.group(2)!);
    print('+ $left * $right');
    sumOfProducts += (left * right);
  }

  return sumOfProducts;
}

int task2(String input) {
  final regex = RegExp(r"(?:do\(\))|(?:don't\(\))|mul\(([0-9]*),([0-9]*)\)");
  final matches = regex.allMatches(input);
  print(matches.map((e) => e.groups([0])));
  
  int sumOfProducts = 0;
  bool ignore = false;
  for (final m in matches) {
    if(m.group(0) == 'do()') {
      ignore = false;
      print('Disable Ignore');
      continue;
    } else if(m.group(0) == "don't()") {
      ignore = true;
      print('Enable Ignore');
      continue;
    } 


    final left = int.parse(m.group(1)!);
    final right = int.parse(m.group(2)!);
    if (!ignore) {
      print('+ $left * $right');
      sumOfProducts += (left * right);
    } else {
      print('ignore $left * $right ');
    }
    
  }

  return sumOfProducts;
}

void main(List<String> args) {
  /*final catIn = File('cat/03.in').readAsStringSync();
  final catOut = File('cat/03.out').readAsStringSync();
  final catRes = task1(catIn);

  if (catOut != catRes.toString()) {
    print('Failed CAT: expected $catOut got $catRes');
    return;
  }

  final input = File('in/03.in').readAsStringSync();
  print('Real Result: ${task1(input)}');*/

  final catIn = File('cat/03.b.in').readAsStringSync();
  final catOut = File('cat/03.b.out').readAsStringSync();
  final catRes = task2(catIn);

  if (catOut != catRes.toString()) {
    print('Failed CAT 2: expected $catOut got $catRes');
    return;
  }

  final input = File('in/03.in').readAsStringSync();
  print('Real Result: ${task2(input)}');
}