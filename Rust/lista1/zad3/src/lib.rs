pub fn count_red_beads(n: u32) -> u32 {
    if n > 0 {(n - 1) * 2} else {0}
}

#[cfg(test)]
mod test{
    #[test]
    fn returns_expected() {
        assert_eq!(super::count_red_beads(0), 0);
        assert_eq!(super::count_red_beads(1), 0);
        assert_eq!(super::count_red_beads(3), 4);
        assert_eq!(super::count_red_beads(5), 8);
        assert_eq!(super::count_red_beads(2), 2);
        assert_eq!(super::count_red_beads(64), 126);
        assert_eq!(super::count_red_beads(66), 130);
        assert_eq!(super::count_red_beads(70), 138);        
    }
}