pub fn square_area_to_circle(size:f64) -> f64 {
    (size / 4.0) * std::f64::consts::PI
}


#[cfg(test)]
mod tests {
    #[test]
    fn tests() {
        assert_eq!(super::square_area_to_circle(9.0), 7.0685834705770345);
        assert_eq!(super::square_area_to_circle(20.0), 15.707963267948966);
        assert_eq!(super::square_area_to_circle(4.0), std::f64::consts::PI);
        assert_eq!(super::square_area_to_circle(1.0), std::f64::consts::PI / 4.0);
        assert_eq!(super::square_area_to_circle(40.0), 15.707963267948966 * 2.0);
        assert_eq!(super::square_area_to_circle(100.0), 15.707963267948966 * 5.0);   
        assert_eq!(super::square_area_to_circle(1000.0), 15.707963267948966 * 50.0);                
    }
}
