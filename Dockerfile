# Stage 1: Build the binary using an Ubuntu image
FROM ubuntu:22.04 as builder

# Install packages to build the C program
RUN apt-get update && apt-get install -y build-essential

# Copy the C file to the container
COPY HelloWorld.c /HelloWorld.c

# Compile the C program
RUN gcc -o /HelloWorld /HelloWorld.c

# Stage 2: Create image with only needed components
FROM scratch

# Copy all required libraries from the builder image
COPY --from=builder /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=builder /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

# Copy the HelloWorld binary and the password file from the builder image
COPY --from=builder /HelloWorld /HelloWorld
COPY --from=builder /etc/passwd /etc/passwd

# Create necessary directories
COPY --from=builder /tmp /tmp

# Set the entrypoint to the HelloWorld binary
ENTRYPOINT ["/HelloWorld"]
