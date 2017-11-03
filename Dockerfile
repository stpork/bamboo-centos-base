FROM stpork/tini-centos

MAINTAINER stpork from Mordor team

ENV OCP_VERSION		v3.6.1
ENV OCP_BUILD		008f2d5
ENV CLI_VERSION		7.1.0
ENV CLI_BUILD		16285777
ENV TOOL_INSTALL	/usr/local/bin

ENV BAMBOO_HOME		/var/atlassian/application-data/bamboo
ENV HOME			$BAMBOO_HOME/home
ENV BAMBOO_USER		daemon
ENV BAMBOO_GROUP	daemon
ENV _JAVA_OPTIONS	-Duser.home=$HOME

ARG M2_URL=https://bitbucket.org/stpork/bamboo-agent/downloads/settings.xml
ARG OC_URL=http://github.com/openshift/origin/releases/download/${OCP_VERSION}/openshift-origin-client-tools-${OCP_VERSION}-${OCP_BUILD}-linux-64bit.tar.gz
ARG CLI_URL=http://bobswift.atlassian.net/wiki/download/attachments/${CLI_BUILD}/atlassian-cli-${CLI_VERSION}-distribution.zip

RUN yum install -y curl wget openssl unzip git maven gradle nano tini \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && mkdir -p ${BAMBOO_HOME} \
    && mkdir -p ${HOME} \
    && mkdir -p ${HOME}/.m2 \
    && curl -o ${HOME}/.m2/settings.xml -L --silent ${M2_URL} \
    && curl -L --silent ${OC_URL} | tar -xz --strip-components=1 -C "$TOOL_INSTALL" \
    && cd /opt \
    && curl -o atlassian-cli.zip -L --silent ${CLI_URL} \
    && unzip atlassian-cli.zip \
    && mv atlassian-cli-${CLI_VERSION}/* "$TOOL_INSTALL" \
    && rm -rf atlassian-cli* \
    && chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${TOOL_INSTALL} \
    && chmod -R 777 ${TOOL_INSTALL} \
    && chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_HOME} \
    && chmod -R 777 ${BAMBOO_HOME}

USER ${BAMBOO_USER}:${BAMBOO_GROUP}

VOLUME ["${BAMBOO_HOME}"]

ENTRYPOINT ["/usr/bin/tini", "--"]
