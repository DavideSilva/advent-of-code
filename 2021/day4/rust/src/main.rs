use std::env;
use std::fs;

#[derive(Debug)]
struct Board<'a> {
    board: Vec<Vec<&'a str>>,
}

impl Board<'_> {
    fn default() -> Self {
        Board { board: Vec::new() }
    }
}

fn create_boards(board_lines: &str) -> Vec<Board> {
    let lines: Vec<&str> = board_lines.split("\n\n").collect();

    println!("{:?}", lines);

    vec![Board::default()]
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something went wrong reading the file");

    let (numbers, boards): (Vec<u32>, Vec<Board>) = match contents.split_once("\n\n") {
        Some((p, s)) => (
            p.split(",").map(|n| n.parse().unwrap()).collect(),
            create_boards(s),
        ),
        _ => (vec![], vec![]),
    };

    // println!("{:?}\n{:?}", numbers, boards);
}
