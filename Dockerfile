FROM nginx:1.13.10

# Rebuild with nginx-module-vts
ENV NGINX_VERSION     "1.13.10"
ENV NGINX_VTS_VERSION "0.1.15"
RUN echo "deb-src http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y dpkg-dev curl \
  && mkdir -p /opt/rebuildnginx \
  && chmod 0777 /opt/rebuildnginx \
  && cd /opt/rebuildnginx \
  && apt-get source nginx \
  && apt-get build-dep -y nginx=${NGINX_VERSION} \
  && cd /opt \
  && curl -sL https://github.com/vozlt/nginx-module-vts/archive/v${NGINX_VTS_VERSION}.tar.gz | tar -xz \
  && sed -i -r -e "s/\.\/configure(.*)/.\/configure\1 --add-module=\/opt\/nginx-module-vts-${NGINX_VTS_VERSION}/" /opt/rebuildnginx/nginx-${NGINX_VERSION}/debian/rules \
  && cd /opt/rebuildnginx/nginx-${NGINX_VERSION} \
  && dpkg-buildpackage -b \
  && cd /opt/rebuildnginx \
  && dpkg --install nginx_${NGINX_VERSION}-1~stretch_amd64.deb \
  && apt-get remove --purge -y dpkg-dev curl && apt-get -y --purge autoremove && rm -rf /var/lib/apt/lists/*

COPY files /usr/share/nginx/html
RUN mkdir /usr/share/nginx/doc
COPY doc /usr/share/nginx/doc
COPY nginx.conf /etc/nginx/nginx.conf
