use compression::consts::{DataStoreError, DICT_SIZE, INPUT_SIZE, MAX_MATCH};
use compression::lz77;
use compression::lzss;

use getopts::Options;
use std::env;
use DataStoreError::*;

fn print_usage(program: &str, opts: Options) {
    let brief = format!("Usage: {} FILE [options]", program);
    print!("{}", opts.usage(&brief));
}

fn gen_options() -> Options {
    let mut opts = Options::new();
    opts.optopt("o", "out", "set output file name", "NAME");
    opts.optopt("d", "dict", "set dict buffer size in KB", "DICT_BUFF_SIZE");
    opts.optopt(
        "i",
        "input",
        "set input buffer sizein KB",
        "INPUT_BUFF_SIZE",
    );
    opts.optflag("7", "lz77", "change compression algorithm to lz77");
    opts.optopt("m", "match", "set max match for search opt", "MAX_SIZE");
    opts.optflag("u", "decompress", "set programm to decompression mode");
    opts.optflag("h", "help", "print this help menu");
    opts
}

fn main_wrapper() -> Result<(), DataStoreError> {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();
    let opts = gen_options();
    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => return Err(WrongArg(f.to_string())),
    };
    if matches.opt_present("h") {
        print_usage(&program, opts);
        return Ok(());
    }
    if matches.free.is_empty() {
        print_usage(&program, opts);
        return Err(NoFile);
    } else if matches.free.len() > 1 {
        print_usage(&program, opts);
        return Err(WrongArg(
            matches
                .free
                .into_iter()
                .skip(1)
                .collect::<Vec<String>>()
                .join(" "),
        ));
    }
    let file_name = matches.free[0].clone();
    let out_file = matches.opt_str("o").unwrap_or(if matches.opt_present("u") {
        String::new()
    } else {
        file_name.clone()
    });
    let dict_size = matches
        .opt_str("d")
        .unwrap_or(DICT_SIZE.to_string())
        .parse::<usize>()
        .map_err(|v| WrongArg(v.to_string()))?
        * 1024;
    let input_size = matches
        .opt_str("i")
        .unwrap_or(INPUT_SIZE.to_string())
        .parse::<usize>()
        .map_err(|v| WrongArg(v.to_string()))?
        * 1024;
    let max_match = matches
        .opt_str("m")
        .unwrap_or(MAX_MATCH.to_string())
        .parse::<usize>()
        .map_err(|v| WrongArg(v.to_string()))?;
    if matches.opt_present("u") {
        println!("Decoding {}...", file_name.clone());
        let fname = if matches.opt_present("7") {
            lz77::decode_from_file(&file_name, out_file.clone())?
        } else {
            lzss::decode_from_file(&file_name, out_file.clone())?
        };
        println!("Done, decoded file in {}", fname);
    } else {
        println!("Encoding {}...", file_name.clone());
        let fname = if matches.opt_present("7") {
            lz77::encode_to_file(
                dict_size,
                input_size,
                max_match,
                out_file.clone(),
                &file_name,
            )?
        } else {
            lzss::encode_to_file(
                dict_size,
                input_size,
                max_match,
                out_file.clone(),
                &file_name,
            )?
        };
        println!("Done, encoded file in {}", fname);
    }
    Ok(())
}

fn main() {
    if let Err(e) = main_wrapper() {
        eprintln!("{}", e.to_string())
    }
}
