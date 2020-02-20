pub fn good_vs_evil(good: &str, evil: &str) -> String {
    let gd = calculate_side(good, vec![1,2,3,3,4,10]);
    let bd = calculate_side(evil, vec![1,2,2,2,3,5,10]);
    if gd == bd { return "Battle Result: No victor on this battle field".into() }
    else if gd > bd { return "Battle Result: Good triumphs over Evil".into() }
    "Battle Result: Evil eradicates all trace of Good".into()   
}

fn calculate_side(data: &str, values: Vec<usize>) -> usize {
    data.split(" ").into_iter()
                   .filter_map(|c| c.parse::<usize>().ok())
                   .zip(values.into_iter())
                   .map(|(num, val)| num*val).sum::<usize>()
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn returns_expected() {
        assert_eq!(good_vs_evil("0 0 0 0 0 10", "0 0 0 0 0 0 0"), "Battle Result: Good triumphs over Evil");
        assert_eq!(good_vs_evil("0 0 0 0 0 0", "0 0 0 0 0 0 10"), "Battle Result: Evil eradicates all trace of Good");
        assert_eq!(good_vs_evil("0 0 0 0 0 10", "0 0 0 0 0 0 10"), "Battle Result: No victor on this battle field");
        assert_eq!(good_vs_evil("0 0 0 0 0 00", "0 0 0 0 0 0 00"), "Battle Result: No victor on this battle field");
    }
}
