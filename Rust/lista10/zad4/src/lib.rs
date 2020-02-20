use std::collections::HashMap;

pub fn change(s: &str, prog: &str, version: &str) -> String {
    let err = "ERROR: VERSION or PHONE".to_string();
    let hash = s.split("\n").map(|s| (s.split(": ").next().unwrap(),
                                      s.split(": ").last().unwrap()))
                            .collect::<HashMap<_,_>>();
    let mut phone = hash["Phone"].split("-");
    if phone.clone().count() != 4 { return err }
    let version = match hash["Version"].parse::<f32>().ok() {
        None => return err,
        _ if hash["Version"] == "2.0" => "2.0",
        _ => if !hash["Version"].contains(".") || hash["Version"].len() < 3 { return err } else { version }
    };
    if phone.next().unwrap() != "+1" { return err }
    if vec![check_digits(phone.next().unwrap(), 3), check_digits(phone.next().unwrap(), 3), check_digits(phone.next().unwrap(), 4)]
        .into_iter().any(|b| !b) { return err }
    format!("Program: {} Author: g964 Phone: +1-503-555-0090 Date: 2019-01-01 Version: {}", prog, version)
}

fn check_digits(s: &str, cnt: usize) -> bool{
    if s.len() != cnt { return false }
    return s.chars().all(char::is_numeric)
}

#[cfg(test)]
    mod tests {
    use super::*;
   
    fn dotest(s: &str, prog: &str, version: &str, exp: &str) -> () {
        println!("s:{:?}", s);
        println!("prog:{:?}", prog);
        println!("version:{:?}", version);
        let ans = change(s, prog, version);
        println!("actual: {:?}", ans);
        println!("expect: {:?}", exp);
        println!("{}", ans == exp);
        assert_eq!(ans, exp);
        println!("{}", "-");
    }    
      
    #[test]
    fn basic_tests() {
        let s1="Program title: Primes\nAuthor: Kern\nCorporation: Gold\nPhone: +1-503-555-0091\nDate: Tues April 9, 2005\nVersion: 6.7\nLevel: Alpha";
        dotest(s1, "Ladder", "1.1", "Program: Ladder Author: g964 Phone: +1-503-555-0090 Date: 2019-01-01 Version: 1.1");
        let s2="Program title: Balance\nAuthor: Dorries\nCorporation: Funny\nPhone: +1-503-555-0095\nDate: Tues July 19, 2014\nVersion: 6.7\nLevel: Release";
        dotest(s2, "Circular", "1.5", "Program: Circular Author: g964 Phone: +1-503-555-0090 Date: 2019-01-01 Version: 1.5");        
        let s13="Program title: Primes\nAuthor: Kern\nCorporation: Gold\nPhone: +1-503-555-0090\nDate: Tues April 9, 2005\nVersion: 67\nLevel: Alpha";
        dotest(s13, "Ladder", "1.1", "ERROR: VERSION or PHONE");
        let s13="Program title: Primes\nAuthor: Kern\nCorporation: Gold\nPhone: +1-503-555-0090\nDate: Tues April 9, 2005\nVersion: 1.1.0\nLevel: Alpha";
        dotest(s13, "Ladder", "1.1", "ERROR: VERSION or PHONE");
    }
}
