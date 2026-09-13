# Auto ADB WiFi

KernelSU 模块，用于管理 **Wi-Fi 热点**以及 **ADB USB / Wi-Fi 调试模式**。

无需输入命令，安装模块后即可在配置页面通过开关完成操作。

## 功能

- 立即开启或关闭系统 Wi-Fi 热点
- 设置开机后自动开启热点
- 在 USB 模式与 Wi-Fi 模式之间切换 ADB
- 设置开机后自动使用 ADB Wi-Fi 模式
- 自动使用系统已保存的热点名称和密码

## 安装

1. 从 [Releases](https://github.com/KernelSU-Modules-Repo/auto_adb_wifi/releases/latest) 下载最新的 `AutoADBWiFi.zip`
2. 在 KernelSU 管理器中安装模块
3. 安装完成后重启设备
4. 在模块列表中打开 AutoADBWiFi 配置页面

## 兼容性

- Android Root 环境
- KernelSU

本模块已在 Android 13、MIUI、Qualcomm 平台设备上测试。不同 Android 版本或厂商 ROM 的兼容性可能有所不同。

## 使用说明

### Wi-Fi 热点

- **开机自动开启热点**：设备启动完成后自动恢复系统热点
- **Wi-Fi 热点**：立即开启或关闭当前热点

模块直接使用 Android 系统中已经保存的热点配置，不会在模块目录中另外保存热点密码。

### ADB

- **开机使用 Wi-Fi 模式**：开启后，设备每次启动都会进入 ADB Wi-Fi 模式；关闭后则进入 USB 模式
- **USB 模式 / Wi-Fi 模式**：立即切换当前 ADB 连接方式

## 常见问题

### 切换到 USB 模式后电脑没有立即识别

请等待几秒，让系统完成 USB 功能重新绑定。如果仍未识别，可以重新插拔一次 USB 数据线。

### 热点无法自动开启

请先进入 Android 系统设置，手动配置并成功开启一次热点，然后再使用模块的自动开启功能。

### 配置页面无法打开

请确认当前 Root 管理器支持模块 WebUI。推荐使用较新版本的 KernelSU 管理器。

### 无法通过 Wi-Fi 连接 ADB

请确认设备与电脑处于可互相访问的网络中，并检查防火墙是否阻止 TCP 5555 端口。

## 安全提示

ADB Wi-Fi 模式会在网络接口上开放调试端口。请仅在可信网络中使用，使用完成后建议切回 USB 模式。

## 支持与源码

- 问题反馈：[GitHub Issues](https://github.com/KernelSU-Modules-Repo/auto_adb_wifi/issues)
- 源代码：[KernelSU-Modules-Repo/auto_adb_wifi](https://github.com/KernelSU-Modules-Repo/auto_adb_wifi)
