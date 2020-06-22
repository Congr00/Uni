use std::io;
use thiserror::Error;

pub const DICT_SIZE: usize = 4; // 4kb
pub const INPUT_SIZE: usize = 1; // 1kb
pub const MAX_MATCH: usize = 10;
pub const END_SYMBOL: char = 0x1f as char;
pub const DIVIDER: char = 007 as char;
pub const MIN_LEN: usize = 4;

#[derive(Error, Debug)]
pub enum DataStoreError {
    #[error("Error during file byte decoding, possible file corruption")]
    HuffmanReadError,
    #[error("Error during deserialization, possible file corruption")]
    DeserializeError(#[from] bincode::Error),
    #[error("Error during structure parsing, possible file corruption")]
    TripletError,
    #[error("file reading or writing error")]
    InOutError(#[from] io::Error),
    #[error("File name not specified")]
    NoFile,
    #[error("Wrong argument specified - {0}")]
    WrongArg(String),
}

pub fn u32_to_u8(input: usize) -> Vec<u8> {
    if input == 0 {
        return vec![0x00 as u8];
    }
    (0..4)
        .filter_map(|shift| {
            let v = input >> (shift * 8);
            if v != 0 {
                Some((v & 0xff) as u8)
            } else {
                None
            }
        })
        .collect::<Vec<u8>>()
}

pub fn u8_to_u32(input: &[u8]) -> usize {
    let mut output: usize = 0;
    for (i, v) in input.into_iter().enumerate() {
        output |= (*v as usize) << (i * 8);
    }
    output
}
