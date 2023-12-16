FROM docker.io/library/debian
ENV GPP_VER=12.2.0
ENV BUILD_DIR=/mydjgpp
ENV INPUT_DIR=/input
ENV DJGPP_PREFIX=/usr/local/my-djgpp
ENV DJGPP_BIN=${DJGPP_PREFIX}/i586-pc-msdosdjgpp/bin
ENV ENABLE_LANGUAGES=c,c++,f95,objc,obj-c++
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bison flex curl gcc g++ make texinfo zlib1g-dev g++ unzip git nano neofetch bzip2 xz-utils cmake
WORKDIR ${BUILD_DIR}
RUN git clone https://github.com/andrewwutw/build-djgpp.git
WORKDIR ${BUILD_DIR}/build-djgpp
RUN ./build-djgpp.sh ${GPP_VER}
ENV PATH ${DJGPP_BIN}:${PATH}
ENV GCC_EXEC_PREFIX=${DJGPP_PREFIX}/lib/gcc/
RUN ln -s ${DJGPP_BIN}/gcc ${DJGPP_BIN}/cc
VOLUME ${INPUT_DIR}
WORKDIR ${INPUT_DIR}
RUN rm -rf ${BUILD_DIR}
RUN DEBIAN_FRONTEND=noninteractive apt-get clean
ENTRYPOINT ["/bin/bash"]
