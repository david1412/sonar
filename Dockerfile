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
    set -x \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip -q sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && chown -R sonarqube:sonarqube sonarqube \
    && rm sonarqube.zip* \
    && curl -O http://downloads.code-scan.com/sonar-salesforce-plugin-$SCAN_VERSION.zip \
    && unzip sonar-salesforce-plugin-$SCAN_VERSION.zip \
    && rm -f sonar-salesforce-plugin-$SCAN_VERSION.zip \
    && mv sonar-salesforce-plugin/sonar-salesforce-plugin-$SCAN_VERSION.jar /opt/sonarqube/extensions/plugins \
    && rm -rf $SONARQUBE_HOME/bin/*
    
VOLUME "$SONARQUBE_HOME/data"
WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
USER sonarqube
ENTRYPOINT ["./bin/run.sh"]
