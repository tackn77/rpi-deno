FROM arm64v8/rust AS build-rust
WORKDIR /usr/local/src

ENV DENO_VERSION=main
RUN git clone --recurse-submodules https://github.com/denoland/deno.git -b ${DENO_VERSION} --depth 1 
RUN cd deno && CARGO_HOME=/cargo cargo check
RUN cd deno && CARGO_HOME=/cargo cargo build --release

FROM arm64v8/debian:bullseye-slim

ENV APP=/usr/bin/deno
ENV APP_USER=deno
ENV APP_UID=1993

RUN groupadd --gid $APP_UID $APP_USER \
    && useradd -g $APP_USER -u $APP_UID -s /bin/sh -M $APP_USER

COPY --from=build-rust /usr/local/src/deno/target/release/deno ${APP}

WORKDIR /

CMD ["/bin/sh"]
