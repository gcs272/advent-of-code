use std::fs;

fn get_map_from_file(path: &str) -> Option<Vec<Vec<bool>>> {
    let mut map: Vec<Vec<bool>> = Vec::new();

    if let Ok(contents) = fs::read_to_string(path) {
        for line in contents.lines() {
            let row = line.chars().map(|c| { c == '#'}).collect::<Vec<bool>>();
            map.push(row);
        }
        return Some(map);
    }
    return None;
}

fn ow(map: &Vec<Vec<bool>>, slope: [usize; 2]) -> i32 {
    let mut x = 0;
    let mut y = 0;
    let mut hits = 0;

    while y < map.len() {
        if map[y][x % map[y].len()] {
            hits += 1;
        }
        x += slope[0];
        y += slope[1];
    }

    return hits;
}

fn main() {
    if let Some(map) = get_map_from_file("day3.input") {
        // part one
        println!("{}", ow(&map, [3, 1]));

        // part two
        let slopes: [[usize; 2]; 5] = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]];
        println!("{:?}", slopes.iter().fold(1i64, |acc, slope| acc * i64::from(ow(&map, *slope))))
    }
}
