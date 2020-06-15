use lipsum::lipsum;
use std::collections::HashMap;
use std::collections::VecDeque;

pub const DICT_SIZE: usize = 3; // at least 2
pub const INPUT_SIZE: usize = 3; // at least 2
pub const MAX_MATCH: usize = 1;

#[derive(Debug)]
pub struct DictBuffer {
    frame: Vec<char>,
    indexes: HashMap<String, VecDeque<usize>>,
    start: Wrapper,
}

impl DictBuffer {
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
        let rmv = if input.len() > self.frame.len() {
            input.len() - self.frame.len()
        } else {
            0
        };
        self.add_new_indexses(&input.chars().skip(rmv).collect::<String>());
    }
    fn lookup(&self, word: &Vec<char>, index: &Wrapper, last: usize) -> Triplet {
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
    fn longest_match(&self, start: usize, word: &Vec<char>, ind: &Wrapper, last: usize) -> usize {
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
            //println!("xD {} {} {} {}", self.index, self.size, self.size - diff, i);
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
pub struct InputBuffer {
    frame: Vec<char>,
    free_space: usize,
    index: Wrapper,
    last: usize,
    write: Wrapper,
}
impl InputBuffer {
    pub fn new(size: usize) -> Self {
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
        let lost = if encoded.symbol == '\0' {
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
            encoded.last = true;
            encoded.symbol = '\0';
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
            let mut out_str = String::new();
            if trip.length != 0 {
                out_str = i
                    .range(trip.length)
                    .into_iter()
                    .map(|ind| self.frame[ind])
                    .collect::<String>();
                res.push_str(&out_str);
            }
            if !trip.last {
                res.push(trip.symbol);
            }
            for c in out_str.chars() {
                self.frame[self.index.get()] = c;
                self.index.update();
            }
            if trip.symbol != '\0' {
                self.frame[self.index.get()] = trip.symbol;
                self.index.update();
            }
        }
        res
    }
}

fn main() {
    let mut dict = DictBuffer::new(DICT_SIZE);
    let mut buff: InputBuffer = InputBuffer::new(INPUT_SIZE);
    let w = "fdhfhfhhdhd";
    let mut consumed = 0;
    let mut out: Vec<Triplet> = vec![];

    let mut rdy = w.split_at(consumed).1;
    //println!("rdy: {} {}", rdy, consumed);
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
    let mut decoder = Decoder::new(DICT_SIZE);
    println!("out:{:?}\n{:?}\n{:?}", out, dict, buff);
    assert_eq!(w, &decoder.decode(&out));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_1() {
        let w = &lipsum(1000);
        //    for w in words.iter() {
        for i in 64..128 {
            for j in 64..128 {
                let mut dict = DictBuffer::new(i);
                let mut buff = InputBuffer::new(j);
                let mut consumed = 0;
                let mut out: Vec<Triplet> = vec![];
                let mut rdy = w.split_at(consumed).1;
                //println!("rdy: {} {}", rdy, consumed);
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
        //}
    }
}
