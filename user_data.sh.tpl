#!/bin/bash
dnf install -y httpd
systemctl enable --now httpd
cat > /var/www/html/index.html <<HTML
<h1>${environment} Environment</h1>
HTML