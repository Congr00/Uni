pub fn row_sum_odd_numbers(n:i64) -> i64 {
  let sum = (0..n).fold(1, |acc, x| acc + x*2);
  return (1..n).fold(sum, |acc, x| acc + (sum + 2*x))
}

#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        assert_eq!(super::row_sum_odd_numbers(1), 1);
        assert_eq!(super::row_sum_odd_numbers(42), 74088);
        assert_eq!(super::row_sum_odd_numbers(2), 8);
        assert_eq!(super::row_sum_odd_numbers(3), 27);
        assert_eq!(super::row_sum_odd_numbers(4), 64);
        assert_eq!(super::row_sum_odd_numbers(5), 125);
        assert_eq!(super::row_sum_odd_numbers(6), 216);
        assert_eq!(super::row_sum_odd_numbers(69), 328509);
    }
}