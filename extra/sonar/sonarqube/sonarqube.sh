#!/bin/bash

set -x 
    cd /opt 
    curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip 
    curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc 
    gpg --batch --verify sonarqube.zip.asc sonarqube.zip 
    unzip -q sonarqube.zip 
    mv sonarqube-$SONAR_VERSION sonarqube 
    chown -R sonarqube:sonarqube sonarqube 
    rm sonarqube.zip* 
