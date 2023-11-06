FROM ghcr.io/brotholomew/python-non-root:3.12.0-bookworm

COPY requirements.txt /var/requirements.txt
COPY backend /var/backend

RUN pip install --user -r /var/requirements.txt

WORKDIR /var
CMD [ "tail", "-f", "/dev/null" ]
#CMD ["uvicorn", "backend.main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "80"]