pub fn order(sentence: &str) -> String {
    let mut res = sentence.split(' ').collect::<Vec<&str>>();
    res.sort_by_key(|k| k.chars().filter(|c| c.is_digit(10)).next().unwrap());
    res.join(" ")
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn returns_expected() {
        assert_eq!(order("is2 Thi1s T4est 3a"), "Thi1s is2 3a T4est");
        assert_eq!(order(""), "");
        assert_eq!(order("4of Fo1r pe6ople g3ood th5e the2"), "Fo1r the2 g3ood 4of th5e pe6ople");
        assert_eq!(order("first1 second2"), "first1 second2");
    }
}