# استخدام نسخة أوبنتو رسمية
FROM ubuntu:22.04

# تحديث النظام وتثبيت الأدوات الأساسية للشبكات والـ VPN
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    net-tools \
    iproute2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ضبط بيئة العمل
WORKDIR /root

# أمر لإبقاء السيرفر يعمل بشكل مستمر دون توقف
CMD ["tail", "-f", "/dev/null"]
