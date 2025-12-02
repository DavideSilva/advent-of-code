use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    let records = process_input(&contents);

    dbg!(records);
}

#[derive(Debug)]
struct Record {
    springs: Vec<char>,
    condition: Vec<u32>,
}

fn split_line(line: &str) -> Record {
    let mut parts = line.split_whitespace();

    let springs = parts.next().unwrap().chars().collect();
    let condition = parts
        .next()
        .unwrap()
        .split(',')
        .map(|g| g.parse().unwrap())
        .collect();

    Record { springs, condition }
}

fn process_input(input: &str) -> Vec<Record> {
    input.lines().map(&split_line).collect()
}

fn part1(records: Vec<Record>) {}
