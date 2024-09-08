![Anurag's GitHub stats](https://github-readme-stats.vercel.app/api?username=kenzok8&show_icons=true&theme=radical)
<div align="center">
<h1 align="center"openwrt-packages</h1>
<img src="https://img.shields.io/github/issues/kenzok8/openwrt-packages?color=green">
<img src="https://img.shields.io/github/stars/kenzok8/openwrt-packages?color=yellow">
<img src="https://img.shields.io/github/forks/kenzok8/openwrt-packages?color=orange">
<img src="https://img.shields.io/github/license/kenzok8/openwrt-packages?color=ff69b4">
<img src="https://img.shields.io/github/languages/code-size/kenzok8/openwrt-packages?color=blueviolet">
</div>

<img src="https://v2.jinrishici.com/one.svg?font-size=24&spacing=2&color=Black">

<br>English | [简体中文](README.md)

##### illustrate

* If you like to follow new ones, you can download small-package, the warehouse is automatically updated every day

* [small-package warehouse address](https://github.com/kenzok8/small-package)

* The software syn the updates from to time, suitable for one-click download for openwrt compilation


##### Plugin update download:

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/kenzok8/compile-package?style=for-the-badge&label=插件更新下载)](https://github.com/kenzok8/compile-package/releases/latest)

+ [ssr+passwall](https://github.com/kenzok8/small)

+ [firmware+plugin](https://op.dllkids.xyz/)

#### Instructions
add command
```yaml
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default
git pull
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
```

- openwrt firmware to compile custom themes and software
- 
| software name                | illustrate               | Chinese description       |
| -----------------------------|------------------------| ------------|
| luci-app-alist               | file list program    | 支持多存储的文件列表程序   |
| luci-app-advanced            | System advanced settings               | 系统高级设置        |
| luci-app-adguardhome         | Block adg          |  AdG去广告      |
| luci-theme-atmaterial_new    | atmaterial theme (adapted to luci-18.06) | Atmaterial 三合一主题        |
| luci-theme-argone            | argone theme           | 修改老竭力主题名     |
| luci-app-argone-config       | argone theme settings            |  argone主题设置      |
| luci-app-aliddns             | aliyunddns         |   阿里云ddns插件      |
| luci-app-aliyundrive-webdav  | Aliyun Disk WebDAV Service            |  阿里云盘 WebDAV 服务   |
| luci-app-dnsfilter           | dns ad filtering            | 基于DNS的广告过滤        |
| luci-theme-design            | design theme          | design 主题        |
| luci-app-amlogic             | Amlogic Service             |  晶晨宝盒   |
| luci-app-eqos                | Speed ​​limit by IP address       | 依IP地址限速      |
| luci-app-gost                | https proxy      | 隐蔽的https代理   |
| luci-app-openclash           | openclash proxy            |  clash的图形代理软件      |
| luci-app-passwall            | passwall proxy      | passwall代理软件        |
| luci-app-wechatpush          | WeChat/DingTalk Pushed plugins    |   微信/钉钉推送        |
| luci-theme-tomato            | Modify topic name             |  tomato主题        |
| luci-app-smartdns            | smartdns dns pollution prevention     |  smartdns DNS防污染       |
| luci-app-ssr-plus            | ssr-plus proxy              | ssr-plus 代理软件       |
| luci-app-store               | store software repository            |  应用商店   |
| luci-theme-mcat              | Modify topic name          |   mcat主题        |
| luci-app-mosdns              | mosdns dns offload            |DNS 国内外分流解析与广告过滤        |
| luci-app-unblockneteasemusic | Unlock NetEase Cloud Music         | 解锁网易云音乐   |
| luci-app-homeproxy           | homeproxy  proxy        | homeproxy 代理   |

* Modify argon to argonne, including argonne-config, to prevent argon with the same name from affecting compilation

![atmaterial_Brown theme](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-9.jpg)
![atmaterial_Brown theme](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-10.jpg)
![atmaterial_Brown theme](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-11.jpg)
![atmaterial_red theme](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-5.jpg)
![atmaterial_red theme](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-6.jpg)
![atmaterial_red theme](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-7.jpg)
![atmaterial_red theme](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-8.jpg)
![atmaterial](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-12.jpg)
![atmaterial](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-13.jpg)
![atmaterial](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-14.jpg)
![argone](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-1.png)
![argone](https://raw.githubusercontent.com/kenzok8/kenzok8/main/screenshot/sshot-2.png)
