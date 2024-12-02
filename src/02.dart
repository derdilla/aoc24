import 'dart:io';
import 'dart:math' as math;

bool isSafe(List<int> nums) {
  final bool increasing = (nums[1] > nums[0]);
  for (int i = 1; i < nums.length; i++) {
    //print('${nums[i-1]}, ${nums[i]}')
    if ((nums[i-1] - nums[i]).abs() < 1 || (nums[i-1] - nums[i]).abs() > 3) return false;
    if (increasing && (nums[i-1] > nums[i])) return false;
    if (!increasing && (nums[i-1] < nums[i])) return false;
  }

  return true;
}

void main() {
  final data = File("02.in").readAsStringSync();
  final lines = data.split("\n");
  final numLines = lines.map((String line) => line.split(" ").map((String e) => int.parse(e))); 
  print(numLines);

  int safeCount = 0;
  for (final line in numLines) {
    if (isSafe(line.toList())) {
      safeCount += 1;
      continue;
    }
    print(line);
    for (int i = 0; i < line.length; i++) {
      final l = line.toList();
      l.removeAt(i);
      print(l);
      if (isSafe(l)) {
        safeCount += 1;
        i = 9999;
        continue;
      }
    }
    print('x');
  } 

  print(safeCount);
}