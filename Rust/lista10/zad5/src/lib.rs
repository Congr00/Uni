pub fn interpreter(code: &str, iterations: usize,
                     width: usize, height: usize) -> String
{
  let mut x:usize = 0;
  let mut y:usize = 0;
  println!("{}", code);
  let mut grid:Vec<Vec<usize>> = vec![vec![0;width];height];
  let code = code.chars().filter(|c| !vec!['n','e','s','w','*',']','['].iter().all(|x| x != c)).collect::<Vec<_>>();
  let mut curr:usize = 0;

  let mut iter = 0;
  while curr < code.len() && iter < iterations{
      let command = code[curr];
      match command{
          'n' => { mv_north(&mut y, &height); iter += 1;}
          'e' => { mv_east (&mut x,  &width); iter += 1;}
          's' => { mv_south(&mut y, &height); iter += 1;}
          'w' => { mv_west (&mut x,  &width); iter += 1;}
          '*' => { if let Some(cell) = grid[y].get_mut(x) { *cell ^= 1; } iter += 1;}
          '[' => { if grid[y][x] == 0 { curr = find_closure(&code, curr+1, 0); } iter += 1;}
          ']' => { if grid[y][x] != 0 { curr = find_opener(&code, curr-1, 0); } iter += 1;}
           _  => { }
      }
      curr += 1;
  }
  grid.into_iter().map(|vec| vec.iter().map(|el| el.to_string())
                                       .into_iter()
                                       .collect::<String>())
      .collect::<Vec<_>>()  
      .join("\r\n")
}
fn find_closure(code: &Vec<char>, cursor: usize, closer_cnt: usize) -> usize{
    if code[cursor] == ']' { if closer_cnt == 0 { return cursor; }  
                             else { return find_closure(code, cursor+1, closer_cnt-1); }
                           }
    else if code[cursor] == '[' { return find_closure(code, cursor+1, closer_cnt+1); }
    find_closure(code, cursor+1, closer_cnt)
}
fn find_opener(code: &Vec<char>, cursor: usize, opener_cnt: usize) -> usize{
    if code[cursor] == '[' { if opener_cnt == 0 { return cursor; }  
                             else { return find_opener(code, cursor-1, opener_cnt-1); }
                           }
    else if code[cursor] == ']' { return find_opener(code, cursor-1, opener_cnt+1); }
    find_opener(code, cursor-1, opener_cnt)
}

fn mv_north(y:&mut usize, h:&usize) -> (){
    if *y == 0 { *y = h-1; }
    else { *y -= 1; }
}
fn mv_east(x:&mut usize, w:&usize) -> (){
    if *x == w-1 { *x = 0; }
    else { *x += 1; }
}
fn mv_south(y:&mut usize, h:&usize) -> (){
    if *y == h-1 { *y = 0; }
    else { *y += 1; }
}
fn mv_west(x:&mut usize, w:&usize) -> (){
    if *x == 0 { *x = w-1; }
    else { *x -= 1; }
}



#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn simple_cases() {
      assert_eq!(&interpreter("*e*e*e*es*es*ws*ws*w*w*w*n*n*n*ssss*s*s*s*", 0, 6, 9), "000000\r\n000000\r\n000000\r\n000000\r\n000000\r\n000000\r\n000000\r\n000000\r\n000000");
      assert_eq!(&interpreter("*e*e*e*es*es*ws*ws*w*w*w*n*n*n*ssss*s*s*s*", 7, 6, 9), "111100\r\n000000\r\n000000\r\n000000\r\n000000\r\n000000\r\n000000\r\n000000\r\n000000");
      assert_eq!(&interpreter("*e*e*e*es*es*ws*ws*w*w*w*n*n*n*ssss*s*s*s*", 19, 6, 9), "111100\r\n000010\r\n000001\r\n000010\r\n000100\r\n000000\r\n000000\r\n000000\r\n000000");
      assert_eq!(&interpreter("*e*e*e*es*es*ws*ws*w*w*w*n*n*n*ssss*s*s*s*", 42, 6, 9), "111100\r\n100010\r\n100001\r\n100010\r\n111100\r\n100000\r\n100000\r\n100000\r\n100000");
      assert_eq!(&interpreter("*e*e*e*es*es*ws*ws*w*w*w*n*n*n*ssss*s*s*s*", 100, 6, 9), "111100\r\n100010\r\n100001\r\n100010\r\n111100\r\n100000\r\n100000\r\n100000\r\n100000");
      assert_eq!(&interpreter("[[[[[[[[[]]]]]]]]]", 1000, 2, 2), "00\r\n00");
    }
}
