pub fn printer_error(s: &str) -> String {
    s.chars().filter(|&c| c > 'm').count().to_string() + &"/".to_string() + &s.chars().count().to_string()
}

#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        assert_eq!(&super::printer_error("aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbmmmmmmmmmmmmmmmmmmmxyz"), "3/56");
        assert_eq!(&super::printer_error("kkkwwwaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbmmmmmmmmmmmmmmmmmmmxyz"), "6/60");
        assert_eq!(&super::printer_error("kkkwwwaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbmmmmmmmmmmmmmmmmmmmxyzuuuuu"), "11/65");
        assert_eq!(&super::printer_error("kkkwwwaaaaaaaaaaaaaabbbbbbuuubbbbbbbbbmmmmmmmmmmmmmmmmmmmxyzuuuuu"), "14/65");
        assert_eq!(&super::printer_error("xyz"), "3/3");
        assert_eq!(&super::printer_error("xaaybbz"), "3/7");
        assert_eq!(&super::printer_error("mmmmmaaaaa"), "0/10");
        assert_eq!(&super::printer_error("mmmmmmmmmm"), "0/10");
        assert_eq!(&super::printer_error("mnmnmnmn"), "4/8");
        assert_eq!(&super::printer_error("mama"), "0/4");                    
    }
}
