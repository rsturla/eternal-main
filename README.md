# Eternal Main

The images in this repository are used as the base images for all other images in the Eternal project.
They include basic configuration and tools which will be inherited by all other images.  Packages and configuration contained within these images are intended to be unopinionated and as minimal as possible, while allowing for the most flexibility and customization possible further downstream.

While these images are not intended to be used directly, you are free to do so if you wish, however packages and configuration may change at any time without notice.


## Features

- Automated Upgrades
  - [x] OS Packages
  - [x] Flatpaks
- Proprietary Drivers
  - [x] Nvidia
- Convenience Packages
  - [x] Direnv
  - [x] Distrobox
  - [x] FFmpeg
  - [x] Tmux
  - [x] ZSH
- UDev Rules
  - [x] Game Controllers


## Usage

To use these images, you can use the following `FROM` statement in your Dockerfile:

```dockerfile
FROM ghcr.io/rsturla/eternal-main/<type>:<version>
```

Where `<type>` is the type of image you want to use (e.g. Silverblue), and `<version>` is the Fedora version of the image you want to use (e.g. 38).

All images are also built with the `:<version>-nvidia` tag, which includes the Nvidia drivers and CUDA libraries.


### Using the Images Directly

As mentioned above, these images are not intended to be used directly, however you are free to do so if you wish.  If you do, you will need to use the following commands in your host terminal:

```bash
$ rpm-ostree rebase ostree-unverified-registry:ghcr.io/rsturla/eternal-linux/main/<type>:<version>
$ reboot
$ eternal sign
```

Where `<type>` is the type of image you want to use (e.g. Silverblue), and `<version>` is the Fedora version of the image you want to use (e.g. 38).

The `sign` command is provided by the Eternal CLI, which is installed by default in all images.  It contains convenience scripts for importing the Eternal GPG keys and requiring new images to be signed before they can be trusted and used.


## Building

To build these images, you can use the following command:

```bash
$ docker build -t ghcr.io/rsturla/eternal-main/<type>:<version> -f Containerfile .
$ docker build -t ghcr.io/rsturla/eternal-main/<type>:<version>-nvidia -f Containerfile.nvidia .
```

Where `<type>` is the type of image you want to build (e.g. Silverblue), and `<version>` is the Fedora version of the image you want to build (e.g. 38).


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
