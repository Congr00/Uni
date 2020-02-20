pub fn camel_case(s: &str) -> String {
    let s = s.trim();
    if s == "" { return "".into(); }
    s.split(" ").fold(String::new(), |acc, s|{
        format!("{}{}{}", acc, &s[..1].to_uppercase(), &s[1..])
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn sample_test() {
      assert_eq!(camel_case("test case"), "TestCase");
      assert_eq!(camel_case("camel case method"), "CamelCaseMethod");
      assert_eq!(camel_case("say hello "), "SayHello");
      assert_eq!(camel_case(" camel case word"), "CamelCaseWord");
      assert_eq!(camel_case(""), "");
    }
}
