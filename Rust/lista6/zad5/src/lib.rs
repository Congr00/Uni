struct Sudoku{
    data: Vec<Vec<u32>>,
}


impl Sudoku{
    
    fn is_valid(&self) -> bool {
      //horizontal len check
      for i in self.data.iter() { if i.len() != self.data.len() { return false } }
      //vertical len check
      for i in 0..self.data.len() { if self.row_iter(i).collect::<Vec<u32>>().len() != self.data.len() { return false } }
      //vertical number check
      self.data.iter().all(|v| {
          let mut x = v.clone();
          x.sort();
          x[0] == 1 && *x.last().unwrap() == self.data.len() as u32
      }) &&
      //horizontal number check
      (0..self.data.len()).all(|n| {
          let mut x = self.row_iter(n).collect::<Vec<u32>>();
          x.sort();
          x[0] == 1 && *x.last().unwrap() == self.data.len() as u32
      }) &&
      //squares number check
      (0..self.data.len()).all(|n| {
          let mut x = self.square_iter(n).collect::<Vec<u32>>();
          x.sort();
          x[0] == 1 && *x.last().unwrap() == self.data.len() as u32
      })
    }
    
    fn square_iter(&self, n:usize) -> impl Iterator<Item = u32> + '_ {
        let sqr = (self.data.len() as f64).sqrt() as usize;
        let column:usize = (n % sqr) * sqr;
        let row:usize = (n / sqr) * sqr;
        self.data.iter()
                 .skip(row)
                 .take(sqr)
                 .flat_map(move |r| r.iter().skip(column).take(sqr))
                 .cloned()
    }

    fn row_iter(&self, n:usize) -> impl Iterator<Item = u32> + '_ {
        self.data.iter().flat_map(move |line| line.get(n)).cloned()
    }
}

#[test]
fn good_sudoku() {
    let good_sudoku_1 = Sudoku{
        data: vec![
                vec![7,8,4, 1,5,9, 3,2,6],
                vec![5,3,9, 6,7,2, 8,4,1],
                vec![6,1,2, 4,3,8, 7,5,9],

                vec![9,2,8, 7,1,5, 4,6,3],
                vec![3,5,7, 8,4,6, 1,9,2],
                vec![4,6,1, 9,2,3, 5,8,7],
                
                vec![8,7,6, 3,9,4, 2,1,5],
                vec![2,4,3, 5,6,1, 9,7,8],
                vec![1,9,5, 2,8,7, 6,3,4]
            ]
    };
    
    let good_sudoku_2 = Sudoku{
        data: vec![
                vec![1, 4,  2, 3],
                vec![3, 2,  4, 1],
        
                vec![4, 1,  3, 2],
                vec![2, 3,  1, 4],
            ]
    };
    assert!(good_sudoku_1.is_valid());
    assert!(good_sudoku_2.is_valid());
}

#[test]
fn bad_sudoku() {
    let bad_sudoku_1 = Sudoku{
        data: vec![
                vec![1,2,3, 4,5,6, 7,8,9],
                vec![1,2,3, 4,5,6, 7,8,9],
                vec![1,2,3, 4,5,6, 7,8,9],

                vec![1,2,3, 4,5,6, 7,8,9],
                vec![1,2,3, 4,5,6, 7,8,9],
                vec![1,2,3, 4,5,6, 7,8,9],
                
                vec![1,2,3, 4,5,6, 7,8,9],
                vec![1,2,3, 4,5,6, 7,8,9],
                vec![1,2,3, 4,5,6, 7,8,9],
            ]
    };
    
    let bad_sudoku_2 = Sudoku{
        data: vec![
                vec![1,2,3,4,5],
                vec![1,2,3,4],
                vec![1,2,3,4],
                vec![1],
            ]
    };
    assert!(!bad_sudoku_1.is_valid());
    assert!(!bad_sudoku_2.is_valid());
}