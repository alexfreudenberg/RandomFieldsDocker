# rocker image r-ver supplies the most recent Ubuntu LTS and a specified version of R
# (https://rocker-project.org/images/versioned/r-ver.html)
# RandomFields has been tested to work with R version 4.0.1
# Most likely there will be versions of R which are not compatible with RandomFields
FROM rocker/r-ver:4.0.1
SHELL ["/bin/bash", "-ec"]
ARG _DEV_CONTAINERS_BASE_IMAGE
ARG GUI


# Initialize user account for the docker image
RUN useradd -m docker 
RUN echo "docker:docker" | chpasswd 
RUN usermod -s /bin/bash docker 
RUN usermod -aG sudo docker 
ENV HOME /home/docker

# Necessary packages for tcl/tk
# These can be omitted if there is no interest in using the RandomFields GUI
RUN if [[ "x$GUI" != "x" ]] ; then apt update && apt-get install -y git libsm6 libxrender1 libfontconfig1 libxtst6 libxt-dev libxt6 xorg tk tk-dev tcl-dev ; fi
RUN if [[ "x$GUI" != "x" ]] ; then install2.r -n 4 tkrplot RColorBrewer colorspace ; fi

# Check if running on Codespaces and install languageserver
RUN if [[ "x$_DEV_CONTAINERS_BASE_IMAGE" != "x" ]] ; then apt update && apt-get install -y sudo git libxml2-dev libxt-dev libxt6  ; fi
RUN if [[ "x$_DEV_CONTAINERS_BASE_IMAGE" != "x" ]] ; then install2.r -d TRUE httpgd languageserver ; fi

# Set CRAN repository
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"
RUN echo \
    "# Note: Putting RandomFields in the .Rprofile/Rprofile.site messes up R's namespace and some methods (e.g. plot) won't work anymore" \ 
    >>"${R_HOME}/etc/Rprofile.site"

# Copy precompiled packages and set working directory
COPY ./src /usr/local/src/
WORKDIR /usr/local/src/

# Install precompiled packages and dependencies
RUN install2.r -d TRUE --repos=NULL RandomFieldsUtils_*.tar.gz
RUN install2.r sp
RUN install2.r --repos=NULL RandomFields_*.tar.gz

# Start R
CMD R 
