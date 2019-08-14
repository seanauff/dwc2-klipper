# dwc2-klipper

dwc2-klipper is a Docker image for running [DWC2] and [Klipper] 3d Printer controllers. It is design to run on Raspberry Pi or similar.

## Running via Docker

Pull the image. If using raspberry pi or similar use `arm` in place of `[tag]`. The `latest` tag will pull the `amd64` image:

```shell
docker pull seanauff/dwc2-klipper:[tag]
```

Start the container:

```shell
docker run -d --device /dev/ttyUSB0:/dev/ttyUSB0 seanauff/dwc2-klipper:[tag]
```

### Build the image yourself

Clone the repository and build the image:

```shell
git clone https://github.com/seanauff/dwc2-klipper.git
docker build -t seanauff/dwc2-klipper dwc2-klipper
```

[DWC2]: https://github.com/Stephan3/dwc2-for-klipper
[Klipper]: https://github.com/KevinOConnor/klipper
