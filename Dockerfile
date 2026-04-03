FROM nginx:latest

ARG NGINX_PORT=80
ENV NGINX_PORT=${NGINX_PORT}

RUN sed -i "s/listen       80;/listen       ${NGINX_PORT};/" /etc/nginx/conf.d/default.conf

EXPOSE ${NGINX_PORT}

CMD ["nginx", "-g", "daemon off;"]
