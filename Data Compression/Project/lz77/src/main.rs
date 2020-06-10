use std::collections::HashMap;
use std::collections::VecDeque;

pub const DICT_SIZE: usize = 3; // at least 2
pub const INPUT_SIZE: usize = 2; // at least 2
pub const MAX_MATCH: usize = 1;
#[derive(Debug)]
pub struct DictBuffor {
    frame: Vec<char>,
    indexes: HashMap<String, VecDeque<usize>>,
    start: Wrapper,
}

impl DictBuffor {
    pub fn new(size: usize) -> Self {
        Self {
            frame: vec![' '; size],
            indexes: HashMap::new(),
            start: Wrapper::new(size),
        }
    }
    pub fn push_string(&mut self, input: &String) {
        self.remove_old_indexes(input.len());
        for c in input.chars() {
            self.frame[self.start.get()] = c;
            self.start.update();
        }
        self.add_new_indexses(input);
    }
    fn lookup(&self, word: &Vec<char>, index: &Wrapper, last: usize) -> Triplet {
        for i in 1..=MAX_MATCH {
            let match_str: String = index.range(i).into_iter().map(|ind| word[ind]).collect();
            println!("{:?}", self.indexes);
            let (len, id) = match self.indexes.get(&match_str) {
                Some(ind) => match ind
                    .into_iter()
                    .map(|&i| (self.longest_match(i, word, index, last), i))
                    .max()
                {
                    Some(val) => val,
                    None => (0, 0),
                },
                None => (0, 0),
            };
            if len != 0 {
                return match word.get(index.from_add(len)) {
                    Some(c) => Triplet::new(id, len, *c),
                    None => Triplet::last(id, len),
                };
            }
        }
        Triplet::empty(word[index.get()])
    }
    fn longest_match(&self, start: usize, word: &Vec<char>, ind: &Wrapper, last: usize) -> usize {
        let mut length: usize = 0;
        let mut ptr = Wrapper::from(start, self.frame.len());
        let index = ind;
        println!(
            "word: {:?}, {:?}, {:?}, last: {}, start: {}",
            word, index, self.frame, last, start
        );
        for i in index.range(word.len()) {
            let c = word[i];
            if self.frame[ptr.get()] == c && i != last {
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
        if self.index < i {
            let diff = (i - self.index) % self.size;
            return self.size - diff;
        }
        self.index - i
    }
    fn from_add(self, i: usize) -> usize {
        if self.index + i >= self.size {
            println!(
                "{} {} {} {}",
                self.index,
                i,
                self.size,
                (self.index + i) % self.size
            );
            return (self.index + i) % self.size;
        }
        self.index + i
    }
    fn get(self) -> usize {
        self.index
    }
    fn update(&mut self) {
        if self.index + 1 == self.size {
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
            let diff = self.size - self.index;
            if (size - diff) > self.size {
                return (self.index..self.size)
                    .chain((0..self.size).cycle().take(size - diff))
                    .collect();
            } else {
                return (self.index..self.size).chain(0..(size - diff)).collect();
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
    pub last: bool,
}
impl Triplet {
    fn new(index: usize, len: usize, symbol: char) -> Self {
        Self {
            index: index,
            length: len,
            symbol: symbol,
            last: false,
        }
    }
    fn empty(symbol: char) -> Self {
        Self {
            index: 0,
            length: 0,
            symbol: symbol,
            last: false,
        }
    }
    fn last(index: usize, len: usize) -> Self {
        Self {
            index: index,
            length: len,
            symbol: '\0',
            last: true,
        }
    }
}
#[derive(Debug)]
pub struct InputBuffor {
    frame: Vec<char>,
    free_space: usize,
    index: Wrapper,
    last: usize,
}
impl InputBuffor {
    pub fn new(size: usize) -> Self {
        Self {
            frame: vec![' '; size],
            free_space: size,
            index: Wrapper::new(size),
            last: 0,
        }
    }
    pub fn feed(&mut self, data: &str) -> usize {
        let mut i = Wrapper::from(self.index.get(), self.frame.len());
        for c in data.chars() {
            if self.free_space == 0 {
                break;
            }
            self.last += 1;
            self.frame[i.get()] = c;
            self.free_space -= 1;
            i.update();
        }
        self.free_space
    }
    pub fn encode(&mut self, dict: &mut DictBuffor) -> Triplet {
        let mut encoded = dict.lookup(&self.frame, &self.index, self.last);
        let lost = encoded.length;
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
            encoded.last = true;
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
    pub fn decode(&mut self, input: &Vec<Triplet>) -> String {
        let mut res = String::new();
        for trip in input {
            let mut i = Wrapper::from(trip.index, self.frame.len());
            if trip.length != 0 {
                println!(
                    "{:?}, {:?}, indexes {:?}, trip {:?}",
                    self.frame,
                    i,
                    i.range(trip.length)
                        .into_iter()
                        .map(|i| i)
                        .collect::<Vec<usize>>(),
                    trip
                );
                res.push_str(
                    &i.range(trip.length)
                        .into_iter()
                        .map(|ind| self.frame[ind])
                        .collect::<String>(),
                );
            }
            if !trip.last {
                res.push(trip.symbol);
            }
            for _ in 0..trip.length {
                self.frame[self.index.get()] = self.frame[i.get()];
                i.update();
                self.index.update();
            }
            self.frame[self.index.get()] = trip.symbol;
            self.index.update();
        }
        res
    }
}

fn main() {
    let mut dict = DictBuffor::new(DICT_SIZE);
    let mut buff: InputBuffor = InputBuffor::new(INPUT_SIZE);
    let w = "abcabcabc";
    let mut consumed = 0;
    let mut out: Vec<Triplet> = vec![];
    loop {
        let (_, rdy) = w.split_at(consumed);
        buff.feed(rdy);
        println!("rdy: {} {}", rdy, consumed);
        while !buff.done() {
            out.push(buff.encode(&mut dict));
        }
        consumed += INPUT_SIZE;
        if consumed >= w.len() {
            break;
        }
    }
    let mut decoder = Decoder::new(DICT_SIZE);
    assert_eq!(w, &decoder.decode(&out));
    println!("out:{:?}\n{:?}\n{:?}", out, dict, buff);
    let mut decoder = Decoder::new(DICT_SIZE);
    println!("{}", decoder.decode(&out));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_1() {
        let words = [
            "abcabcabc",
            "abcabc123",
            "abc123123abc",
            "111111111111111111111111111111",
            "abcabcabcabcabcabcabcabcabcabca",
        ];
        for w in words.iter() {
            for i in 2..32 {
                for j in 2..32 {
                    println!("DICT-SIZE: {} INPUT_SIZE: {}", i, j);
                    let mut dict = DictBuffor::new(i);
                    let mut buff = InputBuffor::new(j);
                    let mut consumed = 0;
                    let mut out: Vec<Triplet> = vec![];
                    loop {
                        let (_, rdy) = w.split_at(consumed);
                        buff.feed(rdy);
                        while !buff.done() {
                            out.push(buff.encode(&mut dict));
                        }
                        consumed += j;
                        if consumed >= w.len() {
                            break;
                        }
                    }
                    let mut decoder = Decoder::new(i);
                    assert_eq!(w, &decoder.decode(&out));
                }
            }
        }
    }
}
