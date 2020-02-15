#!/bin/bash

curl -O http://downloads.code-scan.com/sonar-salesforce-plugin-$SCAN_VERSION.zip 
unzip sonar-salesforce-plugin-$SCAN_VERSION.zip 
rm -f sonar-salesforce-plugin-$SCAN_VERSION.zip 
mv sonar-salesforce-plugin/sonar-salesforce-plugin-$SCAN_VERSION.jar /opt/sonarqube/extensions/plugins 
rm -rf $SONARQUBE_HOME/bin/*
