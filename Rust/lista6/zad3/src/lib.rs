pub fn print(n: i32) -> Option<String> {
    if n < 0 || n % 2 == 0 { return None }
    let mut res = String::new();
    for i in (1..=n).step_by(2)     { res.push_str(&line(n, i)); }
    for i in (1..=n-2).rev().step_by(2) { res.push_str(&line(n, i)); }
    Some(res)
}

fn line(size: i32, len: i32) -> String{
    let empty = size - len;
    format!("{}{}\n", ' '.to_string().repeat((empty/2) as usize), '*'.to_string().repeat(len as usize))
}

#[cfg(test)]
mod tests {
    use super::print;
    #[test]
    fn basic_test() {
        assert_eq!(print(3), Some(" *\n***\n *\n".to_string()) );
        assert_eq!(print(5), Some("  *\n ***\n*****\n ***\n  *\n".to_string()) );
        assert_eq!(print(-3),None);
        assert_eq!(print(2),None);
        assert_eq!(print(0),None);
        assert_eq!(print(1), Some("*\n".to_string()) );
        assert_eq!(print(10),None);
    }
}
