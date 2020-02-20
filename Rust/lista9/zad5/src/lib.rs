pub mod solution {
    
    pub fn range_extraction(a: &[i32]) -> String {
        let mut res = String::new();        
        a.into_iter().chain(vec![&(a[a.len()-1]+2)].into_iter()).fold(vec![], |mut acc, &i|{
            if acc.is_empty() || i == (acc.last().unwrap()+1) { acc.push(i); }
            else if acc.len() > 2 { 
                res = format!("{}{}-{},", res, acc.first().unwrap().to_string(), acc.last().unwrap().to_string());
                acc.clear();
                acc.push(i);
            }
            else if acc.len() == 2 { 
                res = format!("{}{},{},", res, acc.first().unwrap().to_string(), acc.last().unwrap().to_string());
                acc.clear();
                acc.push(i);
            }
            else { res = format!("{}{},", res, acc.first().unwrap().to_string()); acc.clear(); acc.push(i); }
            acc
        });
        res.pop();
        res
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn example() {
        assert_eq!("-6,-3-1,3-5,7-11,14,15,17-20", solution::range_extraction(&[-6,-3,-2,-1,0,1,3,4,5,7,8,9,10,11,14,15,17,18,19,20]));	
        assert_eq!("-3--1,2,10,15,16,18-20", solution::range_extraction(&[-3,-2,-1,2,10,15,16,18,19,20]));
        assert_eq!("-1-10", solution::range_extraction(&[-1,0,1,2,3,4,5,6,7,8,9,10]));
        assert_eq!("1,3,5,7,9,11,13", solution::range_extraction(&[1,3,5,7,9,11,13]));
        assert_eq!("-10--8", solution::range_extraction(&[-10,-9,-8]));
    }
}