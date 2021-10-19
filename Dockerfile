FROM debian:latest

RUN apt-get -y update && apt-get -y upgrade

# Create user with sudo
RUN apt-get -y install sudo
RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN useradd -s "/bin/bash" -m build && groupadd wheel && usermod -a -G wheel build

RUN apt-get -y update
RUN apt-get -y install build-essential ccache ecj fastjar file g++ gawk gettext git java-propose-classpath libelf-dev libncurses5-dev libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget python3-distutils python3-setuptools python3-dev rsync subversion swig time xsltproc zlib1g-dev 
# Random utilities
RUN apt-get -y install vim

# Download and update the sources
RUN sudo -u build bash -c "cd /home/build/ && git clone https://git.openwrt.org/openwrt/openwrt.git openwrt"
RUN sudo -u build bash -c "cd /home/build/openwrt/ && git pull"

# Find latest non-release candidate
RUN sudo -u build bash -c "cd /home/build/openwrt/ && git branch -a && git tag | grep -E \"[^(rc)]\\w$\" | tail | tail -n 1 | xargs git checkout"

# Update the feeds
RUN sudo -u build bash -c "cd /home/build/openwrt/ && ./scripts/feeds update -a"
RUN sudo -u build bash -c "cd /home/build/openwrt/ && ./scripts/feeds install -a"

CMD cd /home/build/openwrt/ && sudo -s -u build
