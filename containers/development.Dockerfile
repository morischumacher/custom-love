FROM python:3.12.0-bookworm
COPY requirements.txt /var/requirements.txt
RUN mkdir -p /var/inso_06
RUN pip install -r /var/requirements.txt
CMD tail -f /dev/null