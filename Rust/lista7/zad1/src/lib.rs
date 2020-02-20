pub fn chessboard_cell_color(cell1: &str, cell2: &str) -> bool {
    let a1 = cell1.chars().next().unwrap();
    let a2 = cell2.chars().next().unwrap();
    println!("{},{}", a1, a2);
    let n1 = cell1.chars().last().unwrap().to_string().parse::<i32>().unwrap();
    let n2 = cell2.chars().last().unwrap().to_string().parse::<i32>().unwrap();
    let k = a1 as u32 + a2 as u32 - 96;
    ((n1+n2) % 2 == 0 && k % 2 == 0) || ((n1+n2) % 2 == 1 && k % 2 == 1)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn basic_tests() {
        assert_eq!(chessboard_cell_color("A1", "C3"), true);
        assert_eq!(chessboard_cell_color("A1", "H3"), false);
        assert_eq!(chessboard_cell_color("A1", "A2"), false);
        assert_eq!(chessboard_cell_color("A1", "C1"), true);
        assert_eq!(chessboard_cell_color("A1", "A1"), true);
    }
}
