pub fn even_numbers(array: &Vec<i32>, number: usize) -> Vec<i32> {
  let narr:Vec<i32> = array.iter().cloned().filter(|&n| n % 2 == 0).collect();
  return narr.iter().cloned().skip(narr.len()-number).collect();
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(super::even_numbers(&vec!(1, 2, 3, 4, 5, 6, 7, 8, 9), 3), vec!(4, 6, 8));
        assert_eq!(super::even_numbers(&vec!(-22, 5, 3, 11, 26, -6, -7, -8, -9, -8, 26), 2), vec!(-8, 26));
        assert_eq!(super::even_numbers(&vec!(6, -25, 3, 7, 5, 5, 7, -3, 23), 1), vec!(6));
        assert_eq!(super::even_numbers(&vec!(2), 1), vec!(2));
        assert_eq!(super::even_numbers(&vec!(1,1,1,1,1,2), 1), vec!(2));
        assert_eq!(super::even_numbers(&vec!(1,1,1,1,1,1,2,1,1,1,11,2), 2), vec!(2,2));
        assert_eq!(super::even_numbers(&vec!(0), 1), vec!(0));
        assert_eq!(super::even_numbers(&vec!(-10,-10,-10), 2), vec!(-10,-10));
    }
}
