FROM rust:1.51.0 as build

RUN rustup default nightly-2021-05-09
RUN apt-get update && apt-get install -y clang

WORKDIR /build
COPY . /build
RUN make release

FROM debian:buster

COPY --from=build /build/target/release/krypto_wealth-node /usr/local/bin
COPY --from=build /build/assets/chain_spec_testnet_raw.json /usr/local/bin/chain_spec_testnet_raw.json
ENTRYPOINT ["krypto_wealth-node", "--chain=/usr/local/bin/chain_spec_testnet_raw.json"]
