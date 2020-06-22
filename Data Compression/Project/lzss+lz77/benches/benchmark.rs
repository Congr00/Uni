use compression::lz77;
use compression::lzss;
use criterion::criterion_main;
use criterion::{criterion_group, BenchmarkId, Criterion, Throughput};
use lipsum::lipsum;
use lipsum::MarkovChain;

fn generate_lipsum(size: usize) -> String {
    let res = lipsum(size / 8);
    res.chars().take(size).collect::<String>()
}

fn benchmark_compression_lipsum_lz77(c: &mut Criterion) {
    const KB: usize = 1024;
    const MB: usize = KB * 1024;
    const SIZES: [usize; 10] = [
        KB,
        2 * KB,
        4 * KB,
        8 * KB,
        16 * KB,
        32 * KB,
        64 * KB,
        128 * KB,
        MB,
        4 * MB,
    ];

    let mut group = c.benchmark_group("benchmark_compression_lipsum_lz77");
    group.sample_size(10);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || generate_lipsum(size),
                |lip| lz77::encode_string(&lip, 1024, 512, 20),
            )
        });
    }
}

fn benchmark_compression_lipsum_lzss(c: &mut Criterion) {
    const KB: usize = 1024;
    const MB: usize = KB * 1024;
    const SIZES: [usize; 10] = [
        KB,
        2 * KB,
        4 * KB,
        8 * KB,
        16 * KB,
        32 * KB,
        64 * KB,
        128 * KB,
        MB,
        4 * MB,
    ];

    let mut group = c.benchmark_group("benchmark_compression_lipsum_lzss");
    group.sample_size(10);
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(*size as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || generate_lipsum(size),
                |lip| lzss::encode_string(&lip, 1024, 512, 20),
            )
        });
    }
}

fn benchmark_compression_lipsum_lz77_max_match(c: &mut Criterion) {
    const SIZES: [usize; 10] = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19];

    let mut group = c.benchmark_group("benchmark_compression_lipsum_lz77_max_match");
    group.sample_size(10);
    let tr = 1024 * 1024 * 1;
    for size in SIZES.iter() {
        group.throughput(Throughput::Bytes(tr as u64));
        group.bench_with_input(BenchmarkId::from_parameter(size), size, |b, &size| {
            b.iter_with_setup(
                || generate_lipsum(tr),
                |lip| lz77::encode_string(&lip, 1024 * 2, 1024 * 5, size),
            )
        });
    }
}

criterion_group!(
    benches,
    benchmark_compression_lipsum_lz77,
    benchmark_compression_lipsum_lzss,
    benchmark_compression_lipsum_lz77_max_match
);

criterion_main! {
    benches
}
