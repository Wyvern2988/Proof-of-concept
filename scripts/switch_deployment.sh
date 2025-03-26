#!/bin/bash

# Define the Nginx configuration file
NGINX_CONF="./nginx/nginx.conf"

# Check if Blue or Green is active
if grep -q "proxy_pass http://blue-app:3000;" $NGINX_CONF; then
  echo "Switching to Green environment..."

  # Update nginx.conf to point to Green container
  sed -i 's|proxy_pass http://blue-app:3000;|proxy_pass http://green-app:3000;|' $NGINX_CONF

else
  echo "Switching to Blue environment..."

  # Update nginx.conf to point to Blue container
  sed -i 's|proxy_pass http://green-app:3000;|proxy_pass http://blue-app:3000;|' $NGINX_CONF
fi

# Restart Nginx to apply the changes
docker-compose restart nginx
