FROM ubuntu:22.04
# Instalacion de dependencias
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-17-jdk wget unzip gnupg git xvfb\
    && wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.198-1_amd64.deb \
    && apt-get install -y /tmp/chrome.deb \
    && rm /tmp/chrome.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#Variables de entorno Java
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

# Variables de entorno
ENV RAMA=${RAMA}
ENV REPOSITORIO=${REPOSITORIO}
ENV TAG=${TAG}
ENV NAV=${NAV}

COPY app /opt
WORKDIR /opt/
RUN chmod 777 /opt/
RUN chmod +x entrypoint.sh
ENTRYPOINT /bin/bash entrypoint.sh ${RAMA} ${REPOSITORIO} ${TAG} ${NAV} ${MAIL_USERNAME} ${MAIL_PW} ${B_TOKEN}
