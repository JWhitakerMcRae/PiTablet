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
    python3-dev \
    python3-pip \
    raspi-config \
    rpi-update \
    vim \
    wget

# Install LXDE desktop environment and dependencies
RUN apt-get update && apt-get --install-recommends -y install \
    xserver-xorg \
    lightdm \
    lxde

# Install bluetooth stack (bluez) and all dependencies
RUN apt-get update && apt-get -y install \
    bluetooth \
    bluez \
    libbluetooth-dev \
    libboost-all-dev \
    libboost-python-dev \
    libglib2.0-dev

# Install GTK+3 and dependencies (http://pygobject.readthedocs.io/en/latest/getting_started.html)
RUN apt-get update && apt-get -y install \
    gtk+3.0 \
    gobject-introspection \
    python3-gi \
    python3-gi-cairo

# Install script requirements
RUN pip3 install -U \
    flask \
    gattlib \
    netifaces \
    pybluez \
    pyserial \
    requests

# Create default user, set to auto login
RUN useradd -m "pitablet" && \
    echo "root:pitablet1!" | chpasswd && \
    echo "pitablet:pitablet1!" | chpasswd && \
    echo "[SeatDefaults]" >> /etc/lightdm/lightdm.conf && \
    echo "autologin-user=pitablet" >> /etc/lightdm/lightdm.conf

# Copy user data
USER pitablet
COPY icons/* /home/pitablet/Desktop/
COPY media/* /home/pitablet/Pictures/

# Copy app data
USER root
COPY config/* src/* /app/
COPY start.sh /app/

# Configure desktop preferences # TODO: is this the proper way to set desktop background?
RUN ln -f -s /home/pitablet/Pictures/Rocky\ Mountains\ \(Day\).png /etc/alternatives/desktop-background && \
    sed -i 's/single_click=0/single_click=1/g' /etc/xdg/libfm/libfm.conf

# Ensure filesystem owner, group, and permissions
RUN chown -R pitablet:pitablet /home/pitablet && \
    chown -R pitablet:pitablet /app && \
    chmod +x /app/start.sh

# Boot app
CMD ["bash", "/app/start.sh"]
