use std::ops::Index;

use shrinkwraprs::Shrinkwrap;

#[derive(Shrinkwrap)]
struct PaddedSlice<'a, T>(&'a [T]);

impl Index<usize> for PaddedSlice<'_, usize> {
    type Output = usize;

    fn index(&self, i: usize) -> &Self::Output {
        if i >= self.len() {
            &0
        } else {
            &self.0[i]
        }
    }
}

impl<'a, T> From<&'a [T]> for PaddedSlice<'a, T> {
    fn from(e: &'a [T]) -> Self {
        Self(e)
    }
}

pub fn transformer<S: AsRef<str>>(input: S) -> Vec<usize> {
    input
        .as_ref()
        .chars()
        .map(|c| match c {
            'A'..='Z' => (c as u8 - b'A') * 2 + 1,
            'a'..='z' => (c as u8 - b'a') * 2 + 2,
            '0'..='9' => (c as u8 - b'0') + 53,
            '$' => 0,
            _ => unimplemented!(),
        } as usize)
        .collect()
}

fn radix_sort(a: &[usize], b: &mut [usize], r: &[usize], n: usize, k: usize) {
    let mut c = vec![0; k + 1];
    let r: PaddedSlice<_> = r.into();

    for i in 0..n {
        c[r[a[i]]] += 1;
    }

    let mut sum = 0;
    for v in &mut c {
        let t = *v;
        *v = sum;
        sum += t;
    }

    for &v in a {
        b[c[r[v]]] = v;
        c[r[v]] += 1;
    }
}

pub fn suffix_array(s: &[usize], k: usize) -> Vec<usize> {
    let s: PaddedSlice<_> = s.into();
    let n = s.len();
    let n0 = (n + 2) / 3;
    let n1 = (n + 1) / 3;
    let n2 = n / 3;
    let n02 = n0 + n2;

    let mut s12 = vec![0; n02];
    let mut sa12 = vec![0; n02];
    let mut s0 = vec![0; n0];
    let mut sa0 = vec![0; n0];

    for (i, j) in (0..n + n0 - n1).filter(|i| (i % 3) != 0).enumerate() {
        s12[i] = j;
    }

    radix_sort(&s12, &mut sa12, &s.0[2..], n02, k);
    radix_sort(&sa12, &mut s12, &s.0[1..], n02, k);
    radix_sort(&s12, &mut sa12, &s, n02, k);

    let mut name = 0;
    let (mut c0, mut c1, mut c2) = (-1i64, -1i64, -1i64);

    for i in 0..n02 {
        if s[sa12[i]] as i64 != c0 || s[sa12[i] + 1] as i64 != c1 || s[sa12[i] + 2] as i64 != c2 {
            name += 1;
            c0 = s[sa12[i]] as _;
            c1 = s[sa12[i] + 1] as _;
            c2 = s[sa12[i] + 2] as _;
        }

        if sa12[i] % 3 == 1 {
            s12[sa12[i] / 3] = name;
        } else {
            s12[sa12[i] / 3 + n0] = name;
        }
    }

    if name < n02 {
        sa12 = suffix_array(&s12, name);
        for i in 0..n02 {
            s12[sa12[i]] = i + 1;
        }
    } else {
        for i in 0..n02 {
            sa12[s12[i] - 1] = i;
        }
    }

    for (i, j) in (0..n02).filter(|&i| sa12[i] < n0).enumerate() {
        s0[i] = 3 * sa12[j];
    }
    radix_sort(&s0, &mut sa0, &s, n0, k);

    let mut p = 0;
    let mut k = 0;
    let mut t = n0 - n1;

    let s12: PaddedSlice<_> = PaddedSlice(&s12);
    let sa12: PaddedSlice<_> = PaddedSlice(&sa12);
    let mut sa = vec![0; n];

    while k < n {
        let i = if sa12[t] < n0 {
            sa12[t] * 3 + 1
        } else {
            (sa12[t] - n0) * 3 + 2
        };
        let j = sa0[p];

        if (sa12[t] < n0 && (s[i], s12[sa12[t] + n0]) <= (s[j], s12[j / 3]))
            || (sa12[t] >= n0
                && (s[i], s[i + 1], s12[sa12[t] - n0 + 1]) <= (s[j], s[j + 1], s12[j / 3 + n0]))
        {
            sa[k] = i;
            t += 1;

            if t == n02 {
                k += 1;
                while p < n0 {
                    sa[k] = sa0[p];
                    p += 1;
                    k += 1;
                }
            }
        } else {
            sa[k] = j;
            p += 1;

            if p == n0 {
                k += 1;
                while t < n02 {
                    sa[k] = if sa12[t] < n0 {
                        sa12[t] * 3 + 1
                    } else {
                        (sa12[t] - n0) * 3 + 2
                    };
                    t += 1;
                    k += 1;
                }
            }
        }

        k += 1;
    }

    sa
}
