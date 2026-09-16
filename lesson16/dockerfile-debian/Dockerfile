FROM debian:11

RUN printf '%s\n' \
    'deb [check-valid-until=no] http://archive.debian.org/debian bullseye main' \
    > /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nginx \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/www

COPY index.html /opt/www/index.html
COPY nginx.conf /etc/nginx/sites-available/default

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
