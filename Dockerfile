FROM arm64v8/rust AS build-rust
WORKDIR /usr/local/src

ENV DENO_VERSION=v1.26.2
RUN git clone --recurse-submodules https://github.com/denoland/deno.git -b ${DENO_VERSION} --depth 1 
RUN cd deno && CARGO_HOME=/cargo cargo check
RUN cd deno && CARGO_HOME=/cargo cargo build --release

FROM arm64v8/debian:bullseye-slim

ENV APP=/usr/local/bin/deno
ENV APP_USER=deno
ENV APP_HOME=/home/deno

RUN groupadd $APP_USER \
    && useradd -g $APP_USER $APP_USER \
    && mkdir -p ${APP_HOME}

COPY --from=build-rust /usr/local/src/deno/target/release/deno ${APP}

RUN chown -R $APP_USER:$APP_USER ${APP}
USER $APP_USER
WORKDIR ${APP_HOME}

CMD ["/bin/bash"]
