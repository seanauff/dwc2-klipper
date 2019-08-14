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
    cmake

# enable klipper to install
RUN apt-get install -y sudo
COPY klippy.sudoers /etc/sudoers.d/klippy
RUN useradd -ms /bin/bash klippy

#Create an dwc2-klipper user
RUN useradd -ms /bin/bash dwc2-klipper && adduser dwc2-klipper dialout
USER dwc2-klipper

WORKDIR /home/dwc2-klipper

RUN git clone https://github.com/KevinOConnor/klipper
RUN ./klipper/scripts/install-octopi.sh

RUN virtualenv ./klippy-env
RUN ./klippy-env/bin/pip install tornado==5.1.1

RUN git clone https://github.com/Stephan3/dwc2-for-klipper.git
RUN ln -s ~/dwc2-for-klipper/web_dwc2.py ~/klipper/klippy/extras/web_dwc2.py

RUN gcode=$(sed 's/self.bytes_read = 0/self.bytes_read = 0\n        self.respond_callbacks = []/g' klipper/klippy/gcode.py)
RUN gcode=$(echo "$gcode" | sed 's/# Response handling/def register_respond_callback(self, callback):\n        self.respond_callbacks.append(callback)/')
RUN gcode=$(echo "$gcode" | sed 's/os.write(self.fd, msg+"\\n")/os.write(self.fd, msg+"\\n")\n            for callback in self.respond_callbacks:\n                callback(msg+"\\n")/')
RUN echo "$gcode" > klipper/klippy/gcode.py

# config file to use. see list here: https://github.com/KevinOConnor/klipper/tree/master/config
ARG KLIPPER_CONFIG=example.cfg
RUN cp klipper/config/${KLIPPER_CONFIG}} /home/dwc2-klipper/printer.cfg

RUN mkdir -p /home/dwc2-klipper/sdcard/dwc2/web
WORKDIR /home/dwc2-klipper/sdcard/dwc2/web

RUN wget https://github.com/chrishamm/DuetWebControl/releases/download/2.0.0-RC5/DuetWebControl.zip
RUN unzip *.zip && for f_ in $(find . | grep '.gz');do gunzip ${f_};done

VOLUME /home/dwc2-klipper

EXPOSE 4750

USER root

COPY runklipper.py /

CMD ["/runklipper.py"]
