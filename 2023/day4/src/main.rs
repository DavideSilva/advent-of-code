#![allow(unused)]
#![allow(dead_code)]

use std::{collections::HashMap, env, fs};

use regex::Regex;
use std::collections::BTreeSet;

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    // dbg!(process_input(&contents, part1));
    dbg!(part2(&contents));
}

fn process_input<F>(input: &str, transform: F) -> u32
where
    F: Fn(&str) -> u32,
{
    input.trim().split('\n').map(transform).sum()
}

fn part2(input: &str) -> u32 {
    let numbers_regex = Regex::new(r"Card\s+(\d+): (.*?) \| (.*)").unwrap();
    let mut scratchcards: HashMap<u32, u32> = HashMap::new();

    for line in input.trim().lines() {
        for (_, [game, winning, elf]) in numbers_regex.captures_iter(line).map(|c| c.extract()) {
            let game_id = game.parse::<u32>().unwrap();

            let winning_set: BTreeSet<u32> = winning
                .split_whitespace()
                .map(|n| n.parse::<u32>().unwrap())
                .collect();
            let elf_set: BTreeSet<u32> = elf
                .split_whitespace()
                .map(|n| n.parse::<u32>().unwrap())
                .collect();

            let copies: u32 = winning_set
                .intersection(&elf_set)
                .count()
                .try_into()
                .unwrap();

            let card_copies = &scratchcards.get(&game_id).unwrap_or(&0).clone() + 1;

            scratchcards
                .entry(game_id)
                .and_modify(|value| *value += 1)
                .or_insert(card_copies);

            ((game_id + 1)..=(game_id + copies)).for_each(|c| {
                scratchcards
                    .entry(c)
                    .and_modify(|value| *value += card_copies)
                    .or_insert(card_copies);
            });
        }
    }
    scratchcards.values().sum()
}

fn part1(input: &str) -> u32 {
    let numbers_regex = Regex::new(r": (.*?) \| (.*)").unwrap();
    let mut score = 0;

    for (_, [winning, elf]) in numbers_regex.captures_iter(input).map(|c| c.extract()) {
        let winning_set: BTreeSet<u32> = winning
            .split_whitespace()
            .map(|n| n.parse::<u32>().unwrap())
            .collect();
        let elf_set: BTreeSet<u32> = elf
            .split_whitespace()
            .map(|n| n.parse::<u32>().unwrap())
            .collect();

        let points: u32 = winning_set
            .intersection(&elf_set)
            .count()
            .try_into()
            .unwrap();
        if points > 0 {
            score = 2_u32.pow(points.saturating_sub(1));
        }
    }
    score
}
