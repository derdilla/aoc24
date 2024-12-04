import 'dart:io';

abstract class AOCSolver<T> {
  /// Day as a 2 digit String like '10', or '03'.
  String get day;

  void main() {
    print('[--------------- Running tests ---------------]');
    if (test()) return;
    //print('\\---------------------------------------------/');

    print('[--------------- Solve puzzles ---------------]');
    print('  A: ${solveA(input)}');
    print('  B: ${solveB(input)}');
    //print('\\---------------------------------------------/');
  }

  bool ignoreTests = false;

  /// Run KATs on tests and returns true on failure.
  bool test() {
    if (ignoreTests) return false;

    bool failed = false;

    String res = solveA(katA.$1);
    if (res != katA.$2) {
      print('KAT A failed: expected ${katA.$2} but got $res');
      failed = true;
    } else print('  ✔️ KAT A passed');
  
    res = solveB(katB.$1);
    if (res != katB.$2) {
      print('KAT B failed: expected ${katB.$2} but got $res');
      failed = true;
    } else print('  ✔️ KAT B passed');

    return failed;
  }

  String solveA(String input) {
    final parsed = parseA(input);
    return computeA(parsed);
  }
  String solveB(String input) {
    final parsed = parseB(input);
    return computeB(parsed);
  }

  /// First parsing step of the data.
  T parse(String input);
  T parseA(String input) => parse(input);
  T parseB(String input) => parse(input);

  /// Create result of task a from parsed data.
  String computeA(T input);
  /// Create result of task b from parsed data.
  String computeB(T input);

  (String, String) get katA => _readInGenericKAT('a');
  (String, String) get katB => _readInGenericKAT('b');

  (String, String) _readInGenericKAT(String variant) {
    final katIn = File('kat/$day.$variant.in').readAsStringSync();
    final katOut = File('kat/$day.$variant.out').readAsStringSync();
    return (katIn, katOut);
  }

  String get input => File('in/$day.in').readAsStringSync();

  bool doLogging = true;

  void log(Object? data) {
    if(doLogging) print(data);
  }
}