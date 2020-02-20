use std::collections::HashSet;
pub fn longest(a1: &str, a2: &str) -> String {
    let mut clear = format!("{}{}", a1, a2).chars().collect::<HashSet<_>>().into_iter().collect::<Vec<_>>();
    clear.sort();
    clear.into_iter().collect()
}

#[cfg(test)]
mod tests {
    use super::*;
   
    fn testing(s1: &str, s2: &str, exp: &str) -> () {
        println!("s1:{:?} s2:{:?}", s1, s2);
        println!("{:?} {:?}", longest(s1, s2), exp);
        println!("{}", longest(s1, s2) == exp);
        assert_eq!(&longest(s1, s2), exp)
    }

    #[test]
    fn basic_tests() {
        testing("aretheyhere", "yestheyarehere", "aehrsty");
        testing("loopingisfunbutdangerous", "lessdangerousthancoding", "abcdefghilnoprstu");
        testing("thesame", "thesame", "aehmst");
        testing("", "", "");
        testing("aaaaaaaa", "", "a");
        testing("abcdefg", "hijklmn", "abcdefghijklmn");
        testing("zxy", "wut", "tuwxyz");
        testing("moar", "tests", "aemorst");
        testing("it", "works", "ikorstw");
    }
}