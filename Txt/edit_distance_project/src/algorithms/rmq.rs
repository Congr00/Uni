use segment_tree::SegmentPoint;
use crate::suffix_array::*;
use segment_tree::ops::Min;

fn lcp_array(s: &[usize] , sa: &[usize]) -> Vec<isize> {
    let n = sa.len();
    let mut rsa = vec![0; n];
    let mut lcp = vec![0; n];
    for i in 0..n {
        rsa[sa[i]] = i;
    }

    let mut h = 0;
    for i in 0..n {
        let k = rsa[i];
        if k == 0 {
            lcp[k] = -1;
        } else {
            let j = sa[k - 1];
            while i + h < n && j + h < n && s[i + h] == s[j + h] {
                h += 1;
            }
            lcp[k] = h as _;
        }

        if h > 0 {
            h -= 1;
        }
    }

    lcp
}
#[derive(Debug)]
pub struct RMQ{
    rsa: Vec<usize>,
    rmq: SegmentPoint<isize, segment_tree::ops::Min>
}

impl RMQ{
    pub fn new<S: AsRef<str>>(s: S) -> Self{
        let s = transformer(s);
        let sa = suffix_array(&s, 63);
        let lcp = lcp_array(&s, &sa); 
        let tree = SegmentPoint::build(lcp, Min);
        let mut sa_1 = vec![0; sa.len()];
        for (i, _) in sa.iter().enumerate() {
            sa_1[sa[i]] = i;
        }
        Self{
            rsa: sa_1,
            rmq: tree
        }
    }

    pub fn query(&self, k: (usize, usize)) -> isize{
        let (i, j) = k;
        assert!(i <= j);
        if i == j {
            return (self.rsa.len() - i) as isize;
        }
        let (mut ri, mut rj) = (self.rsa[i], self.rsa[j]);
        if ri + 1 > rj {
            std::mem::swap(&mut ri, &mut rj);
        }
        ri += 1;
        rj += 1;
        self.rmq.query(ri, rj)
    }
}