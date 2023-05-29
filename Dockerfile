ARG OPENCPI_VERSION=v2.5.0-beta.1

FROM centos:7 AS base

#install common packages

RUN yum update -y \
&& yum install -y \
  git \
  nfs-utils \
  gcc \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  Xvfb \
&& yum -y reinstall glibc-common \
&& yum clean all \
&& rm -rf /var/cache/yum

# required to install opencpi
RUN echo "LANG=en_US.utf8" >> /etc/locale.conf
ENV LANG=en_US.utf8

# install opencpi
FROM base as opencpi

ARG OPENCPI_VERSION

RUN git clone -b "${OPENCPI_VERSION}" https://gitlab.com/opencpi/opencpi.git
RUN /opencpi/projects/core/rcc/platforms/centos7/centos7-packages.sh \
&& yum clean all \
&& rm -rf /var/cache/yum

WORKDIR /opencpi
RUN ./scripts/install-opencpi.sh --minimal
RUN source cdk/opencpi-setup.sh -s

ENTRYPOINT [""]

CMD ["/bin/bash"]

LABEL org.opencontainers.image.source=https://github.com/benjmarshall/centos7_opencpi_docker
LABEL org.opencontainers.image.description="A container to run OpenCPI on a centos7 base."