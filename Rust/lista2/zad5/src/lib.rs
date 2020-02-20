
pub fn next_bigger_number(n: i64) -> i64 {
    let vec:Vec<u32> = n.to_string()
            .chars()
            .map(|c| c.to_digit(10).unwrap())
            .collect::<Vec<_>>();
    if vec.len() < 2 { return -1 };
    for n in (0..=vec.len()-2).rev() {
        let prev = vec[n+1];
        if prev > vec[n]{
            let mut n_bigger = n+1;
            for m in n+2..vec.len(){
                if vec[m] < vec[n_bigger] && vec[m] > vec[n]{
                    n_bigger = m;
                }
            }
            let mut n_vec:Vec<u32> = vec.clone();
            n_vec[n] = vec[n_bigger];
            n_vec[n_bigger] = vec[n];
            let mut tmp:Vec<u32> = n_vec.clone();
            let slice = &mut tmp[n+1..];
            slice.sort();

            for m in 0..slice.len(){
                n_vec[n+1+m] = slice[m]; 
            }
            return vec_to_int(&n_vec);
        }
    }
    return -1;
}

fn vec_to_int(vec: &[u32]) -> i64{
    vec.into_iter().map(|el| el.to_string()).collect::<String>().parse().unwrap()
}

#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        assert_eq!(21, super::next_bigger_number(12));  
        assert_eq!(531, super::next_bigger_number(513));
        assert_eq!(2071, super::next_bigger_number(2017));
        assert_eq!(441, super::next_bigger_number(414));
        assert_eq!(414, super::next_bigger_number(144));
        assert_eq!(1234567908, super::next_bigger_number(1234567890));
        assert_eq!(-1, super::next_bigger_number(99999990));
        assert_eq!(-1, super::next_bigger_number(10));
        assert_eq!(-1, super::next_bigger_number(5));
        assert_eq!(-1, super::next_bigger_number(9876543210));
    }
}