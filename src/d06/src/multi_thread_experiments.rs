use std::{collections::HashSet, fs, sync::{mpsc, Arc, Mutex}, thread};

// solving of 06/b too slow in dart

static NUM_WORKERS: u8 = 6; 

fn main() {
    // parse input
    let input = fs::read_to_string("/home/derdilla/Coding/aoc24/in/06.in").unwrap();

    let mut obstacles: Vec<(usize, usize)> = Vec::new();
    let mut guard_pos: (usize, usize) = (0,0);
    let mut facing = Dir::Up;

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
    let obstacles: Vec<(usize, usize)> = obstacles;
    let initial_guard_pos = guard_pos;
    let initial_facing = facing.clone();

    let max_x = lines.first().unwrap().len();
    let max_y = lines.len();

    println!("Inputs:\n\tguard_pos: {:?}\n\tmax_x: {}\n\tmax_y: {}", &guard_pos, max_x, max_y);

    // setup multithreading
    let (task_sender, task_receiver) = mpsc::channel::<Box<dyn FnOnce() -> Option<(usize, usize)> + Send>>();
    let task_receiver = Arc::new(Mutex::new(task_receiver));
    let results = Arc::new(Mutex::new(Vec::new()));
    let mut handles = vec![];
    for i in 0..NUM_WORKERS {
        let task_receiver = Arc::clone(&task_receiver);
        let results = Arc::clone(&results);
        let handle = thread::spawn(move || {
            while let Ok(task) = task_receiver.lock().unwrap().recv() {
                results.lock().unwrap().push(task());
            }
        });
        handles.push(handle);
    }

    // compute possible placements
    while guard_pos.0 < max_x
      && guard_pos.1 < max_y {
      if let Some(next_pos) = facing.step(guard_pos) {
        if obstacles.contains(&next_pos) {
          facing = facing.next();
        } else {
          let initial_facing = initial_facing;
          let obstacles = obstacles.clone();
          let initial_guard_pos = initial_guard_pos;
          let task = move || {
            if gets_stuck(&obstacles, initial_guard_pos, initial_facing, max_x, max_y, next_pos) {
              return Some(next_pos);
            }
            None
          };
          task_sender.send(Box::new(task)).unwrap();
          
          guard_pos = next_pos;
        }
      } else {
        break; // reached map end top/left
      }
    }

    // wait for workers to finish
    drop(task_sender);
    for handle in handles {
        handle.join().unwrap();
    }

    let mut total = 0;
    for _ in results.lock().unwrap().iter().filter(|e| e.is_some()) {
      total += 1;
    }
    println!("{}", total);
}

fn gets_stuck(obstacles: &Vec<(usize, usize)>, mut guard_pos: (usize, usize), mut facing: Dir, max_x: usize, max_y: usize, extra_obstacle: (usize, usize)) -> bool {
  if obstacles.contains(&extra_obstacle) {
    return false;
  }
  
  let mut path = Vec::new();
  while guard_pos.0 < max_x
    && guard_pos.1 < max_y {
    if path.contains(&(guard_pos.0, guard_pos.1, facing.clone())) {
      return true;
    }

    path.push((guard_pos.0, guard_pos.1, facing.clone()));
    match facing {
      Dir::Up => {
        if obstacles.contains(&(guard_pos.0, guard_pos.1 - 1)) || extra_obstacle == (guard_pos.0, guard_pos.1 - 1) {
          facing = Dir::Right;
        } else if guard_pos.1 == 0 {
          return false;
        } else {
          guard_pos = (guard_pos.0, guard_pos.1 - 1)
        }
      },
      Dir::Left => {
        if obstacles.contains(&(guard_pos.0 -1 , guard_pos.1)) || extra_obstacle == (guard_pos.0 -1 , guard_pos.1) {
          facing = Dir::Up;
        } else if guard_pos.0 == 0 {
          return false;
        }  else {
          guard_pos = (guard_pos.0 - 1, guard_pos.1)
        }
      },
      Dir::Right => {
        if obstacles.contains(&(guard_pos.0 + 1, guard_pos.1)) || extra_obstacle == (guard_pos.0 + 1, guard_pos.1) {
          facing = Dir::Down;
        } else {
          guard_pos = (guard_pos.0 + 1, guard_pos.1)
        }
      },
      Dir::Down => {
        if obstacles.contains(&(guard_pos.0, guard_pos.1 + 1)) || extra_obstacle == (guard_pos.0, guard_pos.1 + 1) {
          facing = Dir::Left;
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
    Up,
    Left,
    Right,
    Down,
}

impl Dir {
    pub fn next(&self) -> Dir {
      match self {
        Dir::Up => Dir::Right,
        Dir::Left => Dir::Up,
        Dir::Right => Dir::Down,
        Dir::Down => Dir::Left,
      }
    }

    pub fn step(&self, old: (usize, usize)) -> Option<(usize, usize)> {
      if (matches!(self, Dir::Left) && old.0 == 0)
      || (matches!(self, Dir::Up) && old.1 == 0) {
        return None;
      }

      match self {
        Dir::Up => Some((old.0, old.1 - 1)),
        Dir::Left => Some((old.0 -1 , old.1)),
        Dir::Right => Some((old.0 + 1, old.1)),
        Dir::Down => Some((old.0, old.1 + 1)),
      }
    }
}

// ----------------

use std::{collections::HashSet, fs};

// solving of 06/b too slow in dart

fn main() {
    // parse input
    let input = fs::read_to_string("/home/derdilla/Coding/aoc24/in/06.in").unwrap();

    let mut obstacles: Vec<(usize, usize)> = Vec::new();
    let mut guard_pos: (usize, usize) = (0,0);
    let mut facing = Dir::Up;

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
    let obstacles: Vec<(usize, usize)> = obstacles;
    let initial_guard_pos = guard_pos;
    let initial_facing = facing.clone();

    let max_x = lines.first().unwrap().len();
    let max_y = lines.len();

    println!("Inputs:\n\tguard_pos: {:?}\n\tmax_x: {}\n\tmax_y: {}", &guard_pos, max_x, max_y);

    // compute possible placements
    let mut possible_spots = Vec::new();
    while guard_pos.0 < max_x
      && guard_pos.1 < max_y {
      if let Some(next_pos) = facing.step(guard_pos) {
        if obstacles.contains(&next_pos) {
          facing = facing.next();
        } else {
          if gets_stuck(&obstacles, initial_guard_pos, initial_facing.clone(), max_x, max_y, next_pos) {
            possible_spots.push(next_pos); 
          }
          guard_pos = next_pos;
        }
      } else {
        break; // reached map end top/left
      }
    }

    println!("{}", possible_spots.len());
}

fn gets_stuck(obstacles: &Vec<(usize, usize)>, mut guard_pos: (usize, usize), mut facing: Dir, max_x: usize, max_y: usize, extra_obstacle: (usize, usize)) -> bool {
  if obstacles.contains(&extra_obstacle) {
    return false;
  }
  
  let mut path = Vec::new();
  while guard_pos.0 < max_x
    && guard_pos.1 < max_y {
    if path.contains(&(guard_pos.0, guard_pos.1, facing.clone())) {
      return true;
    }

    path.push((guard_pos.0, guard_pos.1, facing.clone()));
    match facing {
      Dir::Up => {
        if obstacles.contains(&(guard_pos.0, guard_pos.1 - 1)) || extra_obstacle == (guard_pos.0, guard_pos.1 - 1) {
          facing = Dir::Right;
        } else if guard_pos.1 == 0 {
          return false;
        } else {
          guard_pos = (guard_pos.0, guard_pos.1 - 1)
        }
      },
      Dir::Left => {
        if obstacles.contains(&(guard_pos.0 -1 , guard_pos.1)) || extra_obstacle == (guard_pos.0 -1 , guard_pos.1) {
          facing = Dir::Up;
        } else if guard_pos.0 == 0 {
          return false;
        }  else {
          guard_pos = (guard_pos.0 - 1, guard_pos.1)
        }
      },
      Dir::Right => {
        if obstacles.contains(&(guard_pos.0 + 1, guard_pos.1)) || extra_obstacle == (guard_pos.0 + 1, guard_pos.1) {
          facing = Dir::Down;
        } else {
          guard_pos = (guard_pos.0 + 1, guard_pos.1)
        }
      },
      Dir::Down => {
        if obstacles.contains(&(guard_pos.0, guard_pos.1 + 1)) || extra_obstacle == (guard_pos.0, guard_pos.1 + 1) {
          facing = Dir::Left;
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
    Up,
    Left,
    Right,
    Down,
}

impl Dir {
    pub fn next(&self) -> Dir {
      match self {
        Dir::Up => Dir::Right,
        Dir::Left => Dir::Up,
        Dir::Right => Dir::Down,
        Dir::Down => Dir::Left,
      }
    }

    pub fn step(&self, old: (usize, usize)) -> Option<(usize, usize)> {
      if (matches!(self, Dir::Left) && old.0 == 0)
      || (matches!(self, Dir::Up) && old.1 == 0) {
        return None;
      }

      match self {
        Dir::Up => Some((old.0, old.1 - 1)),
        Dir::Left => Some((old.0 -1 , old.1)),
        Dir::Right => Some((old.0 + 1, old.1)),
        Dir::Down => Some((old.0, old.1 + 1)),
      }
    }
}
