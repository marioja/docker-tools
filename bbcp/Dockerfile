# Build stage - use Ubuntu 20.04 with GCC that's compatible with legacy C++ code
FROM ubuntu:20.04 AS builder

# Set environment to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies including git to clone source
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libssl-dev \
    linux-libc-dev \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download bbcp source code from official repository (ignore SSL certs)
RUN git -c http.sslVerify=false clone https://www.slac.stanford.edu/~abh/bbcp/bbcp.git /bbcp

# Build bbcp from downloaded source - use x86_64 Linux target
WORKDIR /bbcp/src
RUN mkdir -p ../obj/amd64_linux ../bin/amd64_linux && \
    make makeLinuxx86_64 OSVER=amd64_linux MD5HEADER=bbcp_MD5_openssl.h OBJMD5="../obj/amd64_linux/bbcp_MD5_openssl.o" && \
    cp ../bin/amd64_linux/bbcp /usr/local/bin/

# Runtime stage - use Ubuntu 20.04 for consistency
FROM ubuntu:20.04

# Set environment to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    bash \
    zlib1g \
    libssl1.1 \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Copy the compiled bbcp executable from builder stage
COPY --from=builder /usr/local/bin/bbcp /usr/local/bin/bbcp

# Set entrypoint
ENTRYPOINT ["bbcp"]