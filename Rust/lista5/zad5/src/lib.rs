pub fn dbl_linear(n: u32) -> u32{
    let n = n as usize;
    let mut res = vec![1];
    let mut iz = 0;
    let mut iy = 0;
    while res.len() <= n {
        let y = res[iy] * 2 + 1;
        let z = res[iz] * 3 + 1;
        if y < z { res.push(y); iy += 1;}
        else if z < y {res.push(z); iz += 1;}
        else { res.push(y); iy += 1; iz += 1;}
    }
    res[n]
}

#[cfg(test)]
mod tests {
    use super::dbl_linear;
    fn testing(n: u32, exp: u32) -> () {
        assert_eq!(dbl_linear(n), exp)
    }
    #[test]
    fn basics_dbl_linear() {
        testing(10, 22);
        testing(20, 57);
        testing(30, 91);
        testing(50, 175);
        testing(100, 447);
        testing(0, 1);
        testing(1, 3);
        testing(2, 4);
        testing(3, 7);
    }
}
