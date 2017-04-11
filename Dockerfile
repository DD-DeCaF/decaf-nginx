FROM nginx:1.9.6
COPY files /usr/share/nginx/html
RUN mkdir /usr/share/nginx/docs
COPY docs /usr/share/nginx/docs
COPY nginx.conf /etc/nginx/nginx.conf
