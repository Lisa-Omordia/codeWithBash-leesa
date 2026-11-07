#!/bin/bash
set -e

# Install nginx 1.30.6 from source with systemd integration on Ubuntu/Debian.
# Run as root: sudo bash nginx_install.sh

NGINX_VERSION="1.30.6"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NGINX_URL="https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz"
BUILD_DIR="/tmp/nginx-build"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: run as root (sudo bash nginx_install.sh)${NC}"
    exit 1
fi

echo -e "${GREEN}=== Installing nginx ${NGINX_VERSION} from source ===${NC}\n"

# ── 1. Build dependencies ────────────────────────────────────────────────────
echo -e "${YELLOW}[1/8] Installing build dependencies...${NC}"
apt-get update
apt-get install -y \
    build-essential \
    libpcre2-dev \
    zlib1g zlib1g-dev \
    libssl-dev libgd-dev libgeoip-dev \
    libxml2 libxml2-dev libxslt1-dev \
    wget

# ── 2. nginx system user ─────────────────────────────────────────────────────
echo -e "${YELLOW}[2/8] Creating nginx user...${NC}"
if ! id -u nginx >/dev/null 2>&1; then
    useradd -r -M -s /sbin/nologin -d /var/cache/nginx nginx
    echo "  ✓ nginx user created"
else
    echo "  ✓ nginx user already exists"
fi

# ── 3. Download & extract ────────────────────────────────────────────────────
echo -e "${YELLOW}[3/8] Downloading nginx ${NGINX_VERSION}...${NC}"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
if [ -f "$SCRIPT_DIR/nginx-${NGINX_VERSION}.tar.gz" ]; then
    echo "  ✓ Using local tarball: $SCRIPT_DIR/nginx-${NGINX_VERSION}.tar.gz"
    cp "$SCRIPT_DIR/nginx-${NGINX_VERSION}.tar.gz" .
else
    echo "  Local tarball not found, downloading from $NGINX_URL"
    wget -q --show-progress "$NGINX_URL"
fi
tar -xzf "nginx-${NGINX_VERSION}.tar.gz"
cd "nginx-${NGINX_VERSION}"

# ── 4. Configure ─────────────────────────────────────────────────────────────
echo -e "${YELLOW}[4/8] Configuring build...${NC}"
./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx --group=nginx \
    --with-compat --with-file-aio --with-threads \
    --with-http_addition_module --with-http_auth_request_module \
    --with-http_dav_module --with-http_flv_module \
    --with-http_gunzip_module --with-http_gzip_static_module \
    --with-http_mp4_module --with-http_random_index_module \
    --with-http_realip_module --with-http_secure_link_module \
    --with-http_slice_module --with-http_ssl_module \
    --with-http_stub_status_module --with-http_sub_module \
    --with-http_v2_module \
    --with-mail --with-mail_ssl_module \
    --with-stream --with-stream_realip_module \
    --with-stream_ssl_module --with-stream_ssl_preread_module

# ── 5. Compile & install ─────────────────────────────────────────────────────
echo -e "${YELLOW}[5/8] Compiling nginx (takes a few minutes)...${NC}"
make -j$(nproc)
echo -e "${YELLOW}Installing...${NC}"
make install

# ── 6. Directories & permissions ─────────────────────────────────────────────
echo -e "${YELLOW}[6/8] Creating directories and setting permissions...${NC}"
for dir in client_temp proxy_temp fastcgi_temp uwsgi_temp scgi_temp; do
    mkdir -p "/var/cache/nginx/$dir"
done
mkdir -p /var/log/nginx /etc/nginx/sites-available /etc/nginx/sites-enabled \
         /etc/nginx/conf.d /usr/share/nginx/html
chown -R nginx:nginx /var/cache/nginx /var/log/nginx

# ── 7. nginx.conf — backup, sites-enabled include, rate-limit zone ───────────
echo -e "${YELLOW}[7/8] Configuring nginx.conf...${NC}"
if [ -f /etc/nginx/nginx.conf ]; then
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
    grep -q "sites-enabled" /etc/nginx/nginx.conf || \
        sed -i '/http {/a \    include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf
    grep -q "limit_req_zone" /etc/nginx/nginx.conf || \
        sed -i '/http {/a \    limit_req_zone $binary_remote_addr zone=api:10m rate=30r/s;' /etc/nginx/nginx.conf
fi

# Default index page
if [ ! -f /usr/share/nginx/html/index.html ]; then
    cat > /usr/share/nginx/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>nginx</title></head>
<body><h1>nginx is running</h1></body>
</html>
EOF
fi

# Default catch-all site (disabled — app sites take precedence)
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /usr/share/nginx/html;
    index index.html;
    server_name _;
    location / { try_files $uri $uri/ =404; }
}
EOF
cp /etc/nginx/sites-available/default /etc/nginx/default.bak
rm -f /etc/nginx/sites-enabled/default

# ── 8. systemd service ───────────────────────────────────────────────────────
echo -e "${YELLOW}[8/8] Installing systemd service...${NC}"
cat > /etc/systemd/system/nginx.service << 'EOF'
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
nginx -t
systemctl enable nginx
systemctl start nginx

# ── Cleanup ──────────────────────────────────────────────────────────────────
cd /
rm -rf "$BUILD_DIR"

echo -e "\n${GREEN}=== nginx ${NGINX_VERSION} installation complete! ===${NC}"
echo -e "  nginx -v     →  $(nginx -v 2>&1)"
echo -e "  status       →  $(systemctl is-active nginx)"
echo -e "\nManage with:"
echo -e "  ${GREEN}sudo systemctl start|stop|restart|reload|status nginx${NC}"
