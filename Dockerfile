FROM golang:1.19.13-alpine3.18
ENV PATH="$PATH:/bin/bash" \
    BENTO4_BIN="/opt/bento4/bin" \
    PATH="$PATH:/opt/bento4/bin"

# FFMPEG
RUN apk add --update ffmpeg bash curl make

# Install Bento
WORKDIR /tmp/bento4
ENV BENTO4_BASE_URL="http://zebulon.bok.net/Bento4/source/" \
    BENTO4_VERSION="1-6-0-637" \
    BENTO4_CHECKSUM="45b627e73253a3e03fa31af3b843f2c194f85793" \
    BENTO4_TARGET="" \
    BENTO4_PATH="/opt/bento4" \
    BENTO4_TYPE="SRC"

# download and unzip bento4
RUN apk add --update --upgrade curl python3 unzip bash gcc g++ scons
RUN wget -q ${BENTO4_BASE_URL}/Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip
RUN sha1sum -b Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip | grep -o "^$BENTO4_CHECKSUM "
RUN mkdir -p ${BENTO4_PATH}
RUN unzip Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip -d ${BENTO4_PATH}
RUN rm -rf Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}${BENTO4_TARGET}.zip
RUN apk del unzip

# don't do these steps if using binary install
# RUN cd ${BENTO4_PATH} && scons -u build_config=Release target=x86_64-unknown-linux
# RUN cp -R ${BENTO4_PATH}/Build/Targets/x86_64-unknown-linux/ ${BENTO4_PATH}/bin
# RUN cp -R ${BENTO4_PATH}/Source/Python/utils ${BENTO4_PATH}/utils
# RUN cp -a ${BENTO4_PATH}/Source/Python/wrappers/. ${BENTO4_PATH}/bin

# Fix Python 2-style print statements
# RUN sed -i "s/print \(.*\)/print(\1)/g" ${BENTO4_PATH}/Build/Boot.scons

WORKDIR /go/src

ENTRYPOINT ["tail", "-f", "/dev/null"]