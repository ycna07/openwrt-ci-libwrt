
# hostname修改
sed -i "s/hostname='.*'/hostname='ycna-route'/g" package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 免登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 调整NSS驱动q6_region内存区域预留大小（ipq6018.dtsi默认预留85MB，ipq6018-512m.dtsi默认预留55MB，带WiFi必须至少预留54MB，以下分别是改成预留16MB、32MB、64MB和96MB）
# sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x01000000>/' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi
# sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x02000000>/' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi
# sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x04000000>/' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi
# sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x06000000>/' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi


rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led

# 在 OpenWrt 源码的 package/kernel/linux/modules/netsupport.mk 文件中添加以下内容：
echo 'define KernelPackage/xdp-sockets-diag
SUBMENU:=$(NETWORK_SUPPORT_MENU)
TITLE:=PF_XDP sockets monitoring interface support for ss utility
KCONFIG:= \
CONFIG_XDP_SOCKETS=y \
CONFIG_XDP_SOCKETS_DIAG
FILES:=$(LINUX_DIR)/net/xdp/xsk_diag.ko
AUTOLOAD:=$(call AutoLoad,31,xsk_diag)
endef
define KernelPackage/xdp-sockets-diag/description
Support for PF_XDP sockets monitoring interface used by the ss tool
endef
$(eval $(call KernelPackage,xdp-sockets-diag))' >> package/kernel/linux/modules/netsupport.mk

# 在 .config 文件中启用该模块：
echo 'CONFIG_PACKAGE_kmod-xdp-sockets-diag=y' >> .config

git clone --depth=1 https://github.com/QiuSimons/luci-app-daed package/luci-app-daed

git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter



./scripts/feeds update -a
./scripts/feeds install -a