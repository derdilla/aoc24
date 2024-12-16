import '../aoc_solver.dart';
import 'dart:math' as math;

void main(List<String> _args) {
  final solver = A15()
    ..ignoreTests = false
    ..doLogging = true;
  solver.main();
}

class A15 extends AOCSolver<(Warehouse, List<(int,int)>)> {
  @override
  String get day => '15';

  @override
  (Warehouse, List<(int,int)>) parse(String input) {
    final rawMap = input.split('\n\n')[0];
    final mapLines = rawMap.split('\n');
    final map = <List<Item>>[];
    log(mapLines);
    (int, int)? roboPos;
    for (int i = 0; i < mapLines.length; i++) {
      final row = mapLines[i];
      final line = <Item>[];
      for (int j = 0; j < row.length; j++) {
        final e = row[j];
        // log('$i, $j: $e');
        //if(e == '' || e == ' ' || e == '\n') continue;
        Item? item;
        switch(e) {
          case '#': 
            item = Item.Wall;
          case 'O':
            item = Item.Box;
          case '.':
            item = Item.Empty;
          case '@':
            roboPos = (i,j);
            item = Item.Empty;
          default:
           print('WORONG DATA: $e');
        };
        line.add(item!);
      }
      map.add(line);
    }
    final warehouse = Warehouse(map, roboPos!);

    final rawMoves = input.split('\n\n')[1].split('\n').join('');
    final dirs = rawMoves.split('').map((e) => switch(e) {
      '^' => (-1,0),
      'v' => (1,0),
      '>' => (0,1),
      '<' => (0,-1),
      _ => throw UnimplementedError(),
    }).toList();

    return (warehouse, dirs);
  }

  @override
  String computeA((Warehouse, List<(int,int)>) input) {
    final warehouse = input.$1;
    final moves = input.$2;

    for (final m in moves) {
      log(m);
      log(warehouse.roboPos);
      warehouse.moveRobo(m);
    }

    int coordSum = 0;
    for (int i = 0; i < warehouse.map.length; i++) {
      for (int j = 0; j < warehouse.map[i].length; j++) {
        if (warehouse.map[i][j] == Item.Box) {
          coordSum += 100 * i + j;
        }
      }
    }
    
    return coordSum.toString();
  }

  @override
  String computeB((Warehouse, List<(int,int)>) input) {
    final warehouse = input.$1;
    warehouse.convertToBig();
    final moves = input.$2;

    for (final m in moves) {
      warehouse.moveRoboBig(m);
      log(m);
      printWarehouse(warehouse);
    }

    int coordSum = 0;
    for (int i = 0; i < warehouse.map.length; i++) {
      for (int j = 0; j < warehouse.map[i].length; j++) {
        if (warehouse.map[i][j] == Item.BigBoxL) {
          final horizDist = math.min(j, warehouse.map[i].length - j);
          final topDist = math.min(i, warehouse.map.length - i);
          coordSum += horizDist * 100 + topDist;
        }
      }
    }
    
    return coordSum.toString();
  }

  void printWarehouse(Warehouse warehouse) {
    for(int i = 0; i < warehouse.map.length; i++) {
      String s = '';
      for (int j = 0; j < warehouse.map[i].length; j++) {
        if(i == warehouse.roboPos.$1 && j == warehouse.roboPos.$2) {
          s += '@';
          continue;
        }
        s += switch(warehouse.map[i][j]) {
          Item.Empty => '.',
          Item.Wall => '#',
          Item.Box => 'O',
          Item.BigBoxL => '[',
          Item.BigBoxR => ']',
        };
      }
      print(s);
    }
  }
}

class Warehouse {
  Warehouse(this.map, this.roboPos);

  List<List<Item>> map;
  (int, int) roboPos;

  void moveRobo((int,int) dir) {
    if(_move(roboPos, dir)) {
      roboPos = (roboPos.$1 + dir.$1, roboPos.$2 + dir.$2);
    }
  }

  void moveRoboBig((int,int) dir) {
    if(_moveWithBigBoxes(roboPos, dir)) {
      roboPos = (roboPos.$1 + dir.$1, roboPos.$2 + dir.$2);
    }
  }

  void convertToBig() {
    roboPos = (roboPos.$1, roboPos.$2 * 2);
    final newMap = <List<Item>>[];
    for (final r in map) {
      final newRow = <Item>[];
      for (final i in r) {
        switch(i) {
          case Item.Box:
            newRow.add(Item.BigBoxL);
            newRow.add(Item.BigBoxR);
          case Item.Wall:
            newRow.add(Item.Wall);
            newRow.add(Item.Wall);
          case Item.Empty:
            newRow.add(Item.Empty);
            newRow.add(Item.Empty);
          case Item.BigBoxL:
          case Item.BigBoxR:
            print('WTF???');
        }
      }
      newMap.add(newRow);
    }
    map = newMap;
  }

  bool _move((int,int) pos, (int,int) dir) {
    final bool canMove = switch(map[dir.$1 + pos.$1][pos.$2 + dir.$2]) {
      Item.Wall => false,
      Item.Box => _move((pos.$1 + dir.$1, pos.$2 + dir.$2), dir),
      Item.Empty => true,
      Item.BigBoxL || Item.BigBoxR => throw AssertionError('Wrong algorithm'),
    };

    if(canMove && map[pos.$1][pos.$2] == Item.Box) {
      map[dir.$1 + pos.$1][pos.$2 + dir.$2] = map[pos.$1][pos.$2];
      map[pos.$1][pos.$2] = Item.Empty;
    }

    return canMove;
  }

  bool _checkMovePossible((int,int) pos, (int,int) dir) => switch(map[dir.$1 + pos.$1][pos.$2 + dir.$2]) {
    Item.Wall => false,
    Item.Box =>  throw AssertionError('Wrong algorithm'),
    Item.Empty => true,
    Item.BigBoxL => (dir.$1 == 0) 
      ? _checkMovePossible((pos.$1, pos.$2 + dir.$2), dir) // horizontal
      : _checkMovePossible((pos.$1 + dir.$1, pos.$2 + 1), dir) && _checkMovePossible((pos.$1 + dir.$1, pos.$2 + dir.$2), dir), // vertical
    Item.BigBoxR => (dir.$1 == 0) 
      ? _checkMovePossible((pos.$1, pos.$2 + dir.$2), dir) // horizontal
      : _checkMovePossible((pos.$1 + dir.$1, pos.$2 - 1), dir) && _checkMovePossible((pos.$1 + dir.$1, pos.$2 + dir.$2), dir), // vertical
  };

  bool _moveWithBigBoxes((int,int) pos, (int,int) dir, [bool calledFromBlock = false]) {
    // caling this always only moves the current column / row forwards 
    // and updates to connected boxes only happen through recursion.
    if(!_checkMovePossible(pos, dir)) return false;
    
    if (map[pos.$1][pos.$2] == Item.Empty) return true;

    if(!calledFromBlock && map[pos.$1][pos.$2] == Item.BigBoxL && (dir.$2 == 0)) {
      _moveWithBigBoxes((pos.$1, pos.$2 + 1), dir, true);
    }
    if(!calledFromBlock && map[pos.$1][pos.$2] == Item.BigBoxR && (dir.$2 == 0)) {
      _moveWithBigBoxes((pos.$1, pos.$2 - 1), dir, true);
    }
    _moveWithBigBoxes((dir.$1 + pos.$1, pos.$2 + dir.$2), dir);
    if(map[pos.$1][pos.$2] == Item.BigBoxL || map[pos.$1][pos.$2] == Item.BigBoxR) {
      map[dir.$1 + pos.$1][pos.$2 + dir.$2] = map[pos.$1][pos.$2];
      map[pos.$1][pos.$2] = Item.Empty;
    }

    return true;
  }
}

enum Item {
  Box,
  Wall,
  Empty,
  BigBoxL,
  BigBoxR,
}
