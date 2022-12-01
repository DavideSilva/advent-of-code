use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something went wrong reading the file");

    let crabs: Vec<i32> = contents
        .trim()
        .split(",")
        .map(|i| i.parse().unwrap())
        .collect();

    println!("{:?}", part1(&crabs));
    println!("{:?}", part2(&crabs));
}

fn part1(crabs: &Vec<i32>) -> i32 {
    let min: i32 = *crabs.iter().min().unwrap();
    let max: i32 = *crabs.iter().max().unwrap();

    let fuel = *(min..max)
        .collect::<Vec<i32>>()
        .iter()
        .map(|i| {
            let c: i32 = crabs
                .iter()
                .map(|c| (i - c).abs())
                .collect::<Vec<i32>>()
                .into_iter()
                .sum();
            c
        })
        .collect::<Vec<i32>>()
        .iter()
        .min()
        .unwrap();

    fuel
}

fn part2(crabs: &Vec<i32>) -> i32 {
    let min: i32 = *crabs.iter().min().unwrap();
    let max: i32 = *crabs.iter().max().unwrap();

    let fuel = *(min..max)
        .collect::<Vec<i32>>()
        .iter()
        .map(|i| {
            let c = crabs
                .iter()
                .map(|c| {
                    let d = (i - c).abs();
                    d * (d + 1) / 2
                })
                .collect::<Vec<i32>>()
                .into_iter()
                .sum::<i32>();
            c
        })
        .collect::<Vec<i32>>()
        .iter()
        .min()
        .unwrap();

    fuel
}
