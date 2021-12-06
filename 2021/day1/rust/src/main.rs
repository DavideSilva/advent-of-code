use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];

    let contents = fs::read_to_string(filename).expect("Something went wrong reading the file");

    let lines: Vec<&str> = contents.split_whitespace().collect();

    let depths: Vec<i32> = lines.iter().map(|s| s.parse().unwrap()).collect();

    println!("Part 1: {:?}", measure_increase(&depths));

    println!("Part 2: {:?}", rolling_window(&depths));
}

fn measure_increase(depths: &Vec<i32>) -> i32 {
    let iter = depths.windows(2);

    let mut res = 0;
    for val in iter {
        if val[1] > val[0] {
            res = res + 1;
        }
    }
    return res;
}

fn rolling_window(depths: &Vec<i32>) -> i32 {
    let sums_of_depths: Vec<i32> = depths.windows(3).map(|d| d.to_vec().iter().sum()).collect();

    // Alternative solution
    /*
     let sums_of_depths: Vec<i32> = depths.windows(3).fold(Vec::new(), |mut sum,value| {
        sum.push(value.to_vec().iter().sum());
        sum
    });
    */

    return measure_increase(&sums_of_depths);
}
