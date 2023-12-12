#![allow(unused)]

use std::{env, fs};

#[derive(Debug)]
struct Tile {
    pipe: String,
    distance: u8,
}

#[derive(Debug)]
struct Grid {
    grid: Vec<Vec<Tile>>,
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    let grid = parse_contents(&contents);

    let mut start_pos = (0, 0);
    for (i, row) in grid.iter().enumerate() {
        if let Some(j) = row.iter().position(|&start| start == 'S') {
            start_pos = (i, j);
            break;
        }
    }

    dbg!(part2(grid, start_pos));
    // dbg!(process_input(&contents, part2));
}

fn parse_contents(input: &str) -> Vec<Vec<char>> {
    input.lines().map(|line| line.chars().collect()).collect()
}

#[derive(Debug, PartialEq)]
enum Direction {
    North,
    South,
    East,
    West,
}

fn pipe_loop(grid: &str, start_pos: (usize, usize)) -> Vec<(u32, u32)> {
    let mut coords = vec![];
    coords.push(start_pos);

    let (i, j) = start_pos;
    let direction = Direction::East;
    let current_node = 'Z';
    let current_pos = start_pos;

    while (current_node != 'S') {
        current_pos = match direction {
            Direction::West => (current_pos.0, current_pos.1 - 1),
            Direction::East => (current_pos.0, current_pos.1 + 1),
            Direction::North => (current_pos.0 - 1, current_pos.1),
            Direction::South => (current_pos.0 + 1, current_pos.1),
        };

        direction = match grid[i][j] {
            '-' => {
                if direction == Direction::West {
                    Direction::West
                } else {
                    Direction::East
                }
            }
            '|' => {
                if direction == Direction::South {
                    Direction::South
                } else {
                    Direction::North
                }
            }
            'F' => {
                if direction == Direction::North {
                    Direction::East
                } else {
                    Direction::South
                }
            }
            '7' => {
                if direction == Direction::East {
                    Direction::South
                } else {
                    Direction::West
                }
            }
            'J' => {
                if direction == Direction::East {
                    Direction::North
                } else {
                    Direction::West
                }
            }
            'L' => {
                if direction == Direction::South {
                    Direction::East
                } else {
                    Direction::North
                }
            }
            _ => direction,
        };
    }
}

fn part1(grid: Vec<Vec<char>>, start_pos: (usize, usize)) {
    let mut steps = 0;
    let mut current_node = 'Z';
    let mut direction = Direction::East;
    let mut current_pos = start_pos;

    while current_node != 'S' {
        current_pos = match direction {
            Direction::West => (current_pos.0, current_pos.1 - 1),
            Direction::East => (current_pos.0, current_pos.1 + 1),
            Direction::North => (current_pos.0 - 1, current_pos.1),
            Direction::South => (current_pos.0 + 1, current_pos.1),
        };

        current_node = grid[current_pos.0][current_pos.1];

        direction = match current_node {
            '-' => {
                if direction == Direction::West {
                    Direction::West
                } else {
                    Direction::East
                }
            }
            '|' => {
                if direction == Direction::South {
                    Direction::South
                } else {
                    Direction::North
                }
            }
            'F' => {
                if direction == Direction::North {
                    Direction::East
                } else {
                    Direction::South
                }
            }
            '7' => {
                if direction == Direction::East {
                    Direction::South
                } else {
                    Direction::West
                }
            }
            'J' => {
                if direction == Direction::East {
                    Direction::North
                } else {
                    Direction::West
                }
            }
            'L' => {
                if direction == Direction::South {
                    Direction::East
                } else {
                    Direction::North
                }
            }
            _ => direction,
        };

        steps += 1;
    }

    dbg!(steps / 2);
}

fn part2(mut grid: Vec<Vec<char>>, start_pos: (usize, usize)) {
    let mut current_node = 'Z';
    let mut direction = Direction::East;
    let mut current_pos = start_pos;

    while current_node != 'S' {
        current_pos = match direction {
            Direction::West => (current_pos.0, current_pos.1 - 1),
            Direction::East => (current_pos.0, current_pos.1 + 1),
            Direction::North => (current_pos.0 - 1, current_pos.1),
            Direction::South => (current_pos.0 + 1, current_pos.1),
        };

        current_node = grid[current_pos.0][current_pos.1];

        match current_node {
            'F' | 'L' | '7' | 'J' | 'S' | '|' => grid[current_pos.0][current_pos.1] = '!',
            _ => grid[current_pos.0][current_pos.1] = '_',
        };

        direction = match current_node {
            '-' => {
                if direction == Direction::West {
                    Direction::West
                } else {
                    Direction::East
                }
            }
            '|' => {
                if direction == Direction::South {
                    Direction::South
                } else {
                    Direction::North
                }
            }
            'F' => {
                if direction == Direction::North {
                    Direction::East
                } else {
                    Direction::South
                }
            }
            '7' => {
                if direction == Direction::East {
                    Direction::South
                } else {
                    Direction::West
                }
            }
            'J' => {
                if direction == Direction::East {
                    Direction::North
                } else {
                    Direction::West
                }
            }
            'L' => {
                if direction == Direction::South {
                    Direction::East
                } else {
                    Direction::North
                }
            }
            _ => direction,
        };
    }

    grid[start_pos.0][start_pos.1] = '!';

    dbg!(&grid
        .iter()
        .map(|l| l.iter().collect::<String>())
        .collect::<Vec<String>>());

    let loops: u32 = grid
        .iter()
        .map(|line| {
            let mut l = line.iter().collect::<String>();
            l = l.replace('_', "").replace("!!", "");

            let mut inside = false;
            let mut inside_count = 0;

            dbg!(&line);
            dbg!(&l);

            l.chars()
                .map(|c| {
                    if c == '!' {
                        inside = !inside;
                    } else if inside {
                        inside_count += 1;
                    }
                })
                .collect::<Vec<_>>();

            dbg!(&inside);
            dbg!(&inside_count);

            if inside {
                0
            } else {
                inside_count
            }
        })
        .collect::<Vec<u32>>()
        .iter()
        .sum();

    dbg!(loops);
}

/* fn part2(mut grid: Vec<Vec<char>>, start_pos: (usize, usize)) {
    let mut steps = 0;
    let mut current_node = 'Z';
    let mut direction = Direction::East;
    let mut current_pos = start_pos;

    while current_node != 'S' {
        current_pos = match direction {
            Direction::West => (current_pos.0, current_pos.1 - 1),
            Direction::East => (current_pos.0, current_pos.1 + 1),
            Direction::North => (current_pos.0 - 1, current_pos.1),
            Direction::South => (current_pos.0 + 1, current_pos.1),
        };

        current_node = grid[current_pos.0][current_pos.1];
        direction = match current_node {
            '-' => {
                if direction == Direction::West {
                    Direction::West
                } else {
                    Direction::East
                }
            }
            '|' => {
                if direction == Direction::South {
                    Direction::South
                } else {
                    Direction::North
                }
            }
            'F' => {
                if direction == Direction::North {
                    Direction::East
                } else {
                    Direction::South
                }
            }
            '7' => {
                if direction == Direction::East {
                    Direction::South
                } else {
                    Direction::West
                }
            }
            'J' => {
                if direction == Direction::East {
                    Direction::North
                } else {
                    Direction::West
                }
            }
            'L' => {
                if direction == Direction::South {
                    Direction::East
                } else {
                    Direction::North
                }
            }
            _ => direction,
        };
    }

    grid[start_pos.0][start_pos.1] = '-';

    let a = &grid
        .iter()
        .map(|line| {
            let mut inside = 0;
            let mut inside_count = 0;

            let mut last = '-';

            for &c in line.iter() {
                if c == '|' {
                    inside += 1;
                    continue;
                }
                if c == '-' {
                    continue;
                }

                if last == '-' && (c == '7' || c == 'J' || c == 'L' || c == 'F') {
                    if c == '7' || c == 'J' || c == 'L' || c == 'F' {
                        last = c;
                        continue;
                    }
                } else if last != '-' && (c == '7' || c == 'J' || c == 'L' || c == 'F') {
                    if (last == 'L' && c == '7') {
                        inside += 1;
                    }

                    if (last == 'F' && c == 'J') {
                        inside += 1;
                    }
                    last = '-';
                    continue;
                }

                if inside % 2 != 0 {
                    inside_count += 1;
                }
            }

            inside_count
        })
        .collect::<Vec<u32>>();

    dbg!(&grid
        .iter()
        .map(|l| l.iter().collect::<String>())
        .collect::<Vec<String>>());
    dbg!(&a);
    dbg!(&a.iter().sum::<u32>());
} */
