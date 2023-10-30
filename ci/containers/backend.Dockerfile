FROM ghcr.io/brotholomew/python-non-root:3.12.0-alpine

COPY requirements.txt /var/requirements.txt
COPY backend /var/inso_06

RUN pip install --user -r /var/requirements.txt

WORKDIR /var
CMD ["uvicorn", "inso_06.main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "80"]