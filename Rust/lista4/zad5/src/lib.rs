use std::collections::HashMap;
pub fn sum_pairs(ints: &[i8], s: i8) -> Option<(i8, i8)> {
    let mut pairs = HashMap::new();
    ints.iter().fold(0usize, |acc, i|{
        match pairs.get(i){
            None         => { pairs.insert(i, (acc, 1)); }
            Some((_, 1)) => { *pairs.get_mut(i).unwrap() = (acc, 2); }
            _            => {}
        }
        acc+1
    });
    let mut worst = ints.len()+1;
    let mut _match = None;
    for i in ints{
        match pairs.get(&(s-i)){
            Some((len, count)) => {
                if len > &pairs.get(i).unwrap().0 || count == &2 {
                    if worst > *len {
                            _match = Some((*i, s-i));
                            worst = *len;
                    }
                }
            }
            None => {}
        }
    }
    return _match;
}

#[cfg(test)]
mod tests {
    #[test]
    fn returns_expected() {
        let l1 = [1, 4, 8, 7, 3, 15];
        let l2 = [1, -2, 3, 0, -6, 1];
        let l3 = [20, -13, 40];
        let l4 = [1, 2, 3, 4, 1, 0, 1, 1, 1];
        let l5 = [10, 5, 2, 3, 7, 5];
        let l6 = [4, -2, 3, 3, 4];
        let l7 = [0, 2, 0];
        let l8 = [5, 9, 13, -3];
        let l9 = [];
        assert_eq!(super::sum_pairs(&l1, 8), Some((1, 7)));
        assert_eq!(super::sum_pairs(&l2, -6), Some((0, -6)));
        assert_eq!(super::sum_pairs(&l3, -7), None);
        assert_eq!(super::sum_pairs(&l4, 2), Some((1, 1)));
        assert_eq!(super::sum_pairs(&l5, 10), Some((3, 7)));
        assert_eq!(super::sum_pairs(&l6, 8), Some((4, 4)));
        assert_eq!(super::sum_pairs(&l7, 0), Some((0, 0)));
        assert_eq!(super::sum_pairs(&l8, 10), Some((13, -3)));
        assert_eq!(super::sum_pairs(&l9, 10), None);
        assert_eq!(super::sum_pairs(&l8, 2), Some((5, -3)));
        assert_eq!(super::sum_pairs(&l8, 6), Some((9, -3)));
        assert_eq!(super::sum_pairs(&l8, 0), None);
    }
}
