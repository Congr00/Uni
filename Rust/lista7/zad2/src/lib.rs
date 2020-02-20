use std::collections::BTreeMap;

pub fn letter_frequency(input: &str) -> BTreeMap<char, i32> {
    let mut res = BTreeMap::new();
    let input = input.chars().filter(|c| c.is_alphabetic()).map(|c| c.to_ascii_lowercase());
    for c in input{
        *res.entry(c).or_insert(0) += 1;
    }
    res
}

#[cfg(test)]
mod tests {
    use std::collections::BTreeMap;
    use super::letter_frequency;
    
    #[test]
    fn simpleword() {
        let answer: BTreeMap<char, i32> =
        [('a', 2),
         ('c', 1),
         ('l', 1),
         ('t', 1),
         ('u', 1)]
         .iter().cloned().collect();
         
      assert_eq!(letter_frequency("actual"), answer);
    }
    
    #[test]
    fn sequence() {
        let answer: BTreeMap<char, i32> =
        [('a', 3),
         ('b', 2),
         ('f', 1),
         ('p', 1),
         ('s', 1),
         ('t', 2),
         ('u', 1),
         ('x', 5)]
         .iter().cloned().collect();
         
      assert_eq!(letter_frequency("AaabBF UttsP xxxxx"), answer);
    }
    #[test]
    fn other() {
        let answer: BTreeMap<char, i32> =
        [('a', 1)]
         .iter().cloned().collect();
         
      assert_eq!(letter_frequency("     -----   A   "), answer);
    }
    #[test]
    fn big_smull() {
        let answer: BTreeMap<char, i32> =
        [('a', 5)]
         .iter().cloned().collect();
         
      assert_eq!(letter_frequency("   a  --a---   A a  a"), answer);
    }
}