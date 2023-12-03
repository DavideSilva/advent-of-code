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
    let digits: Vec<char> = input.chars().filter(|c| c.is_ascii_digit()).collect();
    first_and_last(digits)
}

fn first_and_last(input: Vec<char>) -> u32 {
    format!("{}{}", input[0], input[&input.len() - 1])
        .parse::<u32>()
        .unwrap()
}

fn part2(input: &str) -> u32 {
    let subs = vec![
        ("oneight", "18"),
        ("twone", "21"),
        ("threeight", "38"),
        ("fiveight", "58"),
        ("sevenine", "79"),
        ("eightwo", "82"),
        ("eighthree", "83"),
        ("nineight", "98"),
        ("one", "1"),
        ("two", "2"),
        ("three", "3"),
        ("four", "4"),
        ("five", "5"),
        ("six", "6"),
        ("seven", "7"),
        ("eight", "8"),
        ("nine", "9"),
    ];

    let digits: Vec<char> = subs
        .iter()
        .fold(String::from(input), |out, (pattern, replacement)| {
            out.replace(pattern, replacement)
        })
        .chars()
        .filter(|c| c.is_ascii_digit())
        .collect();

    first_and_last(digits)
}
