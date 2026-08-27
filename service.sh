#!/system/bin/sh

CONFIG_DIR=/data/adb/auto_adb_wifi
HOTSPOT_BOOT_FILE=$CONFIG_DIR/hotspot_boot_enabled
ADB_BOOT_FILE=$CONFIG_DIR/boot_enabled
MODDIR=${0%/*}
mkdir -p "$CONFIG_DIR"

# Wait until Android has completed booting.
until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done
sleep 3

# Initialize and evaluate Wi-Fi hotspot first.
[ -f "$HOTSPOT_BOOT_FILE" ] || echo 0 > "$HOTSPOT_BOOT_FILE"
if [ "$(cat "$HOTSPOT_BOOT_FILE" 2>/dev/null)" = "1" ]; then
  /system/bin/sh "$MODDIR/hotspot.sh" on >/dev/null 2>&1

  # Wait briefly for the hotspot interface before handling wireless ADB.
  COUNT=0
  until ip link show wlan2 >/dev/null 2>&1 || [ "$COUNT" -ge 15 ]; do
    sleep 1
    COUNT=$((COUNT + 1))
  done
else
  /system/bin/sh "$MODDIR/hotspot.sh" off >/dev/null 2>&1
fi

# Initialize and evaluate ADB over Wi-Fi second.
[ -f "$ADB_BOOT_FILE" ] || echo 1 > "$ADB_BOOT_FILE"
if [ "$(cat "$ADB_BOOT_FILE" 2>/dev/null)" = "1" ]; then
  /system/bin/sh "$MODDIR/adb.sh" on >/dev/null 2>&1
else
  /system/bin/sh "$MODDIR/adb.sh" off >/dev/null 2>&1
fi
