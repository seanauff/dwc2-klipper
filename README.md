# dwc2-klipper

dwc2-klipper is a Docker image for running [DWC2] and [Klipper] 3d Printer controllers. It is design to run on Raspberry Pi or similar.

[More info](https://klipper.info/klipper-+-dwc2-1/things-to-know-about-klipper-and-dwc2)

[DockerHub Image](https://hub.docker.com/r/seanauff/dwc2-klipper)

## Prepare your printer.cfg file

Copy an appropriate config file from [here](https://github.com/KevinOConnor/klipper/tree/master/config) and add the following lines to it:

```cfg
[virtual_sdcard]
path: /home/dwc2-klipper/sdcard

[web_dwc2]
## optional - defaulting to Klipper
printer_name: Klipper
# optional - defaulting to 0.0.0.0
listen_adress: 0.0.0.0
# needed - use above 1024 as nonroot
listen_port: 4750
# optional defaulting to dwc2/web. Its a folder relative to your virtual sdcard.
web_path: dwc2/web
```

Rename the file `printer.cfg` and place in a known place on your docker host, which you will mount when starting the container.

## Running via Docker

Pull the image. If using raspberry pi or similar use `arm` in place of `[tag]`. `amd64` is also available:

```shell
docker pull seanauff/dwc2-klipper:[tag]
```

Start the container:

```shell
docker run -d --device /dev/ttyUSB0:/dev/ttyUSB0 -v [some/path/on/host]:/home/dwc2-klipper/config seanauff/dwc2-klipper:[tag]
```

### Build the image yourself

Clone the repository and build the image:

```shell
git clone https://github.com/seanauff/dwc2-klipper.git
docker build -t seanauff/dwc2-klipper dwc2-klipper
```

[DWC2]: https://github.com/Stephan3/dwc2-for-klipper
[Klipper]: https://github.com/KevinOConnor/klipper
