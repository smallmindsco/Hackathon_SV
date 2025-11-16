# Smith&Vader OS ES - Docker Build Environment
# Provides ARM cross-compilation toolchain and QEMU emulation

FROM ubuntu:22.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install ARM cross-compilation toolchain and QEMU
RUN apt-get update && apt-get install -y \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    qemu-system-arm \
    make \
    git \
    vim \
    nano \
    tree \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /smithvader

# Copy all source files
COPY . .

# Set permissions
RUN chmod +x *.sh 2>/dev/null || true

# Default command shows help
CMD ["make", "help"]
