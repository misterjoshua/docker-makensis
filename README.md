<img src="https://img.shields.io/docker/cloud/automated/wheatstalk/makensis.svg" /> <img src="https://img.shields.io/docker/cloud/build/wheatstalk/makensis.svg" />

# Supported tags and respective `Dockerfile` links

## Simple Tags
* [`3.04-1`, `3`, `latest` *(Dockerfile)*](https://github.com/misterjoshua/docker-makensis/blob/master/Dockerfile)

# What is NSIS?
[NSIS (Nullsoft Scriptable Install System)](https://nsis.sourceforge.io/Main_Page) is a professional open source system to create Windows installers. It is designed to be as small and flexible as possible and is therefore very suitable for internet distribution.

# What is the Modern UI 2? (MUI2)
The [Modern UI](https://nsis.sourceforge.io/Docs/Modern%20UI%202/Readme.html) provides a user interface for NSIS installers with a modern wizard style, similar to the wizards of recent Windows versions. It is based on the basic user interface that is provided by the NSIS compiler itself and extends it with more interface features and pages.

# What is this repository?
This repository provides `makensis` for building NSIS-based Windows installers from Linux containers and build pipelines. This repository is built from `debian:experimental`. MUI 2 is available with this image to create the Windows installers NSIS has become widely known for.

# How to use this image
## Create an installer
`docker run -it --rm -v /path/to/build:/app wheatstalk/makensis:3 /app/installer.nsi`

# License
This repository's source is licensed under the [Apache License 2.0](https://github.com/misterjoshua/docker-makensis/blob/master/LICENSE).

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.