FROM alpine:3.15.2
ENV SCALA_VERSION=2.13.8 \
    SCALA_HOME=/usr/share/scala \
    SBT_VERSION=1.6.2 \
    JDK_VERSION=15.0.5_p3-r0 \ 
    REACT_PORT=3000 \
    PLAY_PORT=9000

RUN addgroup -S appgroup && adduser -S dominik -G appgroup && \
    apk add --update npm && \
    apk add openjdk15=${JDK_VERSION} && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    apk add --no-cache bash curl jq && \
    cd "/tmp" && \
    wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    apk del .build-dependencies && \
    rm -rf "/tmp/"* && \
    export PATH="/usr/local/sbt/bin:$PATH" &&  apk update && apk add ca-certificates wget tar && \
    mkdir -p "/usr/local/sbt" && \
    wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | tar xz -C /usr/local/sbt --strip-components=1 && sbt sbtVersion

USER dominik
WORKDIR /src
VOLUME /src
EXPOSE ${REACT_PORT} ${PLAY_PORT}

ENTRYPOINT bash
