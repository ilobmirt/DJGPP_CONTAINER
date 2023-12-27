FROM docker.io/library/debian as Stage1
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
RUN ln -s ${DJGPP_BIN}/gcc ${DJGPP_BIN}/cc
RUN rm -rf ${BUILD_DIR}
RUN DEBIAN_FRONTEND=noninteractive apt-get clean
VOLUME ${INPUT_DIR}

#Stage2 - This should squash all the layers
FROM scratch
COPY --from=Stage1 / /

ENV INPUT_DIR=/input
ENV DJGPP_PREFIX=/usr/local/my-djgpp
ENV DJGPP_BIN=${DJGPP_PREFIX}/i586-pc-msdosdjgpp/bin

ENV PATH ${DJGPP_BIN}:${PATH}
ENV GCC_EXEC_PREFIX=${DJGPP_PREFIX}/lib/gcc/

WORKDIR ${INPUT_DIR}
ENTRYPOINT ["/bin/bash"]