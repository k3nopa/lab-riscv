FROM ubuntu:latest

# 1. Preparation for 2.
RUN apt-get update && apt-get upgrade -yy

# Setting TIMEZONE (required when installing texinfo)
# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# installing packages non-interactively
# https://stackoverflow.com/questions/44331836/apt-get-install-tzdata-noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# 2. Prepare for installation RISC-V GNU Compiler Toolchain
# https://github.com/riscv/riscv-gnu-toolchain#prerequisites
RUN apt-get install -y \
    autoconf        \
    autotools-dev   \
    curl            \
    python3         \
    libmpc-dev      \
    libmpfr-dev     \
    libgmp-dev      \
    gawk            \
    build-essential \
    bison           \
    flex            \
    texinfo         \
    gperf           \
    libtool         \
    patchutils      \
    bc              \
    zlib1g-dev      \
    libexpat-dev

# 3. Clone RISC-V GNU Compiler Toolchain
# https://github.com/riscv/riscv-gnu-toolchain#getting-the-sources
RUN apt-get install -y git
WORKDIR /home/
RUN mkdir github
WORKDIR /home/github/
RUN git clone https://github.com/riscv/riscv-gnu-toolchain

# # 4. Installing RISC-V GNU Compiler Toolchain (Newlib/Linux multilib)
# # https://github.com/riscv/riscv-gnu-toolchain#installation-newliblinux-multilib
WORKDIR /home/github/riscv-gnu-toolchain/
RUN ./configure --prefix=/opt/riscv --enable-multilib
RUN make

ENV RISCV /opt/riscv

# 3. Copy RISC-V GNU Compiler Toolchain (Newlib/Linux multilib)
# COPY ~/../../usr/local/opt/riscv/ ${RISCV}/

# 5. Copy extra files required to compile test programs
# Copy files from /env to RISCV
COPY ./local-env/memdat ${RISCV}/bin/
COPY ./local-env/ldscripts ${RISCV}/ldscripts/
COPY ./local-env/*_makefile ${RISCV}/

# 6. Copy source files of processors and test programs
WORKDIR /home/
RUN mkdir sandbox
WORKDIR /home/sandbox/

