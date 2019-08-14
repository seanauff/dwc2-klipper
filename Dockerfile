FROM python:2.7

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    wget \
    gzip \
    tar \
    build-essential \
    libjpeg62-turbo-dev \
    imagemagick \
    libv4l-dev \
    cmake \
    sudo

# enable klipper to install by creating users
COPY klippy.sudoers /etc/sudoers.d/klippy
RUN useradd -ms /bin/bash klippy && \
    useradd -ms /bin/bash dwc2-klipper && \
    adduser dwc2-klipper dialout
USER dwc2-klipper

WORKDIR /home/dwc2-klipper

# config file to use. see list here: https://github.com/KevinOConnor/klipper/tree/master/config
ARG KLIPPER_CONFIG=example.cfg

RUN git clone https://github.com/KevinOConnor/klipper && \
    ./klipper/scripts/install-octopi.sh && \
    virtualenv ./klippy-env && \
    ./klippy-env/bin/pip install tornado==5.1.1 && \
    git clone https://github.com/Stephan3/dwc2-for-klipper.git && \
    ln -s ~/dwc2-for-klipper/web_dwc2.py ~/klipper/klippy/extras/web_dwc2.py && \
    wget https://raw.githubusercontent.com/Stephan3/klipper/master/klippy/gcode.py > klipper/klippy/gcode.py && \
    cp klipper/config/${KLIPPER_CONFIG} /home/dwc2-klipper/printer.cfg && \
    mkdir -p /home/dwc2-klipper/sdcard/dwc2/web

WORKDIR /home/dwc2-klipper/sdcard/dwc2/web

RUN wget https://github.com/chrishamm/DuetWebControl/releases/download/2.0.0-RC5/DuetWebControl.zip && \
    unzip *.zip && for f_ in $(find . | grep '.gz');do gunzip ${f_};done

EXPOSE 4750

USER root

COPY runklipper.py /

CMD ["/usr/bin/python","/runklipper.py"]
