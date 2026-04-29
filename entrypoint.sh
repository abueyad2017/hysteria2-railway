#!/bin/bash

mkdir -p /etc/xray

# إنشاء شهادة TLS داخلية
openssl req -x509 -nodes -newkey rsa:2048 \
-keyout /etc/xray/key.pem \
-out /etc/xray/cert.pem \
-days 3650 \
-subj "/CN=www.cloudflare.com"

PORT=${PORT:-443}
PASS=${PASSWORD:-123456}

cat > /etc/xray/config.json <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "${PASS}"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/cert.pem",
              "keyFile": "/etc/xray/key.pem"
            }
          ]
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

exec xray run -c /etc/xray/config.json
