pub fn count_bits(n: i64) -> u32 {
     n.count_ones()
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn sample_tests() {
        assert_eq!(count_bits(0), 0);
        assert_eq!(count_bits(4), 1);
        assert_eq!(count_bits(7), 3);
        assert_eq!(count_bits(9), 2);
        assert_eq!(count_bits(10), 2);
        assert_eq!(count_bits(32), 1);
        assert_eq!(count_bits(64), 1);
        assert_eq!(count_bits(63), 6);
        assert_eq!(count_bits(128), 1);
        assert_eq!(count_bits(127), 7);
        assert_eq!(count_bits(256), 1);
        assert_eq!(count_bits(255), 8);
    }
}