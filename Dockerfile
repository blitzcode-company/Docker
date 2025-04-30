FROM ggmartinez/laravel:php-8.2

RUN sed -i 's/mirror.centos.org/vault.centos.org/g' /etc/yum.repos.d/*.repo && \
    sed -i 's/^#.*baseurl=http/baseurl=http/g' /etc/yum.repos.d/*.repo && \
    sed -i 's/^mirrorlist=http/#mirrorlist=http/g' /etc/yum.repos.d/*.repo

RUN yum -y install epel-release && \
    yum -y install curl tar xz unzip zip openldap-devel libzip-devel php-ldap && \
    yum clean all

RUN curl -L -o /tmp/ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz && \
    mkdir -p /opt/ffmpeg && \
    tar -xf /tmp/ffmpeg.tar.xz -C /opt/ffmpeg --strip-components=1 && \
    mv /opt/ffmpeg/ffmpeg /usr/local/bin/ffmpeg && \
    mv /opt/ffmpeg/ffprobe /usr/local/bin/ffprobe && \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe && \
    ln -s /usr/local/bin/ffmpeg /usr/bin/ffmpeg && \
    ln -s /usr/local/bin/ffprobe /usr/bin/ffprobe && \
    rm -rf /tmp/ffmpeg.tar.xz /opt/ffmpeg

RUN sed -i 's/^post_max_size = .*/post_max_size = 500M/' /etc/php.ini && \
    sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 500M/' /etc/php.ini && \
    sed -i 's/^memory_limit = .*/memory_limit = 512M/' /etc/php.ini && \
    sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /etc/php.ini && \
    sed -i 's/^max_input_time = .*/max_input_time = 300/' /etc/php.ini
