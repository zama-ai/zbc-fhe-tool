FROM rust:1.72 as builder

WORKDIR /usr/local/app/fhevm-tfhe-cli
COPY . .
RUN cargo build --release --features tfhe/seeder_unix

FROM debian:bookworm-slim
WORKDIR /usr/local/app

RUN apt-get update && apt-get install -y \
        libc6 \
    && rm -rf /var/lib/apt/lists/*

COPY  --from=builder /usr/local/app/fhevm-tfhe-cli/target/release/fhevm-tfhe-cli /usr/local/bin
ENV RUST_LOG=info

CMD ["fhevm-tfhe-cli"]
