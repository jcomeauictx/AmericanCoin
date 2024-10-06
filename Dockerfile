# syntax=docker/dockerfile:1
FROM debian:buster
ARG USERNAME=americancoiner
ARG REALNAME='AmericanCoin Daemon'
ARG WORKDIR=/usr/src/jcomeauictx
ARG GITHUB=https://github.com/jcomeauictx
ARG AMCSRC=AmericanCoin/src
WORKDIR $WORKDIR
RUN adduser --quiet --disabled-password --gecos "$REALNAME" $USERNAME
RUN apt update
RUN apt install --yes git make finger
RUN finger $USERNAME  # make sure adduser worked correctly
RUN chown $USERNAME $WORKDIR
RUN ls -ld $WORKDIR  # make sure chown worked
RUN su $USERNAME -c "git clone $GITHUB/AmericanCoin.git"
RUN cd $AMCSRC && make -f docker.mk prepare
# following must exit successfully or image will not be tagged
RUN su $USERNAME -c "cd $AMCSRC && make -f docker.mk conf"
RUN cd $AMCSRC && make install
ENTRYPOINT ["docker-entrypoint.sh", "americancoind"]
