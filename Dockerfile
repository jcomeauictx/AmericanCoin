# syntax=docker/dockerfile:1
FROM debian:buster
ARG USERNAME=americancoiner
ARG REALNAME='AmericanCoin Daemon'
ARG GITHUB=https://github.com/jcomeauictx
WORKDIR /usr/src/jcomeauictx
RUN adduser --quiet --disabled-password --gecos "$REALNAME" $USERNAME
RUN loginctl enable-linger $USERNAME
RUN apt update
RUN apt install git make
RUN chown $WORKDIR $USERNAME
RUN su - $USERNAME -c "git clone $GITHUB/AmericanCoin.git"
RUN cd AmericanCoin/src && make -f buster.mk prepare
RUN su $USERNAME -c "make -f buster.mk all install"
ENTRYPOINT ["docker-entrypoint.sh", "americancoind"]
