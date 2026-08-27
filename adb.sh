#!/system/bin/sh
CONFIG_DIR=/data/adb/auto_adb_wifi
BOOT_FILE=$CONFIG_DIR/boot_enabled
mkdir -p "$CONFIG_DIR"
[ -f "$BOOT_FILE" ] || echo 1 > "$BOOT_FILE"

# Rebind USB functions after the caller has returned. This keeps the
# transition alive even when the current ADB transport is disconnected.
switch_usb_to_charging() {
  (
    sleep 1
    svc usb setFunctions
  ) >/dev/null 2>&1 &
}

switch_usb_to_adb() {
  (
    sleep 1
    svc usb setFunctions
    sleep 2
    svc usb setFunctions adb
  ) >/dev/null 2>&1 &
}

case "$1" in
  on)
    setprop service.adb.tcp.port 5555
    stop adbd
    start adbd
    switch_usb_to_charging
    echo "当前 ADB 模式：Wi-Fi"
    ;;
  off)
    setprop service.adb.tcp.port -1
    stop adbd
    start adbd
    switch_usb_to_adb
    echo "当前 ADB 模式：USB"
    ;;
  boot-on) echo 1 > "$BOOT_FILE"; echo "开机自动执行：已开启" ;;
  boot-off) echo 0 > "$BOOT_FILE"; echo "开机自动执行：已关闭" ;;
  status)
    [ "$(cat "$BOOT_FILE" 2>/dev/null)" = "1" ] && echo "开机自动开启：已开启" || echo "开机自动开启：已关闭"
    PORT=$(getprop service.adb.tcp.port)
    if [ "$PORT" = "5555" ] && [ "$(getprop init.svc.adbd)" = "running" ]; then
      echo "当前 ADB：已开启 端口：$PORT"
    else
      echo "当前 ADB：已关闭 端口：$PORT"
    fi
    ;;
  *) echo "用法：adb.sh {on|off|boot-on|boot-off|status}"; exit 1 ;;
esac
