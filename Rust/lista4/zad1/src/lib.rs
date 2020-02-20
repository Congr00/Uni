pub fn find_digit(num: i32, nth: i32) -> i32 {
  let snum:String = num.to_string().chars().filter(|&c| c != '-').collect();
  if nth <= 0 { -1 }
  else if snum.len() < (nth as usize) { 0 }
  else { snum.chars().rev().nth((nth as usize) -1).unwrap().to_digit(10).unwrap() as i32 }
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(super::find_digit(5673, 4), 5);
        assert_eq!(super::find_digit(129, 2), 2);
        assert_eq!(super::find_digit(-2825, 3), 8);
        assert_eq!(super::find_digit(-456, 4), 0);
        assert_eq!(super::find_digit(0, 20), 0);
        assert_eq!(super::find_digit(65, 0), -1);
        assert_eq!(super::find_digit(24, -8), -1);
        assert_eq!(super::find_digit(24000000, -8), -1);
        assert_eq!(super::find_digit(90000000, 1), 0);
        assert_eq!(super::find_digit(-1, 1), 1);
        assert_eq!(super::find_digit(-1, 2), 0);
        assert_eq!(super::find_digit(-1, 0), -1);
    }
}
