FROM curlimages/curl:7.74.0 as curl
FROM rocker/r-ver:4.0.3 as rver
ENV DEBIAN_FRONTEND=noninteractive

FROM curl as python_source

RUN curl -L -o /tmp/Python.tar.xz https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tar.xz

FROM rver as python

RUN apt-get update \
    && apt-get -yyq install \
      build-essential \
      libncurses5-dev \
      libgdbm-dev \
      libnss3-dev \
      libssl-dev \
      libsqlite3-dev \
      libreadline-dev \
      libffi-dev \
      libbz2-dev \
      zlib1g-dev

COPY --from=python_source /tmp/Python.tar.xz /tmp/Python_src.tar.xz

WORKDIR /tmp/python/
RUN tar -xJ --strip-components 1 --file /tmp/Python_src.tar.xz
RUN ./configure --enable-shared --enable-optimizations
RUN make altinstall
RUN tar --create -f /tmp/python.tar /usr/local/include/python3.7m  /usr/local/lib/python3.7/ /usr/local/bin/*3.7 /usr/local/lib/pkgconfig/python-3.7.pc /usr/local/lib/python3.7/ /usr/local/lib/libpython3.7*

FROM rver as app

WORKDIR /app/

RUN apt-get update \
    && apt-get -yyq install \
      libncurses5 \
      libgdbm6 \
      libnss3 \
      libssl1.1 \
      libsqlite3-0 \
      libreadline8 \
      libffi7 \
      libbz2-1.0 \
      zlib1g

COPY --from=python ["/tmp/python.tar", "/"]
RUN tar --extract --directory=/ --file /python.tar \
    && rm /python.tar \
    && ldconfig

#
#RUN apt-get update \
#    && apt-get -yyq install \
#        libpython3-dev \
#        python3-dev \
#        python3-pip \
#        python3-virtualenv \
#        python3-venv
#
RUN apt-get update \
    && apt-get -yyq install \
        libcurl4-openssl-dev

COPY [".","/app/"]
RUN /usr/local/bin/Rscript -e 'renv::restore()'

ENTRYPOINT ["/usr/local/bin/Rscript"]
CMD [ "/app/R/pipeline.R" ]

