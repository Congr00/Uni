pub fn highlight(code: &str) -> String {
  // Implement your syntax highlighter here
  if code.is_empty() { return code.to_string() }
  return code.to_string().chars().chain(std::iter::once('\0')).fold(String::new(), |mut state, c| {
        if state.is_empty() { state += &format!("{}{}", map_to_string(&c), c); return state }
        let last = state.chars().last().unwrap();
        if last == c || ( last.is_digit(10) && c.is_digit(10)) { state.push(c) }
        else if c == '\0' && last != '>' && last != ')' && last != '(' { state += "</span>"}
        else if c == '\0' { return state; }
        else if last == '(' || last == ')' {state += &format!("{}{}", map_to_string(&c), c)}
        else { state += &format!("</span>{}{}", map_to_string(&c), c) }
        state
  })
}

fn map_to_string(c: &char) -> &str {
    match c {
        'F' => r#"<span style="color: pink">"#,
        'L' => r#"<span style="color: red">"#,
        'R' => r#"<span style="color: green">"#,
         _  if c.is_digit(10) => r#"<span style="color: orange">"#,
         _  => ""
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[cfg(test)]
    macro_rules! assert_highlight {
        ($code:expr , $expected:expr $(,)*) => {{
            let actual = highlight($code);
            let expected = $expected;
            println!("Code without syntax highlighting: {}", $code);
            println!("Your code with syntax highlighting: {}", actual);
            println!("Expected syntax highlighting: {}", expected);
            assert_eq!(actual, expected);
        }};
    }

    #[test]
    fn examples_in_description() {
        assert_highlight!(
            "F3RF5LF7",
            r#"<span style="color: pink">F</span><span style="color: orange">3</span><span style="color: green">R</span><span style="color: pink">F</span><span style="color: orange">5</span><span style="color: red">L</span><span style="color: pink">F</span><span style="color: orange">7</span>"#,
        );
        assert_highlight!(
            "FFFR345F2LL",
            r#"<span style="color: pink">FFF</span><span style="color: green">R</span><span style="color: orange">345</span><span style="color: pink">F</span><span style="color: orange">2</span><span style="color: red">LL</span>"#,
        );
        assert_highlight!(
            "",
            ""
       );
        assert_highlight!(
            "()()()()()()()()",
            "()()()()()()()()"
       );
        assert_highlight!(
            "(",
            "("
       );
    }
}
