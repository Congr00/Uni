pub fn part_list(arr: Vec<&str>) -> String {
    (1..arr.len()).map(|i| {
        format!("({}, {})", arr[..i].join(" "), arr[i..].join(" "))
    }).collect()
}

#[cfg(test)]
    mod tests {
    use super::*;

    fn dotest(arr: Vec<&str>, exp: &str) -> () {
        println!("arr: {:?}", arr);
        let ans = part_list(arr);
        println!("actual:\n{}", ans);
        println!("expect:\n{}", exp);
        println!("{}", ans == exp);
        assert_eq!(ans, exp);
        println!("{}", "-");
    }

    #[test]
    fn basis_tests() {
        dotest(vec!["I", "wish", "I", "hadn't", "come"],
                "(I, wish I hadn't come)(I wish, I hadn't come)(I wish I, hadn't come)(I wish I hadn't, come)");
        dotest(vec!["cdIw", "tzIy", "xDu", "rThG"], 
            "(cdIw, tzIy xDu rThG)(cdIw tzIy, xDu rThG)(cdIw tzIy xDu, rThG)");
        dotest(vec![], "");
        dotest(vec!["I"], "");
        dotest(vec!["I", "I"], "(I, I)");
    }
}
