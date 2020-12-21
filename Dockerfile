FROM debian:buster-slim AS build

RUN ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb && \
    ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split

RUN apt-get update && \
    apt-get -y install --no-install-recommends ca-certificates file git build-essential  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone -b master https://github.com/sippy/rtpproxy.git && \
    git -C rtpproxy submodule update --init --recursive && \
    cd rtpproxy && \
    ./configure && \
    make && \
    make install


FROM debian:buster-slim
COPY --from=build /usr/local/lib/ /usr/local/lib/
COPY --from=build /usr/local/bin/ /usr/local/bin/

CMD ["/usr/local/bin/rtpproxy", "-F", "-f"]
