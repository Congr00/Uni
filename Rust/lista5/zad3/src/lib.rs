
pub fn solution(n: f64) -> f64 {
    n.floor() + (2.0 * n.fract()).round() / 2.0
}

#[cfg(test)]
mod tests {
    use super::solution;
    
    #[test]
    fn sample_tests() {
        assert_eq!(solution(4.2), 4.0);
        assert_eq!(solution(4.4), 4.5);
        assert_eq!(solution(4.6), 4.5);
        assert_eq!(solution(4.8), 5.0);
        assert_eq!(solution(1.75), 2.0);
    }
}
