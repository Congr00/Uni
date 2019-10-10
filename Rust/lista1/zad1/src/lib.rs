pub fn string_to_number(s: &str) -> i32 {
  s.parse().unwrap()
}

#[cfg(test)]
mod test{
    #[test]
    fn returns_expected() {
        assert_eq!(super::string_to_number("0"), 0);
        assert_eq!(super::string_to_number("-0"), 0);
        assert_eq!(super::string_to_number("-1"), -1);
        assert_eq!(super::string_to_number("10"), 10);
        assert_eq!(super::string_to_number("-76"), -76);
        assert_eq!(super::string_to_number("1201"), 1201);
        assert_eq!(super::string_to_number("42"), 42);
        assert_eq!(super::string_to_number("25546"), 25546);
        assert_eq!(super::string_to_number("-255"), -255);
    }
}