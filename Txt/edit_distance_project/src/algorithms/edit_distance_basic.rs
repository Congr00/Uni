use std::cmp::min;
use crate::helper;

/*
basic O(n^2) edit distance algorithm
*/
fn edit_distance(s1: &str, s2: &str, 𝜁: &[usize], 𝛼: usize, 𝛿: usize) -> usize{
    assert_eq!(s1.len(), s1.as_bytes().len(), "Strings can't contain special characters");
    assert_eq!(s2.len(), s2.as_bytes().len(), "Strings can't contain special characters");
    let (s1, s2) = if s1.len() > s2.len() { (s1.as_bytes(), s2.as_bytes()) } else { (s2.as_bytes(), s1.as_bytes()) };
    let mut row1 = (0..(s1.len()+1)).into_iter().collect::<Vec<usize>>();
    let mut row2 = vec![];
    for j in 0..s1.len(){
        for i in 0..s2.len()+1 {
            if i == 0                { row2.push(j+1) }
            else if s1[j] == s2[i-1] { row2.push(row1[i-1]+𝜁[0]) }
            else                     { row2.push(min(min(row1[i]+𝛼, row2[i-1]+𝛿), row1[i-1]+𝜁[1])) }
        }
        row1 = row2;
        row2 = vec![];
    }
    return *row1.last().unwrap();
}

pub fn lcs(s1: &String, s2: &String) -> usize{
    return (s1.len() + s2.len() - edit_distance(&s1, &s2, &[0, 2], 1, 1)) / 2;
}

#[cfg(test)]
mod edit_distance_basic_tests {
    use super::*;
    #[test]
    fn random_lipsum_lcs(){
        for _ in 0..100{
            let s1 = helper::generate_lipsum(1000);
            let s2 = helper::generate_lipsum(1000);
            assert_eq!(s1.len(), s2.len(), "Input strings are of a different size");
            assert_eq!(lcs(&s1.clone(), &s2.clone()), helper::lcs_naive(s1, s2) as usize);
        }
    }
    #[test]
    fn random_input_lcs(){
        for _ in 0..100{
            let s1 = helper::generate_random(1000);
            let s2 = helper::generate_random(1000);
            assert_eq!(s1.len(), s2.len(), "Input strings are of a different size");
            assert_eq!(lcs(&s1.clone(), &s2.clone()), helper::lcs_naive(s1, s2) as usize);
        }
    }
}