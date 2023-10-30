FROM ghcr.io/cirruslabs/flutter:3.13.9

RUN useradd -m worker
RUN chown -R worker:worker /sdks/
RUN chown -R worker:worker /home/worker
ENV PATH=$PATH:/sdks/flutter/bin

USER worker
