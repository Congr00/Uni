pub fn dig_pow(n: i64, p: i32) -> i64 {
    let mut p = p;
    let sum = n.to_string().chars().fold(0, |acc, c|{
        let na = acc + (c.to_digit(10).unwrap() as i64).pow(p as u32) as i64;
        p += 1;
        na
    });
    if sum % n == 0 { return sum / n }
    -1
}

#[cfg(test)]
    mod tests {
    use super::*;

    fn dotest(n: i64, p: i32, exp: i64) -> () {
        println!(" n: {:?};", n);
        println!("p: {:?};", p);
        let ans = dig_pow(n, p);
        println!(" actual:\n{:?};", ans);
        println!("expect:\n{:?};", exp);
        println!(" {};", ans == exp);
        assert_eq!(ans, exp);
        println!("{};", "-");
    }
    
    #[test]
    fn basic_tests() {
        dotest(89, 1, 1);
        dotest(92, 1, -1);
        dotest(46288, 3, 51);
        dotest(1, 1, 1);
    }
}