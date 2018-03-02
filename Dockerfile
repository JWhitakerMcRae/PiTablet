# Install base image
FROM resin/raspberrypi3-debian:latest

# Enable systemd
ENV INITSYSTEM on

# Install base OS tools and dependencies
RUN apt-get update && apt-get -y install \
    build-essential \
    curl \
    git \
    make \
    net-tools \
    openssh-server \
    pkgconf \
    raspi-config \
    rpi-update \
    vim \
    wget

# Install LXDE desktop environment and dependencies
RUN apt-get update && apt-get -y install \
    lightdm \
    lxde \
    xserver-xorg
RUN apt-get update && apt-get -y install \
    firefox

# Create default user, set to auto login
RUN useradd -m "pitablet" && \
    echo "root:pitablet1!" | chpasswd && \
    echo "pitablet:pitablet1!" | chpasswd && \
    echo "[SeatDefaults]" >> /etc/lightdm/lightdm.conf && \
    echo "autologin-user=pitablet" >> /etc/lightdm/lightdm.conf

# Install dependencies for the STM-8 and J-Link packages
RUN apt-get update && apt-get -y install \
    git \
    libstdc++6 \
    libusb-1.0.0-dev \
    sdcc

# Install and configure STM-8 package (https://github.com/vdudouyt/stm8flash.git)
ADD packages/stm8flash.tgz /root/
RUN cd /root/stm8flash && make && make install

# Install and configure J-Link package (https://www.segger.com/downloads/jlink/)
ADD packages/JLink_Linux_V612f_arm.tgz /opt/SEGGER/
RUN cd /opt/SEGGER && ln -s JLink_Linux_V612f_arm JLink && \
    cd /opt/SEGGER/JLink && cp -p 99-jlink.rules /etc/udev/rules.d/

# Fix J-Link ARM package issues (could change with newer versions than 6.12)
RUN cd /opt/SEGGER/JLink && ln -s libjlinkarm.so.6 libjlinkarm.so.5
RUN cd /lib && ln -s arm-linux-gnueabihf/libudev.so.1 libudev.so.0

# Install pip and other custom script requirements
RUN apt-get update && apt-get -y install python-pip && \
    pip install -U awscli pyserial requests

# Copy scripts, icons, and media
COPY scripts/* /home/pitablet/
COPY icons/* /home/pitablet/Desktop/
COPY media/* /home/pitablet/Pictures/
RUN chown -R pitablet:pitablet /home/pitablet

# Configure desktop preferences
RUN ln -s /home/pitablet/Pictures/Rocky\ Mountains\ \(Day\).png /etc/alternatives/desktop-background && \
    sed -i 's/single_click=0/single_click=1/g' /etc/xdg/libfm/libfm.conf

# Complete boot
USER root
RUN chmod +x /home/pitablet/start.sh
CMD ["bash", "/home/pitablet/start.sh"]
