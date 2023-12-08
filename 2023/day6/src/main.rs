use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    dbg!(part1(&contents));
    dbg!(part2(&contents));
}

fn part1(sheet: &str) -> u32 {
    let times_and_distances: Vec<Vec<u32>> = sheet
        .lines()
        .map(|line| {
            line.split_once(':')
                .unwrap()
                .1
                .split_whitespace()
                .map(|v| v.parse().unwrap())
                .collect()
        })
        .collect();

    times_and_distances[0]
        .iter()
        .zip(times_and_distances[1].iter())
        .collect::<Vec<_>>()
        .iter()
        .map(|(&t, &r)| {
            let mut wins = 0;
            for speed in 1..t {
                let distance = speed * (t - speed);
                if distance > r {
                    wins += 1;
                }
            }
            wins
        })
        .product()
}

fn part2(sheet: &str) -> u64 {
    let times_and_distances: Vec<u64> = sheet
        .lines()
        .map(|line| {
            line.split_once(':')
                .unwrap()
                .1
                .replace(' ', "")
                .parse()
                .unwrap()
        })
        .collect();

    let time = &times_and_distances[0];
    let record = &times_and_distances[1];

    let mut wins = 0;
    for speed in 1..*time {
        let distance = speed * (time - speed);
        if distance > *record {
            wins += 1;
        }
    }
    wins
}
