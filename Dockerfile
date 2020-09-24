FROM maven:3-openjdk-11

RUN apt-get update
RUN wget https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-amd64.tar.xz
RUN xz -d tmate-2.4.0-static-linux-amd64.tar.xz
RUN tar xvf tmate-2.4.0-static-linux-amd64.tar
RUN mv tmate-2.4.0-static-linux-amd64/tmate /usr/local/bin/tmate
RUN tmate -V
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
