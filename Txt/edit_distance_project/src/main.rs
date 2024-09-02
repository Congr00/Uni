#![feature(non_ascii_idents)]
#![allow(less_used_codepoints)]

use edit_distance::edit_distance_basic;
use edit_distance::edit_distance_improved;
use edit_distance::helper;

fn main(){
/*
    let word = "abcba$bacbb";
    let w1 = "oH22";//"CLF2";
    let w2 = "Yo22";//"LD22";

    println!("{}  |  {}", w1, w2);
    println!("edit_distance: {}", edit_distance_adv::lcs(w1, w2));*/
}

#[cfg(test)]
mod regression_tests {
    use super::*;
    #[test]
    fn random_lipsum_lcs(){
        for _ in 0..100{
            let s1 = helper::generate_lipsum(1000);
            let s2 = helper::generate_lipsum(1000);
            assert_eq!(s1.len(), s2.len(), "Input strings are of a different size");
            assert_eq!(edit_distance_basic::lcs(&s1, &s2), edit_distance_improved::lcs(&s1, &s2) as usize);
        }
    }
    #[test]
    fn random_input_lcs(){
        for _ in 0..100{
            let s1 = helper::generate_random(1000);
            let s2 = helper::generate_random(1000);
            assert_eq!(s1.len(), s2.len(), "Input strings are of a different size");
            assert_eq!(edit_distance_basic::lcs(&s1, &s2), edit_distance_improved::lcs(&s1, &s2) as usize);
        }
    }
}