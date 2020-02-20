pub fn comp(mut a: Vec<i64>, mut b: Vec<i64>) -> bool {
    
    a.iter_mut().for_each(|a| *a = a.pow(2) );
    a.sort();
    b.sort();
    a == b
}

#[cfg(test)]
mod tests {
    fn testing(a: Vec<i64>, b: Vec<i64>, exp: bool) -> () {
        assert_eq!(super::comp(a, b), exp)
    }
    #[test]
    fn tests_comp() {
        let a1 = vec![121, 144, 19, 161, 19, 144, 19, 11];
        let a2 = vec![11*11, 121*121, 144*144, 19*19, 161*161, 19*19, 144*144, 19*19];
        testing(a1, a2, true);
        let a1 = vec![121, 144, 19, 161, 19, 144, 19, 11];
        let a2 = vec![11*21, 121*121, 144*144, 19*19, 161*161, 19*19, 144*144, 19*19];
        testing(a1, a2, false);
        testing(vec![1,1,1,1,1], vec![1,1,1,1,1], true);
        testing(vec![], vec![], true);
    }
}

