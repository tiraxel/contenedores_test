FROM ubuntu:22.04
# Instalacion de dependencias
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-17-jdk wget unzip gnupg curl jq git inetutils-traceroute mlocate libnet-ssleay-perl libio-socket-ssl-perl tzdata
# Estableciendo la zona horaria
ENV TZ=America/Santiago
# Configuracion la zona horaria
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV JAVA_HOME='/usr/lib/jvm/java-17-openjdk-amd64'
ENV PATH=${JAVA_HOME}/bin:${PATH}
# Descargar e instalar Gradle
ENV GRADLE_VERSION=8.5
RUN wget --no-verbose  "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    && unzip -d /opt gradle-${GRADLE_VERSION}-bin.zip \
    && rm gradle-${GRADLE_VERSION}-bin.zip \
    && wget "https://repo1.maven.org/maven2/org/eclipse/jgit/org.eclipse.jgit/6.7.0.202309050840-r/org.eclipse.jgit-6.7.0.202309050840-r.jar" \
    && mv org.eclipse.jgit-6.7.0.202309050840-r.jar /opt/gradle-${GRADLE_VERSION}/lib/plugins/  \
    && rm /opt/gradle-${GRADLE_VERSION}/lib/plugins/org.eclipse.jgit-5.7.0.202003110725-r.jar \
    && mv /opt/gradle-${GRADLE_VERSION}/lib/plugins/org.eclipse.jgit-6.7.0.202309050840-r.jar /opt/gradle-${GRADLE_VERSION}/lib/plugins/org.eclipse.jgit-5.7.0.202003110725-r.jar \
    && wget "https://repo1.maven.org/maven2/org/testng/testng/7.5.1/testng-7.5.1.jar" \
    && mv testng-7.5.1.jar /opt/gradle-${GRADLE_VERSION}/lib/plugins/ \
    && rm /opt/gradle-${GRADLE_VERSION}/lib/plugins/testng-6.3.1.jar \
    && mv /opt/gradle-${GRADLE_VERSION}/lib/plugins/testng-7.5.1.jar /opt/gradle-${GRADLE_VERSION}/lib/plugins/testng-6.3.1.jar
# Configuracion variables de entorno de Gradle
ENV GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
ENV PATH=${GRADLE_HOME}/bin:${PATH}
# SendEmail
RUN apt-get update && \
    apt-get install -y sendemail && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Variables de entorno
ENV RAMA=${RAMA}
ENV REPOSITORIO=${REPOSITORIO}
ENV TAG=${TAG}
ENV NAV=${NAV}
ENV MAIL_USERNAME=${MAIL_USERNAME}
ENV MAIL_PW=${MAIL_PW}
ENV B_TOKEN=${B_TOKEN}
COPY app /opt
WORKDIR /opt/
RUN chmod 777 /opt/
RUN chmod +x entrypoint.sh
ENTRYPOINT /bin/bash entrypoint.sh ${RAMA} ${REPOSITORIO} ${TAG} ${NAV} ${MAIL_USERNAME} ${MAIL_PW} ${B_TOKEN}
