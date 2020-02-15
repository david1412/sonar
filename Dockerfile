FROM openjdk:11-jre-slim
    
ENV SONAR_VERSION=7.9.2 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_USERNAME=admin \
    SONARQUBE_PASSWORD=admin \
    SCAN_VERSION=4.3.11

EXPOSE 9000

RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube

RUN for server in $(shuf -e ha.pool.sks-keyservers.net \
                            hkp://p80.pool.sks-keyservers.net:80 \
                            keyserver.ubuntu.com \
                            hkp://keyserver.ubuntu.com:80 \
                            pgp.mit.edu) ; do \
        gpg --batch --keyserver "$server" --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE && break || : ; \
    done
    
RUN apt-get update \
    && apt-get install -y curl gnupg2 unzip \
    && rm -rf /var/lib/apt/lists/* \
    && /extra/sonar/sonarqube/sonarqube.sh \  
    && /extra/sonar/codescan/codescan.sh \
    rm -rf /extra
    
    
VOLUME "$SONARQUBE_HOME/data"
WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
USER sonarqube
ENTRYPOINT ["./bin/run.sh"]

CMD /bin/bash
