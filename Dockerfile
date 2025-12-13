FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

# 로케일 설정
RUN apt-get update && \
    apt-get upgrade -yq && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# 기본 패키지 설치
RUN apt-get update && apt-get upgrade -yq && apt-get install -y \
    apt-utils \
    bear \
    automake \
    build-essential \
    clang-tools \
    cppcheck \
    coreutils \
    pv \
    vim \
    lsof \
    net-tools \
    git \
    g++ \
    git-lfs \
    cmake \
    bison \
    flex \
    texlive \
    texlive-latex-extra \
    texlive-fonts-extra \
    pdftk \
    doxygen \
    texinfo \
    bzip2 \
    xz-utils \
    unzip \
    wget \
    curl \
    tar \
    pax \
    sudo \
    policykit-1 \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    uml-utilities \
    mono-complete \
    gtk-sharp3 \
    x11-apps \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /opt

CMD ["/bin/bash"]
