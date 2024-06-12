# Irontec Debian Packaging images

This project contains the Dockerfiles used to generate images for Debian packaging in Irontec projects.
These images are available at DockerHub and relay on pbuilder to automatically install each package dependencies.

# Building Packaging environment
From the project root run:

    docker build --file debian/Dockerfile --tag ${PWD##*/}:latest debian

This will create a docker image with all required dependencies for your project

# Creating Debian packages
From the project root run:

    docker run --tty --volume $PWD:/build/source --volume /tmp/:/build/ ${PWD##*/}:latest

This will create debian packages for the project and leave the .deb files in /tmp/

