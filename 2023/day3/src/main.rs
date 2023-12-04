#![allow(unused)]

use regex::Regex;
use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    dbg!(part1(&contents));
    dbg!(part2(&contents));
}

fn part2(schematic: &str) -> u32 {
    let lines: Vec<&str> = schematic.lines().collect();
    let regex = Regex::new(r"([^0-9.])|(\d+)").unwrap();
    let mut symbols = vec![];
    let mut numbers = vec![];
    let mut ratio = 0;

    for (i, line) in lines.iter().enumerate() {
        for c in regex.find_iter(line) {
            match c.as_str() {
                "*" => symbols.push((i, c.start())),
                v if v.len() == 1 && !v.chars().next().unwrap().is_ascii_digit() => {}
                v => numbers.push((i, c.start(), c.end(), v.parse::<u32>().unwrap())),
            }
        }
    }

    for (line, col) in &symbols {
        let mut search_coords = vec![];
        (line.saturating_sub(1)..=line.saturating_add(1)).for_each(|i| {
            (col.saturating_sub(1)..=col.saturating_add(1)).for_each(|j| {
                search_coords.push((i, j));
            });
        });

        let filtered_numbers: Vec<_> = numbers
            .iter()
            .filter(|number| {
                let (line, start, end, value) = number;

                (*start..*end)
                    .collect::<Vec<usize>>()
                    .iter()
                    .any(|&x| search_coords.contains(&(*line, x)))
            })
            .collect();

        if filtered_numbers.len() == 2 {
            ratio += filtered_numbers
                .iter()
                .fold(1, |ratio, (_, _, _, number)| ratio * number);
        }
    }

    ratio
}

fn part1(schematic: &str) -> u32 {
    let lines: Vec<&str> = schematic.lines().collect();
    let regex = Regex::new(r"([^0-9.])|(\d+)").unwrap();
    let mut symbols = vec![];
    let mut numbers = vec![];

    for (i, line) in lines.iter().enumerate() {
        for c in regex.find_iter(line) {
            match c.as_str() {
                v if v.len() == 1 && !v.chars().next().unwrap().is_ascii_digit() => {
                    symbols.push((i, c.start()))
                }
                v => numbers.push((i, c.start(), c.end(), v.parse::<u32>().unwrap())),
            }
        }
    }

    let mut sum = 0;

    for (line, start, end, number) in &numbers {
        (line.saturating_sub(1)..=line.saturating_add(1)).for_each(|i| {
            (start.saturating_sub(1)..end.saturating_add(1)).for_each(|j| {
                if symbols.contains(&(i, j)) {
                    sum += number;
                }
            });
        });
    }
    sum
}
