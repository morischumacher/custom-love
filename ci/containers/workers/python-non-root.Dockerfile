FROM python:3.12.0-alpine

RUN pip install --upgrade pip

RUN adduser -D worker
USER worker
WORKDIR /home/worker

ENV PATH="/home/worker/.local/bin:${PATH}"

COPY --chown=worker:worker . .