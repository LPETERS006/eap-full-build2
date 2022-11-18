FROM lpeters999/base-eap2:latest as builder

RUN cd /tmp/eap-build && ./build-eap7.sh 7.2.0 && cd ./dist && unzip jboss-eap-7.2.0.zip >/dev/null && cd /tmp && \ 
    git clone https://github.com/LPETERS006/eap-full-build2.git && \
    cp -R -f /tmp/eap-full-build/7.2.0-jdk11/files/* /tmp/eap-build/dist/jboss-eap-7.2/ >/dev/null && \
    addgroup -g 888 -S jboss && adduser -u 888 -D -h /tmp/eap-build/dist/jboss-eap-7.2 -s /bin/sh -S jboss -G root && \
    chown -R 888:root /tmp/eap-build/dist/jboss-eap-7.2 && chmod 0755 /tmp/eap-build/dist/jboss-eap-7.2 && chmod -R g+rwX /tmp/eap-build/dist/jboss-eap-7.2

FROM  eclipse-temurin:11-jdk-jammy

ENV LANG="C.UTF-8"
LABEL name="$JBOSS_IMAGE_NAME" version="$JBOSS_IMAGE_VERSION" architecture="amd64,arm64v8" maintainer="LPETERS999"
ENV JBOSS_IMAGE_NAME="lpeters999/eap-full-ci" \
    JBOSS_IMAGE_VERSION="7.2.0-jdk11" \
    LAUNCH_JBOSS_IN_BACKGROUND="true" \
    JBOSS_PRODUCT="eap" \
    JBOSS_EAP_VERSION="7.2.0" \
    PRODUCT_VERSION="7.2.0" \
    EAP_HOME="/opt/jboss" \
    JBOSS_HTTP_PORT="8090" \
    JBOSS_HOME="/opt/jboss" \
    JBOSS_CONFIG_DIR="/opt/jboss/standalone/configuration" \
    JBOSS_DEPLOY_DIR="/opt/jboss/standalone/deployments" \
    LANG="C.UTF-8" \
    JAVA_OPTS="-Xms1303m -Xmx2048m -XX:MaxPermSize=1024m -XX:MetaspaceSize=256M -Djava.net.preferIPv4Stack=true --add-modules=ALL-SYSTEM"
RUN mkdir -p /opt/jboss/ /opt/jboss/fr
COPY --from=builder --chown=888:root /tmp/eap-build/dist/jboss-eap-7.2 /opt/jboss
RUN addgroup -g 888 -S jboss && adduser -u 888 -D -h ${JBOSS_HOME} -s /bin/sh -S jboss -G root && chmod +x ${JBOSS_HOME}/bin/*.sh && \
	apt update && apt upgrade -y -f && \
	apt install -f -y fontconfig fonts-dejavu && wait
USER 888
RUN ${JBOSS_HOME}/bin/add-user.sh admin Admin#007 --silent
EXPOSE 8090 10000
#VOLUME [ "/opt/jboss/standalone/deployments", "/opt/jboss/standalone/configuration", "/opt/jboss/fr" ]

ENTRYPOINT ["sh", "-c", "/opt/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.socket.binding.port-offset=10"]