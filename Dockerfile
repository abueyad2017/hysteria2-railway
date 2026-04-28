FROM ubuntu:22.04

# تثبيت المتطلبات الأساسية
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# أمر تثبيت X-UI بشكل صامت وتلقائي
RUN curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh | bash -s -- -y

WORKDIR /root

# لإبقاء السيرفر حياً
CMD ["tail", "-f", "/dev/null"]
