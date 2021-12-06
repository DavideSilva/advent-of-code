use std::env;
use std::fs;

#[derive(Debug, Copy, Clone, PartialEq)]
struct Frequencies {
    zero: u32,
    one: u32,
}

impl Frequencies {
    fn default() -> Self {
        Frequencies { zero: 0, one: 0 }
    }

    fn add_zero(&mut self) {
        self.zero += 1;
    }

    fn add_one(&mut self) {
        self.one += 1;
    }

    fn max(self) -> &'static str {
        if self.zero == self.one {
            return "1";
        }

        if self.zero > self.one {
            return "0";
        } else {
            return "1";
        }
    }

    fn min(self) -> &'static str {
        if self.zero == self.one {
            return "0";
        }

        if self.zero < self.one {
            return "0";
        } else {
            return "1";
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Something went wrong reading the file");
    let readings: Vec<&str> = contents.split("\n").filter(|line| line.len() > 0).collect();

    calculate_power_consumption(&readings);

    let o2_rating = calculate_o2_rating(&readings);
    let co2_rating = calculate_co2_rating(&readings);

    let o2_rating_dec = u32::from_str_radix(&o2_rating, 2).unwrap();
    let co2_rating_dec = u32::from_str_radix(&co2_rating, 2).unwrap();

    println!("O2 Rating: {:?} - {:?}", o2_rating, o2_rating_dec);
    println!("CO2 Rating: {:?} - {:?}", co2_rating, co2_rating_dec);

    println!("Life support Rating: {:?}", o2_rating_dec * co2_rating_dec);
}

fn calculate_frequencies(readings: &Vec<&str>) -> Vec<Frequencies> {
    let size = readings.first().unwrap().len();
    let mut frequencies = vec![Frequencies::default(); size];

    for reading in readings {
        for (pos, bit) in reading.chars().enumerate() {
            match bit {
                '0' => Ok(frequencies[pos].add_zero()),
                '1' => Ok(frequencies[pos].add_one()),
                _ => Err(()),
            }
            .expect("Error parsing the readings");
        }
    }

    frequencies
}

fn calculate_power_consumption(readings: &Vec<&str>) {
    let frequencies: Vec<Frequencies> = calculate_frequencies(&readings);
    let gamma: &str = &frequencies
        .clone()
        .into_iter()
        .map(|f| f.max())
        .collect::<Vec<_>>()
        .concat();
    let epsilon: &str = &frequencies
        .clone()
        .into_iter()
        .map(|f| f.min())
        .collect::<Vec<_>>()
        .concat();
    let gamma_dec = u32::from_str_radix(gamma, 2).unwrap();
    let epsilon_dec = u32::from_str_radix(epsilon, 2).unwrap();

    println!("Gamma: {:?} - {:?}", gamma, gamma_dec);
    println!("Epsilon: {:?} - {:?}", epsilon, epsilon_dec);

    println!("Power consumption: {:?}", gamma_dec * epsilon_dec);
}

fn calculate_o2_rating(readings: &Vec<&str>) -> String {
    let mut frequencies: Vec<Frequencies> = calculate_frequencies(&readings);
    let mut o2_readings: Vec<&str> = readings.clone();

    let mut i = 0;

    while i < o2_readings[0].len() {
        let bit = frequencies[i].max();

        o2_readings = o2_readings
            .iter()
            .filter(|reading| reading.chars().nth(i) == bit.chars().nth(0))
            .cloned()
            .collect();
        frequencies = calculate_frequencies(&o2_readings);
        i += 1;
    }

    o2_readings.first().unwrap().to_string()
}

fn calculate_co2_rating(readings: &Vec<&str>) -> String {
    let mut frequencies: Vec<Frequencies> = calculate_frequencies(&readings);
    let mut co2_readings: Vec<&str> = readings.clone();

    let mut i = 0;

    while i < co2_readings[0].len() {
        let bit = frequencies[i].min();

        co2_readings = co2_readings
            .iter()
            .filter(|reading| reading.chars().nth(i) == bit.chars().nth(0))
            .cloned()
            .collect();

        if co2_readings.len() == 1 {
            break;
        }

        frequencies = calculate_frequencies(&co2_readings);
        i += 1;
    }

    co2_readings.first().unwrap().to_string()
}
