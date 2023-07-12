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
    
# Install Java 11
#RUN apt-get update && \
#    apt-get install -y openjdk-11-jdk && \
#    apt-get install -y ant && \
#    apt-get clean;

RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Install required softwares (curl & zip & wget)
RUN apt install curl -y
RUN apt install zip -y
RUN apt install wget -y

# update
RUN apt-get update -y

# Install python
RUN apt-get install -y wget unzip git python3 python3-pip

# Install git
RUN apt-get install -y git

# Install Maven
ARG MAVEN_VERSION=3.9.3
ARG SHA=400fc5b6d000c158d5ee7937543faa06b6bda8408caa2444a9c947c21472fde0f0b64ac452b8cec8855d528c0335522ed5b6c8f77085811c7e29e1bedbb5daa2
ARG BASE_URL=https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && echo "Downloading maven" \
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
ARG GRADLE_VERSION=7.4.2
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
ARG GRADLE_SHA=29e49b10984e585d8118b7d0bc452f944e386458df27371b49b4ac1dec4b7fda
RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
  && echo "Downloading gradle hash" \
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
ENV GRADLE_VERSION 7.4.2
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
#RUN wget https://github.com/github/codeql-cli-binaries/releases/latest/download/codeql-linux64.zip && \  
#    unzip codeql-linux64.zip && \  
#    rm codeql-linux64.zip && \  
#    mv codeql /usr/local/bin  

# Clone the CodeQL repository  
#RUN git clone --recursive https://github.com/github/codeql.git /workspace/codeql-repo  

#ENV PATH=$PATH:/usr/local/bin/codeql
    
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

#ENV JAVA11_HOME /usr/lib/jvm/java-11-openjdk-amd64/
#RUN export JAVA11_HOME

ENV CF_BRANCH "oopsla-2023"
ENV CF_REPO https://github.com/Nargeshdb/checker-framework.git

#ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
#RUN export $JAVA_HOME

# download ResourceLeakChecker
RUN git clone "${CF_REPO}"
RUN export CHECKERFRAMEWORK=$(pwd)/checker-framework

#RUN cd checker-framework \
#    && ./gradlew assemble \
#    export PATH=$CHECKERFRAMEWORK/checker/bin:${PATH}

#RUN git checkout "${CF_BRANCH}" \
#    && ./gradlew publishToMavenLocal \
#    && cd ..

ENV ZK_REPO https://github.com/Nargeshdb/zookeeper.git
ENV ZK_CMD "mvn --projects zookeeper-server --also-make clean install -DskipTests"
ENV ZK_CLEAN "mvn clean"

ENV HADOOP_REPO https://github.com/Nargeshdb/hadoop.git
ENV HADOOP_CMD "mvn --projects hadoop-hdfs-project/hadoop-hdfs --also-make clean compile -DskipTests"
ENV HADOOP_CLEAN "mvn clean"

ENV HBASE_REPO https://github.com/Nargeshdb/hbase.git
ENV HBASE_CMD "mvn --projects hbase-server --also-make clean install -DskipTests"
ENV HBASE_CLEAN "mvn clean"

ENV RLCI_BRANCH "main"
ENV RLCI_BRANCH https://github.com/Nargeshdb/rlci-paper.git

# download rlci-paper
RUN git clone "${RLCI_BRANCH}"
RUN cp rlci-paper/inference.sh .
RUN cp rlci-paper/table1.sh .
RUN cp rlci-paper/table3.sh .

#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
#RUN export JAVA_HOME

# download Zookeeper
RUN git clone "${ZK_REPO}"

# download Hadoop
RUN git clone "${HADOOP_REPO}"

# download HBase
RUN git clone "${HBASE_REPO}"

CMD ["/bin/bash"]
  
# Create CodeQL repositories for Lucene.Net and EF Core

# Clone the Inference repository
##RUN git clone https://github.com/microsoft/global-resource-leaks-codeql.git
