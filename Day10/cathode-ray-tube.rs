use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::str::FromStr;

fn main() {
    if let Ok(lines) = read_lines("./input.txt") {
        let mut x = 1;
        let mut cycle = 1;
        let mut cumulative_strength = 0;

        for line in lines {
            if let Ok(instruction) = line {
                let parts: Vec<&str> = instruction.split(' ').collect();
                let op = *parts.get(0).unwrap();
                let value = i32::from_str(*parts.get(1).unwrap_or(&"0")).unwrap();
                let cycles = match op {
                    "addx" => 2,
                    "noop" => 1,
                    _ => 0
                };

                for i in 0..cycles {
                    if (cycle - 20) % 40 == 0 {
                        cumulative_strength += cycle * x;
                    }
                    let h = (cycle - 1) % 40;
                    let pixel = if h >= x - 1 && h <= x + 1 { "#" } else { "." };
                    print!("{}", pixel);
                    if cycle % 40 == 0 {
                        println!("");
                    }
                    if i == cycles - 1 { x += value }
                    cycle += 1
                }
            }
        }
        println!("cumulative signal strength: {:?}", cumulative_strength);
    }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}