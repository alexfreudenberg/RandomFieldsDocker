# rocker image r-ver supplies the most recent Ubuntu LTS and a specified version of R
# (https://rocker-project.org/images/versioned/r-ver.html)
# RandomFields has been tested to work with R version 4.0.1
# Most likely there will be versions of R which are not compatible with RandomFields
FROM rocker/r-ver:4.0.1

# Initialize user account for the docker image
RUN useradd -m docker 
RUN usermod -s /bin/bash docker 
RUN usermod -aG sudo docker 
ENV HOME /home/docker

# Necessary packages for tcl/tk
# These can be omitted if there is no interest in using the RandomFields GUI
RUN apt update && apt-get install -y libsm6 libxrender1 libfontconfig1 libxtst6 libxt-dev libxt6 xorg tk tk-dev tcl-dev 

# Set CRAN repository
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"

# Copy precompiled packages and set working directory
COPY ./build /usr/local/src/
WORKDIR /usr/local/src/

# Install precompiled packages and dependencies
RUN install2.r -d TRUE --repos=NULL -n 4 RandomFieldsUtils_1.1.0_R_x86_64-pc-linux-gnu.tar.gz
RUN install2.r  -n 4 sp_1.5-1_R_x86_64-pc-linux-gnu.tar.gz
RUN install2.r -n 4 tkrplot RColorBrewer colorspace
RUN install2.r --repos=NULL -n 4 RandomFields_3.3.14_R_x86_64-pc-linux-gnu.tar.gz

# Start R
CMD R 
