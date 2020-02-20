pub fn alphabet_position(text: &str) -> String {
    let text = text.chars().filter(|c| c.is_alphabetic()).map(|c| c.to_ascii_lowercase());
    text.map(|c| (c as u32 - 96).to_string() + " ").collect::<String>().trim_end().to_string()
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn returns_expected() {
        assert_eq!(
            alphabet_position("The sunset sets at twelve o' clock."),
            "20 8 5 19 21 14 19 5 20 19 5 20 19 1 20 20 23 5 12 22 5 15 3 12 15 3 11".to_string()
        );
        assert_eq!(
            alphabet_position("The narwhal bacons at midnight."),
            "20 8 5 14 1 18 23 8 1 12 2 1 3 15 14 19 1 20 13 9 4 14 9 7 8 20".to_string()
        );
        assert_eq!(
            alphabet_position("2312314124124  .. aa12412412412"), "1 1".to_string()
        );
    }
}
