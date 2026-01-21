#!/bin/bash

LOGFILE=~/devops-lab/health.log
THRESHOLD_DISK=80
THRESHOLD_MEM=500   # in MB

echo "===================================" >> $LOGFILE
echo "Health Check: $(date)" >> $LOGFILE
echo "===================================" >> $LOGFILE

# Host info
echo "Hostname: $(hostname)" >> $LOGFILE
uptime >> $LOGFILE

# CPU load
echo "------ CPU Load ------" >> $LOGFILE
top -b -n1 | head -5 >> $LOGFILE

# Memory
echo "------ Memory ------" >> $LOGFILE
free -m >> $LOGFILE

# Disk
echo "------ Disk ------" >> $LOGFILE
df -h >> $LOGFILE

# 🔥 ALERT LOGIC

# Disk usage check
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//g')

if [ "$DISK_USAGE" -gt "$THRESHOLD_DISK" ]; then
  echo "⚠ ALERT: Disk usage is HIGH: ${DISK_USAGE}%" | tee -a $LOGFILE
else
  echo "✔ Disk usage is normal: ${DISK_USAGE}%" >> $LOGFILE
fi

# Memory check
FREE_MEM=$(free -m | awk '/Mem:/ {print $4}')

if [ "$FREE_MEM" -lt "$THRESHOLD_MEM" ]; then
  echo "⚠ ALERT: Free memory is LOW: ${FREE_MEM}MB" | tee -a $LOGFILE
else
  echo "✔ Memory is sufficient: ${FREE_MEM}MB free" >> $LOGFILE
fi

echo "" >> $LOGFILE
echo "Health check completed successfully."



