extern crate getopts;
use bit_vec::BitVec;

use crate::consts::{
    u32_to_u8, u8_to_u32, DataStoreError, DIVIDER, END_SYMBOL, MAX_MATCH, MIN_LEN,
};

use fnv::FnvHashMap;
#[cfg(test)]
use lipsum::lipsum;
use std::fs;
use std::fs::File;

use std::collections::HashMap;
use std::collections::VecDeque;
use std::io::prelude::*;

use DataStoreError::*;

#[derive(Debug)]
pub struct DictBuffer {
    frame: Vec<char>,
    indexes: FnvHashMap<String, VecDeque<usize>>,
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
            indexes: FnvHashMap::default(),
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
                        // .take(10)
                        .map(|&i| (self.longest_match(i, word, index, last), i))
                        .max()
                })
                .unwrap_or_else(|| (0, 0));
            if len > MIN_LEN {
                return Triplet::new(id, len);
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
    pub single: bool,
}
impl Triplet {
    fn new(index: usize, len: usize) -> Self {
        Self {
            index: index,
            length: len,
            symbol: END_SYMBOL,
            single: false,
        }
    }
    fn empty(symbol: char) -> Self {
        Self {
            index: 0,
            length: 1,
            symbol: symbol,
            single: true,
        }
    }
    fn to_u8(self) -> Vec<u8> {
        let div = DIVIDER as u8;
        let mut res = vec![];
        res.push(div.clone());
        if self.single {
            let bytes = self.symbol.to_string().into_bytes();
            if (bytes[0] & 0x80) != 0 || (bytes[0] == 0) {
                res.push(0x00 as u8);
            }
            for c in bytes {
                res.push(c);
            }
        } else {
            let mut bytes = self.index.to_string().into_bytes();
            if (bytes[0] & 0x80) != 0 {
                res.push(0x80 as u8);
            } else {
                bytes[0] |= 0x80;
            }
            for c in bytes {
                res.push(c);
            }
            res.push(div);
            for c in self.length.to_string().into_bytes() {
                res.push(c);
            }
        }
        res
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
        let encoded = dict.lookup(&self.frame, &self.index, self.frame.len() - self.free_space);
        let lost = encoded.length;
        dict.push_string(
            &self
                .index
                .range(lost)
                .into_iter()
                .map(|ind| self.frame[ind])
                .collect::<String>(),
        );
        self.free_space += lost;
        self.index.update_by(lost);
        if self.free_space > self.frame.len() {
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
        fn parse_u8symbol(parsed: &[Vec<u8>]) -> Result<Triplet, DataStoreError> {
            let mut sym_u8 = parsed[0].clone();
            if parsed[0][0] == 0 {
                sym_u8 = sym_u8.drain(1..).collect::<Vec<u8>>();
            }
            let symbol: char = match String::from_utf8_lossy(&sym_u8).chars().next() {
                Some(c) => c,
                None => return Err(TripletError),
            };
            Ok(Triplet::empty(symbol))
        }
        fn parse_u8(parsed: &[Vec<u8>; 2]) -> Result<Triplet, DataStoreError> {
            let mut ind_u8 = parsed[0].clone();
            if (parsed[0][0] & 0x80) == 1 {
                ind_u8 = ind_u8.drain(1..).collect::<Vec<u8>>();
            } else {
                ind_u8[0] = ind_u8[0] << 1;
                ind_u8[0] = ind_u8[0] >> 1;
            }
            let index: usize = match String::from_utf8_lossy(&ind_u8).parse::<usize>() {
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
            Ok(Triplet::new(index, length))
        }
        let mut result: Vec<Triplet> = vec![];
        let mut parsed: [Vec<u8>; 2] = [vec![], vec![]];
        let mut counter = 0;
        let mut first = true;
        let mut parse_symbol = false;
        for c in input.into_iter().skip(1) {
            if *c == DIVIDER as u8 {
                counter += 1;
                if parse_symbol && counter == 1 {
                    result.push(parse_u8symbol(&parsed)?);
                    parsed[0].clear();
                    parsed[1].clear();
                    counter = 0;
                    first = true;
                } else if counter == 2 {
                    counter = 0;
                    result.push(parse_u8(&parsed)?);
                    parsed[0].clear();
                    parsed[1].clear();
                    first = true;
                }
                continue;
            }
            if first {
                first = false;
                parse_symbol = (c >> 7) == 0;
            }
            parsed[counter].push(*c);
        }
        if counter == 0 {
            result.push(parse_u8symbol(&parsed)?);
        } else if counter == 1 {
            result.push(parse_u8(&parsed)?);
        }
        Ok(self.decode(&result))
    }

    pub fn decode(&mut self, input: &[Triplet]) -> String {
        let mut res = String::new();
        for trip in input {
            let i = Wrapper::from(trip.index, self.frame.len());
            let mut out_str = String::new();
            if trip.length > 1 {
                out_str = i
                    .range(trip.length)
                    .into_iter()
                    .map(|ind| self.frame[ind])
                    .collect::<String>();
                res.push_str(&out_str);
            } else {
                res.push(trip.symbol);
                self.frame[self.index.get()] = trip.symbol;
                self.index.update();
            }
            for c in out_str.chars() {
                self.frame[self.index.get()] = c;
                self.index.update();
            }
        }
        res
    }
}

pub fn encode_string(
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
    loop {
        let got = buff.feed(&input[consumed..input.len()]);
        out.extend(buff.encode(&mut dict).to_u8().into_iter());
        consumed += got;
        if input.len() <= consumed {
            break;
        }
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
    new_name.push_str(".ss");
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

pub fn encode_to_u8(
    input: &String,
    dict_size: usize,
    input_size: usize,
    max_match: usize,
) -> Result<Vec<u8>, DataStoreError> {
    let lzss_encoded = encode_string(&input, dict_size, input_size, max_match);
    let (encoded, _, _) = to_huffman(&lzss_encoded);
    Ok(encoded)
}

pub fn encode_to_file(
    dict_size: usize,
    input_size: usize,
    max_match: usize,
    out_file: String,
    in_file: &String,
) -> Result<String, DataStoreError> {
    let data = fs::read_to_string(in_file)?;
    let lzss_encoded = encode_string(&data, dict_size, input_size, max_match);
    let (encoded, weights, size) = to_huffman(&lzss_encoded);
    Ok(to_file(&encoded, &weights, size, dict_size, out_file)?)
}

pub fn decode_from_file(in_file: &String, out_file: String) -> Result<String, DataStoreError> {
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

#[cfg(test)]
mod lzss_tests {
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
    fn triplet_encode_decode_lzss() {
        let words = [
            "11111111111111111111111111111111",
            "112312312312312312312312",
            " ",
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
    fn triplet_to_from_string_lzss() {
        let w = &lipsum(100);
        for i in 2..100 {
            for j in 2..32 {
                for k in 2..20 {
                    let res = encode_string(&w, i, j, k);
                    let mut decoder = Decoder::new(i);
                    let decoded = decoder.from_string(&res).unwrap();
                    if (*w != decoded) {
                        println!("w:\n{}|\ndebug:\n{}|", w, decoded);
                    }
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
    fn file_serialization_lzss() {
        let w = lipsum(5000);
        let res = encode_string(&w, 5000, 1000, 1);
        let (encoded, weights, size) = to_huffman(&res);
        to_file(&encoded, &weights, size, 5000, "test.ss".into());
        let (encoded, weights, size, buff_size, _) = from_file("test.ss".into()).unwrap();
        let mut decoder = Decoder::new(buff_size);
        let decoded = decoder
            .from_string(&from_huffman(&encoded, &weights, size).unwrap())
            .unwrap();
        fs::remove_file("test.ss");
        assert!(w == decoded);
    }
    #[test]
    fn more_lipsum_lzss() {
        for _ in 0..10 {
            let w = lipsum(10000);
            let res = encode_string(&w, 5000, 1000, 2);
            let (encoded, weights, size) = to_huffman(&res);
            to_file(&encoded, &weights, size, 5000, "test.ss".into());
            let (encoded, weights, size, buff_size, _) = from_file("test.ss".into()).unwrap();
            let mut decoder = Decoder::new(buff_size);
            let decoded = decoder
                .from_string(&from_huffman(&encoded, &weights, size).unwrap())
                .unwrap();
            fs::remove_file("test.ss");
            assert!(w == decoded);
        }
    }
    #[test]
    fn testin_lzss() {
        let w = String::from("tetesrererereqweqwwwwwwwwwwwww");
        let res = encode_string(&w, 5, 5, 2);
        let mut decoder = Decoder::new(5);
        let decoded = decoder.from_string(&res).unwrap();
        println!("w: \n{}\ndecoded: \n{}", w, decoded);
        assert!(w == decoded);
    }
}
