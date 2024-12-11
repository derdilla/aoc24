use rayon::prelude::*;
use std::sync::Mutex;
use std::collections::HashMap;
use std::sync::Arc;

fn main() {
    let inp = std::fs::read_to_string("/home/derdilla/Coding/aoc24/in/11.in").unwrap();
    let inp = inp.split(" ").map(|e| e.to_string());
    println!("{:?}", &inp);
    let x = String::from("2004");
    println!("{}", x[..(x.len() / 2)].trim_start_matches('0'));
    println!("{}", x[(x.len() / 2)..].trim_start_matches('0'));


    let mut cache_50 = Mutex::new(HashMap::<String, usize>::new());
    //let mut cache_25 = Mutex::new(HashMap::new());
    let mut inp: Vec<String> = inp.collect();
    let mut len = 0;
    for a in &inp {
        let cache_50 = Arc::new(&cache_50);
        
        let mut vecA = vec![a.to_string()];
        
        for i in 0..25 {
            let mut next = Vec::new();
            println!("{}: {}", i, vecA.len());
            for x in vecA {
                if x == "0".to_string() {
                    next.push("1".to_string())
                } else if x.len() % 2 == 0 {
                    next.push(x[..(x.len() / 2)].trim_start_matches('0').to_string().to_string());
                    next.push(x[(x.len() / 2)..].trim_start_matches('0').to_string().to_string());
                } else {
                    next.push((x.parse::<u64>().unwrap() * 2024).to_string().to_string())
                }
            }
            vecA = next;
            next = Vec::new();
        }
        let sumA: usize = vecA.par_iter().map(move |b| {
            if let Some(sum) = cache_50.lock().unwrap().get(b) {
               return sum.clone();
            }
            let mut vecB = vec![b.to_string()];
            for i in 0..25 {
                let mut next = Vec::new();
                //println!("{}: {}", i, vecB.len());
                for x in vecB {
                    if x == "0".to_string() {
                        next.push("1".to_string())
                    } else if x.len() % 2 == 0 {
                        next.push(x[..(x.len() / 2)].trim_start_matches('0').to_string().to_string());
                        next.push(x[(x.len() / 2)..].trim_start_matches('0').to_string().to_string());
                    } else {
                        next.push((x.parse::<u64>().unwrap() * 2024).to_string().to_string())
                    }
                }
                vecB = next;
                next = Vec::new();
            }
            let mut sumB = 0;
            for c in &vecB {
                let mut vecC = vec![c.to_string()];
                for i in 0..25 {
                    let mut next = Vec::new();
                    //println!("{}: {}", i, vecC.len());
                    for x in &vecB {
                        if x.to_string() == "0".to_string() {
                            next.push("1".to_string())
                        } else if x.len() % 2 == 0 {
                            next.push(x[..(x.len() / 2)].trim_start_matches('0').to_string().to_string());
                            next.push(x[(x.len() / 2)..].trim_start_matches('0').to_string().to_string());
                        } else {
                            next.push((x.parse::<u64>().unwrap() * 2024).to_string().to_string())
                        }
                    }
                    vecC = next;
                    next = Vec::new();
                }
                sumB += vecC.len()
            }
            cache_50.lock().unwrap().insert(b.to_string(), sumB);
            println!("{}", sumB);
            sumB
        }).sum();
        len += sumA;
    }
    println!("{}", len);
}
