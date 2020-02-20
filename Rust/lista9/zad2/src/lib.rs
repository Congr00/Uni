pub fn dont_give_me_five(start: isize, end: isize) -> isize {
    (start..=end).filter(|v| !v.to_string().contains('5')).count() as isize
}


#[cfg(test)]
mod tests {
use super::dont_give_me_five;

#[test]
fn returns_expected() {
    assert_eq!(dont_give_me_five(1, 9), 8);
    assert_eq!(dont_give_me_five(4, 17), 12);
    assert_eq!(dont_give_me_five(0,0), 1);
    assert_eq!(dont_give_me_five(4,5), 1);c
}
}