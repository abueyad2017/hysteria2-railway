#!/bin/bash

# 1. توليد الشهادات
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes -subj "/CN=localhost"

# 2. تجهيز ملف إعدادات Hysteria
cat > config.yaml <<EOF
listen: :443
tls:
  cert: cert.pem
  key: key.pem
auth:
  type: password
  password: "$PASSWORD"
EOF

# 3. تعديل واجهة الويب لتعرض الدومين وكلمة المرور الحقيقية
# ملاحظة: Railway يعطينا الدومين في المتغير RAILWAY_PUBLIC_DOMAIN
sed -i "s/{{PASSWORD}}/$PASSWORD/g" index.html
sed -i "s/{{HOST}}/$RAILWAY_PUBLIC_DOMAIN/g" index.html

# 4. تشغيل سيرفر الواجهة على المنفذ 8080
python3 -m http.server 8080 &

# 5. تشغيل سيرفر Hysteria
./hysteria server --config config.yaml
