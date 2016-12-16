# base image
FROM java:8

# sbt
ENV SCALA_VERSION 2.11.7
ENV SBT_VERSION 0.13.13
## Install scala
RUN \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

## Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

## bootstraping other sbt versions
RUN sbt -sbt-version 0.13.7 exit
RUN sbt -sbt-version 0.13.8 exit
RUN sbt -sbt-version 0.13.9 exit
RUN sbt -sbt-version 0.13.10 exit
RUN sbt -sbt-version 0.13.11 exit
RUN sbt -sbt-version 0.13.12 exit
RUN sbt -sbt-version 0.13.13 exit

# maven
ENV MAVEN_VERSION 3.3.9

## install
RUN mkdir -p /usr/share/maven \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# ant
ENV ANT_VERSION 1.9.7

## install
RUN cd && wget -q http://www.eu.apache.org/dist//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    tar xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
    mv apache-ant-${ANT_VERSION} /opt/ant && \
    rm -f apache-ant-${ANT_VERSION}-bin.tar.gz

ENV ANT_HOME /opt/ant
ENV PATH ${PATH}:/opt/ant/bin

# gradle
ENV GRADLE_VERSION 2.13

## install
WORKDIR /usr/bin
RUN curl -sLO https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip && \
  unzip gradle-${GRADLE_VERSION}-all.zip && \
  ln -s gradle-${GRADLE_VERSION} gradle && \
  rm gradle-${GRADLE_VERSION}-all.zip

ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# nvm
ENV NVM_VERSION 0.32.1
ENV NVM_DIR /usr/local/nvm

## install
# using bash so we can source nvm.sh...
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get install -y -q --no-install-recommends build-essential libssl-dev git && \
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash && \
  source $NVM_DIR/nvm.sh && \
  nvm install 4.7.0 && \
  nvm install 6.9.2

WORKDIR /root
