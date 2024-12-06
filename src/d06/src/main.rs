use std::{collections::HashSet, fs};

// solving of 06/b too slow in dart

fn main() {
    let input = fs::read_to_string("/home/derdilla/Coding/aoc24/in/06.in").unwrap();


    let mut obstacles: Vec<(usize, usize)> = Vec::new();
    let mut guard_pos: (usize, usize) = (0,0);
    let mut facing = Dir::up;

    let lines: Vec<Vec<String>> = input.lines().map(|e| e.split("").map(|e| e.to_string()).collect::<Vec<String>>()).collect();

    for x in 0..lines.first().unwrap().len() {
      for y in 0..lines.len() {
        match lines.get(y).unwrap().get(x).unwrap().as_str()  {
            "#" => obstacles.push((x,y)),
            "^" => guard_pos = (x,y),
            _ => {}
        }
      }
    }
    let obstacles = obstacles;

    let max_x = lines.first().unwrap().len();
    let max_y = lines.len();

    let mut path = Vec::new();
    let mut possible_spots = HashSet::new();

    let mut i = 0;
    while guard_pos.0 < max_x
      && guard_pos.1 < max_y {
      //println!("{} {:?} {:?}", i, &guard_pos, &facing);
      i += 1;

      path.push((guard_pos.0, guard_pos.1, facing.clone()));
      match facing {
        Dir::up => {
          if obstacles.contains(&(guard_pos.0, guard_pos.1 - 1)) {
            facing = Dir::right;
          } else if guard_pos.1 == 0 {
            break;
          } else {
            if gets_stuck(&obstacles, guard_pos, facing.clone(), max_x, max_y, (guard_pos.0, guard_pos.1 - 1)) {
              possible_spots.insert((guard_pos.0, guard_pos.1 - 1));
            }

            guard_pos = (guard_pos.0, guard_pos.1 - 1)
          }
        },
        Dir::left => {
          if obstacles.contains(&(guard_pos.0 -1 , guard_pos.1)) {
            facing = Dir::up;
          } else if guard_pos.0 == 0 {
            break;
          } else {
            if gets_stuck(&obstacles, guard_pos, facing.clone(), max_x, max_y, (guard_pos.0 - 1, guard_pos.1)) {
              possible_spots.insert((guard_pos.0 - 1, guard_pos.1));
            }
            guard_pos = (guard_pos.0 - 1, guard_pos.1)
          }
        },
        Dir::right => {
          if obstacles.contains(&(guard_pos.0 + 1, guard_pos.1)) {
            facing = Dir::down;
          } else if guard_pos.0 == max_x - 1 {
            break;
          }else {
            if gets_stuck(&obstacles, guard_pos, facing.clone(), max_x, max_y, (guard_pos.0 + 1, guard_pos.1)) {
              possible_spots.insert((guard_pos.0 + 1, guard_pos.1));
            }
            guard_pos = (guard_pos.0 + 1, guard_pos.1)
          }
        },
        Dir::down => {
          if obstacles.contains(&(guard_pos.0, guard_pos.1 + 1)) {
            facing = Dir::left;
          } else if guard_pos.0 == max_x - 1 {
            break;
          } else {
            if gets_stuck(&obstacles, guard_pos, facing.clone(), max_x, max_y, (guard_pos.0, guard_pos.1 + 1)) {
              possible_spots.insert((guard_pos.0, guard_pos.1 + 1));
            }
            guard_pos = (guard_pos.0, guard_pos.1 + 1)
          }
        },
      }
    }

    println!("{}", possible_spots.len() - 50); // Not at guard starting pos, counted from file
}

fn gets_stuck(obstacles: &Vec<(usize, usize)>, mut guard_pos: (usize, usize), mut facing: Dir, max_x: usize, max_y: usize, extra_obstacle: (usize, usize)) -> bool {
  let mut path = Vec::new();
  while guard_pos.0 < max_x
    && guard_pos.1 < max_y {
    if path.contains(&(guard_pos.0, guard_pos.1, facing.clone())) {
      return true;
    }

    path.push((guard_pos.0, guard_pos.1, facing.clone()));
    match facing {
      Dir::up => {
        if obstacles.contains(&(guard_pos.0, guard_pos.1 - 1)) || extra_obstacle == (guard_pos.0, guard_pos.1 - 1) {
          facing = Dir::right;
        } else if guard_pos.1 == 0 {
          return false;
        } else {
          guard_pos = (guard_pos.0, guard_pos.1 - 1)
        }
      },
      Dir::left => {
        if obstacles.contains(&(guard_pos.0 -1 , guard_pos.1)) || extra_obstacle == (guard_pos.0 -1 , guard_pos.1) {
          facing = Dir::up;
        } else if guard_pos.0 == 0 {
          return false;
        }  else {
          guard_pos = (guard_pos.0 - 1, guard_pos.1)
        }
      },
      Dir::right => {
        if obstacles.contains(&(guard_pos.0 + 1, guard_pos.1)) || extra_obstacle == (guard_pos.0 + 1, guard_pos.1) {
          facing = Dir::down;
        } else {
          guard_pos = (guard_pos.0 + 1, guard_pos.1)
        }
      },
      Dir::down => {
        if obstacles.contains(&(guard_pos.0, guard_pos.1 + 1)) || extra_obstacle == (guard_pos.0, guard_pos.1 + 1) {
          facing = Dir::left;
        } else {
          guard_pos = (guard_pos.0, guard_pos.1 + 1)
        }
      },
    }
  }

  false
}

#[derive(PartialEq, Debug, Clone)]
enum Dir {
    up,
    left,
    right,
    down,
}
