pub fn number(bus_stops:&[(i32,i32)]) -> i32 {
    let mut peps = 0;
    bus_stops.iter().for_each(|&(x, y)| peps += x - y);
    return peps
}

#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        assert_eq!(super::number(&[(10,0),(3,5),(5,8)]), 5);
        assert_eq!(super::number(&[(3,0),(9,1),(4,10),(12,2),(6,1),(7,10)]), 17);
        assert_eq!(super::number(&[(3,0),(9,1),(4,8),(12,2),(6,1),(7,8)]), 21);
        assert_eq!(super::number(&[(3,0)]), 3);
        assert_eq!(super::number(&[]), 0);
        assert_eq!(super::number(&[(3,4)]), -1);
        assert_eq!(super::number(&[(3,0),(0,3)]), 0);
    }
}