FROM stpork/tini-centos

MAINTAINER stpork from Mordor team

ENV BAMBOO_USER=daemon \
BAMBOO_GROUP=daemon \
BAMBOO_HOME=/var/atlassian/application-data/bamboo \
PATH=$PATH:/opt/gradle/bin

ENV HOME			$BAMBOO_HOME/home 
ENV _JAVA_OPTIONS	-Duser.home=$HOME

RUN TOOL_INSTALL=/usr/local/bin \
&& OCP_VERSION=v3.6.1 \
&& OCP_BUILD=008f2d5 \
&& CLI_VERSION=7.1.0 \
&& CLI_BUILD=16285777 \
&& GRADLE_VERSION=4.3  \
&& M2_URL=https://bitbucket.org/stpork/bamboo-agent/downloads/settings.xml \
&& OC_URL=http://github.com/openshift/origin/releases/download/${OCP_VERSION}/openshift-origin-client-tools-${OCP_VERSION}-${OCP_BUILD}-linux-64bit.tar.gz \
&& CLI_URL=http://bobswift.atlassian.net/wiki/download/attachments/${CLI_BUILD}/atlassian-cli-${CLI_VERSION}-distribution.zip \
&& GRADLE_URL=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
&& yum install -y curl wget openssl unzip git maven net-tools nano tini telnet \
&& yum clean all \
&& rm -rf /var/cache/yum \
&& mkdir -p ${BAMBOO_HOME} \
&& mkdir -p ${HOME}/.m2 \
&& curl -o ${HOME}/.m2/settings.xml -L --silent ${M2_URL} \
&& curl -L --silent ${OC_URL} | tar -xz --strip-components=1 -C "$TOOL_INSTALL" \
&& cd /opt \
&& curl -o atlassian-cli.zip -L --silent ${CLI_URL} \
&& unzip -q atlassian-cli.zip \
&& mv atlassian-cli-${CLI_VERSION}/* "$TOOL_INSTALL" \
&& rm -rf atlassian-cli* \
&& curl -o gradle.zip -L --silent ${GRADLE_URL} \
&& mkdir -p /opt/gradle \
&& unzip -q gradle.zip \
&& mv gradle-${GRADLE_VERSION}/* /opt/gradle \
&& rm -rf gradle* \
&& chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${TOOL_INSTALL} \
&& chmod -R 777 ${TOOL_INSTALL} \
&& chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_HOME} \
&& chmod -R 777 ${BAMBOO_HOME}

ENTRYPOINT ["/usr/bin/tini", "--"]
