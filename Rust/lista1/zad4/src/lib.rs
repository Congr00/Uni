pub fn printer_error(s: &str) -> String {
    format!("{}/{}", s.chars().filter(|&c| c > 'm').count(), s.len())
 }


#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        assert_eq!(super::printer_error("aaabbbcccd"), "0/10");
    }
}
