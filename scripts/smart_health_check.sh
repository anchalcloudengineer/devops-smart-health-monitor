#!/bin/bash

BASE_DIR="$HOME/devops-lab"
LOGFILE="$BASE_DIR/smart_health.log"

mkdir -p "$BASE_DIR"
touch "$LOGFILE"

DATE=$(date)
HOST=$(hostname)

echo "===================================" >> $LOGFILE
echo "Smart Health Check: $DATE" >> $LOGFILE
echo "Server: $HOST" >> $LOGFILE
echo "===================================" >> $LOGFILE

# -------- Disk Check --------
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ $DISK_USAGE -ge 80 ]; then
    echo "[ALERT] Disk usage is high: $DISK_USAGE%" | tee -a $LOGFILE
else
    echo "[OK] Disk usage normal: $DISK_USAGE%" | tee -a $LOGFILE
fi

# -------- Memory Check --------
FREE_MEM=$(free -m | awk '/Mem:/ {print $4}')

if [ $FREE_MEM -le 300 ]; then
    echo "[ALERT] Low memory: ${FREE_MEM}MB free" | tee -a $LOGFILE
else
    echo "[OK] Memory sufficient: ${FREE_MEM}MB free" | tee -a $LOGFILE
fi

# -------- CPU Load Check --------
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | tr -d ' ')
LOAD_LIMIT=1.50

CHECK=$(echo "$CPU_LOAD > $LOAD_LIMIT" | bc)

if [ "$CHECK" -eq 1 ]; then
    echo "[ALERT] High CPU load: $CPU_LOAD" | tee -a $LOGFILE
else
    echo "[OK] CPU load normal: $CPU_LOAD" | tee -a $LOGFILE
fi

echo "" >> $LOGFILE
