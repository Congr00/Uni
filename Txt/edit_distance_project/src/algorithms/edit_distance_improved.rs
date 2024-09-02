use std::cmp::min;
use crate::helper;

/*
O(n*d) edit distance algorithm.
It assumes d and calculates a fraction of dxd values in NxN matrix
If assumed d is wrong, we start over with new d=d*2
*/
fn edit_distance(s1: &str, s2: &str, 𝜁: &[usize], 𝛼: usize, 𝛿: usize) -> usize{
    // we guess our distance as 0
    let mut d = 0;
    assert_eq!(s1.len(), s1.as_bytes().len(), "Strings can't contain special characters");
    assert_eq!(s2.len(), s2.as_bytes().len(), "Strings can't contain special characters");
    let (s1, s2) = if s1.len() > s2.len() { (s1.as_bytes(), s2.as_bytes()) } else { (s2.as_bytes(), s1.as_bytes()) };
    let r = s1.len();
    // like in naive version, we keep 2 rows at a time - upper and lower
    let mut row1: Vec<usize> = vec![];
    // while d is less then string length
    while d <= s2.len(){
        // init first row with values in range 0..d+1
        row1 = (0..(d+1)).into_iter().collect::<Vec<usize>>();
        //init lower row
        let mut row2: Vec<usize>;
        // iterate for each vector in matrix NxN
        for j in 0..r{
            let m = if j < d { 0 }         else { j - d + 1 };
            let b = if j < d { j + d + 1 } else { d * 2 };
            row1.push(*row1.last().unwrap()+1);
            // some if's and hacking to het vector of different size each iteration
            if m == 0 { row2 = vec![row1[0]+𝛼]; }
            else {
                if s1[j] == s2[m-1]{ row2 = vec![row1[0]+𝜁[0]]; }
                else               { row2 = vec![min(row1[0]+𝜁[1], row1[1]+𝛼)]; }
            }
            let o = if m == 0 { 1 } else { 0 };
            for i in m..m+b{
                // fill values for second vector using standard minima checking on neighbors
                if s1[j] == s2[i] { row2.push(row1[row2.len()-o]+𝜁[0]); }
                else              { row2.push(min(min(row1[row2.len()-o]+𝜁[1], *row2.last().unwrap()+𝛿), row1[row2.len()+1-o]+𝛼)); }
                if i >= r-1 { break; }
            }
            // swap first row with second
            row1 = row2;
        }
        // if value in last row is greater then d, we need to increase d and check again
        if *row1.last().unwrap() > d{
            if d == r { break; }
            d = if d == 0 { 1 } else { min(d*2, r) };
        }
        else { break; }
    }
    // return last value of vector
    return *row1.last().unwrap();
}

pub fn lcs(s1: &String, s2: &String) -> usize{
    return (s1.len() + s2.len() - edit_distance(s1, s2, &[0, 2], 1, 1)) / 2;
}

#[cfg(test)]
mod edit_distance_improved_tests {
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