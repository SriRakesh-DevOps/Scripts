#!/bin/bash

set -e   # Exit immediately if a command fails

echo "Updating system..."
apt update -y

echo "Installing required packages..."
apt install -y openjdk-21-jre-headless net-tools wget

echo "Switching to /opt directory..."
cd /opt

echo "Downloading Nexus Repository Manager..."
wget https://download.sonatype.com/nexus/3/nexus-3.88.0-08-linux-x86_64.tar.gz

echo "Extracting Nexus..."
tar -zxvf nexus-3.88.0-08-linux-x86_64.tar.gz

echo "Creating nexus user..."
if ! id nexus &>/dev/null; then
  adduser --disabled-password --gecos "" nexus
fi

echo "Setting password for nexus user..."
echo "nexus:Nexus@123" | chpasswd 

echo "Setting ownership..."
chown -R nexus:nexus nexus-3.88.0-08
chown -R nexus:nexus sonatype-work

echo "Configuring Nexus to run as nexus user..."
NEXUS_RC="/opt/nexus-3.88.0-08/bin/nexus.rc"

if ! grep -q "run_as_user" "$NEXUS_RC"; then
  echo 'run_as_user="nexus"' >> "$NEXUS_RC"
else
  sed -i 's/^#*run_as_user=.*/run_as_user="nexus"/' "$NEXUS_RC"
fi

echo "Starting Nexus service..."
su - nexus -c "/opt/nexus-3.88.0-08/bin/nexus start"

echo "Checking Nexus process..."
ps aux | grep nexus | grep -v grep

echo "Checking listening ports..."
netstat -lnpt | grep java || true

echo "Nexus default admin password:"
cat /opt/sonatype-work/nexus3/admin.password

echo "Nexus installation completed successfully!"
echo "Access Nexus at: http://<server-ip>:8081"