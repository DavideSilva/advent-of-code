use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something went wrong reading the file");

    let mut sums: Vec<u32> = contents
        .split("\n\n")
        .into_iter()
        .map(|elf| {
            elf.split_whitespace()
                .collect::<Vec<&str>>()
                .iter_mut()
                .map(|c| c.parse().unwrap())
                .collect::<Vec<u32>>()
                .iter()
                .sum()
        })
        .collect();

    println!("Part1: {:?}", sums.iter().max().unwrap());

    sums.sort();
    sums.reverse();

    println!("Part1: {:?}", sums.iter().take(3).sum::<u32>());

}
