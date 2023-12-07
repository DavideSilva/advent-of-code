#![allow(unused)]
#![allow(dead_code)]

use std::{collections::HashMap, env, f32::INFINITY, fs};

#[derive(Debug)]
struct Range {
    source: i64,
    destination: i64,
    range: i64,
}

#[derive(Debug)]
struct SeedRange {
    seed: i64,
    range: i64,
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    let sections: Vec<&str> = contents.trim().split("\n\n").collect();

    let mut maps: HashMap<String, Vec<Range>> = HashMap::new();

    let seeds: Vec<i64> = sections[0]
        .split(": ")
        .last()
        .unwrap()
        .split_whitespace()
        .map(|seed| seed.parse::<i64>().unwrap())
        .collect();

    let locations = [
        "seed-to-soil",
        "soil-to-fertilizer",
        "fertilizer-to-water",
        "water-to-light",
        "light-to-temperature",
        "temperature-to-humidity",
        "humidity-to-location",
    ];

    for &map_name in locations.iter() {
        let map_section = sections.iter().find(|s| s.starts_with(map_name)).unwrap();
        let map_values = parse_map(map_section.split(" map:\n").last().unwrap());
        maps.insert(
            map_name.to_string(),
            map_values
                .chunks_exact(3)
                .map(|c| Range {
                    destination: c[0],
                    source: c[1],
                    range: c[2],
                })
                .collect(),
        );
    }

    // dbg!(part1(&seeds, &maps));
    dbg!(part2(&seeds, &maps));
}

fn part1(seeds: &[i64], maps: &HashMap<String, Vec<Range>>) -> i64 {
    let locations = [
        "seed-to-soil",
        "soil-to-fertilizer",
        "fertilizer-to-water",
        "water-to-light",
        "light-to-temperature",
        "temperature-to-humidity",
        "humidity-to-location",
    ];

    let final_locations: Vec<_> = seeds
        .iter()
        .map(|seed| seed_location(seed, maps, locations))
        .collect();

    *final_locations.iter().min().unwrap()
}

fn part2(seeds: &[i64], maps: &HashMap<String, Vec<Range>>) -> i64 {
    let seed_ranges: Vec<SeedRange> = seeds
        .chunks_exact(2)
        .map(|s| SeedRange {
            seed: s[0],
            range: s[1],
        })
        .collect();

    let locations = [
        "seed-to-soil",
        "soil-to-fertilizer",
        "fertilizer-to-water",
        "water-to-light",
        "light-to-temperature",
        "temperature-to-humidity",
        "humidity-to-location",
    ];

    let all_seeds: Vec<i64> = seed_ranges
        .iter()
        .flat_map(|seed_range| {
            (seed_range.seed..seed_range.seed + seed_range.range)
                .map(|seed| seed_location(&seed, maps, locations))
                .collect::<Vec<i64>>()
        })
        .collect();

    *all_seeds.iter().min().unwrap()

    // for i in (0..i64::MAX) {
    //     let seed = seed_location(&i, maps, locations);
    //     match (seed_in_range(&seed, &seed_ranges)) {
    //         true => {
    //             res = i;
    //             break;
    //         }
    //         false => (),
    //     };
    // }
}

fn seed_in_range(seed: &i64, seed_ranges: &[SeedRange]) -> bool {
    let p: Vec<&SeedRange> = seed_ranges
        .iter()
        .filter(|range| (range.seed..range.seed + range.range).contains(seed))
        .collect();

    !p.is_empty()
}

fn seed_location(seed: &i64, maps: &HashMap<String, Vec<Range>>, locations: [&str; 7]) -> i64 {
    let mut next_location = *seed;

    let _: Vec<_> = locations
        .iter()
        .map(|&location| {
            let ranges = maps.get(location).unwrap();
            for range in ranges.iter() {
                if (range.source..(range.source + range.range)).contains(&next_location) {
                    next_location = range.destination + (next_location - range.source);
                    break;
                }
            }
        })
        .collect();

    next_location
}

fn parse_map(map_section: &str) -> Vec<i64> {
    map_section
        .split_whitespace()
        .map(|v| v.parse::<i64>().unwrap())
        .collect()
}
