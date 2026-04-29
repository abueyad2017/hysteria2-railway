#!/bin/bash
set -e  # إيقاف السكربت عند أي خطأ

# تعيين كلمة سر افتراضية إذا لم تُعطَ
PASSWORD=${PASSWORD:-"change-me"}

# استبدال المتغير باستخدام sed (لا نحتاج envsubst)
sed "s/\${PASSWORD}/$PASSWORD/g" \
    /etc/hysteria/config.yaml.template > /etc/hysteria/config.yaml

echo "Starting Hysteria 2 on UDP 2000..."
hysteria server -c /etc/hysteria/config.yaml &

# إعطاء Hysteria فرصة للبدء
sleep 2

# تشغيل udp2raw في وضع السيرفر (الخيار الصحيح -s)
echo "Starting udp2raw tunnel: TCP 0.0.0.0:9000 -> UDP 127.0.0.1:2000"
udp2raw -s -l 0.0.0.0:9000 -r 127.0.0.1:2000 \
    --raw-mode faketcp --log-level 1

# انتظار أي عملية تنتهي (إذا تعطل أحدهما تنهار الحاوية)
wait -n
exit $?
