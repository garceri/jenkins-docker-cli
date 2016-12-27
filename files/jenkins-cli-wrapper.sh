#!/bin/bash
## Modified by Gerardo Arceri <arceri@pythian.com>
## Changelog
## v1.0  Added support to pass the ssh key as an ENV variable
## v1.1  Added support for configuring maven with ENV variables
### Setting up Maven, required variables
## CLOUDBEES_USER
## CLOUDBEES_PASS
## CLOUDBEES_ACCOUNT (no domain)
sed -e "s/%%CLOUDBEES_USER%%/$CLOUDBEES_USER/g" -e "s/%%CLOUDBEES_PASS%%/$CLOUDBEES_PASS/g" -e "s/%%CLOUDBEES_ACCOUNT%%/$CLOUDBEES_ACCOUNT/g" /etc/maven/settings.xml.template >/etc/maven/settings.xml

#Setting up ssh key for the jenkins slave

echo "$SSH_KEY" >~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
# echo "$@"
if test -z "$JENKINS_URL"; then
  echo "JENKINS_URL environment variable is mandatory"
  exit 1
else
  url_hash=$(echo $JENKINS_URL | md5sum)

  mkdir -p "$url_hash"
  echo $JENKINS_URL > "$url_hash/url.txt"

  cli_jar="$url_hash/jenkins-cli.jar"
  if [ ! -f "$cli_jar" ]; then
    wget "$JENKINS_URL/jnlpJars/jenkins-cli.jar" -q -O "$cli_jar"
  fi

  if [ -f "$PRIVATE_KEY" ]; then
    java -jar "$cli_jar" -s $JENKINS_URL -i $PRIVATE_KEY "$@"
  else
    java -jar "$cli_jar" -s $JENKINS_URL "$@"
  fi
fi
