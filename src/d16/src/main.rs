fn main() {
    println!("Hello, world!");
}

struct HorseRace {
    running: Vec<Horse>,
    finished: Vec<Horse>,
    min_score: u64,
    goal: (u32, u32), 
}

impl HorseRace {
    pub fn new(input: String) -> Self {
        let walls = input.lines().map(|line| line.split("").map(|c| switch(c){
            "#" => true,
        _   => false
        }));
        
    }
}

#[derive(PartialEq)]
struct Horse {
    x: u32,
    y: u32,
    score: u64,
}