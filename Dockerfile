# Build Stage
FROM rust as builder

RUN rustup update nightly && \
    rustup default nightly && \
    cargo install cargo-fuzz

RUN mkdir memc-rs
ADD . /memc-rs
WORKDIR /memc-rs/memcrs/fuzz
RUN cargo fuzz build

# Package Stage
FROM ubuntu:20.04

COPY --from=builder /memc-rs/memcrs/fuzz/target/x86_64-unknown-linux-gnu/release/fuzz_binary_decoder /
