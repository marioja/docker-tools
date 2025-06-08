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

# Clone bbcp source code from marioja/bbcp repository (with Docker container fixes)
RUN git clone https://github.com/marioja/bbcp.git /bbcp

# Build bbcp from cloned source - use x86_64 Linux target
WORKDIR /bbcp/src
RUN mkdir -p ../obj/amd64_linux ../bin/amd64_linux && \
    make makeLinuxx86_64 OSVER=amd64_linux MD5HEADER=bbcp_MD5_openssl.h OBJMD5="../obj/amd64_linux/bbcp_MD5_openssl.o" && \
    cp ../bin/amd64_linux/bbcp /usr/local/bin/

# Runtime stage - use Ubuntu 20.04 for consistency
FROM ubuntu:20.04

# Build arguments for version information
ARG BBCP_VERSION_EXTRACTED
ARG BUILD_DATE  
ARG VCS_REF
ARG VERSION_TAG=latest

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

# Add metadata labels for version identification
LABEL org.opencontainers.image.title="BBCP - Berkeley Balanced Copy Protocol"
LABEL org.opencontainers.image.description="High-performance copy utility for large files with Docker container fixes"
LABEL org.opencontainers.image.version="${BBCP_VERSION_EXTRACTED}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${VCS_REF}"
LABEL org.opencontainers.image.source="https://github.com/marioja/bbcp"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/marioja/bbcp"
LABEL org.opencontainers.image.documentation="https://github.com/marioja/bbcp/blob/main/README.md"
LABEL org.opencontainers.image.vendor="marioja"
LABEL org.opencontainers.image.licenses="LGPL-3.0"
LABEL maintainer="marioja"
LABEL bbcp.version="${BBCP_VERSION_EXTRACTED}"
LABEL bbcp.build.version="${VERSION_TAG}"

# Set entrypoint
ENTRYPOINT ["bbcp"]