import 'dart:io';

void main(List<String> args) {
  if (args.length == 0 || int.tryParse(args[0]) == 0) {
    print('Provide one argument containing the version');
    return;
  }
  final n = args[0];

  if (File('src/$n.dart').existsSync()) {
    print('File "src/$n.dart" file already exists: Aborting.');
    return;
  }

  File('in/$n.in').createSync();
  File('kat/$n.a.in').createSync();
  File('kat/$n.a.out').createSync();
  File('kat/$n.b.in').createSync();
  File('kat/$n.b.out').createSync();
  File('src/$n.dart').writeAsStringSync("import '../aoc_solver.dart';\n\n"
    'void main(List<String> _args) {\n'
    '  final solver = A$n()\n'
    '    ..ignoreTests = false\n'
    '    ..doLogging = true;\n'
    '  solver.main();\n'
    '}\n\n'
    'class A$n extends AOCSolver<CustomType> {\n'
    '  @override\n'
    "  String get day => '$n';\n\n"
    '  @override\n'
    '  CustomType parse(String input) => input;\n\n'
    '  @override\n'
    '  String computeA(CustomType input) {\n'
    '    TODO\n'
    '  }\n\n'
    '  @override\n'
    '  String computeB(CustomType input) {\n'
    '    throw UnimplementedError();\n'
    '  }\n}\n'
  );

  Process.run('/usr/bin/git', ['add', 'in/$n.in']);
  Process.run('/usr/bin/git', ['add', 'kat/$n.a.in']);
  Process.run('/usr/bin/git', ['add', 'kat/$n.a.out']);
  Process.run('/usr/bin/git', ['add', 'kat/$n.b.in']);
  Process.run('/usr/bin/git', ['add', 'kat/$n.b.out']);
  Process.run('/usr/bin/git', ['add', 'src/$n.dart']);
}