FROM ubuntu:22.04 AS base

ARG USER=devuser
ARG GROUP=devgroup
ARG UID=1000
ARG GID=$UID
ARG USER_FOLDER=/home/${USER}
ARG WORK_FOLDER=${USER_FOLDER}/workspace
ARG STORAGE_FOLDER=${USER_FOLDER}/storage
ARG DEBIAN_FRONTEND=noninteractive

# Installing basic tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gdb \
    git \
    nano \
    bash \
    bash-completion \
    locales \
    ca-certificates \
    sudo \
    vim \
    wget \
    python3 \
    python-is-python3 \
    gcc-avr \
    binutils-avr \
    avr-libc \
    gdb-avr \
    avrdude \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# future commands are run via bash (instead of sh)
SHELL ["/bin/bash", "-c"]

# create locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Add non root user, make it sudoer and not to require password in one layer
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# install clang-format-18
RUN ( wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc ) && \
    echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-18 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-18 main" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    clang-format-18 clang-tidy-18 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/clang-format-18 /usr/bin/clang-format && \
    ln -s /usr/bin/clang-tidy-18 /usr/bin/clang-tidy

# create a non-root user and give access to necessary folders
RUN addgroup --gid ${GID} ${GROUP} && \
    useradd -r -l -u ${UID} -g ${GID} -m -d ${USER_FOLDER} -s /bin/bash ${USER}

RUN mkdir -p ${STORAGE_FOLDER} ${WORK_FOLDER} && \
    chown -R ${USER}:${GROUP} ${USER_FOLDER} ${STORAGE_FOLDER} ${WORK_FOLDER}

# switch to normal user
USER ${USER}

WORKDIR ${WORK_FOLDER}
