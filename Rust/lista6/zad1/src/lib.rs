pub fn encode(msg: String, n: i32) -> Vec<i32> {
    let code:Vec<char> = n.to_string().chars().collect();
    let mut res:Vec<i32> = Vec::new();
    let mut i:usize = 0;
    for c in msg.chars(){
        res.push((c as u8 - 'a' as u8 + 1 + code[i % code.len()].to_digit(10).unwrap() as u8) as i32);
        i += 1;
    }
    res
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn fixed_tests() {
        assert_eq!(encode("".to_string(), 1939), vec![]);
        assert_eq!(encode("scout".to_string(), 1939), vec![20, 12, 18, 30, 21]);
        assert_eq!(encode("masterpiece".to_string(), 1939), vec![14, 10, 22, 29, 6, 27, 19, 18, 6, 12, 8]);
    }
}
