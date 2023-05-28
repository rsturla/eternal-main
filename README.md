# Eternal Main

The images in this repository are used as the base images for all other images in the Eternal project.
They include basic configuration and tools which will be inherited by all other images.


## Features

- Automated Upgrades
  - [x] OS Packages
  - [x] Flatpaks
- Proprietary Drivers
  - [x] Nvidia


## Usage

To use these images, you can use the following `FROM` statement in your Dockerfile:

```dockerfile
FROM ghcr.io/rsturla/eternal-main/<type>:<version>
```

Where `<type>` is the type of image you want to use (e.g. Silverblue), and `<version>` is the Fedora version of the image you want to use (e.g. 38).

All images are also built with the `:<version>-nvidia` tag, which includes the Nvidia drivers and CUDA libraries.


## Building

To build these images, you can use the following command:

```bash
docker build -t ghcr.io/rsturla/eternal-main/<type>:<version> -f Containerfile .
docker build -t ghcr.io/rsturla/eternal-main/<type>:<version>-nvidia -f Containerfile.nvidia .
```

Where `<type>` is the type of image you want to build (e.g. Silverblue), and `<version>` is the Fedora version of the image you want to build (e.g. 38).


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
