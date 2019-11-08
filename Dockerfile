#Pull The docker container
FROM nvidia/cuda:latest
# LABEL ACE

RUN apt update && apt install -y wget python3-dev python3-pip sudo git vim
# maybe jupyter

#Update to cmake 3.15
#remove the current cmake installation
RUN apt-get purge cmake
WORKDIR /root/
RUN wget https://cmake.org/files/v3.15/cmake-3.15.4.tar.gz
RUN tar -xvzf cmake-3.15.4.tar.gz
RUN pwd
RUN ls 
WORKDIR /root/cmake-3.15.4
RUN ls
RUN ./configure
RUN make

#Add the cmake path to PATH
RUN echo 'export PATH=/root/cmake-3.15.4/bin:$PATH' > ~/.bashrc
RUN . ~/.bashrc

WORKDIR /root/
RUN git clone https://github.com/usmanr149/distro.git
RUN cp -r distro torch
RUN rm -rf distro/

# RUN sh -c '/bin/echo' -e 'yes\12\9' | apt install -y jupyter
RUN DEBIAN_FRONTEND=noninteractive apt install -y jupyter

WORKDIR /root/torch
RUN bash install-deps
RUN yes | ./install.sh

WORKDIR ~

RUN . ~/.bashrc


RUN sh -c /bin/echo -e '12/9' | apt install -y caffe-cuda

#Make sure to change path correctly

RUN apt install -y libprotobuf-dev protobuf-compiler
RUN /root/torch/install/bin/luarocks install loadcaffe

COPY . /root/

WORKDIR /root/

