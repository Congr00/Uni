pub fn fcn(n: i32) -> i64 {
    if n == 0 { return 1;}
    let mut num: Vec<i128> = vec![1,2];
    for _ in 2..=n{
        let un = num[num.len()-2];
        let un1 = num[num.len()-1];
        num.push(6*un*un1 / (5*un - un1));
    }
    *num.last().unwrap() as i64
}


#[cfg(test)]
mod tests {
    use super::*;
    pub fn testequal(n: i32, exp: i64) -> () {
        assert_eq!(exp, fcn(n))
    }
    #[test]
    fn basics() {
        testequal(17, 131072);
        testequal(21, 2097152);
        testequal(0, 1);
        testequal(1, 2);
        testequal(2, 4);
        testequal(3, 8);
    }
}


