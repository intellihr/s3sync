FROM kickstarter/docker-s3-sync:latest
MAINTAINER Soloman Weng "soloman.weng@intellihr.com.au"
ENV REFRESHED_AT 2017-07-12

RUN curl -o /usr/local/bin/mantra -L https://github.com/pugnascotia/mantra/releases/download/0.0.1/mantra && \
    chmod +x /usr/local/bin/mantra

ENTRYPOINT ["/entrypoint.sh"]
