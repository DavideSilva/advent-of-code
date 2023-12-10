#![allow(unused)]

use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    dbg!(process_input(&contents, part1));
    dbg!(process_input(&contents, part2));
}

fn process_input<F>(input: &str, transform: F) -> i64
where
    F: Fn(&str) -> i64,
{
    input.trim().lines().map(transform).sum()
}

fn calculate_differences(input: &str) -> Vec<Vec<i64>> {
    let history: Vec<i64> = input
        .split_whitespace()
        .map(|v| v.parse::<i64>().unwrap())
        .collect();

    let mut differences = vec![history.clone()];

    while let Some(last_diffs) = differences.last().cloned() {
        let diffs: Vec<i64> = last_diffs.windows(2).map(|w| w[1] - w[0]).collect();

        if diffs.iter().all(|&d| d == 0) {
            break;
        }

        differences.push(diffs);
    }

    differences
}

fn part1(input: &str) -> i64 {
    calculate_differences(input)
        .iter()
        .flat_map(|d| d.last().cloned())
        .sum()
}

fn part2(input: &str) -> i64 {
    calculate_differences(input)
        .iter()
        .rev()
        .fold(0, |mut acc, d| d.first().unwrap() - acc)
}
