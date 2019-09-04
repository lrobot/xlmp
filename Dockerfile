## xlmp
FROM xenocider/container:python3.6.4
LABEL maintainer="xenos <xenos.lu@gmail.com>"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# runit \
# supervisor 3.3.4 not support python3
RUN apk add --no-cache \
            git \
            nginx \
            s6 &&\
    # pip3 install tornado==5.1 &&\
    pip3 install tornado==5.1.1 -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com &&\
    pip3 install xmltodict==0.11.0 -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com &&\
    mkdir /run/nginx &&\
    rm -f /etc/nginx/conf.d/default.conf

# copy nginx config file
COPY docker/xlmp.conf /etc/nginx/conf.d/

# deploy script
COPY docker/deploy /usr/local/bin

# git clone
RUN git clone https://github.com/lrobot/xlmp.git /xlmp

EXPOSE 82

# media folder:
VOLUME /xlmp/media

# ENTRYPOINT ["/bin/sh", "/xlmp/docker/docker-entrypoint.sh"]
# CMD ["/usr/bin/supervisord", "-c", "/xlmp/docker/supervisord.conf"]
CMD ["/bin/s6-svscan", "/xlmp/docker/s6/"]
