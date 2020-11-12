#!/bin/bash

# Bash output configuration to display message with colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
ORANGE='\e[93m'

info() {
    printf "${BLUE}$1${NC}\n"
}
error() {
    printf "${RED}$1${NC}\n"
}
warn() {
    printf "${ORANGE}$1${NC}\n"
}

# Verify And Install Java
info "#######################################################"
info "Verifying Java Installation..."
info "#######################################################"
java -v > /dev/null 2>&1
RETURN=$?
if [[ ${RETURN:0:1} -ne 0 ]];then
    warn "Java is not installed"
    sleep 1
    info "Insatlling Java .."
    sudo apt-get install java-1.8.0-openjdk -y
    info "Java Installed"
fi

echo "Do you want to install Logstash ? [y/n]:  "
read logstash
if [[ $logstash -eq "y"]];then
    info "#######################################################"
    info "Installing logstash..."
    info "#######################################################"
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
    sudo apt-get update && sudo apt-get install -y logstash
    sudo systemctl enable logstash
    sudo systemctl start logstash
    info "#######################################################"
    info "Logstash installed Successfully"
    info "#######################################################"
fi

echo "Do you want to install filebeat ? [y/n]:  "
read filebeat
if [[ $filebeat -eq "y"]];then
    info "#######################################################"
    info "Installing filebeat..."
    info "#######################################################"
    sudo apt-get update && sudo apt-get install -y filebeat
    sudo systemctl enable filebeat
    sudo systemctl start filebeat
    info "#######################################################"
    info "filebeat installed Successfully"
    info "#######################################################"
fi