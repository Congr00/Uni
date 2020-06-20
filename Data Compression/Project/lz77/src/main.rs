#[cfg(test)]
use lipsum::lipsum;

extern crate getopts;
use bincode;
use bit_vec::BitVec;
use getopts::Options;
use huffman_compress::Tree;
use std::env;
use std::fs;
use std::fs::File;

use std::collections::HashMap;
use std::collections::VecDeque;
use std::io;
use std::io::prelude::*;
use thiserror::Error;

pub const DICT_SIZE: usize = 4; // 4kb
pub const INPUT_SIZE: usize = 10; // 10kb
pub const MAX_MATCH: usize = 3;
pub const END_SYMBOL: char = 0x1f as char;
pub const DIVIDER: char = 007 as char;

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

use DataStoreError::*;

#[derive(Debug)]
pub struct DictBuffer {
    frame: Vec<char>,
    indexes: HashMap<String, VecDeque<usize>>,
    start: Wrapper,
    max_match: usize,
}
impl DictBuffer {
    pub fn new(size: usize, match_num: usize) -> Self {
        if size < 2 {
            panic!("Dict Buffer size needs to be greater then 2!");
        }
        Self {
            frame: vec![' '; size],
            indexes: HashMap::new(),
            start: Wrapper::new(size),
            max_match: match_num,
        }
    }
    pub fn push_string(&mut self, input: &String) {
        self.remove_old_indexes(input.len());
        for c in input.chars() {
            self.frame[self.start.get()] = c;
            self.start.update();
        }
        let rmv = if input.len() > self.frame.len() {
            input.len() - self.frame.len()
        } else {
            0
        };
        self.add_new_indexses(&input.chars().skip(rmv).collect::<String>());
    }
    fn lookup(&self, word: &[char], index: &Wrapper, last: usize) -> Triplet {
        for i in 1..=MAX_MATCH {
            let match_str: String = index.range(i).into_iter().map(|ind| word[ind]).collect();
            let (len, id) = self
                .indexes
                .get(&match_str)
                .and_then(|ind| {
                    ind.into_iter()
                        .map(|&i| (self.longest_match(i, word, index, last), i))
                        .max()
                })
                .unwrap_or_else(|| (0, 0));
            if len != 0 {
                if len >= word.len() {
                    return Triplet::last(id, len);
                }
                return match word.get(index.from_add(len)) {
                    Some(c) => Triplet::new(id, len, *c),
                    None => Triplet::last(id, len),
                };
            }
        }
        Triplet::empty(word[index.get()])
    }
    fn longest_match(&self, start: usize, word: &[char], ind: &Wrapper, last: usize) -> usize {
        let mut length: usize = 0;
        let mut ptr = Wrapper::from(start, self.frame.len());
        for i in ind.range(word.len()) {
            let c = word[i];
            if self.frame[ptr.get()] == c && length < last {
                length += 1;
            } else {
                break;
            }
            ptr.update();
        }
        length
    }
    fn remove_old_indexes(&mut self, num: usize) {
        for frame_len in 1..=MAX_MATCH {
            let mut ptr = Wrapper::from(self.start.get(), self.frame.len());
            for _ in 0..num {
                let substr = ptr
                    .range(frame_len)
                    .into_iter()
                    .map(|ind| self.frame[ind])
                    .collect::<String>();
                let _ = match self.indexes.get_mut(&substr) {
                    Some(vec) => vec.pop_front(),
                    None => None,
                };
                ptr.update();
            }
        }
    }
    fn add_new_indexses(&mut self, word: &String) {
        for frame_len in 1..=MAX_MATCH {
            let mut ptr = Wrapper::from(self.start.from_sub(word.len()), self.frame.len());
            if frame_len > word.len() {
                break;
            }
            for i in 0..(word.len() - frame_len + 1) {
                let substr: String = word.chars().skip(i).take(frame_len).collect();
                match self.indexes.get_mut(&substr) {
                    Some(vec) => vec.push_back(ptr.get()),
                    None => {
                        let mut v = VecDeque::new();
                        v.push_back(ptr.get());
                        self.indexes.insert(substr, v);
                    }
                }
                ptr.update();
            }
        }
    }
}
#[derive(Debug, Copy, Clone)]
pub struct Wrapper {
    index: usize,
    size: usize,
}
impl Wrapper {
    fn new(size: usize) -> Self {
        Self {
            index: 0,
            size: size,
        }
    }
    fn from(i: usize, size: usize) -> Self {
        Self {
            index: i,
            size: size,
        }
    }
    fn from_sub(self, i: usize) -> usize {
        let i = i % self.size;
        if self.index < i {
            let diff = i - self.index;
            return self.size - diff;
        }
        self.index - i
    }
    fn from_add(self, i: usize) -> usize {
        if self.index + i >= self.size {
            return (self.index + i) % self.size;
        }
        self.index + i
    }
    fn get(self) -> usize {
        self.index
    }
    fn update(&mut self) {
        if self.index + 1 >= self.size {
            self.index = 0;
        } else {
            self.index += 1;
        }
    }
    fn update_by(&mut self, n: usize) {
        if self.index + n >= self.size {
            self.index = self.index + n - self.size;
        } else {
            self.index += n;
        }
    }
    fn range(self, size: usize) -> Vec<usize> {
        if self.index + size > self.size {
            let index = self.index % self.size;
            let diff = self.size - index;
            if (size - diff) > self.size {
                return (index..self.size)
                    .chain((0..self.size).cycle().take(size - diff))
                    .collect();
            } else {
                return (index..self.size).chain(0..(size - diff)).collect();
            }
        }
        (self.index..(self.index + size)).collect()
    }
}
#[derive(Debug, Copy, Clone)]
pub struct Triplet {
    pub index: usize,
    pub length: usize,
    pub symbol: char,
}
impl Triplet {
    fn new(index: usize, len: usize, symbol: char) -> Self {
        Self {
            index: index,
            length: len,
            symbol: symbol,
        }
    }
    fn empty(symbol: char) -> Self {
        Self {
            index: 0,
            length: 0,
            symbol: symbol,
        }
    }
    fn last(index: usize, len: usize) -> Self {
        Self {
            index: index,
            length: len,
            symbol: END_SYMBOL,
        }
    }
    fn is_last(self) -> bool {
        self.symbol == END_SYMBOL
    }
    fn to_u8(self) -> Vec<u8> {
        let div: String = DIVIDER.to_string();
        [
            div.clone(),
            self.index.to_string(),
            div.clone(),
            self.length.to_string(),
            div.clone(),
            self.symbol.to_string(),
        ]
        .iter()
        .cloned()
        .flat_map(|v| v.into_bytes().into_iter())
        .filter(|v| *v != 0)
        .collect::<Vec<_>>()
    }
    fn to_string(self) -> String {
        let div: String = DIVIDER.to_string();
        /*let mut vec: Vec<u8> = vec![div];
        for u in self.index.to_string().as_bytes().into_iter() {
            vec.push(*u);
        }
        vec.push(div);
        for u in self.length.to_string().as_bytes().into_iter() {
            vec.push(*u);
        }
        vec.push(div);
        for u in self.symbol.to_string().as_bytes().into_iter() {
            vec.push(*u);
        }
        */
        String::from_utf8(
            [
                div.clone(),
                self.index.to_string(),
                div.clone(),
                self.length.to_string(),
                div.clone(),
                self.symbol.to_string(),
            ]
            .iter()
            .cloned()
            .flat_map(|v| v.into_bytes().into_iter())
            .collect::<Vec<_>>(),
        )
        .unwrap()
        //String::from_utf8(vec).unwrap()
    }
}
#[derive(Debug)]
pub struct InputBuffer {
    frame: Vec<char>,
    free_space: usize,
    index: Wrapper,
    last: usize,
    write: Wrapper,
}
impl InputBuffer {
    pub fn new(size: usize) -> Self {
        if size < 2 {
            panic!("Input buffer size needs to be greater then 2!");
        }
        Self {
            frame: vec![' '; size],
            free_space: size,
            index: Wrapper::new(size),
            last: 0,
            write: Wrapper::new(size),
        }
    }
    pub fn feed(&mut self, data: &str) -> usize {
        let mut i = 0;
        for c in data.chars() {
            if self.free_space == 0 {
                break;
            }
            self.last += 1;
            self.frame[self.write.get()] = c;
            self.free_space -= 1;
            self.write.update();
            i += 1;
        }
        if self.free_space != 0 {
            self.last = self.index.from_sub(1);
        }
        i
    }
    pub fn encode(&mut self, dict: &mut DictBuffer) -> Triplet {
        let mut encoded = dict.lookup(&self.frame, &self.index, self.frame.len() - self.free_space);
        let lost = if encoded.is_last() {
            encoded.length - 1
        } else {
            encoded.length
        };
        dict.push_string(
            &self
                .index
                .range(lost + 1)
                .into_iter()
                .map(|ind| self.frame[ind])
                .collect::<String>(),
        );
        self.free_space += lost + 1;
        self.index.update_by(lost + 1);
        if self.free_space > self.frame.len() {
            encoded.symbol = END_SYMBOL;
            self.free_space = self.frame.len();
        }
        encoded
    }
    pub fn done(&self) -> bool {
        if self.free_space >= self.frame.len() {
            return true;
        }
        false
    }
}
#[derive(Debug)]
pub struct Decoder {
    frame: Vec<char>,
    index: Wrapper,
}
impl Decoder {
    fn new(size: usize) -> Self {
        Self {
            frame: vec![' '; size],
            index: Wrapper::new(size),
        }
    }
    pub fn from_string(&mut self, input: &[u8]) -> Result<String, DataStoreError> {
        fn parse_u8(parsed: &[Vec<u8>; 3]) -> Result<Triplet, DataStoreError> {
            let index: usize = match String::from_utf8_lossy(&parsed[0]).parse::<usize>() {
                Ok(i) => i,
                Err(_) => {
                    return Err(TripletError);
                }
            };
            let length: usize = match String::from_utf8_lossy(&parsed[1]).parse::<usize>() {
                Ok(i) => i,
                Err(_) => {
                    return Err(TripletError);
                }
            };
            let symbol: char = match String::from_utf8_lossy(&parsed[2]).chars().next() {
                Some(c) => c,
                None => return Err(TripletError),
            };
            Ok(Triplet::new(index, length, symbol))
        }
        let mut result: Vec<Triplet> = vec![];
        let mut parsed: [Vec<u8>; 3] = [vec![], vec![], vec![]];
        let mut counter = 0;
        for c in input.into_iter().skip(1) {
            if *c == DIVIDER as u8 {
                counter += 1;
                if counter % 3 == 0 {
                    result.push(parse_u8(&parsed)?);
                    parsed[0].clear();
                    parsed[1].clear();
                    parsed[2].clear();
                }
                continue;
            }
            parsed[counter % 3].push(*c);
        }
        result.push(parse_u8(&parsed)?);
        Ok(self.decode(&result))
    }
    pub fn decode(&mut self, input: &[Triplet]) -> String {
        let mut res = String::new();
        for trip in input {
            let i = Wrapper::from(trip.index, self.frame.len());
            let mut out_str = String::new();
            if trip.length != 0 {
                out_str = i
                    .range(trip.length)
                    .into_iter()
                    .map(|ind| self.frame[ind])
                    .collect::<String>();
                res.push_str(&out_str);
            }
            for c in out_str.chars() {
                self.frame[self.index.get()] = c;
                self.index.update();
            }
            if !trip.is_last() {
                res.push(trip.symbol);
                self.frame[self.index.get()] = trip.symbol;
                self.index.update();
            }
        }
        res
    }
}

fn encode_string(
    input: &String,
    dict_size: usize,
    input_size: usize,
    match_size: usize,
) -> Vec<u8> {
    let mut dict = if input.len() >= dict_size {
        DictBuffer::new(dict_size, match_size)
    } else {
        DictBuffer::new(input.len(), match_size)
    };
    let mut buff = if input.len() >= input_size {
        InputBuffer::new(input_size)
    } else {
        InputBuffer::new(input.len())
    };
    let mut consumed = 0;
    let mut out: Vec<u8> = vec![];
    let mut rdy = input.split_at(consumed).1;
    loop {
        let got = buff.feed(rdy);
        out.extend(buff.encode(&mut dict).to_u8().into_iter());
        consumed += got;
        if input.len() <= consumed {
            break;
        }
        rdy = input.split_at(consumed).1;
    }
    while !buff.done() {
        out.extend(buff.encode(&mut dict).to_u8().into_iter());
    }
    out
}

fn to_huffman(data: &[u8]) -> (Vec<u8>, HashMap<u8, usize>, usize) {
    let mut weights = HashMap::new();

    for &e in data {
        *weights.entry(e).or_insert(0) += 1;
    }
    let (codebook, _) = huffman_compress::codebook(&weights);
    let mut buffer = BitVec::default();
    for e in data {
        let _ = codebook.encode(&mut buffer, e);
    }
    (buffer.to_bytes(), weights, data.len())
}

fn from_huffman(
    encoded: &[u8],
    weights: &HashMap<u8, usize>,
    size: usize,
) -> Result<Vec<u8>, DataStoreError> {
    let buffer = BitVec::from_bytes(&encoded);
    let (_, tree) = huffman_compress::codebook(weights);
    let res = tree.decoder(&buffer, size).collect::<Vec<u8>>();
    if res.is_empty() {
        return Err(HuffmanReadError);
    }
    Ok(res)
}

fn to_file(
    data: &[u8],
    weights: &HashMap<u8, usize>,
    size: usize,
    buffer_size: usize,
    filename: String,
) -> Result<String, DataStoreError> {
    let mut new_name = filename.split('.').next().unwrap().to_string();
    new_name.push_str(".77");
    let mut file = std::fs::File::create(new_name.clone())?;
    bincode::serialize_into(&mut file, &(data, weights, size, buffer_size, filename))?;
    Ok(new_name)
}

fn from_file(
    filename: String,
) -> Result<(Vec<u8>, HashMap<u8, usize>, usize, usize, String), DataStoreError> {
    let file = std::fs::File::open(filename).map_err(InOutError)?;
    bincode::deserialize_from(&file).map_err(DeserializeError)
}

fn print_usage(program: &str, opts: Options) {
    let brief = format!("Usage: {} FILE [options]", program);
    print!("{}", opts.usage(&brief));
}

fn gen_options() -> Options {
    let mut opts = Options::new();
    opts.optopt("o", "out", "set output file name", "NAME");
    opts.optopt("d", "dict", "set dict buffer size in KB", "DICT_BUFF_SIZE");
    opts.optopt(
        "i",
        "input",
        "set input buffer sizein KB",
        "INPUT_BUFF_SIZE",
    );
    opts.optopt("m", "match", "set max match for search opt", "MAX_SIZE");
    opts.optflag("u", "decompress", "set programm to decompression mode");
    opts.optflag("h", "help", "print this help menu");
    opts
}

fn encode_to_file(
    dict_size: usize,
    input_size: usize,
    max_match: usize,
    out_file: String,
    in_file: &String,
) -> Result<String, DataStoreError> {
    let data = fs::read_to_string(in_file)?;
    let lz77_encoded = encode_string(&data, dict_size, input_size, max_match);
    let (encoded, weights, size) = to_huffman(&lz77_encoded);
    Ok(to_file(&encoded, &weights, size, dict_size, out_file)?)
}

fn decode_from_file(in_file: &String, out_file: String) -> Result<String, DataStoreError> {
    let (encoded, tree, size, buff_size, original_name) = from_file(in_file.to_string())?;
    let mut decoder = Decoder::new(buff_size);
    let decoded = decoder.from_string(&from_huffman(&encoded, &tree, size)?)?;
    let file_name = if out_file == "" {
        original_name
    } else {
        out_file
    };
    let mut file = File::create(file_name.clone())?;
    file.write_all(decoded.as_bytes())?;
    Ok(file_name)
}

fn main() -> Result<(), DataStoreError> {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();
    let opts = gen_options();
    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => return Err(WrongArg(f.to_string())),
    };
    if matches.opt_present("h") {
        print_usage(&program, opts);
        return Ok(());
    }
    if matches.free.is_empty() {
        print_usage(&program, opts);
        return Err(NoFile);
    } else if matches.free.len() > 1 {
        print_usage(&program, opts);
        return Err(WrongArg(
            matches
                .free
                .into_iter()
                .skip(1)
                .collect::<Vec<String>>()
                .join(" "),
        ));
    }
    let file_name = matches.free[0].clone();
    let out_file = matches.opt_str("o").unwrap_or(if matches.opt_present("u") {
        String::new()
    } else {
        file_name.clone()
    });
    let dict_size = matches
        .opt_str("d")
        .unwrap_or(DICT_SIZE.to_string())
        .parse::<usize>()
        .map_err(|v| WrongArg(v.to_string()))?
        * 1024;
    let input_size = matches
        .opt_str("i")
        .unwrap_or(INPUT_SIZE.to_string())
        .parse::<usize>()
        .map_err(|v| WrongArg(v.to_string()))?
        * 1024;
    let max_match = matches
        .opt_str("m")
        .unwrap_or(MAX_MATCH.to_string())
        .parse::<usize>()
        .map_err(|v| WrongArg(v.to_string()))?;
    if matches.opt_present("u") {
        println!("Decoding {}...", file_name.clone());
        println!(
            "Done, decoded file in {}",
            decode_from_file(&file_name, out_file.clone())?
        );
    } else {
        println!("Encoding {}...", file_name.clone());
        println!(
            "Done, encoded file in {}",
            encode_to_file(
                dict_size,
                input_size,
                max_match,
                out_file.clone(),
                &file_name,
            )?
        );
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn lipsum_triplet_encode_decode() {
        let w = &lipsum(100);
        for i in 2..32 {
            for j in 2..32 {
                for k in 2..20 {
                    let mut dict = DictBuffer::new(i, k);
                    let mut buff = InputBuffer::new(j);
                    let mut consumed = 0;
                    let mut out: Vec<Triplet> = vec![];
                    let mut rdy = w.split_at(consumed).1;
                    loop {
                        let got = buff.feed(rdy);
                        out.push(buff.encode(&mut dict));
                        consumed += got;
                        if w.len() <= consumed {
                            break;
                        }
                        rdy = w.split_at(consumed).1;
                    }
                    while !buff.done() {
                        out.push(buff.encode(&mut dict));
                    }
                    let mut decoder = Decoder::new(i);
                    assert_eq!(
                        w,
                        &decoder.decode(&out),
                        "DICT-SIZE: {} INPUT_SIZE: {}, word: {}",
                        i,
                        j,
                        w
                    );
                }
            }
        }
    }
    #[test]
    fn triplet_encode_decode() {
        let words = [
            "11111111111111111111111111111111",
            "112312312312312312312312",
            "",
            "adhgrjgnmqwbeuidnemrjr",
            "ababababadjfjjvjjjjvjjvvvvff",
        ];
        for w in words.iter() {
            for i in 2..32 {
                for j in 2..32 {
                    for k in 2..20 {
                        let mut dict = DictBuffer::new(i, k);
                        let mut buff = InputBuffer::new(j);
                        let mut consumed = 0;
                        let mut out: Vec<Triplet> = vec![];
                        let mut rdy = w.split_at(consumed).1;
                        loop {
                            let got = buff.feed(rdy);
                            out.push(buff.encode(&mut dict));
                            consumed += got;
                            if w.len() <= consumed {
                                break;
                            }
                            rdy = w.split_at(consumed).1;
                        }
                        while !buff.done() {
                            out.push(buff.encode(&mut dict));
                        }
                        let mut decoder = Decoder::new(i);
                        assert_eq!(
                            w,
                            &decoder.decode(&out),
                            "DICT-SIZE: {} INPUT_SIZE: {}, word: {}",
                            i,
                            j,
                            w
                        );
                    }
                }
            }
        }
    }
    #[test]
    fn triplet_to_from_string() {
        let w = &lipsum(100);
        for i in 2..32 {
            for j in 2..32 {
                for k in 2..20 {
                    let res = encode_string(&w, i, j, k);
                    let mut decoder = Decoder::new(i);
                    let decoded = decoder.from_string(&res).unwrap();
                    assert!(*w == decoded);
                }
            }
        }
    }
    #[test]
    fn huffman_coding() {
        let w = lipsum(1000);
        let res = encode_string(&w, 1000, 100, 1);
        let (encoded, tree, size) = to_huffman(&res);
        let mut decoder = Decoder::new(1000);
        let decoded = decoder
            .from_string(&from_huffman(&encoded, &tree, size).unwrap())
            .unwrap();
        assert!(w == decoded);
    }
    #[test]
    fn file_serialization() {
        let w = lipsum(5000);
        let res = encode_string(&w, 5000, 1000, 1);
        let (encoded, weights, size) = to_huffman(&res);
        to_file(&encoded, &weights, size, 5000, "test.77".into());
        let (encoded, weights, size, buff_size, _) = from_file("test.77".into()).unwrap();
        let mut decoder = Decoder::new(buff_size);
        let decoded = decoder
            .from_string(&from_huffman(&encoded, &weights, size).unwrap())
            .unwrap();
        fs::remove_file("test.77");
        assert!(w == decoded);
    }
}
