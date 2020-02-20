pub fn zoom(n: i32) -> String {
    let white = "■";
    return (1..=n).step_by(2).fold(white.to_string(), |acc, num|{
        let curr = rev(acc.chars().next().unwrap().to_string());
        if num == 1 { acc }
        else {
            let line = format!("{}", curr.repeat(num as usize));
            format!("{}\n{}{}", line, acc.split('\n').map(|s| format!("{}{}{}\n", curr, s, curr)).fold(String::new(), |acc, s| acc + &s), line)
        }
    })
}

fn rev(m: String) -> String {
    (if m == "■" { "□" }
    else { "■" }).to_string()
}

#[test]
fn basic_test_1() {
  assert_eq!(zoom(1), "■");
}

#[test]
fn basic_test_2() {
  assert_eq!(zoom(3), "\
□□□
□■□
□□□"
  );
}

#[test]
fn basic_test_3() {
  assert_eq!(zoom(5), "\
■■■■■
■□□□■
■□■□■
■□□□■
■■■■■"
  );
}

#[test]
fn basic_test_4() {
  assert_eq!(zoom(7), "\
□□□□□□□
□■■■■■□
□■□□□■□
□■□■□■□
□■□□□■□
□■■■■■□
□□□□□□□"
  );
}

#[test]
fn basic_test_5() {
  assert_eq!(zoom(9), "\
■■■■■■■■■
■□□□□□□□■
■□■■■■■□■
■□■□□□■□■
■□■□■□■□■
■□■□□□■□■
■□■■■■■□■
■□□□□□□□■
■■■■■■■■■"
  );
}
#[test]
fn basic_test_6() {
  assert_eq!(zoom(11), "\
□□□□□□□□□□□
□■■■■■■■■■□
□■□□□□□□□■□
□■□■■■■■□■□
□■□■□□□■□■□
□■□■□■□■□■□
□■□■□□□■□■□
□■□■■■■■□■□
□■□□□□□□□■□
□■■■■■■■■■□
□□□□□□□□□□□"
  );
}