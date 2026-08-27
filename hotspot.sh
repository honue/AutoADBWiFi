#!/system/bin/sh

CONFIG_DIR=/data/adb/auto_adb_wifi
BOOT_FILE=$CONFIG_DIR/hotspot_boot_enabled
SOFTAP_CONFIG=/data/misc/apexdata/com.android.wifi/WifiConfigStoreSoftAp.xml
mkdir -p "$CONFIG_DIR"
[ -f "$BOOT_FILE" ] || echo 0 > "$BOOT_FILE"

# Start the hotspot with the SSID and passphrase saved by Android.
start_hotspot() {
  SSID=$(sed -n 's|.*<string name="WifiSsid">&quot;\(.*\)&quot;</string>.*|\1|p' "$SOFTAP_CONFIG")
  PASS=$(sed -n 's|.*<string name="Passphrase">\(.*\)</string>.*|\1|p' "$SOFTAP_CONFIG")
  if [ -z "$SSID" ]; then
    echo "无法读取系统热点配置"
    return 1
  fi
  if [ -n "$PASS" ]; then
    cmd wifi start-softap "$SSID" wpa2 "$PASS" -b any
  else
    cmd wifi start-softap "$SSID" open
  fi
}

case "$1" in
  on) start_hotspot && echo "当前热点：已开启" ;;
  off) cmd wifi stop-softap && echo "当前热点：已关闭" ;;
  boot-on) echo 1 > "$BOOT_FILE"; echo "开机自动开启热点：已开启" ;;
  boot-off) echo 0 > "$BOOT_FILE"; echo "开机自动开启热点：已关闭" ;;
  status)
    [ "$(cat "$BOOT_FILE" 2>/dev/null)" = "1" ] && echo "开机自动开启热点：已开启" || echo "开机自动开启热点：已关闭"
    if [ "$(getprop init.svc.hostapd)" = "running" ] && ip link show wlan2 >/dev/null 2>&1; then
      echo "当前热点：已开启"
    else
      echo "当前热点：已关闭"
    fi
    ;;
  *) echo "用法：hotspot.sh {on|off|boot-on|boot-off|status}"; exit 1 ;;
esac
