## xlmp
FROM xenocider/container:python3.5.2
LABEL maintainer="xenos <xenos.lu@gmail.com>"

            # runit \
# supervisor 3.3.4 not support python3
RUN apk add --no-cache \
            git \
            nginx \
            s6 &&\
    pip3 install tornado==5.1 &&\
    pip3 install xmltodict==0.11.0 &&\
    mkdir /run/nginx &&\
    rm -f /etc/nginx/conf.d/default.conf

# copy nginx config file
COPY docker/xlmp.conf /etc/nginx/conf.d/

# deploy script
COPY docker/deploy /usr/local/bin
# RUN chmod +x /usr/local/bin/deploy

COPY . /xlmp

# git clone
# RUN git clone -b latest https://github.com/XenosLu/xlmp.git /xlmp

EXPOSE 80

# media folder:
VOLUME /xlmp/media

# RUN chmod -R +x /xlmp/docker/s6
# ENTRYPOINT ["/bin/sh", "/xlmp/docker/docker-entrypoint.sh"]
# CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
CMD ["/bin/s6-svscan", "/xlmp/docker/s6/"]