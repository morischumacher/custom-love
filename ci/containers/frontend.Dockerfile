FROM ghcr.io/brotholomew/flutter-non-root:latest as builder
ARG BASE_HREF="/"

COPY frontend /var/inso_06
WORKDIR /var/inso_06

RUN flutter pub get
RUN flutter build web --base-href ${BASE_HREF}

FROM ghcr.io/brotholomew/httpd-non-root:latest as runner

COPY --from=builder /var/inso_06/build/web /usr/local/apache2/htdocs/