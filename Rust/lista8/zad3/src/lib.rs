pub fn dec2_fact_string(nb: u64) -> String {
    let mut nb = nb;
    let mut res:String = String::new();
    for i in 1..{
        let rem = nb % i;
        res = format!("{}{}", &map_int(rem), res);
        nb /= i;
        if nb == 0 { return res; }
    }
    " ".into()
}

pub fn fact_string_2dec(s: String) -> u64 {
    (1..(s.len())).rev().zip(s.chars()).fold(0u64, |acc, (n, c)|{
        let fac_num = c.to_digit(36).unwrap() as u64;
        acc + fac_num * fac(n as u64)
    })
}

fn map_int(n : u64) -> String{
    std::char::from_digit(n as u32, 36).unwrap().to_uppercase().to_string()
}

fn fac(n : u64) -> u64 { 
    fn fac_aux(n : u64, acc : u64) -> u64 {
        if n <= 1 { return acc; }
        fac_aux(n-1, acc*n)
    }
    fac_aux(n, 1)
}

#[cfg(test)]
mod tests {
    use super::*;
    
    fn testing1(nb: u64, exp: &str) -> () {
        assert_eq!(&dec2_fact_string(nb), exp)
    }
    
    fn testing2(s: &str, exp: u64) -> () {
        assert_eq!(fact_string_2dec(s.to_string()), exp)
    }
    
    #[test]
    fn basics_dec2_fact_string() {
    
        testing1(2982, "4041000");
        testing1(463, "341010");
        
    }
    #[test]
    fn basics_fact_string_2dec() {
    
        testing2("4041000", 2982);
        testing2("341010", 463);
        
    }
}
