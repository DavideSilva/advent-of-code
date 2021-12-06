use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];

    let contents = fs::read_to_string(filename).expect("Something went wrong reading the file");

    let commands: Vec<&str> = contents.split("\n").filter(|item| item.len() > 0).collect();

    calculate_depth(&commands).expect("Uh oh, error");
    new_calculate_depth(&commands);
}

fn calculate_depth(commands: &Vec<&str>) -> Result<u32, ()> {
    let mut h_pos: u32 = 0;
    let mut depth: u32 = 0;

    for line in commands {
        let (action, units_string): (&str, &str) = line.split_once(" ").expect("Couldn't parse the instruction line");
        let units = units_string.parse::<u32>().expect("Couldn't parse the units");

        match action {
            "forward" => Ok(h_pos += units),
            "down" => Ok(depth += units),
            "up" => Ok(depth -= units),
            _ => Err(()),
        }.expect("Error parsing the instructions");
    }

    println!("Position: {:?}, Depth: {:?}, Answer: {:?}", h_pos, depth, h_pos * depth);

    Ok(h_pos * depth)
}

fn new_calculate_depth(commands: &Vec<&str>) {
    let mut h_pos: i32 = 0;
    let mut depth: i32 = 0;
    let mut aim: i32 = 0;

    for line in commands {
        let l: Vec<&str> = line.split_whitespace().collect();
        let action = l[0];
        let units: i32 = l[1].parse().unwrap();

        match action {
            "forward" => {
                h_pos += units;
                depth += aim * units;
            },
            "down" => aim += units,
            "up" => aim -= units,
            _ => unreachable!()
        }
    }

    println!("Position: {:?}, Depth: {:?}, Answer: {:?}", h_pos, depth, h_pos * depth);
}
