# Copyright 2018 Tierion
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM rust:1.29.1-stretch

LABEL MAINTAINER="Glenn Rempe <glenn@tierion.com>"

ENV TZ=UTC

# gosu : https://github.com/tianon/gosu
RUN apt-get update && apt-get install -y git gosu vim

# Tini : https://github.com/krallin/tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
#ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
#RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && gpg --verify /tini.asc
RUN chown root:root /tini && chmod 755 /tini

RUN useradd -ms /bin/bash roughenough

WORKDIR /

RUN git clone https://github.com/int08h/roughenough.git

WORKDIR /roughenough

# PIN Versions:
# 1.0.5 : 7875dda06327f771cd67eb135b381e6d87c228de
RUN git reset --hard 7875dda06327f771cd67eb135b381e6d87c228de

RUN cargo build --release

EXPOSE 2002/udp

ENTRYPOINT ["gosu", "roughenough:roughenough", "/tini", "--"]
CMD ["/roughenough/target/release/server", "/roughenough/roughenough.cfg"]
