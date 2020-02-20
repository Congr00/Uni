pub fn xo(string: &'static str) -> bool {
  string.chars().fold(0, |acc, c|{
      if      c == 'x' || c == 'X' { return acc-1 }
      else if c == 'o' || c == 'O' { return acc+1 }
      acc
  }) == 0
}


#[cfg(test)]
mod tests {
    #[test]
    fn returns_expected() {
        assert_eq!(super::xo("xo"), true);
        assert_eq!(super::xo("Xo"), true);
        assert_eq!(super::xo("xxOo"), true);
        assert_eq!(super::xo("xxxm"), false);
        assert_eq!(super::xo("Oo"), false);
        assert_eq!(super::xo("ooom"), false);
        assert_eq!(super::xo(""), true);
        assert_eq!(super::xo("ooooOOOXXXXXXX"), true);
        assert_eq!(super::xo("qewrtqweqeqweq"), true);
        assert_eq!(super::xo("wqeqwrwerqeqeowerwrwrwex"), true);
    }
}
