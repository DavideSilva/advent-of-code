#![allow(dead_code)]
#![allow(unused)]

use std::{collections::HashMap, env, fs};

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum Card {
    Ace,
    King,
    Queen,
    Jack,
    Ten,
    Nine,
    Eight,
    Seven,
    Six,
    Five,
    Four,
    Three,
    Two,
    Joker,
}

impl Card {
    fn from(card: char) -> Self {
        match card {
            'A' => Self::Ace,
            'K' => Self::King,
            'Q' => Self::Queen,
            'J' => Self::Jack,
            'T' => Self::Ten,
            '9' => Self::Nine,
            '8' => Self::Eight,
            '7' => Self::Seven,
            '6' => Self::Six,
            '5' => Self::Five,
            '4' => Self::Four,
            '3' => Self::Three,
            '2' => Self::Two,
            'W' => Self::Joker,
            _ => panic!("Invalid card!"),
        }
    }
}

#[derive(Debug, PartialEq, Eq, PartialOrd)]
enum Hand {
    FiveKind(Vec<Card>),
    FourKind(Vec<Card>),
    FullHouse(Vec<Card>),
    ThreeKind(Vec<Card>),
    TwoPair(Vec<Card>),
    OnePair(Vec<Card>),
    HighCard(Vec<Card>),
}

impl Hand {
    fn from(hand: Vec<Card>) -> Self {
        let max_card_count = hand
            .iter()
            .fold(HashMap::new(), |mut acc, c| {
                if c != &Card::Joker {
                    *acc.entry(c).or_insert(0) += 1;
                }

                acc
            })
            .into_iter()
            .max_by_key(|&(_, count)| count)
            .map(|(c, _)| c);

        let max_card_count = match max_card_count {
            Some(c) => c,
            None => &Card::Joker,
        };

        let count: Vec<u32> = hand
            .iter()
            .fold(HashMap::new(), |mut acc, c| {
                match c == &Card::Joker {
                    true => *acc.entry(max_card_count).or_insert(0) += 1,
                    false => *acc.entry(c).or_insert(0) += 1,
                };

                acc
            })
            .values()
            .map(|count| count.to_string().parse::<u32>().unwrap())
            .collect();

        match count.len() {
            1 => Self::FiveKind(hand),
            2 => {
                if count.contains(&4) {
                    Self::FourKind(hand)
                } else {
                    Self::FullHouse(hand)
                }
            }
            3 => {
                if count.contains(&3) {
                    Self::ThreeKind(hand)
                } else {
                    Self::TwoPair(hand)
                }
            }
            4 => Self::OnePair(hand),
            5 => Self::HighCard(hand),
            _ => panic!("invalid type"),
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something wrong");

    dbg!(part1(&contents));
    dbg!(part2(&contents));
}

fn part1(input: &str) -> usize {
    let input: Vec<(Hand, u32)> = parse_contents(input);

    input
        .iter()
        .enumerate()
        .map(|(rank, (_, bid))| (rank + 1) * (*bid as usize))
        .sum()
}

fn part2(input: &str) -> usize {
    let input: Vec<(Hand, u32)> = parse_contents(input.replace('J', "W").as_str());

    input
        .iter()
        .enumerate()
        .map(|(rank, (_, bid))| (rank + 1) * (*bid as usize))
        .sum()
}

fn parse_contents(input: &str) -> Vec<(Hand, u32)> {
    let mut hands = input
        .lines()
        .map(|line| line.split_whitespace().collect::<Vec<&str>>())
        .map(|split| {
            let hand = Hand::from(
                split
                    .first()
                    .unwrap()
                    .to_string()
                    .chars()
                    .map(Card::from)
                    .collect::<Vec<Card>>(),
            );

            let bid = split.last().unwrap().parse::<u32>().unwrap();

            (hand, bid)
        })
        .collect::<Vec<(Hand, u32)>>();

    hands.sort_by(|h1, h2| h2.0.partial_cmp(&h1.0).unwrap());

    hands
}
