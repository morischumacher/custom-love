FROM ghcr.io/cirruslabs/flutter:3.13.9 as builder
ARG BASE_HREF="/"

COPY frontend /var/inso_06
WORKDIR /var/inso_06

RUN flutter pub get
RUN flutter build web --base-href ${BASE_HREF}

FROM httpd:2.4 as runner

COPY --from=builder /var/inso_06/build/web /usr/local/apache2/htdocs/