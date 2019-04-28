FROM debian:experimental

ENV NSIS 3.04-1
ENV VERBOSITY 4

RUN apt-get update && \
    apt-get install -y nsis=${NSIS} && \
    apt-get clean

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
CMD [ "/app/installer.nsi" ]