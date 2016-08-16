FROM python:2.7.12-alpine

RUN apk add --update \
    nginx \
    supervisor \
        && rm -rf /var/cache/apk/*

COPY requirements.txt /tmp/requirements.txt

RUN apk add --update \
    build-base \
    linux-headers \
    py-pip \
	&& pip install -r /tmp/requirements.txt \
    && apk del \
        build-base \
        linux-headers \
    && rm -rf /var/cache/apk/*

ENV APP_DIR /app

RUN mkdir ${APP_DIR} \
	&& chown -R nginx:nginx ${APP_DIR} \
	&& chmod 777 /run/ -R \
	&& chmod 777 /root/ -R
WORKDIR ${APP_DIR}

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

COPY . /app

EXPOSE 80

CMD ["/usr/bin/supervisord"]
