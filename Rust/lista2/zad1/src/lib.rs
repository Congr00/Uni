pub fn get_count(string: &str) -> usize {
  let mut vowels_count: usize = 0;
  let vovels: Vec<char> = vec!['a', 'e', 'i', 'o', 'u'];
  string.chars().for_each(|x| { 
      vovels.iter().for_each(|&v| if v == x {vowels_count += 1;} );
  });
  vowels_count
}

#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        assert_eq!(super::get_count("abracadabra"), 5);
        assert_eq!(super::get_count(""), 0);
        assert_eq!(super::get_count("a"), 1);
        assert_eq!(super::get_count("r"), 0);
        assert_eq!(super::get_count("aaabbbccc"), 3);
        assert_eq!(super::get_count("aeiou"), 5);
        assert_eq!(super::get_count("dhgjhghhtgdhagjdjjjjajjj"), 2);
        assert_eq!(super::get_count("**&&&a"), 1);
        assert_eq!(super::get_count(")(*&^%$#@!!@#$%^&"), 0);
        assert_eq!(super::get_count("super test"), 3);
    }
}