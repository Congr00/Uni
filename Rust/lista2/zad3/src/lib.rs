pub fn summy(string: &str) -> i32 {
    string.split(" ").map(|s| -> i32 {s.parse().unwrap()}).sum::<i32>()
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn sample_tests() {
        assert_eq!(summy("1 2 3"), 6);
        assert_eq!(summy("1 2 3 4"), 10);
        assert_eq!(summy("1 2 3 4 5"), 15);
        assert_eq!(summy("10 10"), 20);
        assert_eq!(summy("0 0"), 0);
        assert_eq!(summy("-1 -1 -1"), -3);
        assert_eq!(summy("-1 1"), 0);
        assert_eq!(summy("-1 0 1"), 0);
        assert_eq!(summy("-99 100"), 1);
        assert_eq!(summy("0 0 0 0 0 0 0 0 0 0 0 144"), 144);
        assert_eq!(summy("-9000 20000"), 11000);
    }
}