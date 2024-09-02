use edit_distance::edit_distance_basic;
use edit_distance::edit_distance_improved;
use edit_distance::edit_distance_adv;
use edit_distance::helper;
use criterion::criterion_main;
use criterion::{criterion_group, BenchmarkId, Criterion, Throughput};
use std::time::Duration;

fn benchmark_lcs_lipsum_basic(c: &mut Criterion) {
    const KB: usize = 1024;
    const SIZES: [usize; 6] = [
        KB,
        2 * KB,
        4 * KB,
        8 * KB,
        16 * KB,
        32 * KB,
        //64 * KB
    ];

    let mut group = c.benchmark_group("benchmark_lcs_lipsum_basic");
    group.sample_size(20);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || (helper::generate_lipsum(size), helper::generate_lipsum(size)),
                |(s1, s2)| edit_distance_basic::lcs(&s1, &s2),
            )
        });
    }
}

fn benchmark_lcs_lipsum_improved(c: &mut Criterion) {
    const KB: usize = 1024;
    const SIZES: [usize; 6] = [
        KB,
        2 * KB,
        4 * KB,
        8 * KB,
        16 * KB,
        32 * KB,
        //64 * KB
    ];

    let mut group = c.benchmark_group("benchmark_lcs_lipsum_improved");
    group.sample_size(20);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || (helper::generate_lipsum(size), helper::generate_lipsum(size)),
                |(s1, s2)| edit_distance_improved::lcs(&s1, &s2),
            )
        });
    }
}

fn benchmark_lcs_lipsum_adv(c: &mut Criterion) {
    const KB: usize = 1024;
    const SIZES: [usize; 6] = [
        KB,
        2 * KB,
        4 * KB,
        8 * KB,
        16 * KB,
        32 * KB,
        //64 * KB
    ];

    let mut group = c.benchmark_group("benchmark_lcs_lipsum_adv");
    group.sample_size(15);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || (helper::generate_lipsum(size), helper::generate_lipsum(size)),
                |(s1, s2)| edit_distance_adv::lcs(&s1, &s2),
            )
        });
    }
}


fn benchmark_lcs_similar_improved(c: &mut Criterion) {
    const KB: usize = 1024;
    const SIZES: [usize; 7] = [
        KB,
        2 * KB,
        4 * KB,
        8 * KB,
        16 * KB,
        32 * KB,
        64 * KB
    ];

    let mut group = c.benchmark_group("benchmark_lcs_similar_improved");
    group.sample_size(20);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || helper::generate_similar_string(size, 20),
                |(s1, s2)| edit_distance_improved::lcs(&s1, &s2),
            )
        });
    }
}

fn benchmark_lcs_similar_basic(c: &mut Criterion) {
    const KB: usize = 1024;
    const SIZES: [usize; 7] = [
        KB,
        2 * KB,
        4 * KB,
        8 * KB,
        16 * KB,
        32 * KB,
        64 * KB
    ];

    let mut group = c.benchmark_group("benchmark_lcs_similar_basic");
    group.sample_size(20);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || helper::generate_similar_string(size, 20),
                |(s1, s2)| edit_distance_basic::lcs(&s1, &s2),
            )
        });
    }
}

fn benchmark_lcs_similar_adv(c: &mut Criterion) {
    const KB: usize = 1024;
    const SIZES: [usize; 7] = [
        KB,
        2 * KB,
        4 * KB,
        8 * KB,
        16 * KB,
        32 * KB,
        64 * KB
    ];

    let mut group = c.benchmark_group("benchmark_lcs_similar_adv");
    group.sample_size(20);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || helper::generate_similar_string(size, 20),
                |(s1, s2)| edit_distance_adv::lcs(&s1, &s2),
            )
        });
    }
}


fn benchmark_lcs_sim_diff_improved(c: &mut Criterion) {
    const SIZES: [usize; 7] = [4, 8, 16, 32, 64, 128, 256];

    let mut group = c.benchmark_group("benchmark_lcs_sim_diff_improved");
    group.sample_size(20);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || helper::generate_similar_string(1024 * 32, size),
                |(s1, s2)| edit_distance_improved::lcs(&s1, &s2),
            )
        });
    }
}

fn benchmark_lcs_sim_diff_adv(c: &mut Criterion) {
    const SIZES: [usize; 7] = [4, 8, 16, 32, 64, 128, 256];

    let mut group = c.benchmark_group("benchmark_lcs_sim_diff_adv");
    group.sample_size(20);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || helper::generate_similar_string(1024 * 32, size),
                |(s1, s2)| edit_distance_adv::lcs(&s1, &s2),
            )
        });
    }
}

criterion_group!(
    benches,
    benchmark_lcs_lipsum_basic,
    benchmark_lcs_lipsum_improved,
    benchmark_lcs_lipsum_adv,
    benchmark_lcs_similar_basic,
    benchmark_lcs_similar_improved,
    benchmark_lcs_similar_adv,
    benchmark_lcs_sim_diff_improved,
    benchmark_lcs_sim_diff_adv,
);

criterion_main! {
    benches
}