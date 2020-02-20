use std::collections::HashMap;

pub fn stock_list(list_art: Vec<&str>, list_cat: Vec<&str>) -> String {
    if list_art.is_empty() || list_cat.is_empty() { return String::new() }
    let mut hash = HashMap::new();
    for l in list_art{
        let cat = &l[0..1];
        let counter = hash.entry(cat).or_insert(0);
        *counter += l.split(" ")
                     .last()
                     .and_then(|num| num.parse::<usize>().ok())
                     .unwrap();
    }
    list_cat.into_iter()
            .map(|l| (l, hash.get(l).unwrap_or(&0)))
            .map(|(l, v)| format!("({} : {})", l, v))
            .collect::<Vec<_>>().join(" - ")
}

#[cfg(test)]
    mod tests {
    use super::*;

    fn dotest(list_art: Vec<&str>, list_cat: Vec<&str>, exp: &str) -> () {
        println!("list_art: {:?};", list_art);
        println!("list_cat: {:?};", list_cat);
        let ans = stock_list(list_art, list_cat);
        println!("actual:\n{:?};", ans);
        println!("expect:\n{:?};", exp);
        println!("{};", ans == exp);
        assert_eq!(ans, exp);
        println!("{};", "-");
    }

    #[test]
    fn basic_tests() {
        let mut b = vec!["BBAR 150", "CDXE 515", "BKWR 250", "BTSQ 890", "DRTY 600"];
        let mut c = vec!["A", "B", "C", "D"];
        dotest(b, c, "(A : 0) - (B : 1290) - (C : 515) - (D : 600)");

        b = vec!["ABAR 200", "CDXE 500", "BKWR 250", "BTSQ 890", "DRTY 600"];
        c = vec!["A", "B"];
        dotest(b, c, "(A : 200) - (B : 1140)");
        dotest(vec![], vec![], "");
        dotest(vec!["ABAR 100", "ABAR 200"], vec!["A", "B", "C"], "(A : 300) - (B : 0) - (C : 0)");
    }
}
