use crate::rmq::RMQ;
use crate::helper;
use std::cell::RefCell;
use std::rc::Rc;

type Pointer<T> = Rc<RefCell<T>>;

#[derive(Debug)]
enum DiagType {
    Right,
    Left,
    Middle
}

#[derive(Debug)]
pub struct DIAG<'r> {
    hist: Vec<(usize, (usize, usize))>,
    max_len: usize,
    diag_nr: isize,
    rmq: &'r RMQ,
    l_neib: Option<Pointer<DIAG<'r>>>,
    r_neib: Option<Pointer<DIAG<'r>>>,
    last: (usize, (usize, usize))
}

impl<'r> DIAG<'r> {
    fn diag_to_pair(nr: isize) -> (usize, usize){
        if nr > 0 { return (nr as usize, 0); }
        else      { return (0, (-nr) as usize); }
    }

    fn cov(&mut self) -> (usize, usize){
        ((self.last.1.0), (self.last.1.1)+1+self.max_len)
    }

    pub fn new(diag_nr: isize, max_len: usize, rmq: &'r RMQ, l_neib: Option<Pointer<Self>>, r_neib: Option<Pointer<Self>>) -> Pointer<Self> {
        let last = Self::diag_to_pair(diag_nr);   

        Rc::new(RefCell::new(Self{
            hist: vec![],
            max_len,
            diag_nr,
            rmq,
            l_neib,
            r_neib,
            last: (diag_nr.abs() as usize, last)
        }))
    }

    pub fn cost_fun(&self, k: (usize, usize)) -> usize{
        let (i, j) = k;
        if i == j { return self.max_len - i; }
        let (lower, _) = if i < j { (i, j) } else { (j, i) };
        let diff = self.max_len - lower;
        diff + (diff + lower) - self.max_len
    }

    pub fn last_value(&self, nr: isize) -> (usize, (usize, usize)){
        let offset = 2 - (nr != 0 && ((nr < 0) != (nr > self.diag_nr))) as usize;
        self.hist[self.hist.len()-offset]
    }

    pub fn get_nth_value(&self, n: usize) -> (usize, (usize, usize)){
        self.hist[n]
    }

    pub fn pick_new_pos(&mut self) {
        use DiagType::*;
        if self.last.1.0 >= self.max_len || self.last.1.1 >= self.max_len{
            return;
        }
        let own_pushed = (self.last.0+1, (self.last.1.0 + 1, self.last.1.1 + 1));
        let own_push = self.push(own_pushed.1.0, own_pushed.1.1);
        let mut candidates = vec![(Right, self.r_neib.clone()), (Left, self.l_neib.clone())]
            .into_iter()
            .filter_map(|(d, neib)| {
                let neib = neib?;
                let lst = neib.borrow().last_value(self.diag_nr);
                let pushed = match d{
                    Right  => { if neib.borrow().on_edge((0, 1)){ None } else {Some((lst.0+1, self.push(lst.1.0, lst.1.1+1)))} },
                    Left   => { if neib.borrow().on_edge((1, 0)){ None } else {Some((lst.0+1, self.push(lst.1.0+1, lst.1.1)))} },
                    Middle => { None }
                }?;
                Some((d, self.cost_fun(pushed.1) + pushed.0, pushed))
            })
            .chain(std::iter::once((Middle, self.cost_fun(own_push) + self.last.0+1, own_pushed)))
            .collect::<Vec<_>>();
        candidates.sort_by(|a, b | a.1.cmp(&b.1).then(a.2.0.cmp(&b.2.0)));
        self.last = candidates[0].2;
    }

    pub fn update_parents(this: Pointer<Self>){
        if let Some(ref right) = this.borrow().r_neib {
            right.borrow_mut().l_neib = Some(this.clone());
        }
        if let Some(ref left) = this.borrow().l_neib {
            left.borrow_mut().r_neib = Some(this.clone());
        }
    }

    pub fn on_edge(&self, k:(usize, usize)) -> bool{
        let cp = self.last.1;
        cp.0+k.0 > self.max_len || cp.1+k.1 > self.max_len
    }

    pub fn update_range(&mut self, i: usize){
        let neib = self.l_neib.as_ref().or(self.r_neib.as_ref()).unwrap().clone(); // This is safe
        for n in 1..i {
            if self.last.1.0 >= self.max_len || self.last.1.1 >= self.max_len{
                self.update();
                continue;
            }

            let our = self.cost_fun((self.last.1.0+1, self.last.1.1+1))+self.last.0 + 1;

            let (score, pos) = neib.borrow().get_nth_value(n);
            let nxt = if neib.borrow().diag_nr < self.diag_nr{
                    if pos.0+1 > self.max_len || pos.1 > self.max_len{
                        std::usize::MAX
                    }
                    else{
                        self.cost_fun(self.push(pos.0+1, pos.1)) + score + 1
                    }
                }
                else{
                    if pos.0 > self.max_len || pos.1+1 > self.max_len{
                        std::usize::MAX
                    }
                    else{
                        self.cost_fun(self.push(pos.0, pos.1+1)) + score + 1
                    }
                };
            if our == nxt{
                if self.last.0+1 < neib.borrow().last.0+1{
                    self.last = (self.last.0+1, (self.last.1.0+1, self.last.1.1+1))
                }
                else{
                    if neib.borrow().diag_nr < self.diag_nr{
                        self.last = (1 + score, (pos.0+1, pos.1 ));
                    }
                    else{
                        self.last = (1 + score, (pos.0, pos.1+1 ));
                    }
                }
            }
            if our < nxt{
                self.last = (self.last.0+1, (self.last.1.0+1, self.last.1.1+1))
            }
            else{
                if neib.borrow().diag_nr < self.diag_nr{
                    self.last = (1 + score, (pos.0+1, pos.1 ));
                }
                else{
                    self.last = (1 + score, (pos.0, pos.1+1 ));
                }
            }
            self.update();
        }
    }
    pub fn push(&self, i: usize, j: usize) -> (usize, usize) {
        let cov = (i, j+1+self.max_len);
        let push = if i == self.max_len || j == self.max_len{ 0 } else { self.rmq.query(cov) as usize };
        (i + push, j + push)
    }

    pub fn update(&mut self){
        let push = if self.last.1.0 == self.max_len || self.last.1.1 == self.max_len{ 0 } else { self.rmq.query(self.cov()) as usize };
        self.last = (self.last.0, (self.last.1.0 + push, self.last.1.1 + push));
        if self.r_neib.is_some() && self.l_neib.is_some() && self.hist.len() > 10{
            self.hist = vec![self.hist[self.hist.len()-1]];
            self.hist.push(self.last);
        }
        else if self.hist.len() == 2 && self.r_neib.is_some() && self.l_neib.is_some(){
            self.hist[0] = self.hist[1];
            self.hist[1] = self.last;
        }
        else{
            self.hist.push(self.last);
        }
    }

    pub fn finish(&self) -> bool{
        self.hist[self.hist.len()-1].1 == (self.max_len, self.max_len)
    }
}

/*
O(n + d^2) edit distance algorithm. This implementation is O(n + logn*d^2) because of rmq lookup in O(logn)
It calculates edit distance on each diagonal of NxN matrix. Because of edit distance  property, we can calculate
only d*d diagonals of NxN matrix to get correct result.
*/
fn edit_distance(s1: &str, s2: &str) -> usize{

    let N = s1.len();
    assert_eq!(s1.len(), s1.as_bytes().len(), "Strings can't contain special characters");
    assert_eq!(s2.len(), s2.as_bytes().len(), "Strings can't contain special characters");
    // first init RMQ
    let rmq = RMQ::new(format!("{}${}", s1, s2));
    // vector that contains all diagonals
    let mut diagonals = vec![DIAG::new(0, N, &rmq, None, None)];
    let ZERO = 0;
    // init 0 diagonal and check if it can propagate to the end
    // if it can do se, then the edit distance must be 0
    diagonals[ZERO].borrow_mut().update();
    if diagonals[ZERO].borrow().finish(){
        return diagonals[ZERO].borrow().last.0;
    }
    // itereate d till it as equal to the length of input string
    for d in 1..(N as isize) {
        if d == 1{
            // special case - at the beginning we need to create diagonal 1 and -1 and link it with diagonal 0
            diagonals.push(DIAG::new(d, N, &rmq, Some(diagonals[ZERO].clone()), None));
            diagonals.push(DIAG::new(-d, N, &rmq, None, Some(diagonals[ZERO].clone())));
        }
        else {
            // otherwise, we create diagonals -d and d and link it to (-d+1), (d-1) neighours
            let len = diagonals.len();
            diagonals.push(DIAG::new(d, N, &rmq, Some(diagonals[len-2].clone()), None));
            diagonals.push(DIAG::new(-d, N, &rmq, None, Some(diagonals[len-1].clone())));
        }
        for i in 1..=2 { 
            let idx = diagonals.len()-i;
            DIAG::update_parents(diagonals[idx].clone()); 
            diagonals[idx].borrow_mut().update();
            diagonals[idx].borrow_mut().update_range(d as usize);
        }
        for diagonal in diagonals.iter().rev() {
            diagonal.borrow_mut().pick_new_pos();
            diagonal.borrow_mut().update();
        }

        if diagonals[ZERO].borrow().finish(){
            return diagonals[ZERO].borrow().last.0;
        }
    }
    N
}

pub fn lcs(s1: &str, s2: &str) -> usize{
    return edit_distance(s1, s2);
}

#[cfg(test)]
mod edit_distance_adv_tests {
    use super::*;
    #[test]
    fn random_edit(){
        for _ in 0..50{
            let mut s1 = helper::generate_random(1000);
            let mut s2 = helper::generate_random(1000);

            s1.retain(|c| c.is_alphanumeric());
            s2.retain(|c| c.is_alphanumeric());
            assert_eq!(s1.len(), s2.len(), "Input strings are of a different size");
            assert_eq!(lcs(&s1, &s2), edit_distance_lib::edit_distance(&s1, &s2) as usize, "\n{}\n{}", s1, s2);
        }
    }
    #[test]
    fn random_edit_diff_len(){
        for _ in 0..100{
            for i in 1..100{
                let mut s1 = helper::generate_random(i);
                let mut s2 = helper::generate_random(i);
                
                s1.retain(|c| c.is_alphanumeric());
                s2.retain(|c| c.is_alphanumeric());
                assert_eq!(s1.len(), s2.len(), "Input strings are of a different size");
                assert_eq!(lcs(&s1, &s2), edit_distance_lib::edit_distance(&s1, &s2) as usize, "\n{}\n{}", s1, s2);
            }
        }
    }
    fn random_lipsum_edit_diff_len(){
        for _ in 0..100{
            let mut s1 = helper::generate_lipsum(5000);
            let mut s2 = helper::generate_lipsum(5000);
            assert_eq!(s1.len(), s2.len(), "Input strings are of a different size");
            assert_eq!(lcs(&s1, &s2), edit_distance_lib::edit_distance(&s1, &s2) as usize, "\n{}\n{}", s1, s2);
        }
    }
}