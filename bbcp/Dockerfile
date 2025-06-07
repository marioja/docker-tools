# Build stage - use Alpine 3.14 with older GCC that's more compatible with legacy C++ code
FROM alpine:3.14 AS builder

# Install build dependencies including git to clone source
RUN apk add --no-cache \
    build-base \
    zlib-dev \
    openssl-dev \
    linux-headers \
    libnsl-dev \
    git

# Download bbcp source code from official repository (ignore SSL certs)
RUN git -c http.sslVerify=false clone https://www.slac.stanford.edu/~abh/bbcp/bbcp.git /bbcp

# Copy our patched bbcp_FileSpec.C to fix the decode issue with missing filename fields
COPY bbcp_FileSpec.C /bbcp/src/bbcp_FileSpec.C

# Build bbcp from downloaded source - use default compilation which works with Alpine 3.14 GCC
# Note: To add custom CFLAGS, you can override them like this:
# make makeLinuxx86_64 OSVER=amd64_linux MD5HEADER=bbcp_MD5_openssl.h OBJMD5="../obj/amd64_linux/bbcp_MD5_openssl.o" \
#   CFLAGS="-std=c++14 -Dunix -D_BSD -D_ALL_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DNL_THREADSAFE -D_REENTRANT -DOO_STD -DLINUX -Wno-deprecated -D_GNU_SOURCE -g"
WORKDIR /bbcp/src
RUN mkdir -p ../obj/amd64_linux ../bin/amd64_linux && \
    make makeLinuxx86_64 OSVER=amd64_linux MD5HEADER=bbcp_MD5_openssl.h OBJMD5="../obj/amd64_linux/bbcp_MD5_openssl.o" && \
    cp ../bin/amd64_linux/bbcp /usr/local/bin/

# Runtime stage - use Alpine 3.14 for consistency and OpenSSL compatibility
FROM alpine:3.14

# Install bash and runtime dependencies including C++ standard library
# libstdc++ and libgcc are required for C++ executables compiled with g++
RUN apk add --no-cache bash zlib openssl libnsl libstdc++ libgcc procps

# Copy the compiled bbcp executable from builder stage
COPY --from=builder /usr/local/bin/bbcp /usr/local/bin/bbcp

# Set entrypoint
ENTRYPOINT ["bbcp"]