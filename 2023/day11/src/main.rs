#![allow(unused)]
#![allow(dead_code)]

use itertools::Itertools;
use std::cmp;
use std::collections::BTreeSet;
use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");
    dbg!(p1(&contents));
    // dbg!(p2(&contents, 1000000));
}

fn p1(input: &str) -> usize {
    solve(input, 2)
}

fn p2(input: &str, expand: usize) -> usize {
    solve(input, expand)
}

fn solve(input: &str, expand: usize) -> usize {
    let ((x_max, y_max), galaxies) = parse(input);

    let empty_rows = (0..=y_max)
        .filter(|&y| (0..=x_max).all(|x| !galaxies.contains(&(x, y))))
        .collect::<BTreeSet<usize>>();

    let empty_cols = (0..=x_max)
        .filter(|&x| (0..=y_max).all(|y| !galaxies.contains(&(x, y))))
        .collect::<BTreeSet<usize>>();

    galaxies
        .into_iter()
        .combinations(2)
        .map(|v| {
            manhattan_dist(&v[0], &v[1])
                + expand_count(v[0].0, v[1].0, &empty_cols) * (expand - 1)
                + expand_count(v[0].1, v[1].1, &empty_rows) * (expand - 1)
        })
        .sum()
}

type Coord = (usize, usize);

fn manhattan_dist(c1: &Coord, c2: &Coord) -> usize {
    c1.0.abs_diff(c2.0) + c1.1.abs_diff(c2.1)
}

fn expand_count(a: usize, b: usize, empty: &BTreeSet<usize>) -> usize {
    (cmp::min(a, b)..cmp::max(a, b))
        .collect::<BTreeSet<_>>()
        .intersection(empty)
        .count()
}

fn parse(input: &str) -> (Coord, BTreeSet<Coord>) {
    let y_max = input.lines().count();
    let x_max = input.lines().map(|line| line.len()).max().unwrap();

    let galaxies = input
        .lines()
        .enumerate()
        .flat_map(|(y, line)| line.bytes().enumerate().map(move |(x, b)| ((x, y), b)))
        .filter_map(|(c, b)| if b == b'#' { Some(c) } else { None })
        .collect();
    ((x_max, y_max), galaxies)
}

/*
#[derive(Debug, Clone, PartialEq, Eq)]
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    let universe = expand_universe(
        contents
            .trim()
            .lines()
            .map(|l| l.to_string())
            .collect::<Vec<String>>()
            .to_owned(),
        2,
    );

    dbg!(part2(&contents));
}

fn expand_universe(mut input: Vec<String>, factor: u32) -> Vec<String> {
    input = input
        .iter()
        .flat_map(|line| {
            if !line.contains('#') {
                vec![line.clone(); factor as usize]
            } else {
                vec![line.clone()]
            }
        })
        .collect::<Vec<String>>();

    let mut result: Vec<String> = vec!["".to_string(); input.len()];

    (0..input[0].len()).for_each(|col| {
        match input.iter().any(|line| line.chars().nth(col) == Some('#')) {
            true => {
                for (i, line) in input.iter().enumerate() {
                    result[i].push(line.chars().nth(col).unwrap());
                }
            }
            false => {
                for (i, line) in input.iter().enumerate() {
                    for _ in 0..factor {
                        result[i].push(line.chars().nth(col).unwrap());
                    }
                }
            }
        }
    });

    result
}

fn galaxy_coordinates(universe: Vec<String>) -> Vec<Point> {
    let mut points: Vec<Point> = Vec::new();

    for (x, line) in universe.iter().enumerate() {
        for (y, c) in line.chars().enumerate() {
            if c == '#' {
                points.push(Point {
                    x: x.try_into().unwrap(),
                    y: y.try_into().unwrap(),
                });
            }
        }
    }

    points
}

fn all_pairs_from_points(points: Vec<Point>) -> Vec<(Point, Point)> {
    points
        .iter()
        .cloned()
        .combinations(2)
        .map(|pair| (pair[0].clone(), pair[1].clone()))
        .collect()
}

fn part1(input: &str) -> u32 {
    let universe = expand_universe(
        input
            .trim()
            .lines()
            .map(|l| l.to_string())
            .collect::<Vec<String>>()
            .to_owned(),
        2,
    );

    let coordinates = galaxy_coordinates(universe.clone());
    let all_pairs = all_pairs_from_points(coordinates.clone());

    all_pairs
        .iter()
        .map(|(p1, p2)| -> u32 { (p1.x - p2.x).unsigned_abs() + (p1.y - p2.y).unsigned_abs() })
        .collect::<Vec<u32>>()
        .iter()
        .sum()
}

fn part2(input: &str) -> u32 {
    let universe = expand_universe(
        input
            .trim()
            .lines()
            .map(|l| l.to_string())
            .collect::<Vec<String>>()
            .to_owned(),
        1000000,
    );

    let coordinates = galaxy_coordinates(universe.clone());
    let all_pairs = all_pairs_from_points(coordinates.clone());

    all_pairs
        .iter()
        .map(|(p1, p2)| -> u32 { (p1.x - p2.x).unsigned_abs() + (p1.y - p2.y).unsigned_abs() })
        .collect::<Vec<u32>>()
        .iter()
        .sum()
} */
