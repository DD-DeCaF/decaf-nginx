FROM nginx:1.13

COPY files /usr/share/nginx/html
RUN mkdir /usr/share/nginx/doc
COPY doc /usr/share/nginx/doc
COPY nginx.conf /etc/nginx/nginx.conf
