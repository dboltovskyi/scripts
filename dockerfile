FROM ubuntu:trusty

RUN apt-get update

RUN apt-get install -y git

RUN apt-get install -y wget

RUN apt-get install -y zsh \
  && chsh -s $(which zsh) \
  && bash -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

RUN apt-get install -y software-properties-common python-software-properties

RUN add-apt-repository -y ppa:beineri/opt-qt532-trusty

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get update

RUN apt-get -q -y install cmake gcc-4.9 g++-4.9 libssl-dev libbluetooth3 libbluetooth-dev \
  libudev-dev libavahi-client-dev bluez-tools sqlite3 libsqlite3-dev automake1.11 libexpat1-dev

RUN apt-get -q -y install qt53base qt53websockets liblua5.2-dev libxml2-dev lua-lpeg-dev libgl1-mesa-dev

RUN chmod u+s /sbin/ifconfig

RUN update-alternatives --remove-all cpp \
  && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 20 \
  && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-4.9 20 \
  && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 20

RUN cd /usr/local/share/ca-certificates \
  && mkdir lux \
  && cd lux \
  && wget -nv "http://cert.luxoft.com/Luxoft-Root-CA.crt" \
  && update-ca-certificates

RUN wget -nv -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" \
  && chmod +x /usr/local/bin/gosu

ADD s.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
