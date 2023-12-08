#![allow(unused)]
#![allow(dead_code)]

use num::integer::lcm;
use regex::Regex;
use std::{collections::HashMap, env, fs};

#[derive(Debug)]
struct Map {
    instructions: Vec<String>,
    nodes: HashMap<String, (String, String)>,
}

impl Map {
    fn from(input: &str) -> Self {
        let re = Regex::new(r"(.*) = \((.*), (.*)\)").unwrap();
        let split: Vec<_> = input.split("\n\n").collect();
        let mut nodes: HashMap<String, (String, String)> = HashMap::new();

        split.last().unwrap().split('\n').for_each(|line| {
            let (_, [node, left, right]) = re.captures(line).unwrap().extract();
            nodes.insert(node.to_owned(), (left.to_owned(), right.to_owned()));
        });

        Map {
            instructions: split
                .first()
                .unwrap()
                .chars()
                .map(|i| i.to_string())
                .collect::<Vec<String>>(),
            nodes,
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");
    let map = Map::from(contents.trim());

    dbg!(part1(&map));
    dbg!(part2(&map));
}

fn part1(map: &Map) -> u32 {
    let mut i = 0;
    let mut current_node = "AAA";

    while current_node != "ZZZ" {
        let (l, r) = map.nodes.get(current_node).unwrap();
        let ins = i % map.instructions.len();

        current_node = match map.instructions[ins].as_str() {
            "R" => r,
            "L" => l,
            _ => panic!("invalid instruction"),
        };

        i += 1;
    }

    i.try_into().unwrap()
}

fn part2(map: &Map) -> usize {
    let mut travels = Vec::new();

    for node in map.nodes.keys().filter(|k| k.ends_with('A')) {
        let mut current_node = node;
        let mut i = 0;

        while !current_node.ends_with('Z') {
            let (l, r) = map.nodes.get(current_node).unwrap();
            let ins = i % map.instructions.len();

            current_node = match map.instructions[ins].as_str() {
                "R" => r,
                "L" => l,
                _ => panic!("invalid instruction"),
            };

            i += 1;
        }

        travels.push(i);
    }

    let out = *travels.first().unwrap();
    travels.iter().fold(out, |acc, &t| lcm(acc, t))
}
