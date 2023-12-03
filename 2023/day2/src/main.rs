use regex::Regex;
use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    dbg!(process_input(&contents, part1));
    dbg!(process_input(&contents, part2));
}

fn process_input<F>(input: &str, transform: F) -> u32
where
    F: Fn(&str) -> u32,
{
    input.trim().split('\n').map(transform).sum()
}

fn part1(input: &str) -> u32 {
    let game_regex = Regex::new(r"Game (\d+)").unwrap();
    let color_regex = Regex::new(r"(\d+) (red|green|blue)").unwrap();
    let mut game_id = 0;
    let mut possible = true;

    for (_, [number, color]) in color_regex.captures_iter(input).map(|c| c.extract()) {
        match (color, number.parse::<u32>().unwrap_or(0)) {
            ("red", number) if number > 12 => possible = false,
            ("green", number) if number > 13 => possible = false,
            ("blue", number) if number > 14 => possible = false,
            _ => {}
        }
    }

    if possible {
        let (_, [id]) = game_regex.captures(input).unwrap().extract();
        game_id = id.parse::<u32>().unwrap()
    }

    game_id
}

fn part2(input: &str) -> u32 {
    let color_regex = Regex::new(r"(\d+) (red|green|blue)").unwrap();
    let mut red_cubes = 0;
    let mut green_cubes = 0;
    let mut blue_cubes = 0;

    for (_, [number, color]) in color_regex.captures_iter(input).map(|c| c.extract()) {
        match (color, number.parse::<u32>().unwrap()) {
            ("red", n) if n > red_cubes => red_cubes = n,
            ("green", n) if n > green_cubes => green_cubes = n,
            ("blue", n) if n > blue_cubes => blue_cubes = n,
            _ => {}
        }
    }

    red_cubes * green_cubes * blue_cubes
}
