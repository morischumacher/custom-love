FROM ghcr.io/brotholomew/python-non-root:3.12.0-bookworm
ARG ROOT_PATH

COPY requirements.txt /var/requirements.txt
COPY backend /var/backend

RUN pip install --user -r /var/requirements.txt
ENV ROOT_PATH ${ROOT_PATH}

WORKDIR /var
CMD uvicorn backend.main:app --proxy-headers --root-path ${ROOT_PATH} --host 0.0.0.0 --port 80