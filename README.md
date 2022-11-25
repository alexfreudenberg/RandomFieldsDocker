# RandomFieldsDocker
## Prerequisites
* [Docker](https://docs.docker.com/get-docker/)

For the RandomFields GUI `RFgui`, you need to enable X11 forwarding, as the GUI is provided as a tcl/tk window. A guide for macOS can be found below.

## Use
The docker container can be built as usual through

```Shell
docker build -t RandomFieldsDocker .
```

Afterwards, the container is launched
```Shell
docker run -it -u docker --name="RandomFieldsDocker" --platform linux/amd64 RandomFieldsDocker
```

#### Plots

If you're interested in plots, [the easiest solution](https://rocker-project.org/use/gui.html) is to use the `httpgd` package, which is part of the docker image and provides plots through a http server. In this case, the container is launched through

```Shell
docker run -it -u docker --name="RandomFieldsDocker" -p 8000:8000 --platform linux/amd64 RandomFieldsDocker
```

and the `httpgd` server is initialized in R through

```R
httpgd::hgd(host = "0.0.0.0", port = 8000)
```

Now the plot server should be available to the host at localhost:8000 and be tested through `plot(RMexp())` for instance.

#### RandomFields GUI 

RandomFields has a built-in GUI. Unfortunately, its compatibility with modern operating systems is quite unstable and the corresponding functions have been deprecated. If you rely on the GUI and run into errors, please contact the maintainer of RandomFields.  


## Credits
This docker image builds on 
* [Rocker](https://rocker-project.org/)
* the guide [X11 forwarding on macOS and docker](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088)
