pub fn descending_order(x: u64) -> u64 {
    let mut vec: Vec<char> = x.to_string().chars().collect();
    vec.sort_by(|a, b| a.cmp(b).reverse());
    vec.into_iter().collect::<String>().parse::<u64>().unwrap()
}

#[cfg(test)]
mod tests {
    #[test]
    fn returns_expected() {
        assert_eq!(super::descending_order(0), 0);
        assert_eq!(super::descending_order(1), 1);
        assert_eq!(super::descending_order(15), 51);
        assert_eq!(super::descending_order(1021), 2110);
        assert_eq!(super::descending_order(123456789), 987654321);
        assert_eq!(super::descending_order(145263), 654321);
        assert_eq!(super::descending_order(1254859723), 9875543221);
        assert_eq!(super::descending_order(111111), 111111);
    }
}
