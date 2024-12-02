import 'dart:io';
import 'dart:math';

int diffSum(List<int> a, List<int> b) {
    a.sort(); b.sort();
    assert(a.length == b.length);

    int sum = 0;
    for (int i = 0; i<a.length; i++) {
        sum += max(a[i], b[i]) - min(a[i], b[i]);
        print('a: ${a[i]}, b: ${b[i]}, max: ${max(a[i], b[i])}');
    }

    return sum;
}

int part2(List<int> la, List<int> lb) {
    int sum = 0;
    for (int a in la) {
        sum += a * lb.where((b) => b==a).length;
    }
    return sum;
}

void main() {
    final data = File("01.in").readAsStringSync();
    
    List<int> a = [];
    List<int> b = [];
    for (final line in data.split("\n")) {
        final parts = line.split('   ');
        assert(parts.length == 2);
        print(parts);
        a.add(int.parse(parts[0]));
        b.add(int.parse(parts[1]));
    }

    //print(diffSum(a,b));
    print(part2(a,b));
}