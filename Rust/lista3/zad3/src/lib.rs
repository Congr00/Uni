struct Cipher {
  //your code here
  map_1: String,
  map_2: String,
}

impl Cipher {
  fn new(map1: &str, map2: &str) -> Cipher {
    //your code here
    Cipher{ map_1 :map1.to_string(), map_2 :map2.to_string() }
  }
  
  fn encode(&self, string: &str) -> String {
     return string.chars()
                  .fold(String::new(), |mut acc, c| {
                      let num = self.map_1.find(c);
                      if num != None{
                          acc.push(self.map_2.chars().nth(num.unwrap()).unwrap());
                      }
                      else{
                          acc.push(c);
                      }
                      acc
                  })
  }
  
  fn decode(&self, string: &str) -> String {
     return string.chars()
                  .fold(String::new(), |mut acc, c| {
                      let num = self.map_2.find(c);
                      if num != None{
                          acc.push(self.map_1.chars().nth(num.unwrap()).unwrap());
                      }
                      else{
                          acc.push(c);
                      }
                      acc
                  })
  }
}


#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        let map1 = "abcdefghijklmnopqrstuvwxyz";
        let map2 = "etaoinshrdlucmfwypvbgkjqxz";

        let cipher = super::Cipher::new(map1, map2);
        
        assert_eq!(cipher.encode("abc"), "eta");
        assert_eq!(cipher.encode("xyz"), "qxz");
        assert_eq!(cipher.decode("eirfg"), "aeiou");
        assert_eq!(cipher.decode("erlang"), "aikcfu");
        assert_eq!(cipher.decode("ż"), "ż");
        assert_eq!(cipher.encode("ażbóc"), "eżtóa");
        assert_eq!(cipher.decode("etaoin"), "abcdef");
        assert_eq!(cipher.encode("zyxwv"), "zxqjk");
    }
}
