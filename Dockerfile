# Use the official Ubuntu base image  
FROM ubuntu:latest  
  
# Update the system and install required packages  
RUN apt-get update && \  
    apt-get install --yes software-properties-common  
    
# Install Java 8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Install required softwares (curl & zip & wget)
RUN apt install curl
RUN apt install zip -y
RUN apt install wget -y

# update
RUN apt-get update -y

# Install python
RUN apt-get install -y wget unzip git python3 python3-pip

# Install git
RUN apt-get install -y git

# Install Maven
ARG MAVEN_VERSION=3.6.3
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && echo "Downlaoding maven" \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  \
  && echo "Checking download hash" \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  \
  && echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

#Install Gradle
ARG GRADLE_VERSION=6.8.3
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
ARG GRADLE_SHA=7faa7198769f872826c8ef4f1450f839ec27f0b4d5d1e51bade63667cbccd205
RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
  && echo "Downlaoding gradle hash" \
  && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
  \
  && echo "Checking download hash" \
  && echo "${GRADLE_SHA}  /tmp/gradle.zip" | sha256sum -c - \
  \
  && echo "Unziping gradle" \
  && unzip -d /usr/share/gradle /tmp/gradle.zip \
   \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/gradle.zip \
  && ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/bin/gradle
ENV GRADLE_VERSION 6.8.3
ENV GRADLE_HOME /usr/bin/gradle
#ENV GRADLE_USER_HOME /cache
ENV PATH $PATH:$GRADLE_HOME/bin
#VOLUME $GRADLE_USER_HOME

# Install scc
ARG SCC_3_SHA=04f9e797b70a678833e49df5e744f95080dfb7f963c0cd34f5b5d4712d290f33
RUN mkdir -p /usr/share/scc \
  && echo "Downloading scc" \
  && curl -fsSL -o /tmp/scc.zip https://github.com/boyter/scc/releases/download/v3.0.0/scc-3.0.0-arm64-unknown-linux.zip \
  \
  && echo "Checking download hash" \
  && echo "${SCC_3_SHA} /tmp/scc.zip" | sha256sum -c - \
  \
  && echo "Unzipping scc" \
  && unzip -d /usr/share/scc /tmp/scc.zip \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/scc.zip \
  && ln -s /usr/share/scc/scc /usr/bin/scc
  
# Install CodeQL CLI  
RUN wget https://github.com/github/codeql-cli-binaries/releases/latest/download/codeql-linux64.zip && \  
    unzip codeql-linux64.zip && \  
    rm codeql-linux64.zip && \  
    mv codeql /usr/local/bin  
    
## Create a new user
RUN useradd -ms /bin/bash oopsla && \
    apt-get install -y sudo && \
    adduser oopsla sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER oopsla
  
# Set up a working directory  
WORKDIR /home/oopsla 

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

ENV JAVA8_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA8_HOME
  
# Clone the CodeQL repository  
RUN git clone --recursive https://github.com/github/codeql.git /workspace/codeql-repo  

ENV PATH=$PATH:/usr/local/bin/codeql

# Create CodeQL repositories for Lucene.Net and EF Core

# Clone the Inference repository
##RUN git clone https://github.com/microsoft/global-resource-leaks-codeql.git
