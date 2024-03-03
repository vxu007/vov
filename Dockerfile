# Build using Alpine base image, installing EasyRSA
FROM alpine:latest

# Label
LABEL maintainer="VoltSSHX <iyke.earth@gmail.com>"



# Install necessary packages from additional Alpine stage
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash curl wget easy-rsa openssl && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Set environment variables
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki

# Set working directory and create missing directories
VOLUME ["/etc/openvpn"]
RUN mkdir -p /$OPENVPN/pki/private

# Expose necessary ports
# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
# Internally uses port 443/tcp, remap using `docker run -p 443:1194/tcp`
# Internally uses port 80/tcp, remap using `docker run -p 80:1194/tcp`
EXPOSE 1194/udp
EXPOSE 443/tcp
EXPOSE 80/tcp

# Set default command
CMD ["volt_volt_ovpn_run"]

# Add scripts
ADD ./bin /usr/local/bin

# Set execute permissions for individual files in /usr/local/bin/
RUN chmod +x /usr/local/bin/*
