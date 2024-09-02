use lipsum::lipsum;
use rand::distributions::{Distribution, Alphanumeric};
use rand::prelude::*;

pub fn generate_lipsum(size: usize) -> String {
    let mut res = lipsum(size);
    res.retain(|c| c.is_alphanumeric());
    res.chars().take(size).collect::<String>()
}

pub fn generate_similar_string(size: usize, diff_const: usize) -> (String, String){
    assert!(diff_const < (size / 2), "Const is too big");
    let mut rng = rand::thread_rng();
    let s1 = generate_random(size);
    let mut s2 = s1.clone().chars().collect::<Vec<char>>();
    let mut indexses = (0..s2.len()).collect::<Vec<usize>>();
    let cons = size / diff_const / 2;
    indexses.shuffle(&mut rng);
    for t in indexses.chunks(2).take(cons){
        let (i1, i2) = (t[0], t[1]);
        let c1 = s2[i1];
        s2[i1] = s2[i2];
        s2[i2] = c1;
    }
    (s1, s2.into_iter().collect())
}

pub fn generate_random(size: usize) -> String {
    let mut rng = rand::thread_rng();
    Alphanumeric
        .sample_iter(&mut rng)
        .take(size)
        .map(char::from)
        .collect()
}

pub fn lcs_naive(text1: String, text2: String) -> i32 {
    let mut t1: Vec<char> = text1.chars().collect();
    let mut t2: Vec<char> = text2.chars().collect();

    if t2.len() < t1.len() {
        std::mem::swap(&mut t1, &mut t2);
    }

    let mut prev: Vec<i32> = vec![0; t1.len() + 1];

    for (col, _) in t2.iter().enumerate().rev() {
        let mut cur: Vec<i32> = vec![0; t2.len() + 1];

        for (row, _) in t1.iter().enumerate().rev() {
            if t1[row] == t2[col] {
                cur[row] = 1 + prev[row + 1];
            } else {
                cur[row] = std::cmp::max(prev[row], cur[row + 1]);
            }
        }
        prev = cur;
    }

    prev[0]
}