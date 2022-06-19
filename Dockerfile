FROM ubuntu:20.04


# Install apt dependencies
RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl wget apt-utils python3 python3-pip make build-essential openssl git jq tzdata sudo \
    && useradd -ms /bin/bash bot \
    && usermod -aG sudo bot \
    && python3 -m pip install --upgrade --force pip \
    && ln -s /usr/bin/python3 /usr/local/bin/python

# configure timezone
ENV TZ="America/Los_Angeles"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Use 'bot' user to avoid pip warning messages
USER bot
# Add source code
WORKDIR /bot
COPY --chown=bot:bot . .
# Install requirements.txt with pip
RUN make setup

# Since requirements.txt can be mounted, run install again
# before running python.py in case of differences/updates
CMD make start
