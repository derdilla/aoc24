fn main() {
    let inp = std::fs::read_to_string("/home/derdilla/Coding/aoc24/in/11.in").unwrap();
    let inp = inp.split(" ").map(|e| e.to_string());
    println!("{:?}", &inp);
    let x = String::from("2004");
    println!("{}", x[..(x.len() / 2)].trim_start_matches('0'));
    println!("{}", x[(x.len() / 2)..].trim_start_matches('0'));

    let mut inp: Vec<String> = inp.collect();
    for i in 0..75 {
        let mut next = Vec::new();
        println!("{}: {}", i, inp.len());
        for x in inp {
            if x == "0".to_string() {
                next.push("1".to_string())
            } else if x.len() % 2 == 0 {
                next.push(x[..(x.len() / 2)].trim_start_matches('0').to_string().to_string());
                next.push(x[(x.len() / 2)..].trim_start_matches('0').to_string().to_string());
            } else {
                next.push((x.parse::<u64>().unwrap() * 2024).to_string().to_string())
            }
        }
        inp = next;
        next = Vec::new();
    }
}
