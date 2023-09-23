FROM alpine

ARG GIT_REPO="https://github.com/un1x01d/emulate_get_flood.git"

ENV URL="http://192.168.102.1"

ENV THREADS=10
ENV TIMEOUT=10
ENV TERM="xterm"

RUN apk update && apk upgrade 

RUN apk add bash \
            coreutils \
            git \
            curl \
            ncurses 

RUN git clone $GIT_REPO

WORKDIR emulate_get_flood

RUN chmod +x emulate_get_flood.sh

CMD ./emulate_get_flood.sh -x ${THREADS} -t ${TIMEOUT} -u ${URL}
