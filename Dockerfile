FROM dalijolijo/crypto-lib-ubuntu:14.04

MAINTAINER dalijolijo

ENV VERSION "0.15"
USER root
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /shared

RUN apt-get update && \
      apt-get --no-install-recommends -yq install \
      locales \
      git-core \
      build-essential \
      ca-certificates \
      ruby \
      rsync \
      sudo

RUN apt-get -yq purge grub > /dev/null 2>&1 || true && \
    apt-get -y dist-upgrade

RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

RUN bash -c '[[ -d /shared/gitian-builder ]] || git clone https://github.com/kleetus/gitian-builder /shared/gitian-builder'

RUN useradd -d /home/ubuntu -m -s /bin/bash ubuntu && \
    chown root.root /shared/gitian-builder/target-bin/grab-packages.sh && \
    chmod 755 /shared/gitian-builder/target-bin/grab-packages.sh

#RUN chown -R ubuntu.ubuntu /shared/ && \
#    echo 'ubuntu ALL=(root) NOPASSWD:/usr/bin/apt-get,/shared/gitian-builder/target-bin/grab-packages.sh' > /etc/sudoers.d/ubuntu && \
#    chown root.root /etc/sudoers.d/ubuntu && \
#    chmod 0400 /etc/sudoers.d/ubuntu && \
#    chown -R ubuntu.ubuntu /home/ubuntu

RUN printf "[[ -d /shared/bitcore ]] || \
    git clone -b \$1 --depth 1 \$2 /shared/bitcore && \
    cd /shared/gitian-builder; \
    /shared/gitian-builder/bin/gbuild --skip-image --commit bitcore=\$1 --url bitcore=\$2 \$3" > /root/runit.sh
#RUN echo "[[ -d /shared/bitcore ]] || git clone -b \$1 --depth 1 \$2 /shared/bitcore; cd /shared/gitian-builder; /shared/gitian-builder/bin/gbuild --skip-image --commit bitcore=\$1 --url bitcore=\$2 \$3" > /root/runit.sh

CMD ["0.15","https://github.com/LIMXTEC/BitCore.git","../bitcore/contrib/gitian-descriptors/gitian-linux.yml"]
ENTRYPOINT ["/bin/bash", "/root/runit.sh"]
