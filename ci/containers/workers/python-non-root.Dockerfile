FROM python:3.12.0-slim-bookworm

#RUN pip install --upgrade pip

RUN useradd -m worker
USER worker
WORKDIR /home/worker

ENV PATH="/home/worker/.local/bin:${PATH}"

COPY --chown=worker:worker . .