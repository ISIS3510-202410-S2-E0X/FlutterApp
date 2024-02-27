FROM ubuntu:latest

# Instala ambiente (OS)
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils libglu1-mesa openjdk-11-jdk

# Instala Chrome
RUN apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable

# Crea un volumen llamado 'workspace'
VOLUME /workspace

# Instala Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Configura el SDK de Flutter
RUN flutter config --no-analytics && \
    flutter precache && \
    flutter doctor --android-licenses

WORKDIR /workspace
