FROM alpine:latest
MAINTAINER Soloman Weng "soloman.weng@intellihr.com.au"
ENV REFRESHED_AT 2017-07-12

RUN apk update
RUN apk add python py-pip py-setuptools git ca-certificates curl jq
RUN pip install python-dateutil

RUN git clone https://github.com/s3tools/s3cmd.git /opt/s3cmd
RUN ln -s /opt/s3cmd/s3cmd /usr/bin/s3cmd

RUN curl -o /opt/mantra -L https://github.com/pugnascotia/mantra/releases/download/0.0.1/mantra && \
    chmod +x /opt/mantra

VOLUME /opt/data

COPY sync.sh /opt/sync.sh
COPY run.sh /opt/run.sh

CMD ["/opt/run.sh"]
