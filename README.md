# RandomFieldsDocker
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=dev_codespace&repo=570134693)  

Docker container for R package RandomFields

## Overview
**RandomFields** was an R package on CRAN maintained by **[Martin Schlather](https://www.wim.uni-mannheim.de/schlather/)** which allows the estimation, prediction and simulation of random fields. The R extension 'RandomFieldsUtils' packages auxiliary algebraic routines and is used in many functions in RandomFields.

Due to changes in CRAN requirements there has been a cascade of adjustments to RandomFields and RandomFieldsUtils over the last years, which have added bugs on some operating systems. This repository **contains files for building a docker container in which RandomFields can be used**. For updates on RandomFields, please refer to Martin Schlather's website, the maintainer of RandomFields.

## Prerequisites
* [Docker](https://docs.docker.com/get-docker/)

For the RandomFields GUI `RFgui`, you need to enable X11 forwarding, as the GUI is served as a Tcl/Tk window. This adds further preparatory steps, which are detailed [below](#randomfields-gui).

## Use
The docker container can be built as usual through

```Shell
docker build -t randomfieldsdocker .
```

Afterwards, the container is launched
```Shell
docker run -it -u docker --name="RandomFieldsDocker" --platform linux/amd64 randomfieldsdocker
```

### Plots

If you're interested in plots, [the easiest solution](https://rocker-project.org/use/gui.html) is to use the `httpgd` package, which is part of the docker image and provides plots through a http server. In this case, the container is launched through

```Shell
docker run -it -u docker --name="RandomFieldsDocker" -p 8000:8000 --platform linux/amd64 randomfieldsdocker
```

and the `httpgd` server is initialized in R through

```R
httpgd::hgd(host = "0.0.0.0", port = 8000)
```

Now the plot server should be available to the host at localhost:8000 and can be tested through `plot(RMexp())`, for instance.

### RandomFields GUI 

RandomFields has a built-in GUI. Unfortunately, its compatibility with modern operating systems is quite **unstable** and the corresponding functions have been deprecated. If you rely on the GUI and run into errors, please contact the maintainer of RandomFields.  

The GUI builds on [Tcl/Tk](https://www.tcl.tk/) and to use it as part of a container you need to forward the container's X11 output. Since this involves interaction with the host, the set-up instructions for this are platform-dependent:
* **Windows**: A guide how to do this on windows can be found [here](https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde).
* **macOS**: Instructions for macOS can be found [here](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088).
* **Linux**: Instructions depend on the distribution, window manager, etc.  

In addition to the `docker run` arguments in the respective documents, you also need to mount the X11 socket. On Unix-like operating systems, this is achieved through the flag `-v /tmp/.X11-unix:/tmp.X11-unix:ro`. A full run instruction on macOS might look like this:

```
docker run -it -e DISPLAY=$ip:0 -u docker -v /tmp/.X11-unix:/tmp.X11-unix:ro --platform linux/amd64 RandomFieldsDocker
```


## Credits
This docker image builds on 
* [Rocker](https://rocker-project.org/)
* the guide [X11 forwarding on macOS and docker](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088)
* https://stackoverflow.com/q/25281992/20461152
