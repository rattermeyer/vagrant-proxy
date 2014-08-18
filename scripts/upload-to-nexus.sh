#!/bin/bash
# vim: set ts=4 sw=4 expandtab :
NEXUS_BASE_URL=http://192.168.33.10:8081/nexus
# Set this to "-v" for verbose loggin 
#CURL_OPTIONS="-v"
function upload() {
    groupid=$1
    artifactid=$2
    version=$3
    classifier=$4
    packaging=$5
    file=$6
    statusCode=`resolve ${groupid} ${artifactid} ${version} ${classifier} ${packaging}`
    if [ $statusCode = "404" ] 
    then
      echo "uploading $groupid:$artifactid:$version"
      if [ $4 = "-" ] 
      then
        curl ${CURL_OPTIONS} -F r=thirdparty -F g=${groupid} -F a=${artifactid} -F v=${version} -F p=${packaging} -F file=@${file} -u admin:admin123 \
         ${NEXUS_BASE_URL}/service/local/artifact/maven/content
      else
        curl ${CURL_OPTIONS} -F r=thirdparty -F g=${groupid} -F a=${artifactid} -F v=${version} -F c=${classifier} -F p=${packaging} -F file=@${file} -u admin:admin123 \
         ${NEXUS_BASE_URL}/service/local/artifact/maven/content
      fi
      echo ""
    else
      echo "skipping $groupid:$artifactid:$version"
    fi
}

function resolve() {
    groupid=$1
    artifactid=$2
    version=$3
    classifier=$4
    packaging=$5
    file=$6
    statusCode=""
    if [ $4 = "-" ] 
    then
      statusCode=`curl -o /dev/null --silent --head --write-out '%{http_code}' ${NEXUS_BASE_URL}/service/local/artifact/maven/resolve?g=${groupid}\&a=${artifactid}\&v=${version}\&p=${packaging}\&r=thirdparty`
    else
      statusCode=`curl -o /dev/null --silent --head --write-out '%{http_code}' ${NEXUS_BASE_URL}/service/local/artifact/maven/resolve?g=${groupid}\&a=${artifactid}\&v=${version}\&c=${classifier}\&p=${packaging}\&r=thirdparty`
    fi
    echo "$statusCode"
}

function jdk() {
    for i in jdk*.tar.gz; do
        groupid=com.oracle.java
        artifactid=jdk
        version=`basename $i .tar.gz  | awk 'BEGIN { FS = "-" } { print $2 }'`
        classifier=`basename $i .tar.gz  | awk 'BEGIN { FS = "-" } { print $3"-"$4 }'`
        packaging=tar.gz        
        file="./$i"
	upload $groupid $artifactid $version $classifier $packaging $file
    done;
}

function intellij() {
    for i in ideaIU*.tar.gz; do
        groupid=com.jetbrains.intellij
        artifactid=ideaIU
        version=`basename $i .tar.gz  | awk 'BEGIN { FS = "-" } { print $2 }'`
        classifier="-"
        packaging=tar.gz        
        file="./$i"
	upload $groupid $artifactid $version $classifier $packaging $file
    done
}
function wildfly() {
    for i in wildfly*.tar.gz; do
        groupid=org.wildfly
        artifactid=wildfly-dist
        version=`basename $i .tar.gz  | awk 'BEGIN { FS = "-" } { print $2 }'`
        classifier="-"
        packaging=tar.gz        
        file="./$i"
	upload $groupid $artifactid $version $classifier $packaging $file
    done
}
function sts() {
    for i in spring-tool-suite*.tar.gz; do
        groupid=org.springsource
        artifactid=sts
        version=`basename $i .tar.gz  | awk 'BEGIN { FS = "-" } { print $4 }'`
        classifier=`basename $i .tar.gz  | awk 'BEGIN { FS = "-" } { print $5"-"$6"-"$7"-"$8  }'`
        packaging=tar.gz        
        file="./$i"
	upload $groupid $artifactid $version $classifier $packaging $file
    done;
}

jdk
intellij
wildfly
sts
