use std::collections::HashMap;

struct MorseDecoder {
    morse_code: HashMap<String, String>,
}
impl MorseDecoder {

	
    fn new() -> MorseDecoder {

        MorseDecoder{ morse_code :
        [("....-", "4"),("--..--", ","),(".--", "W"),(".-.-.-", "."),("..---", "2"),(".", "E"),("--..", "Z"),(".----", "1"),(".-..", "L"),
        (".--.", "P"),(".-.", "R"),("...", "S"),("-.--", "Y"),("...--", "3"),(".....", "5"),("--.", "G"),("-.--.", "("),("-....", "6"),
        (".-.-.", "+"),("...-..-", "$"),(".--.-.", "@"),("...---...", "SOS"),("..--.-", "_"),("-.", "N"),("-..-", "X"),("-----", "0"),
        ("....", "H"),("-...", "B"),(".---", "J"),("---...", ","),("-", "T"),("---..", "8"),("-..-.", "/"),("--.-", "Q"),("...-", "V"),
        ("----.", "9"),("--", "M"),("-.-.-.", ";"),("-.-.--", "!"),("..-.", "F"),("..--..", "?"),("-...-", "="),("..-", "U"),(".----.", "'"),
        ("---", "O"),("-.--.-", ")"),("..", "I"),("-....-", "-"),(".-..-.", "\""),(".-", "A"),("-.-.", "C"),("-..", "D"),(".-...", "&"),
        ("--...", "7"),("-.-", "K")].iter().map(|(k, v)| (k.to_string(), v.to_string())).collect()}
    }
    

    fn decode_morse(&self, encoded: &str) -> String {
        let encoded = encoded.trim();
        encoded.split("   ").fold(String::new(), |mut acc, c|{
            acc + &c.split(' ').fold(String::new(), |mut acc, c|{
                match self.morse_code.get(&c.to_string()) {
                    Some(decode) => acc += decode,
                    None => acc += " "
                }
                acc
            }) + " "
        }).trim_end().to_string()
    }
    
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hey_jude() {
        let decoder = MorseDecoder::new();
        assert_eq!(decoder.decode_morse(".... . -.--   .--- ..- -.. ."), "HEY JUDE");
        assert_eq!(decoder.decode_morse("     ....     "), "H");
    }
}

// Rust test example:
// TODO: replace with your own tests (TDD), these are just how-to examples.
// See: https://doc.rust-lang.org/book/testing.html

#[test]
fn examples() {
    let decoder = MorseDecoder::new();
    assert_eq!(decoder.decode_morse(&decoder.decode_bits("1100110011001100000011000000111111001100111111001111110000000000000011001111110011111100111111000000110011001111110000001111110011001100000011")), "HEY JUDE".to_string());
    assert_eq!(decoder.decode_morse(&decoder.decode_bits("11110011110011110011110011111100")), "4".to_string());
}
