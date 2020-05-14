FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    wget \
    gzip \
    tar \
    build-essential \
    imagemagick \
    libv4l-dev \
    cmake \
    sudo \
    ca-certificates \
    unzip \
    socat

# This is to allow the klipper install script to run without error
RUN ln -s /bin/true /bin/systemctl

# enable klipper to install by creating users
COPY klippy.sudoers /etc/sudoers.d/klippy
RUN useradd -ms /bin/bash klippy && \
    useradd -ms /bin/bash dwc2-klipper && \
    adduser dwc2-klipper dialout
USER dwc2-klipper

WORKDIR /home/dwc2-klipper

RUN git clone https://github.com/KevinOConnor/klipper && \
    ./klipper/scripts/install-ubuntu-18.04.sh

RUN virtualenv ./klippy-env && \
    ./klippy-env/bin/pip install tornado==5.1.1

RUN git clone https://github.com/pluuuk/dwc2-for-klipper.git && \
    ln -s ~/dwc2-for-klipper/web_dwc2.py ~/klipper/klippy/extras/web_dwc2.py

RUN mkdir -p /home/dwc2-klipper/sdcard/dwc2/web && \
    mkdir -p /home/dwc2-klipper/sdcard/sys

WORKDIR /home/dwc2-klipper/sdcard/dwc2/web

RUN wget https://github.com/chrishamm/DuetWebControl/releases/download/2.1.7/DuetWebControl-SD.zip && \
    unzip *.zip && for f_ in $(find . | grep '.gz');do gunzip ${f_};done

WORKDIR /home/dwc2-klipper

EXPOSE 4750

USER root

# Clean up hack for install script
RUN rm -f /bin/systemctl

COPY runklipper.py /

CMD ["/usr/bin/python","/runklipper.py"]
