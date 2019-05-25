FROM jupyter/minimal-notebook:abdb27a6dfbb

USER root

RUN apt-get -y update && \
 apt-get -y install \
 apt-utils

# Install Java
RUN apt-get -y install \
 zip \
 openjdk-11-jre \
 openjdk-11-jdk

RUN apt-get purge && \
 apt-get clean && \
 rm -rf /var/lib/apt/lists/*

# Download the kernel release
RUN curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip

# Unpack and install the kernel
RUN unzip ijava-kernel.zip -d ijava-kernel \
  && cd ijava-kernel \
  && python3 install.py --sys-prefix

# Set up the user environment

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid $NB_UID \
    $NB_USER

COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

# Launch the notebook server
WORKDIR $HOME
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
