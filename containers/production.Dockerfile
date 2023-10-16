FROM python:3.12.0-alpine3.18
COPY . /var/inso_6
RUN pip install -r /var/requirements.txt
CMD python3 manage.py runserver 0.0.0.0:8000