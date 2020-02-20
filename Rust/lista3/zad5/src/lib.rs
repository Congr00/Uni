pub fn last_digit(str1: &str, str2: &str) -> i32 {
    let a = str1.to_string();
    let b = str2.to_string();
    if a.len() == 1 && b.len() == 1 && a.chars().next().unwrap() == '0' && b.chars().next().unwrap() == '0' 
        {return 1} 
    if b.len() == 1 && b.chars().next().unwrap() == '0'
        {return 1} 
    
    if a.len() == 1 && a.chars().next().unwrap() == '0'
        {return 0} 
        
    let exp = if Modulo(4, &b) == 0 {4} else {Modulo(4, &b)}; 

    let res = (a.chars().nth(a.len() - 1).unwrap().to_digit(10).unwrap() as i32).pow(exp as u32);
  
    return res % 10;

}

fn Modulo(a: i32, b: &String) -> i32 { 
    let mut m = 0; 
    for i in 0..b.len(){
        m = (m * 10 + b.chars().nth(i).unwrap().to_digit(10).unwrap()) % a as u32; 
    }
    return m as i32
}



#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        assert_eq!(super::last_digit("4", "1"), 4);
        assert_eq!(super::last_digit("4", "2"), 6);
        assert_eq!(super::last_digit("9", "7"), 9);
        assert_eq!(super::last_digit("10","10000000000"), 0);
        assert_eq!(super::last_digit("1606938044258990275541962092341162602522202993782792835301376","2037035976334486086268445688409378161051468393665936250636140449354381299763336706183397376"), 6);
        assert_eq!(super::last_digit("3715290469715693021198967285016729344580685479654510946723", "68819615221552997273737174557165657483427362207517952651"), 7);
        assert_eq!(super::last_digit("10", "0"), 1);
        assert_eq!(super::last_digit("0", "0"), 1);
        assert_eq!(super::last_digit("10", "1"), 0);
        assert_eq!(super::last_digit("992313", "1"), 3);
    }
}