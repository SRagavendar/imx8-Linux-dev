#!/bin/sh -e

DIR=$PWD

config_enable () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xy" ] ; then
		echo "Setting: ${config}=y"
		./scripts/config --enable ${config}
	fi
}

config_disable () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xn" ] ; then
		echo "Setting: ${config}=n"
		./scripts/config --disable ${config}
	fi
}

config_enable_special () {
	test_module=$(cat .config | grep ${config} || true)
	if [ "x${test_module}" = "x# ${config} is not set" ] ; then
		echo "Setting: ${config}=y"
		sed -i -e 's:# '$config' is not set:'$config'=y:g' .config
	fi
	if [ "x${test_module}" = "x${config}=m" ] ; then
		echo "Setting: ${config}=y"
		sed -i -e 's:'$config'=m:'$config'=y:g' .config
	fi
}

config_module_special () {
	test_module=$(cat .config | grep ${config} || true)
	if [ "x${test_module}" = "x# ${config} is not set" ] ; then
		echo "Setting: ${config}=m"
		sed -i -e 's:# '$config' is not set:'$config'=m:g' .config
	fi
}

config_module () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xm" ] ; then
		echo "Setting: ${config}=m"
		./scripts/config --module ${config}
	fi
}

config_string () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "x${option}" ] ; then
		echo "Setting: ${config}=\"${option}\""
		./scripts/config --set-str ${config} "${option}"
	fi
}

config_value () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "x${option}" ] ; then
		echo "Setting: ${config}=${option}"
		./scripts/config --set-val ${config} ${option}
	fi
}

cd ${DIR}/KERNEL/

#
# RCU Subsystem
#
config="CONFIG_IKCONFIG" ; config_enable
config="CONFIG_IKCONFIG_PROC" ; config_enable
config="CONFIG_MEMCG_SWAP_ENABLED" ; config_enable
config="CONFIG_RT_GROUP_SCHED" ; config_enable
config="CONFIG_SYSFS_SYSCALL" ; config_enable
config="CONFIG_SYSCTL_SYSCALL" ; config_enable
config="CONFIG_KALLSYMS_ALL" ; config_enable
config="CONFIG_EMBEDDED" ; config_enable

#
# Kernel Performance Events And Counters
#
config="CONFIG_CC_STACKPROTECTOR_STRONG" ; config_disable
config="CONFIG_CC_STACKPROTECTOR_AUTO" ; config_enable

#https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=861964
#CONFIG_SLUB=y

##
## GCOV-based kernel profiling
##
#config="CONFIG_MODULE_SIG" ; config_disable
#config="CONFIG_SYSTEM_TRUSTED_KEYRING" ; config_disable
config="CONFIG_MODULE_COMPRESS" ; config_enable
config="CONFIG_MODULE_COMPRESS_GZIP" ; config_disable
config="CONFIG_MODULE_COMPRESS_XZ" ; config_enable

#
# CPU Core family selection
#
config="CONFIG_ARCH_VIRT" ; config_disable
config="CONFIG_ARCH_MVEBU" ; config_disable
config="CONFIG_MACH_DOVE" ; config_disable
config="CONFIG_ARCH_BCM" ; config_disable
config="CONFIG_ARCH_HIGHBANK" ; config_disable
config="CONFIG_ARCH_MESON" ; config_disable

#
# Device tree only
#
config="CONFIG_SOC_IMX50" ; config_enable
config="CONFIG_SOC_IMX6SL" ; config_enable
config="CONFIG_SOC_IMX6SLL" ; config_enable
config="CONFIG_SOC_IMX6SX" ; config_enable
config="CONFIG_SOC_IMX6UL" ; config_enable
config="CONFIG_SOC_IMX7D" ; config_enable
config="CONFIG_SOC_LS1021A" ; config_enable

#
# Cortex-A/Cortex-M asymmetric multiprocessing platforms
#
config="CONFIG_SOC_VF610" ; config_enable
config="CONFIG_WAND_RFKILL" ; config_enable

#
# TI OMAP/AM/DM/DRA Family
#
config="CONFIG_SOC_AM43XX" ; config_enable

#
# OMAP Legacy Platform Data Board Type
#
config="CONFIG_MACH_OMAP3517EVM" ; config_disable
config="CONFIG_MACH_OMAP3_PANDORA" ; config_disable
config="CONFIG_OMAP5_ERRATA_801819" ; config_enable
config="CONFIG_ARCH_ROCKCHIP" ; config_disable
config="CONFIG_ARCH_SOCFPGA" ; config_disable
config="CONFIG_ARCH_EXYNOS" ; config_disable

#
# Power management
#
config="CONFIG_ARCH_TEGRA" ; config_disable
config="CONFIG_ARCH_VEXPRESS" ; config_disable
config="CONFIG_ARCH_WM8850" ; config_disable

#
# Processor Features
#
config="CONFIG_CACHE_L2X0_PMU" ; config_enable
config="CONFIG_PL310_ERRATA_753970" ; config_disable
config="CONFIG_ARM_ERRATA_754327" ; config_disable
config="CONFIG_ARM_ERRATA_773022" ; config_disable

#
# Bus support
#
config="CONFIG_PCI" ; config_disable

#
# Kernel Features
#
config="CONFIG_ARM_MODULE_PLTS" ; config_enable
config="CONFIG_PARAVIRT" ; config_disable
config="CONFIG_XEN" ; config_disable

#first check..
#exit

#
# CPU Frequency scaling
#
config="CONFIG_CPU_FREQ_GOV_POWERSAVE" ; config_enable
config="CONFIG_CPU_FREQ_GOV_USERSPACE" ; config_enable
config="CONFIG_CPU_FREQ_GOV_ONDEMAND" ; config_enable
config="CONFIG_CPU_FREQ_GOV_CONSERVATIVE" ; config_enable

#
# CPU frequency scaling drivers
#
config="CONFIG_CPUFREQ_DT" ; config_enable
config="CONFIG_ARM_IMX6Q_CPUFREQ" ; config_enable
config="CONFIG_ARM_OMAP2PLUS_CPUFREQ" ; config_disable
config="CONFIG_ARM_TI_CPUFREQ" ; config_enable

#
# CPU Idle
#
config="CONFIG_CPU_IDLE" ; config_enable

#
# ARM CPU Idle Drivers
#
config="CONFIG_ARM_CPUIDLE" ; config_enable

#
# At least one emulation must be selected
#
config="CONFIG_KERNEL_MODE_NEON" ; config_enable

#
# Power management options
#
config="CONFIG_PM_AUTOSLEEP" ; config_enable
config="CONFIG_PM_WAKELOCKS" ; config_enable
config="CONFIG_PM_WAKELOCKS_GC" ; config_enable

#
# Networking options
#
config="CONFIG_IP_PNP" ; config_enable
config="CONFIG_IP_PNP_DHCP" ; config_enable
config="CONFIG_IP_PNP_BOOTP" ; config_enable
config="CONFIG_IP_PNP_RARP" ; config_enable
config="CONFIG_NETLABEL" ; config_enable

#
# Network testing
#
config="CONFIG_HAMRADIO" ; config_enable

#
# Packet Radio protocols
#
config="CONFIG_AX25" ; config_module
config="CONFIG_NETROM" ; config_module
config="CONFIG_ROSE" ; config_module

#
# AX.25 network device drivers
#
config="CONFIG_MKISS" ; config_module
config="CONFIG_6PACK" ; config_module
config="CONFIG_BPQETHER" ; config_module
config="CONFIG_BAYCOM_SER_FDX" ; config_module
config="CONFIG_BAYCOM_SER_HDX" ; config_module
config="CONFIG_YAM" ; config_module

#
# CAN Device Drivers
#
config="CONFIG_CAN_C_CAN" ; config_module
config="CONFIG_CAN_C_CAN_PLATFORM" ; config_module
config="CONFIG_CAN_SJA1000" ; config_disable
config="CONFIG_CAN_SOFTING" ; config_disable

#
# CAN SPI interfaces
#
config="CONFIG_CAN_HI311X" ; config_module
config="CONFIG_CAN_MCP251X" ; config_module

#
# Bluetooth device drivers
#
config="CONFIG_BT_HCIUART" ; config_module
config="CONFIG_BT_HCIUART_SERDEV" ; config_enable
config="CONFIG_BT_HCIUART_H4" ; config_enable
config="CONFIG_BT_HCIUART_BCSP" ; config_enable
config="CONFIG_BT_HCIUART_ATH3K" ; config_enable
config="CONFIG_BT_HCIUART_LL" ; config_enable
config="CONFIG_BT_HCIUART_3WIRE" ; config_enable
config="CONFIG_BT_HCIUART_QCA" ; config_enable
config="CONFIG_BT_HCIBCM203X" ; config_module
config="CONFIG_BT_HCIBPA10X" ; config_module
config="CONFIG_BT_HCIBFUSB" ; config_module

config="CONFIG_MAC80211_RC_MINSTREL_VHT" ; config_enable

#
# Near Field Communication (NFC) devices
#
config="CONFIG_NFC_NCI" ; config_module
config="CONFIG_NFC_NCI_SPI" ; config_module
config="CONFIG_NFC_HCI" ; config_module
config="CONFIG_NFC_SHDLC" ; config_enable

#
# Near Field Communication (NFC) devices
#
config="CONFIG_NFC_PN544" ; config_module
config="CONFIG_NFC_PN544_I2C" ; config_module
config="CONFIG_NFC_PN533_I2C" ; config_module
config="CONFIG_NFC_MICROREAD" ; config_module
config="CONFIG_NFC_MICROREAD_I2C" ; config_module

#
# Generic Driver Options
#
config="CONFIG_UEVENT_HELPER" ; config_enable
config="CONFIG_UEVENT_HELPER_PATH" ; option="" ; config_string
config="CONFIG_DEVTMPFS_MOUNT" ; config_enable

config="CONFIG_FIRMWARE_IN_KERNEL" ; config_enable
config="CONFIG_EXTRA_FIRMWARE" ; option="am335x-pm-firmware.elf am335x-bone-scale-data.bin am335x-evm-scale-data.bin am43x-evm-scale-data.bin" ; config_string
config="CONFIG_EXTRA_FIRMWARE_DIR" ; option="firmware" ; config_string

#
# Default contiguous memory area size:
#
config="CONFIG_CMA_SIZE_MBYTES" ; option=48 ; config_value

#
# Bus devices
#
config="CONFIG_OMAP_OCP2SCP" ; config_enable
config="CONFIG_SIMPLE_PM_BUS" ; config_enable
config="CONFIG_VEXPRESS_CONFIG" ; config_disable

#
# LPDDR & LPDDR2 PCM memory drivers
#
config="CONFIG_MTD_UBI" ; config_enable
config="CONFIG_OF_OVERLAY" ; config_enable
config="CONFIG_PARPORT" ; config_disable

#
# NVME Support
#
config="CONFIG_NVME_CORE" ; config_disable
config="CONFIG_NVME_MULTIPATH" ; config_disable
config="CONFIG_NVME_FABRICS" ; config_disable
config="CONFIG_NVME_RDMA" ; config_disable
config="CONFIG_NVME_FC" ; config_disable
config="CONFIG_NVME_TARGET" ; config_disable

#
# Misc devices
#
config="CONFIG_SENSORS_LIS3LV02D" ; config_disable
config="CONFIG_MISC_RTSX" ; config_disable
config="CONFIG_MISC_RTSX_USB" ; config_disable
config="CONFIG_TIEQEP" ; config_module
config="CONFIG_C2PORT" ; config_disable

#
# EEPROM support
#
config="CONFIG_EEPROM_AT24" ; config_enable
config="CONFIG_EEPROM_AT25" ; config_enable
config="CONFIG_EEPROM_93XX46" ; config_module

#
# Texas Instruments shared transport line discipline
#
#better one in iio
config="CONFIG_SENSORS_LIS3_I2C" ; config_disable

#
# Altera FPGA firmware download module
#
config="CONFIG_ALTERA_STAPL" ; config_disable

#
# SCSI device support
#
config="CONFIG_SCSI_MOD" ; config_enable
config="CONFIG_SCSI" ; config_enable

#
# SCSI support type (disk, tape, CD-ROM)
#
config="CONFIG_BLK_DEV_SD" ; config_enable

#
# SCSI Transports
#
config="CONFIG_ATA" ; config_enable

#
# Controllers with non-SFF native interface
#
config="CONFIG_SATA_AHCI_PLATFORM" ; config_enable
config="CONFIG_AHCI_IMX" ; config_enable
config="CONFIG_AHCI_SUNXI" ; config_enable

#
# PATA SFF controllers with BMDMA
#
config="CONFIG_PATA_IMX" ; config_enable

#
# PIO-only SFF controllers
#
config="CONFIG_PATA_PLATFORM" ; config_enable
config="CONFIG_PATA_OF_PLATFORM" ; config_enable

#
# Generic fallback / legacy drivers
#
config="CONFIG_MII" ; config_enable

#
# Distributed Switch Architecture drivers
#
config="CONFIG_B53" ; config_disable
config="CONFIG_NET_DSA_BCM_SF2" ; config_disable
config="CONFIG_NET_DSA_MV88E6060" ; config_disable
config="CONFIG_NET_DSA_MV88E6XXX" ; config_disable
config="CONFIG_NET_VENDOR_ALACRITECH" ; config_disable
config="CONFIG_NET_VENDOR_AMAZON" ; config_disable
config="CONFIG_NET_VENDOR_AQUANTIA" ; config_disable
config="CONFIG_NET_CADENCE" ; config_disable
config="CONFIG_NET_VENDOR_BROADCOM" ; config_disable
config="CONFIG_NET_VENDOR_CIRRUS" ; config_disable
config="CONFIG_NET_VENDOR_CORTINA" ; config_disable
config="CONFIG_NET_VENDOR_EZCHIP" ; config_disable
config="CONFIG_NET_VENDOR_FARADAY" ; config_disable
config="CONFIG_NET_VENDOR_HISILICON" ; config_disable
config="CONFIG_NET_VENDOR_HUAWEI" ; config_disable
config="CONFIG_NET_VENDOR_INTEL" ; config_disable
config="CONFIG_NET_VENDOR_MARVELL" ; config_disable
config="CONFIG_NET_VENDOR_MELLANOX" ; config_disable
config="CONFIG_NET_VENDOR_NETRONOME" ; config_disable
config="CONFIG_NET_VENDOR_8390" ; config_disable
config="CONFIG_NET_VENDOR_QUALCOMM" ; config_disable
config="CONFIG_NET_VENDOR_RENESAS" ; config_disable
config="CONFIG_NET_VENDOR_ROCKER" ; config_disable
config="CONFIG_NET_VENDOR_SEEQ" ; config_disable
config="CONFIG_NET_VENDOR_SOLARFLARE" ; config_disable
config="CONFIG_NET_VENDOR_SOCIONEXT" ; config_disable
config="CONFIG_NET_VENDOR_VIA" ; config_disable
config="CONFIG_NET_VENDOR_WIZNET" ; config_enable
config="CONFIG_WIZNET_W5100" ; config_enable
config="CONFIG_WIZNET_W5100_SPI" ; config_enable
config="CONFIG_NET_VENDOR_SYNOPSYS" ; config_disable
config="CONFIG_SUN4I_EMAC" ; config_enable
config="CONFIG_KS8851" ; config_module
config="CONFIG_ENC28J60" ; config_enable
config="CONFIG_ENCX24J600" ; config_enable
config="CONFIG_STMMAC_ETH" ; config_enable
config="CONFIG_STMMAC_PLATFORM" ; config_enable
config="CONFIG_DWMAC_GENERIC" ; config_enable
config="CONFIG_DWMAC_SUNXI" ; config_enable
config="CONFIG_DWMAC_SUN8I" ; config_enable
config="CONFIG_TI_DAVINCI_EMAC" ; config_enable
config="CONFIG_TI_DAVINCI_MDIO" ; config_enable
config="CONFIG_TI_DAVINCI_CPDMA" ; config_enable
config="CONFIG_TI_CPSW_ALE" ; config_enable
config="CONFIG_TI_CPSW" ; config_enable
config="CONFIG_TI_CPTS" ; config_enable

#
# MII PHY device drivers
#
config="CONFIG_AMD_PHY" ; config_disable
config="CONFIG_AQUANTIA_PHY" ; config_disable
config="CONFIG_AT803X_PHY" ; config_disable
config="CONFIG_BCM7XXX_PHY" ; config_disable
config="CONFIG_BCM87XX_PHY" ; config_disable
config="CONFIG_BROADCOM_PHY" ; config_disable
config="CONFIG_CICADA_PHY" ; config_disable
config="CONFIG_DAVICOM_PHY" ; config_disable
config="CONFIG_ICPLUS_PHY" ; config_disable
config="CONFIG_LSI_ET1011C_PHY" ; config_disable
config="CONFIG_LXT_PHY" ; config_disable
config="CONFIG_MARVELL_PHY" ; config_disable
config="CONFIG_NATIONAL_PHY" ; config_disable
config="CONFIG_QSEMI_PHY" ; config_disable
config="CONFIG_REALTEK_PHY" ; config_disable
config="CONFIG_STE10XP" ; config_disable
config="CONFIG_TERANETICS_PHY" ; config_disable
config="CONFIG_DP83848_PHY" ; config_enable
config="CONFIG_MICREL_PHY" ; config_enable
config="CONFIG_MICROSEMI_PHY" ; config_enable
config="CONFIG_SMSC_PHY" ; config_enable
config="CONFIG_VITESSE_PHY" ; config_enable
config="CONFIG_ATH9K_HWRNG" ; config_enable
config="CONFIG_B43" ; config_disable
config="CONFIG_B43LEGACY" ; config_disable
config="CONFIG_BRCMSMAC" ; config_disable

#
# USB Network Adapters
#
config="CONFIG_P54_SPI" ; config_module
config="CONFIG_LIBERTAS_SPI" ; config_module
config="CONFIG_RSI_SDIO" ; config_module
config="CONFIG_CW1200" ; config_module
config="CONFIG_CW1200_WLAN_SDIO" ; config_module
config="CONFIG_CW1200_WLAN_SPI" ; config_module
config="CONFIG_USB_ZD1201" ; config_module

#
# Userland interfaces
#
config="CONFIG_INPUT_MOUSEDEV" ; config_disable

#
# Input Device Drivers
#
config="CONFIG_KEYBOARD_ADP5589" ; config_module
config="CONFIG_KEYBOARD_ATKBD" ; config_disable
config="CONFIG_KEYBOARD_QT1070" ; config_module
config="CONFIG_KEYBOARD_LKKBD" ; config_module
config="CONFIG_KEYBOARD_GPIO_POLLED" ; config_module
config="CONFIG_KEYBOARD_TCA6416" ; config_module
config="CONFIG_KEYBOARD_TCA8418" ; config_module
config="CONFIG_KEYBOARD_MATRIX" ; config_module
config="CONFIG_KEYBOARD_LM8333" ; config_module
config="CONFIG_KEYBOARD_MCS" ; config_module
config="CONFIG_KEYBOARD_MPR121" ; config_module
config="CONFIG_KEYBOARD_SNVS_PWRKEY" ; config_module
config="CONFIG_KEYBOARD_NEWTON" ; config_module
config="CONFIG_KEYBOARD_SAMSUNG" ; config_disable
config="CONFIG_KEYBOARD_SUNKBD" ; config_module
config="CONFIG_KEYBOARD_OMAP4" ; config_disable
config="CONFIG_KEYBOARD_TWL4030" ; config_disable
config="CONFIG_KEYBOARD_XTKBD" ; config_module
config="CONFIG_KEYBOARD_CAP11XX" ; config_module
config="CONFIG_KEYBOARD_BCM" ; config_module

config="CONFIG_MOUSE_PS2" ; config_disable
config="CONFIG_MOUSE_SERIAL" ; config_module
config="CONFIG_MOUSE_BCM5974" ; config_module
config="CONFIG_MOUSE_CYAPA" ; config_module
config="CONFIG_MOUSE_VSXXXAA" ; config_module
config="CONFIG_MOUSE_GPIO" ; config_module

config="CONFIG_INPUT_JOYSTICK" ; config_enable
config="CONFIG_JOYSTICK_ANALOG" ; config_module
config="CONFIG_JOYSTICK_A3D" ; config_module
config="CONFIG_JOYSTICK_ADI" ; config_module
config="CONFIG_JOYSTICK_COBRA" ; config_module
config="CONFIG_JOYSTICK_GF2K" ; config_module
config="CONFIG_JOYSTICK_GRIP" ; config_module
config="CONFIG_JOYSTICK_GRIP_MP" ; config_module
config="CONFIG_JOYSTICK_GUILLEMOT" ; config_module
config="CONFIG_JOYSTICK_INTERACT" ; config_module
config="CONFIG_JOYSTICK_SIDEWINDER" ; config_module
config="CONFIG_JOYSTICK_TMDC" ; config_module
config="CONFIG_JOYSTICK_IFORCE" ; config_module
config="CONFIG_JOYSTICK_IFORCE_USB" ; config_enable
config="CONFIG_JOYSTICK_IFORCE_232" ; config_enable
config="CONFIG_JOYSTICK_WARRIOR" ; config_module
config="CONFIG_JOYSTICK_MAGELLAN" ; config_module
config="CONFIG_JOYSTICK_SPACEORB" ; config_module
config="CONFIG_JOYSTICK_SPACEBALL" ; config_module
config="CONFIG_JOYSTICK_STINGER" ; config_module
config="CONFIG_JOYSTICK_TWIDJOY" ; config_module
config="CONFIG_JOYSTICK_ZHENHUA" ; config_module
config="CONFIG_JOYSTICK_AS5011" ; config_module
config="CONFIG_JOYSTICK_JOYDUMP" ; config_module
config="CONFIG_JOYSTICK_XPAD" ; config_module
config="CONFIG_JOYSTICK_XPAD_FF" ; config_enable
config="CONFIG_JOYSTICK_XPAD_LEDS" ; config_enable
config="CONFIG_JOYSTICK_PXRC" ; config_module

#exit

config="CONFIG_TOUCHSCREEN_AD7879_SPI" ; config_module
config="CONFIG_TOUCHSCREEN_AR1021_I2C" ; config_module
config="CONFIG_TOUCHSCREEN_AUO_PIXCIR" ; config_module
config="CONFIG_TOUCHSCREEN_BU21013" ; config_module
config="CONFIG_TOUCHSCREEN_CHIPONE_ICN8318" ; config_module
config="CONFIG_TOUCHSCREEN_CY8CTMG110" ; config_module
config="CONFIG_TOUCHSCREEN_CYTTSP_CORE" ; config_module
config="CONFIG_TOUCHSCREEN_CYTTSP_I2C" ; config_module
config="CONFIG_TOUCHSCREEN_CYTTSP_SPI" ; config_module
config="CONFIG_TOUCHSCREEN_CYTTSP4_CORE" ; config_module
config="CONFIG_TOUCHSCREEN_CYTTSP4_I2C" ; config_module
config="CONFIG_TOUCHSCREEN_CYTTSP4_SPI" ; config_module
config="CONFIG_TOUCHSCREEN_DA9052" ; config_module
config="CONFIG_TOUCHSCREEN_EETI" ; config_module
config="CONFIG_TOUCHSCREEN_EGALAX" ; config_module
config="CONFIG_TOUCHSCREEN_GOODIX" ; config_module
config="CONFIG_TOUCHSCREEN_ILI210X" ; config_module
config="CONFIG_TOUCHSCREEN_EKTF2127" ; config_module
config="CONFIG_TOUCHSCREEN_ELAN" ; config_module
config="CONFIG_TOUCHSCREEN_WACOM_I2C" ; config_module
config="CONFIG_TOUCHSCREEN_MAX11801" ; config_module
config="CONFIG_TOUCHSCREEN_MMS114" ; config_module
config="CONFIG_TOUCHSCREEN_MELFAS_MIP4" ; config_module
config="CONFIG_TOUCHSCREEN_IMX6UL_TSC" ; config_module
config="CONFIG_TOUCHSCREEN_EDT_FT5X06" ; config_module
config="CONFIG_TOUCHSCREEN_PIXCIR" ; config_module
config="CONFIG_TOUCHSCREEN_WDT87XX_I2C" ; config_module
config="CONFIG_TOUCHSCREEN_TSC_SERIO" ; config_module
config="CONFIG_TOUCHSCREEN_TSC2004" ; config_module
config="CONFIG_TOUCHSCREEN_ST1232" ; config_module
config="CONFIG_TOUCHSCREEN_SX8654" ; config_module
config="CONFIG_TOUCHSCREEN_ZFORCE" ; config_module
config="CONFIG_TOUCHSCREEN_ROHM_BU21023" ; config_module

config="CONFIG_INPUT_AD714X" ; config_module
config="CONFIG_INPUT_AD714X_I2C" ; config_module
config="CONFIG_INPUT_AD714X_SPI" ; config_module
config="CONFIG_INPUT_BMA150" ; config_module
config="CONFIG_INPUT_E3X0_BUTTON" ; config_module
config="CONFIG_INPUT_MC13783_PWRBUTTON" ; config_module
config="CONFIG_INPUT_GP2A" ; config_module
config="CONFIG_INPUT_GPIO_BEEPER" ; config_module
config="CONFIG_INPUT_GPIO_TILT_POLLED" ; config_module
config="CONFIG_INPUT_GPIO_DECODER" ; config_module
config="CONFIG_INPUT_KXTJ9" ; config_module
config="CONFIG_INPUT_KXTJ9_POLLED_MODE" ; config_enable
config="CONFIG_INPUT_REGULATOR_HAPTIC" ; config_module
config="CONFIG_INPUT_TPS65218_PWRBUTTON" ; config_enable
config="CONFIG_INPUT_AXP20X_PEK" ; config_enable
config="CONFIG_INPUT_TWL4030_PWRBUTTON" ; config_enable
config="CONFIG_INPUT_TWL4030_VIBRA" ; config_enable
config="CONFIG_INPUT_TWL6040_VIBRA" ; config_enable
config="CONFIG_INPUT_UINPUT" ; config_enable
config="CONFIG_INPUT_PALMAS_PWRBUTTON" ; config_enable
config="CONFIG_INPUT_PCF8574" ; config_module
config="CONFIG_INPUT_PWM_BEEPER" ; config_module
config="CONFIG_INPUT_GPIO_ROTARY_ENCODER" ; config_module
config="CONFIG_INPUT_DA9052_ONKEY" ; config_module
config="CONFIG_INPUT_DA9055_ONKEY" ; config_module
config="CONFIG_INPUT_ADXL34X" ; config_module
config="CONFIG_INPUT_ADXL34X_I2C" ; config_module
config="CONFIG_INPUT_ADXL34X_SPI" ; config_module
config="CONFIG_INPUT_IMS_PCU" ; config_module
config="CONFIG_INPUT_CMA3000" ; config_module
config="CONFIG_INPUT_CMA3000_I2C" ; config_module
config="CONFIG_INPUT_SOC_BUTTON_ARRAY" ; config_module
config="CONFIG_INPUT_DRV260X_HAPTICS" ; config_module
config="CONFIG_INPUT_DRV2665_HAPTICS" ; config_module
config="CONFIG_INPUT_DRV2667_HAPTICS" ; config_module

#exit

#
# Hardware I/O ports
#
config="CONFIG_SERIO_ALTERA_PS2" ; config_disable

#
# Character devices
#
config="CONFIG_DEVKMEM" ; config_enable

#
# Serial drivers
#
config="CONFIG_SERIAL_8250_DMA" ; config_disable
config="CONFIG_SERIAL_8250_NR_UARTS" ; option="6" ; config_value
config="CONFIG_SERIAL_8250_RUNTIME_UARTS" ; option="6" ; config_value
config="CONFIG_SERIAL_8250_OMAP" ; config_enable
config="CONFIG_SERIAL_8250_OMAP_TTYO_FIXUP" ; config_enable

#
# Non-8250 serial port support
#
config="CONFIG_SERIAL_OMAP" ; config_disable
config="CONFIG_SERIAL_ARC" ; config_disable
config="CONFIG_SERIAL_FSL_LPUART" ; config_enable
config="CONFIG_SERIAL_FSL_LPUART_CONSOLE" ; config_enable
config="CONFIG_SERIAL_DEV_BUS" ; config_enable

config="CONFIG_HW_RANDOM" ; config_enable
config="CONFIG_HW_RANDOM_OMAP" ; config_enable
config="CONFIG_HW_RANDOM_OMAP3_ROM" ; config_enable
config="CONFIG_HW_RANDOM_IMX_RNGC" ; config_enable
config="CONFIG_HW_RANDOM_TPM" ; config_enable
config="CONFIG_TCG_TPM" ; config_enable
config="CONFIG_TCG_TIS_I2C_ATMEL" ; config_enable

#
# I2C support
#
config="CONFIG_I2C_CHARDEV" ; config_enable

#
# Multiplexer I2C Chip support
#
config="CONFIG_I2C_MUX_GPIO" ; config_enable
config="CONFIG_I2C_MUX_PINCTRL" ; config_enable

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
config="CONFIG_I2C_IMX" ; config_enable
config="CONFIG_I2C_MV64XXX" ; config_enable
config="CONFIG_I2C_OCORES" ; config_disable
config="CONFIG_I2C_PCA_PLATFORM" ; config_disable
config="CONFIG_I2C_RK3X" ; config_disable
config="CONFIG_I2C_SIMTEC" ; config_disable
config="CONFIG_I2C_SUN6I_P2WI" ; config_enable

#
# External I2C/SMBus adapter drivers
#
config="CONFIG_I2C_DLN2" ; config_module

#
# SPI Master Controller Drivers
#
config="CONFIG_SPI_BITBANG" ; config_module
config="CONFIG_SPI_DLN2" ; config_module
config="CONFIG_SPI_GPIO" ; config_module
config="CONFIG_SPI_OMAP24XX" ; config_enable
config="CONFIG_SPI_TI_QSPI" ; config_enable
config="CONFIG_SPI_ROCKCHIP" ; config_disable

#
# SPI Protocol Masters
#
config="CONFIG_SPI_SPIDEV" ; config_module

#
# PPS clients support
#
config="CONFIG_PPS_CLIENT_KTIMER" ; config_module
config="CONFIG_PPS_CLIENT_GPIO" ; config_module

#
# Pin controllers
#
config="CONFIG_PINCTRL_AXP209" ; config_enable
config="CONFIG_PINCTRL_MCP23S08" ; config_disable
config="CONFIG_PINCTRL_IMX6SLL" ; config_enable
config="CONFIG_GPIO_MAX730X" ; config_module

#
# Memory mapped GPIO drivers
#
config="CONFIG_GPIO_SYSCON" ; config_enable

#
# I2C GPIO expanders:
#
config="CONFIG_GPIO_ADP5588" ; config_module
config="CONFIG_GPIO_ADNP" ; config_module
config="CONFIG_GPIO_MAX7300" ; config_module
config="CONFIG_GPIO_MAX732X" ; config_module
config="CONFIG_GPIO_PCA953X" ; config_enable
config="CONFIG_GPIO_PCA953X_IRQ" ; config_enable
config="CONFIG_GPIO_TPIC2810" ; config_module

#
# MFD GPIO expanders
#
config="CONFIG_GPIO_DA9052" ; config_enable
config="CONFIG_GPIO_DA9055" ; config_enable
config="CONFIG_GPIO_DLN2" ; config_module
config="CONFIG_GPIO_TPS65218" ; config_enable
config="CONFIG_GPIO_TPS65910" ; config_enable

#
# SPI GPIO expanders:
#
config="CONFIG_GPIO_74X164" ; config_module
config="CONFIG_GPIO_MAX3191X" ; config_module
config="CONFIG_GPIO_MAX7301" ; config_module
config="CONFIG_GPIO_MC33880" ; config_module
config="CONFIG_GPIO_PISOSR" ; config_module
config="CONFIG_GPIO_XRA1403" ; config_module

#
# 1-wire Bus Masters
#
config="CONFIG_W1_MASTER_MXC" ; config_module
config="CONFIG_W1_MASTER_DS1WM" ; config_module

#
# 1-wire Slaves
#
config="CONFIG_W1_SLAVE_DS2405" ; config_module
config="CONFIG_W1_SLAVE_DS2408" ; config_module
config="CONFIG_W1_SLAVE_DS2408_READBACK" ; config_enable
config="CONFIG_W1_SLAVE_DS2413" ; config_module
config="CONFIG_W1_SLAVE_DS2406" ; config_module
config="CONFIG_W1_SLAVE_DS2423" ; config_module
config="CONFIG_W1_SLAVE_DS2805" ; config_module
config="CONFIG_W1_SLAVE_DS2433_CRC" ; config_enable
config="CONFIG_W1_SLAVE_DS2438" ; config_module
config="CONFIG_W1_SLAVE_DS2760" ; config_module
config="CONFIG_W1_SLAVE_DS2780" ; config_module
config="CONFIG_W1_SLAVE_DS2781" ; config_module
config="CONFIG_W1_SLAVE_DS28E04" ; config_module
config="CONFIG_POWER_RESET_IMX" ; config_enable
config="CONFIG_GENERIC_ADC_BATTERY" ; config_module
config="CONFIG_BATTERY_DA9052" ; config_module
config="CONFIG_AXP288_FUEL_GAUGE" ; config_module
config="CONFIG_CHARGER_GPIO" ; config_module
config="CONFIG_AXP20X_POWER" ; config_enable
config="CONFIG_CHARGER_TPS65217" ; config_enable

#exit

#
# Native drivers
#
config="CONFIG_SENSORS_AD7314" ; config_module
config="CONFIG_SENSORS_ADM1021" ; config_module
config="CONFIG_SENSORS_ADM1025" ; config_module
config="CONFIG_SENSORS_ADM1026" ; config_module
config="CONFIG_SENSORS_ADM1031" ; config_module
config="CONFIG_SENSORS_ADT7X10" ; config_module
config="CONFIG_SENSORS_ADT7310" ; config_module
config="CONFIG_SENSORS_ADT7410" ; config_module
config="CONFIG_SENSORS_DS1621" ; config_module
config="CONFIG_SENSORS_DA9052_ADC" ; config_module
config="CONFIG_SENSORS_DA9055" ; config_module
config="CONFIG_SENSORS_F71805F" ; config_module
config="CONFIG_SENSORS_FTSTEUTATES" ; config_module
config="CONFIG_SENSORS_GL518SM" ; config_module
config="CONFIG_SENSORS_GL520SM" ; config_module
config="CONFIG_SENSORS_GPIO_FAN" ; config_enable
config="CONFIG_SENSORS_HIH6130" ; config_module
config="CONFIG_SENSORS_IIO_HWMON" ; config_module
config="CONFIG_SENSORS_IT87" ; config_module
config="CONFIG_SENSORS_POWR1220" ; config_module
config="CONFIG_SENSORS_LTC2945" ; config_module
config="CONFIG_SENSORS_LTC2990" ; config_module
config="CONFIG_SENSORS_LTC4222" ; config_module
config="CONFIG_SENSORS_LTC4260" ; config_module
config="CONFIG_SENSORS_MAX1619" ; config_module
config="CONFIG_SENSORS_MAX197" ; config_module
config="CONFIG_SENSORS_MAX31722" ; config_module
config="CONFIG_SENSORS_MAX6621" ; config_module
config="CONFIG_SENSORS_MAX6697" ; config_module
config="CONFIG_SENSORS_MAX31790" ; config_module
config="CONFIG_SENSORS_MCP3021" ; config_module
config="CONFIG_SENSORS_TC654" ; config_module
config="CONFIG_SENSORS_LM63" ; config_module
config="CONFIG_SENSORS_LM75" ; config_module
config="CONFIG_SENSORS_LM77" ; config_module
config="CONFIG_SENSORS_LM78" ; config_module
config="CONFIG_SENSORS_LM80" ; config_module
config="CONFIG_SENSORS_LM83" ; config_module
config="CONFIG_SENSORS_LM85" ; config_module
config="CONFIG_SENSORS_LM87" ; config_module
config="CONFIG_SENSORS_LM90" ; config_module
config="CONFIG_SENSORS_LM92" ; config_module
config="CONFIG_SENSORS_LM95234" ; config_module
config="CONFIG_SENSORS_PC87360" ; config_module
config="CONFIG_SENSORS_NCT6683" ; config_module
config="CONFIG_SENSORS_NCT7802" ; config_module
config="CONFIG_SENSORS_NCT7904" ; config_module
config="CONFIG_SENSORS_PCF8591" ; config_module

config="CONFIG_PMBUS" ; config_module
config="CONFIG_SENSORS_PMBUS" ; config_module
config="CONFIG_SENSORS_ADM1275" ; config_module
config="CONFIG_SENSORS_LM25066" ; config_module
config="CONFIG_SENSORS_LTC2978" ; config_module
config="CONFIG_SENSORS_LTC2978_REGULATOR" ; config_enable
config="CONFIG_SENSORS_LTC3815" ; config_module
config="CONFIG_SENSORS_MAX16064" ; config_module
config="CONFIG_SENSORS_MAX20751" ; config_module
config="CONFIG_SENSORS_MAX31785" ; config_module
config="CONFIG_SENSORS_MAX34440" ; config_module
config="CONFIG_SENSORS_MAX8688" ; config_module
config="CONFIG_SENSORS_TPS40422" ; config_module
config="CONFIG_SENSORS_TPS53679" ; config_module
config="CONFIG_SENSORS_UCD9000" ; config_module
config="CONFIG_SENSORS_UCD9200" ; config_module
config="CONFIG_SENSORS_ZL6100" ; config_module
config="CONFIG_SENSORS_PWM_FAN" ; config_module
config="CONFIG_SENSORS_SHT15" ; config_module
config="CONFIG_SENSORS_SHTC1" ; config_module
config="CONFIG_SENSORS_SMSC47M1" ; config_module
config="CONFIG_SENSORS_SMSC47B397" ; config_module
config="CONFIG_SENSORS_SCH5636" ; config_module
config="CONFIG_SENSORS_ADC128D818" ; config_module
config="CONFIG_SENSORS_INA209" ; config_module
config="CONFIG_SENSORS_INA2XX" ; config_module
config="CONFIG_SENSORS_INA3221" ; config_module
config="CONFIG_SENSORS_TC74" ; config_module
config="CONFIG_SENSORS_TMP103" ; config_module
config="CONFIG_SENSORS_TMP108" ; config_module
config="CONFIG_SENSORS_W83773G" ; config_module
config="CONFIG_SENSORS_W83781D" ; config_module
config="CONFIG_SENSORS_W83L785TS" ; config_module
config="CONFIG_SENSORS_W83627HF" ; config_module
config="CONFIG_THERMAL_GOV_BANG_BANG" ; config_enable
config="CONFIG_CLOCK_THERMAL" ; config_enable
config="CONFIG_DEVFREQ_THERMAL" ; config_enable
config="CONFIG_IMX_THERMAL" ; config_enable

#
# Texas Instruments thermal drivers
#
config="CONFIG_TI_SOC_THERMAL" ; config_enable
config="CONFIG_OMAP3_THERMAL" ; config_enable
config="CONFIG_GENERIC_ADC_THERMAL" ; config_module
config="CONFIG_WATCHDOG_NOWAYOUT" ; config_enable

#
# Sonics Silicon Backplane
#
config="CONFIG_SSB" ; config_disable
config="CONFIG_BCMA" ; config_disable

#exit

#
# Multifunction device drivers
#
config="CONFIG_MFD_DA9055" ; config_enable
config="CONFIG_MFD_DA9063" ; config_enable
config="CONFIG_MFD_AC100" ; config_enable
config="CONFIG_MFD_AXP20X_RSB" ; config_enable
config="CONFIG_MFD_CROS_EC" ; config_disable
config="CONFIG_MFD_DLN2" ; config_enable
config="CONFIG_MFD_VIPERBOARD" ; config_disable

#
# STMicroelectronics STMPE Interface Drivers
#
config="CONFIG_MFD_TPS65217" ; config_enable
config="CONFIG_MFD_TPS65218" ; config_enable
config="CONFIG_MFD_TPS65910" ; config_enable
config="CONFIG_MFD_WL1273_CORE" ; config_module

config="CONFIG_REGULATOR_USERSPACE_CONSUMER" ; config_enable
config="CONFIG_REGULATOR_ACT8865" ; config_enable
config="CONFIG_REGULATOR_AD5398" ; config_enable
config="CONFIG_REGULATOR_ANATOP" ; config_enable
config="CONFIG_REGULATOR_AXP20X" ; config_enable
config="CONFIG_REGULATOR_DA9052" ; config_enable
config="CONFIG_REGULATOR_DA9055" ; config_disable
config="CONFIG_REGULATOR_DA9063" ; config_enable
config="CONFIG_REGULATOR_DA9210" ; config_enable
config="CONFIG_REGULATOR_DA9211" ; config_enable
config="CONFIG_REGULATOR_GPIO" ; config_enable
config="CONFIG_REGULATOR_MT6311" ; config_enable
config="CONFIG_REGULATOR_PBIAS" ; config_enable
config="CONFIG_REGULATOR_PFUZE100" ; config_enable
config="CONFIG_REGULATOR_PWM" ; config_enable
config="CONFIG_REGULATOR_S2MPA01" ; config_enable
config="CONFIG_REGULATOR_S2MPS11" ; config_enable
config="CONFIG_REGULATOR_S5M8767" ; config_enable
config="CONFIG_REGULATOR_TI_ABB" ; config_enable
config="CONFIG_REGULATOR_TPS51632" ; config_enable
config="CONFIG_REGULATOR_TPS62360" ; config_enable
config="CONFIG_REGULATOR_TPS65023" ; config_enable
config="CONFIG_REGULATOR_TPS6507X" ; config_enable
config="CONFIG_REGULATOR_TPS65217" ; config_enable
config="CONFIG_REGULATOR_TPS65218" ; config_enable
config="CONFIG_REGULATOR_TPS6524X" ; config_enable
config="CONFIG_REGULATOR_TPS65910" ; config_enable

config="CONFIG_CEC_CORE" ; config_enable
config="CONFIG_CEC_NOTIFIER" ; config_enable

#exit

#
# Software defined radio USB devices
#
config="CONFIG_SOC_CAMERA" ; config_module
config="CONFIG_SOC_CAMERA_PLATFORM" ; config_module
config="CONFIG_VIDEO_AM437X_VPFE" ; config_module
config="CONFIG_VIDEO_CODA" ; config_enable
config="CONFIG_VIDEO_MEM2MEM_DEINTERLACE" ; config_module
config="CONFIG_DVB_PLATFORM_DRIVERS" ; config_enable
config="CONFIG_DVB_C8SECTPFE" ; config_module
config="CONFIG_V4L_TEST_DRIVERS" ; config_disable

#
# soc_camera sensor drivers
#
config="CONFIG_SOC_CAMERA_IMX074" ; config_module
config="CONFIG_SOC_CAMERA_MT9M001" ; config_module
config="CONFIG_SOC_CAMERA_MT9M111" ; config_module
config="CONFIG_SOC_CAMERA_MT9T031" ; config_module
config="CONFIG_SOC_CAMERA_MT9T112" ; config_module
config="CONFIG_SOC_CAMERA_MT9V022" ; config_module
config="CONFIG_SOC_CAMERA_OV5642" ; config_module
config="CONFIG_SOC_CAMERA_OV772X" ; config_module
config="CONFIG_SOC_CAMERA_OV9640" ; config_module
config="CONFIG_SOC_CAMERA_OV9740" ; config_module
config="CONFIG_SOC_CAMERA_RJ54N1" ; config_module
config="CONFIG_SOC_CAMERA_TW9910" ; config_module

#
# Graphics support
#
config="CONFIG_IMX_IPUV3_CORE" ; config_enable
config="CONFIG_DRM" ; config_enable
config="CONFIG_DRM_KMS_HELPER" ; config_enable

#exit

#
# Sub-drivers
#

config="CONFIG_DRM_SUN4I" ; config_enable
config="CONFIG_DRM_SUN4I_HDMI" ; config_enable
config="CONFIG_DRM_SUN4I_BACKEND" ; config_enable
config="CONFIG_DRM_SUN8I_DW_HDMI" ; config_enable
config="CONFIG_DRM_SUN8I_MIXER" ; config_enable
config="CONFIG_DRM_OMAP" ; config_enable
config="CONFIG_OMAP2_DSS" ; config_enable

#
# OMAPDRM External Display Device Drivers
#
config="CONFIG_DRM_OMAP_ENCODER_OPA362" ; config_enable
config="CONFIG_DRM_OMAP_ENCODER_TFP410" ; config_enable
config="CONFIG_DRM_OMAP_ENCODER_TPD12S015" ; config_enable
config="CONFIG_DRM_OMAP_CONNECTOR_DVI" ; config_enable
config="CONFIG_DRM_OMAP_CONNECTOR_HDMI" ; config_enable
config="CONFIG_DRM_OMAP_PANEL_DPI" ; config_enable

config="CONFIG_DRM_TILCDC" ; config_enable

#
# Display Interface Bridges
#
config="CONFIG_DRM_DUMB_VGA_DAC" ; config_enable

config="CONFIG_DRM_SII902X" ; config_enable
config="CONFIG_DRM_TI_TFP410" ; config_enable
config="CONFIG_DRM_I2C_ADV7511" ; config_enable
config="CONFIG_DRM_I2C_ADV7511_AUDIO" ; config_enable

config="CONFIG_DRM_DW_HDMI" ; config_enable
config="CONFIG_DRM_DW_HDMI_AHB_AUDIO" ; config_module
config="CONFIG_DRM_DW_HDMI_I2S_AUDIO" ; config_module
config="CONFIG_DRM_DW_HDMI_CEC" ; config_module

config="CONFIG_DRM_IMX" ; config_enable
config="CONFIG_DRM_IMX_PARALLEL_DISPLAY" ; config_enable
config="CONFIG_DRM_IMX_TVE" ; config_enable
config="CONFIG_DRM_IMX_LDB" ; config_enable
config="CONFIG_DRM_IMX_HDMI" ; config_enable
config="CONFIG_DRM_ETNAVIV" ; config_enable

config="CONFIG_DRM_MXSFB" ; config_enable
config="CONFIG_DRM_TINYDRM" ; config_module
config="CONFIG_TINYDRM_MIPI_DBI" ; config_module
config="CONFIG_TINYDRM_ILI9225" ; config_module
config="CONFIG_TINYDRM_MI0283QT" ; config_module
config="CONFIG_TINYDRM_REPAPER" ; config_module
config="CONFIG_TINYDRM_ST7586" ; config_module
config="CONFIG_TINYDRM_ST7735R" ; config_module

config="CONFIG_DRM_LEGACY" ; config_disable

#exit

#
# Frame buffer hardware drivers
#
config="CONFIG_FB_MX3" ; config_disable
config="CONFIG_FB_SSD1307" ; config_enable
config="CONFIG_BACKLIGHT_PWM" ; config_enable
config="CONFIG_BACKLIGHT_GPIO" ; config_enable

#
# Console display driver support
#
config="CONFIG_LOGO" ; config_enable

#
# HD-Audio
#
config="CONFIG_SND_EDMA_SOC" ; config_module
config="CONFIG_SND_DAVINCI_SOC_I2S" ; config_module
config="CONFIG_SND_DAVINCI_SOC_GENERIC_EVM" ; config_module
config="CONFIG_SND_AM33XX_SOC_EVM" ; config_module

#
# SoC Audio support for Freescale i.MX boards:
#
config="CONFIG_SND_OMAP_SOC_HDMI_AUDIO" ; config_module

#
# HID support
#
config="CONFIG_HID" ; config_enable
config="CONFIG_UHID" ; config_enable
config="CONFIG_HID_GENERIC" ; config_enable

#
# Special HID drivers
#
config="CONFIG_HID_APPLEIR" ; config_module
config="CONFIG_HID_GFRM" ; config_module
config="CONFIG_HID_GT683R" ; config_module
config="CONFIG_HID_LOGITECH" ; config_enable
config="CONFIG_HID_LOGITECH_DJ" ; config_enable
config="CONFIG_HID_LOGITECH_HIDPP" ; config_enable
config="CONFIG_HID_MAYFLASH" ; config_module
config="CONFIG_HID_NTI" ; config_module
config="CONFIG_HID_RETRODE" ; config_module
config="CONFIG_HID_UDRAW_PS3" ; config_module

#
# USB HID support
#
config="CONFIG_USB_HID" ; config_enable

#
# I2C HID support
#
config="CONFIG_USB" ; config_enable

#
# Miscellaneous USB options
#
config="CONFIG_USB_OTG" ; config_enable

#
# USB Host Controller Drivers
#
config="CONFIG_USB_XHCI_HCD" ; config_enable
config="CONFIG_USB_XHCI_PLATFORM" ; config_enable
config="CONFIG_USB_EHCI_HCD" ; config_enable
config="CONFIG_USB_EHCI_HCD_OMAP" ; config_enable
config="CONFIG_USB_EHCI_HCD_PLATFORM" ; config_enable
config="CONFIG_USB_OHCI_HCD" ; config_disable

#
# also be needed; see USB_STORAGE Help for more info
#
config="CONFIG_USB_STORAGE" ; config_enable

#
# USB Imaging devices
#
config="CONFIG_USB_MUSB_HDRC" ; config_enable

#
# Platform Glue Layer
#
config="CONFIG_USB_MUSB_SUNXI" ; config_enable
config="CONFIG_USB_MUSB_TUSB6010" ; config_enable
config="CONFIG_USB_MUSB_OMAP2PLUS" ; config_enable
config="CONFIG_USB_MUSB_AM35X" ; config_enable
config="CONFIG_USB_MUSB_DSPS" ; config_enable
config="CONFIG_USB_MUSB_AM335X_CHILD" ; config_enable

#
# MUSB DMA mode
#
config="CONFIG_MUSB_PIO_ONLY" ; config_enable
config="CONFIG_USB_DWC3" ; config_enable

#
# Platform Glue Driver Support
#
config="CONFIG_USB_DWC3_OMAP" ; config_enable
config="CONFIG_USB_DWC3_OF_SIMPLE" ; config_enable

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
config="CONFIG_USB_CHIPIDEA" ; config_enable
config="CONFIG_USB_CHIPIDEA_OF" ; config_enable

#
# USB Physical Layer drivers
#
config="CONFIG_NOP_USB_XCEIV" ; config_enable
config="CONFIG_AM335X_CONTROL_USB" ; config_enable
config="CONFIG_AM335X_PHY_USB" ; config_enable
config="CONFIG_TWL6030_USB" ; config_enable
config="CONFIG_USB_GPIO_VBUS" ; config_enable
config="CONFIG_USB_MXS_PHY" ; config_enable
config="CONFIG_USB_GADGET" ; config_enable
config="CONFIG_USB_GADGET_VBUS_DRAW" ; option="500" ; config_value

#
# USB Peripheral Controller
#
config="CONFIG_USB_ZERO" ; config_module
config="CONFIG_USB_AUDIO" ; config_module
config="CONFIG_USB_G_NCM" ; config_module
config="CONFIG_USB_MASS_STORAGE" ; config_module
config="CONFIG_USB_MIDI_GADGET" ; config_module
config="CONFIG_USB_G_PRINTER" ; config_module
config="CONFIG_USB_CDC_COMPOSITE" ; config_module
config="CONFIG_USB_G_ACM_MS" ; config_module
config="CONFIG_USB_G_MULTI" ; config_module
config="CONFIG_USB_G_MULTI_RNDIS" ; config_enable
config="CONFIG_USB_G_HID" ; config_module
config="CONFIG_USB_G_DBGP" ; config_module
config="CONFIG_TYPEC" ; config_module
config="CONFIG_TYPEC_UCSI" ; config_module

#exit

#
# MMC/SD/SDIO Card Drivers
#
config="CONFIG_MMC_BLOCK_MINORS" ; option="8" ; config_value

#
# MMC/SD/SDIO Host Controller Drivers
#
config="CONFIG_MMC_SDHCI" ; config_enable
config="CONFIG_MMC_SDHCI_PLTFM" ; config_enable
config="CONFIG_MMC_SDHCI_OF_ARASAN" ; config_enable
config="CONFIG_MMC_SDHCI_OF_ESDHC" ; config_enable
config="CONFIG_MMC_SDHCI_ESDHC_IMX" ; config_enable
config="CONFIG_MMC_OMAP" ; config_disable
config="CONFIG_MMC_OMAP_HS" ; config_enable
config="CONFIG_MMC_SPI" ; config_enable
config="CONFIG_MMC_CQHCI" ; config_disable
config="CONFIG_MMC_DW" ; config_enable
config="CONFIG_MMC_DW_PLTFM" ; config_enable
config="CONFIG_MMC_SUNXI" ; config_enable
config="CONFIG_MMC_SDHCI_OMAP" ; config_enable

#
# LED drivers
#
config="CONFIG_LEDS_BCM6328" ; config_module
config="CONFIG_LEDS_BCM6358" ; config_module
config="CONFIG_LEDS_LM3530" ; config_module
config="CONFIG_LEDS_LM3642" ; config_module
config="CONFIG_LEDS_PCA9532" ; config_module
config="CONFIG_LEDS_PCA9532_GPIO" ; config_enable
config="CONFIG_LEDS_GPIO" ; config_enable
config="CONFIG_LEDS_LP5521" ; config_module
config="CONFIG_LEDS_LP5562" ; config_module
config="CONFIG_LEDS_LP8501" ; config_module
config="CONFIG_LEDS_LP8860" ; config_module
config="CONFIG_LEDS_PCA963X" ; config_module
config="CONFIG_LEDS_TCA6507" ; config_module
config="CONFIG_LEDS_TLC591XX" ; config_module
config="CONFIG_LEDS_LM355x" ; config_module_special
config="CONFIG_LEDS_IS31FL319X" ; config_module
config="CONFIG_LEDS_IS31FL32XX" ; config_module

#
# LED Triggers
#
config="CONFIG_LEDS_TRIGGER_TIMER" ; config_enable
config="CONFIG_LEDS_TRIGGER_ONESHOT" ; config_enable
config="CONFIG_LEDS_TRIGGER_DISK" ; config_enable
config="CONFIG_LEDS_TRIGGER_MTD" ; config_enable
config="CONFIG_LEDS_TRIGGER_HEARTBEAT" ; config_enable
config="CONFIG_LEDS_TRIGGER_BACKLIGHT" ; config_enable
config="CONFIG_LEDS_TRIGGER_GPIO" ; config_enable
config="CONFIG_LEDS_TRIGGER_DEFAULT_ON" ; config_enable

#
# iptables trigger is under Netfilter config (LED target)
#
config="CONFIG_LEDS_TRIGGER_NETDEV" ; config_module
config="CONFIG_INFINIBAND" ; config_disable

#
# I2C RTC drivers
#
config="CONFIG_RTC_DRV_ABB5ZES3" ; config_enable
config="CONFIG_RTC_DRV_ABX80X" ; config_enable
config="CONFIG_RTC_DRV_DS1374" ; config_enable
config="CONFIG_RTC_DRV_DS1374_WDT" ; config_enable
config="CONFIG_RTC_DRV_DS1672" ; config_enable
config="CONFIG_RTC_DRV_DS3232" ; config_enable
config="CONFIG_RTC_DRV_HYM8563" ; config_enable
config="CONFIG_RTC_DRV_MAX6900" ; config_enable
config="CONFIG_RTC_DRV_RS5C372" ; config_enable
config="CONFIG_RTC_DRV_ISL1208" ; config_enable
config="CONFIG_RTC_DRV_ISL12022" ; config_enable
config="CONFIG_RTC_DRV_ISL12026" ; config_enable
config="CONFIG_RTC_DRV_X1205" ; config_enable
config="CONFIG_RTC_DRV_PCF2127" ; config_enable
config="CONFIG_RTC_DRV_PCF85063" ; config_enable
config="CONFIG_RTC_DRV_PCF8583" ; config_enable
config="CONFIG_RTC_DRV_M41T80" ; config_enable
config="CONFIG_RTC_DRV_M41T80_WDT" ; config_enable
config="CONFIG_RTC_DRV_BQ32K" ; config_enable
config="CONFIG_RTC_DRV_TPS65910" ; config_enable
config="CONFIG_RTC_DRV_S35390A" ; config_enable
config="CONFIG_RTC_DRV_FM3130" ; config_module
config="CONFIG_RTC_DRV_RX8010" ; config_enable
config="CONFIG_RTC_DRV_RX8581" ; config_enable
config="CONFIG_RTC_DRV_RX8025" ; config_enable
config="CONFIG_RTC_DRV_EM3027" ; config_enable
config="CONFIG_RTC_DRV_RV3029C2" ; config_module
config="CONFIG_RTC_DRV_RV8803" ; config_enable

#
# SPI RTC drivers
#
config="CONFIG_RTC_DRV_M41T93" ; config_enable
config="CONFIG_RTC_DRV_M41T94" ; config_enable
config="CONFIG_RTC_DRV_DS1302" ; config_enable
config="CONFIG_RTC_DRV_DS1305" ; config_enable
config="CONFIG_RTC_DRV_DS1343" ; config_enable
config="CONFIG_RTC_DRV_DS1347" ; config_enable
config="CONFIG_RTC_DRV_DS1390" ; config_enable
config="CONFIG_RTC_DRV_MAX6916" ; config_enable
config="CONFIG_RTC_DRV_MAX6902" ; config_enable
config="CONFIG_RTC_DRV_R9701" ; config_enable
config="CONFIG_RTC_DRV_RX6110" ; config_enable
config="CONFIG_RTC_DRV_RS5C348" ; config_enable
config="CONFIG_RTC_DRV_PCF2123" ; config_enable
config="CONFIG_RTC_DRV_RX4581" ; config_enable
config="CONFIG_RTC_DRV_MCP795" ; config_enable

#
# Platform RTC drivers
#
config="CONFIG_RTC_DRV_CMOS" ; config_disable
config="CONFIG_RTC_DRV_DS1286" ; config_module
config="CONFIG_RTC_DRV_DS1511" ; config_module
config="CONFIG_RTC_DRV_DS1553" ; config_module
config="CONFIG_RTC_DRV_DS1685_FAMILY" ; config_module
config="CONFIG_RTC_DRV_DS1685" ; config_enable
config="CONFIG_RTC_DRV_DS1689" ; config_disable
config="CONFIG_RTC_DRV_DS17285" ; config_disable
config="CONFIG_RTC_DRV_DS17485" ; config_disable
config="CONFIG_RTC_DRV_DS17885" ; config_disable
config="CONFIG_RTC_DRV_DS1742" ; config_module
config="CONFIG_RTC_DRV_DA9055" ; config_module
config="CONFIG_RTC_DRV_DA9063" ; config_module
config="CONFIG_RTC_DRV_STK17TA8" ; config_module
config="CONFIG_RTC_DRV_M48T86" ; config_module
config="CONFIG_RTC_DRV_M48T35" ; config_module
config="CONFIG_RTC_DRV_M48T59" ; config_module
config="CONFIG_RTC_DRV_MSM6242" ; config_module
config="CONFIG_RTC_DRV_BQ4802" ; config_module
config="CONFIG_RTC_DRV_RP5C01" ; config_module
config="CONFIG_RTC_DRV_V3020" ; config_module
config="CONFIG_RTC_DRV_DS2404" ; config_module

#
# on-CPU RTC drivers
#
config="CONFIG_RTC_DRV_SUN6I" ; config_enable
config="CONFIG_RTC_DRV_R7301" ; config_enable
config="CONFIG_RTC_DRV_MXC_V2" ; config_enable

#
# HID Sensor RTC drivers
#
config="CONFIG_RTC_DRV_HID_SENSOR_TIME" ; config_module

#
# DMA Devices
#
config="CONFIG_DMA_SUN6I" ; config_enable
config="CONFIG_FSL_EDMA" ; config_enable
config="CONFIG_TI_CPPI41" ; config_enable
config="CONFIG_DW_DMAC_CORE" ; config_enable
config="CONFIG_DW_DMAC" ; config_enable

#exit

#
# DMABUF options
#
config="CONFIG_UIO_PDRV_GENIRQ" ; config_module
config="CONFIG_UIO_DMEM_GENIRQ" ; config_module
config="CONFIG_UIO_PRUSS" ; config_module

#STAGING
#
# Microsoft Hyper-V guest support
#
config="CONFIG_RTLLIB" ; config_module
config="CONFIG_RTLLIB_CRYPTO_CCMP" ; config_module
config="CONFIG_RTLLIB_CRYPTO_TKIP" ; config_module
config="CONFIG_RTLLIB_CRYPTO_WEP" ; config_module
config="CONFIG_RTL8723BS" ; config_module

#
# Accelerometers
#
config="CONFIG_ADIS16201" ; config_module
config="CONFIG_ADIS16203" ; config_module
config="CONFIG_ADIS16209" ; config_module
config="CONFIG_ADIS16240" ; config_module
config="CONFIG_SCA3000" ; config_module

#
# Analog to digital converters
#
config="CONFIG_AD7606" ; config_module
config="CONFIG_AD7606_IFACE_SPI" ; config_module
config="CONFIG_AD7780" ; config_module
config="CONFIG_AD7816" ; config_module
config="CONFIG_AD7192" ; config_module
config="CONFIG_AD7280" ; config_module

#
# Analog digital bi-direction converters
#
config="CONFIG_ADT7316" ; config_module
config="CONFIG_ADT7316_SPI" ; config_module
config="CONFIG_ADT7316_I2C" ; config_module

#
# Capacitance to digital converters
#
config="CONFIG_AD7150" ; config_module
config="CONFIG_AD7152" ; config_module
config="CONFIG_AD7746" ; config_module

#
# Direct Digital Synthesis
#
config="CONFIG_AD9832" ; config_module
config="CONFIG_AD9834" ; config_module

#
# Digital gyroscope sensors
#
config="CONFIG_ADIS16060" ; config_module

#
# Network Analyzer, Impedance Converters
#
config="CONFIG_AD5933" ; config_module

#
# Light sensors
#
config="CONFIG_SENSORS_ISL29018" ; config_module
config="CONFIG_SENSORS_ISL29028" ; config_module
config="CONFIG_TSL2583" ; config_module
config="CONFIG_TSL2x7x" ; config_module_special

#
# Magnetometer sensors
#
config="CONFIG_SENSORS_HMC5843" ; config_module
config="CONFIG_SENSORS_HMC5843_I2C" ; config_module
config="CONFIG_SENSORS_HMC5843_SPI" ; config_module

#
# Active energy metering IC
#
config="CONFIG_ADE7753" ; config_module
config="CONFIG_ADE7754" ; config_module
config="CONFIG_ADE7758" ; config_module
config="CONFIG_ADE7759" ; config_module
config="CONFIG_ADE7854" ; config_module
config="CONFIG_ADE7854_I2C" ; config_module
config="CONFIG_ADE7854_SPI" ; config_module

#
# Resolver to digital converters
#
config="CONFIG_AD2S90" ; config_module
config="CONFIG_AD2S1200" ; config_module
config="CONFIG_AD2S1210" ; config_module

#exit

#
# Android
#
config="CONFIG_FB_TFT" ; config_module
config="CONFIG_FB_TFT_AGM1264K_FL" ; config_module
config="CONFIG_FB_TFT_BD663474" ; config_module
config="CONFIG_FB_TFT_HX8340BN" ; config_module
config="CONFIG_FB_TFT_HX8347D" ; config_module
config="CONFIG_FB_TFT_HX8353D" ; config_module
config="CONFIG_FB_TFT_HX8357D" ; config_module
config="CONFIG_FB_TFT_ILI9163" ; config_module
config="CONFIG_FB_TFT_ILI9320" ; config_module
config="CONFIG_FB_TFT_ILI9325" ; config_module
config="CONFIG_FB_TFT_ILI9340" ; config_module
config="CONFIG_FB_TFT_ILI9341" ; config_module
config="CONFIG_FB_TFT_ILI9481" ; config_module
config="CONFIG_FB_TFT_ILI9486" ; config_module
config="CONFIG_FB_TFT_PCD8544" ; config_module
config="CONFIG_FB_TFT_RA8875" ; config_module
config="CONFIG_FB_TFT_S6D02A1" ; config_module
config="CONFIG_FB_TFT_S6D1121" ; config_module
config="CONFIG_FB_TFT_SH1106" ; config_module
config="CONFIG_FB_TFT_SSD1289" ; config_module
config="CONFIG_FB_TFT_SSD1305" ; config_module
config="CONFIG_FB_TFT_SSD1306" ; config_module
config="CONFIG_FB_TFT_SSD1325" ; config_module
config="CONFIG_FB_TFT_SSD1331" ; config_module
config="CONFIG_FB_TFT_SSD1351" ; config_module
config="CONFIG_FB_TFT_ST7735R" ; config_module
config="CONFIG_FB_TFT_ST7789V" ; config_module
config="CONFIG_FB_TFT_TINYLCD" ; config_module
config="CONFIG_FB_TFT_TLS8204" ; config_module
config="CONFIG_FB_TFT_UC1611" ; config_module
config="CONFIG_FB_TFT_UC1701" ; config_module
config="CONFIG_FB_TFT_UPD161704" ; config_module
config="CONFIG_FB_TFT_WATTEROTT" ; config_module
config="CONFIG_FB_FLEX" ; config_module
config="CONFIG_FB_TFT_FBTFT_DEVICE" ; config_module

config="CONFIG_WILC1000_SDIO" ; config_module
config="CONFIG_WILC1000_SPI" ; config_module

#
# USB Power Delivery and Type-C drivers
#
config="CONFIG_CHROME_PLATFORMS" ; config_disable

#exit

#
# Common Clock Framework
#
config="CONFIG_CLK_TWL6040" ; config_enable
config="CONFIG_COMMON_CLK_PALMAS" ; config_enable
config="CONFIG_SUN8I_DE2_CCU" ; config_enable
config="CONFIG_HWSPINLOCK" ; config_enable

#
# Hardware Spinlock drivers
#
config="CONFIG_HWSPINLOCK_OMAP" ; config_enable

#
# Generic IOMMU Pagetable Support
#
config="CONFIG_ARM_SMMU" ; config_enable

#
# Remoteproc drivers
#
config="CONFIG_REMOTEPROC" ; config_enable
config="CONFIG_IMX_REMOTEPROC" ; config_module
config="CONFIG_OMAP_REMOTEPROC" ; config_module
config="CONFIG_WKUP_M3_RPROC" ; config_enable

#
# SOC (System On Chip) specific Drivers
#
config="CONFIG_SOC_TI" ; config_enable
config="CONFIG_AMX3_PM" ; config_enable
config="CONFIG_WKUP_M3_IPC" ; config_enable

#
# DEVFREQ Governors
#
config="CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND" ; config_enable
config="CONFIG_DEVFREQ_GOV_PERFORMANCE" ; config_enable
config="CONFIG_DEVFREQ_GOV_POWERSAVE" ; config_enable
config="CONFIG_DEVFREQ_GOV_USERSPACE" ; config_enable
config="CONFIG_DEVFREQ_GOV_PASSIVE" ; config_enable

#
# Extcon Device Drivers
#
config="CONFIG_EXTCON_AXP288" ; config_enable
config="CONFIG_EXTCON_GPIO" ; config_enable
config="CONFIG_EXTCON_PALMAS" ; config_enable
config="CONFIG_EXTCON_USB_GPIO" ; config_enable
config="CONFIG_TI_EMIF" ; config_enable
config="CONFIG_TI_EMIF_SRAM" ; config_enable

config="CONFIG_IIO" ; config_enable

config="CONFIG_IIO_BUFFER_CB" ; config_module
config="CONFIG_IIO_CONFIGFS" ; config_module
config="CONFIG_IIO_SW_DEVICE" ; config_module
config="CONFIG_IIO_SW_TRIGGER" ; config_module

#exit

#
# Accelerometers
#
config="CONFIG_BMA180" ; config_module
config="CONFIG_BMA220" ; config_module
config="CONFIG_BMC150_ACCEL" ; config_module
config="CONFIG_DA280" ; config_module
config="CONFIG_DA311" ; config_module
config="CONFIG_DMARD06" ; config_module
config="CONFIG_DMARD09" ; config_module
config="CONFIG_DMARD10" ; config_module
config="CONFIG_IIO_ST_ACCEL_3AXIS" ; config_module
config="CONFIG_IIO_ST_ACCEL_I2C_3AXIS" ; config_module
config="CONFIG_IIO_ST_ACCEL_SPI_3AXIS" ; config_module
config="CONFIG_KXSD9" ; config_module
config="CONFIG_MMA8452" ; config_module
config="CONFIG_KXCJK1013" ; config_module
config="CONFIG_MC3230" ; config_module
config="CONFIG_MMA7455_I2C" ; config_module
config="CONFIG_MMA7455_SPI" ; config_module
config="CONFIG_MMA7660" ; config_module
config="CONFIG_MMA9551" ; config_module
config="CONFIG_MMA9553" ; config_module
config="CONFIG_MXC4005" ; config_module
config="CONFIG_MXC6255" ; config_module
config="CONFIG_STK8312" ; config_module
config="CONFIG_STK8BA50" ; config_module

#
# Analog to digital converters
#
config="CONFIG_AD7266" ; config_module
config="CONFIG_AD7291" ; config_module
config="CONFIG_AD7298" ; config_module
config="CONFIG_AD7476" ; config_module
config="CONFIG_AD7766" ; config_module
config="CONFIG_AD7791" ; config_module
config="CONFIG_AD7793" ; config_module
config="CONFIG_AD7887" ; config_module
config="CONFIG_AD7923" ; config_module
config="CONFIG_AD799X" ; config_module
config="CONFIG_AXP20X_ADC" ; config_module
config="CONFIG_AXP288_ADC" ; config_module
config="CONFIG_CC10001_ADC" ; config_module
config="CONFIG_DLN2_ADC" ; config_module
config="CONFIG_ENVELOPE_DETECTOR" ; config_module
config="CONFIG_HI8435" ; config_module
config="CONFIG_HX711" ; config_module
config="CONFIG_INA2XX_ADC" ; config_module
config="CONFIG_IMX7D_ADC" ; config_module
config="CONFIG_LTC2471" ; config_module
config="CONFIG_LTC2485" ; config_module
config="CONFIG_LTC2497" ; config_module
config="CONFIG_MAX1027" ; config_module
config="CONFIG_MAX11100" ; config_module
config="CONFIG_MAX1118" ; config_module
config="CONFIG_MAX1363" ; config_module
config="CONFIG_MAX9611" ; config_module
config="CONFIG_MCP320X" ; config_module
config="CONFIG_MCP3422" ; config_module
config="CONFIG_NAU7802" ; config_module
config="CONFIG_PALMAS_GPADC" ; config_module
config="CONFIG_SUN4I_GPADC" ; config_module
config="CONFIG_TI_ADC081C" ; config_module
config="CONFIG_TI_ADC0832" ; config_module
config="CONFIG_TI_ADC084S021" ; config_module
config="CONFIG_TI_ADC12138" ; config_module
config="CONFIG_TI_ADC108S102" ; config_module
config="CONFIG_TI_ADC128S052" ; config_module
config="CONFIG_TI_ADC161S626" ; config_module
config="CONFIG_TI_ADS1015" ; config_module
config="CONFIG_TI_ADS7950" ; config_module
config="CONFIG_TI_ADS8688" ; config_module
config="CONFIG_TI_TLC4541" ; config_module
config="CONFIG_TWL6030_GPADC" ; config_module
config="CONFIG_VF610_ADC" ; config_module

#
# Amplifiers
#
config="CONFIG_AD8366" ; config_module

#
# Chemical Sensors
#
config="CONFIG_ATLAS_PH_SENSOR" ; config_module
config="CONFIG_CCS811" ; config_module
config="CONFIG_IAQCORE" ; config_module
config="CONFIG_VZ89X" ; config_module

#
# SSP Sensor Common
#
config="CONFIG_IIO_SSP_SENSORHUB" ; config_module

#
# Digital to analog converters
#
config="CONFIG_AD5064" ; config_module
config="CONFIG_AD5360" ; config_module
config="CONFIG_AD5380" ; config_module
config="CONFIG_AD5421" ; config_module
config="CONFIG_AD5446" ; config_module
config="CONFIG_AD5449" ; config_module
config="CONFIG_AD5592R" ; config_module
config="CONFIG_AD5593R" ; config_module
config="CONFIG_AD5504" ; config_module
config="CONFIG_AD5624R_SPI" ; config_module
config="CONFIG_LTC2632" ; config_module
config="CONFIG_AD5686" ; config_module
config="CONFIG_AD5755" ; config_module
config="CONFIG_AD5761" ; config_module
config="CONFIG_AD5764" ; config_module
config="CONFIG_AD5791" ; config_module
config="CONFIG_AD7303" ; config_module
config="CONFIG_AD8801" ; config_module
config="CONFIG_DPOT_DAC" ; config_module
config="CONFIG_DS4424" ; config_module
config="CONFIG_M62332" ; config_module
config="CONFIG_MAX517" ; config_module
config="CONFIG_MAX5821" ; config_module
config="CONFIG_MCP4725" ; config_module
config="CONFIG_MCP4922" ; config_module
config="CONFIG_TI_DAC082S085" ; config_module
config="CONFIG_VF610_DAC" ; config_module

#
# Clock Generator/Distribution
#
config="CONFIG_AD9523" ; config_module

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
config="CONFIG_ADF4350" ; config_module

#
# Digital gyroscope sensors
#
config="CONFIG_ADIS16080" ; config_module
config="CONFIG_ADIS16130" ; config_module
config="CONFIG_ADIS16136" ; config_module
config="CONFIG_ADIS16260" ; config_module
config="CONFIG_ADXRS450" ; config_module
config="CONFIG_BMG160" ; config_module
config="CONFIG_MPU3050_I2C" ; config_module
config="CONFIG_IIO_ST_GYRO_3AXIS" ; config_module
config="CONFIG_IIO_ST_GYRO_I2C_3AXIS" ; config_module
config="CONFIG_IIO_ST_GYRO_SPI_3AXIS" ; config_module
config="CONFIG_ITG3200" ; config_module

#
# Health sensors
#

#
# Heart Rate Monitors
#
config="CONFIG_AFE4403" ; config_module
config="CONFIG_AFE4404" ; config_module
config="CONFIG_MAX30100" ; config_module
config="CONFIG_MAX30102" ; config_module

#
# Humidity sensors
#
config="CONFIG_AM2315" ; config_module
config="CONFIG_DHT11" ; config_module
config="CONFIG_HDC100X" ; config_module
config="CONFIG_HTS221" ; config_module
config="CONFIG_HTU21" ; config_module
config="CONFIG_SI7005" ; config_module
config="CONFIG_SI7020" ; config_module

#
# Inertial measurement units
#
config="CONFIG_ADIS16400" ; config_module
config="CONFIG_ADIS16480" ; config_module
config="CONFIG_BMI160_I2C" ; config_module
config="CONFIG_BMI160_SPI" ; config_module
config="CONFIG_KMX61" ; config_module
config="CONFIG_INV_MPU6050_I2C" ; config_module
config="CONFIG_INV_MPU6050_SPI" ; config_module
config="CONFIG_INV_MPU6050_IIO" ; config_module
config="CONFIG_IIO_ST_LSM6DSX" ; config_module

#
# Light sensors
#
config="CONFIG_ADJD_S311" ; config_module
config="CONFIG_AL3320A" ; config_module
config="CONFIG_APDS9300" ; config_module
config="CONFIG_APDS9960" ; config_module
config="CONFIG_BH1750" ; config_module
config="CONFIG_BH1780" ; config_module
config="CONFIG_CM32181" ; config_module
config="CONFIG_CM3232" ; config_module
config="CONFIG_CM3323" ; config_module
config="CONFIG_CM3605" ; config_module
config="CONFIG_CM36651" ; config_module
config="CONFIG_GP2AP020A00F" ; config_module
config="CONFIG_ISL29125" ; config_module
config="CONFIG_JSA1212" ; config_module
config="CONFIG_RPR0521" ; config_module
config="CONFIG_LTR501" ; config_module
config="CONFIG_LV0104CS" ; config_module
config="CONFIG_MAX44000" ; config_module
config="CONFIG_OPT3001" ; config_module
config="CONFIG_PA12203001" ; config_module
config="CONFIG_SI1145" ; config_module
config="CONFIG_STK3310" ; config_module
config="CONFIG_ST_UVIS25" ; config_module
config="CONFIG_ST_UVIS25_I2C" ; config_module
config="CONFIG_ST_UVIS25_SPI" ; config_module
config="CONFIG_TCS3414" ; config_module
config="CONFIG_TCS3472" ; config_module
config="CONFIG_TSL4531" ; config_module
config="CONFIG_US5182D" ; config_module
config="CONFIG_VCNL4000" ; config_module
config="CONFIG_VEML6070" ; config_module
config="CONFIG_VL6180" ; config_module
config="CONFIG_ZOPT2201" ; config_module

#
# Magnetometer sensors
#
config="CONFIG_AK8974" ; config_module
config="CONFIG_AK8975" ; config_module
config="CONFIG_AK09911" ; config_module
config="CONFIG_BMC150_MAGN_I2C" ; config_module
config="CONFIG_BMC150_MAGN_SPI" ; config_module
config="CONFIG_MAG3110" ; config_module
config="CONFIG_MMC35240" ; config_module
config="CONFIG_IIO_ST_MAGN_3AXIS" ; config_module
config="CONFIG_IIO_ST_MAGN_I2C_3AXIS" ; config_module
config="CONFIG_IIO_ST_MAGN_SPI_3AXIS" ; config_module
config="CONFIG_BMC150_MAGN" ; config_module

#
# Triggers - standalone
#
config="CONFIG_IIO_INTERRUPT_TRIGGER" ; config_module
config="CONFIG_IIO_SYSFS_TRIGGER" ; config_module

#
# Digital potentiometers
#
config="CONFIG_AD5272" ; config_module
config="CONFIG_DS1803" ; config_module
config="CONFIG_MAX5481" ; config_module
config="CONFIG_MAX5487" ; config_module
config="CONFIG_MCP4018" ; config_module
config="CONFIG_MCP4131" ; config_module
config="CONFIG_MCP4531" ; config_module
config="CONFIG_TPL0102" ; config_module

#
# Digital potentiostats
#
config="CONFIG_LMP91000" ; config_module

#
# Pressure sensors
#
config="CONFIG_ABP060MG" ; config_module
config="CONFIG_BMP280" ; config_module
config="CONFIG_HP03" ; config_module
config="CONFIG_MPL115_I2C" ; config_module
config="CONFIG_MPL115_SPI" ; config_module
config="CONFIG_MPL115" ; config_module
config="CONFIG_MPL3115" ; config_module
config="CONFIG_MS5611" ; config_module
config="CONFIG_MS5611_I2C" ; config_module
config="CONFIG_MS5611_SPI" ; config_module
config="CONFIG_MS5637" ; config_module
config="CONFIG_IIO_ST_PRESS" ; config_module
config="CONFIG_IIO_ST_PRESS_I2C" ; config_module
config="CONFIG_IIO_ST_PRESS_SPI" ; config_module
config="CONFIG_T5403" ; config_module
config="CONFIG_HP206C" ; config_module
config="CONFIG_ZPA2326" ; config_module

#
# Lightning sensors
#
config="CONFIG_AS3935" ; config_module

#
# Proximity sensors
#
config="CONFIG_LIDAR_LITE_V2" ; config_module
config="CONFIG_RFD77402" ; config_module
config="CONFIG_SRF04" ; config_module
config="CONFIG_SX9500" ; config_module
config="CONFIG_SRF08" ; config_module

#
# Temperature sensors
#
config="CONFIG_MAXIM_THERMOCOUPLE" ; config_module
config="CONFIG_MLX90614" ; config_module
config="CONFIG_MLX90632" ; config_module
config="CONFIG_TMP006" ; config_module
config="CONFIG_TMP007" ; config_module
config="CONFIG_TSYS01" ; config_module
config="CONFIG_TSYS02D" ; config_module
config="CONFIG_PWM_OMAP_DMTIMER" ; config_module
config="CONFIG_PWM_PCA9685" ; config_module
config="CONFIG_RESET_TI_SYSCON" ; config_enable

#
# PHY Subsystem
#
config="CONFIG_OMAP_CONTROL_PHY" ; config_enable
config="CONFIG_OMAP_USB2" ; config_enable
config="CONFIG_TI_PIPE3" ; config_module
config="CONFIG_TWL4030_USB" ; config_enable
config="CONFIG_PHY_SUN4I_USB" ; config_enable
config="CONFIG_PHY_SUN9I_USB" ; config_enable

#exit

#
# Android
#
config="CONFIG_NVMEM_IMX_IIM" ; config_enable
config="CONFIG_NVMEM_IMX_OCOTP" ; config_enable
config="CONFIG_NVMEM_SUNXI_SID" ; config_enable
config="CONFIG_NVMEM_VF610_OCOTP" ; config_enable
config="CONFIG_NVMEM_SNVS_LPGPR" ; config_enable

#
# File systems
#
config="CONFIG_EXT4_FS" ; config_enable
config="CONFIG_JBD2" ; config_enable
config="CONFIG_FS_MBCACHE" ; config_enable
config="CONFIG_XFS_FS" ; config_enable
config="CONFIG_BTRFS_FS" ; config_enable
config="CONFIG_F2FS_FS" ; config_enable
config="CONFIG_FS_ENCRYPTION" ; config_enable
config="CONFIG_AUTOFS4_FS" ; config_enable
config="CONFIG_FUSE_FS" ; config_enable
config="CONFIG_OVERLAY_FS" ; config_enable

#
# DOS/FAT/NT Filesystems
#
config="CONFIG_FAT_FS" ; config_enable
config="CONFIG_MSDOS_FS" ; config_enable
config="CONFIG_VFAT_FS" ; config_enable

#
# Pseudo filesystems
#
config="CONFIG_CONFIGFS_FS" ; config_enable
config="CONFIG_ORANGEFS_FS" ; config_enable
config="CONFIG_UBIFS_FS" ; config_enable
config="CONFIG_SQUASHFS_LZ4" ; config_enable
config="CONFIG_NFS_FS" ; config_enable
config="CONFIG_NFS_V2" ; config_enable
config="CONFIG_NFS_V3" ; config_enable
config="CONFIG_NFS_V4" ; config_enable
config="CONFIG_ROOT_NFS" ; config_enable

#
# Compile-time checks and compiler options
#
config="CONFIG_DEBUG_INFO" ; config_disable

#
# Debug Lockups and Hangs
#
config="CONFIG_SOFTLOCKUP_DETECTOR" ; config_disable

#
# Runtime Testing
#
config="CONFIG_RUNTIME_TESTING_MENU" ; config_disable
config="CONFIG_KGDB" ; config_enable
config="CONFIG_KGDB_SERIAL_CONSOLE" ; config_enable
config="CONFIG_KGDB_TESTS" ; config_disable
config="CONFIG_KGDB_KDB" ; config_enable
config="CONFIG_KDB_KEYBOARD" ; config_enable

config="CONFIG_STRICT_DEVMEM" ; config_disable

#
# Security options
#
config="CONFIG_SECURITY_DMESG_RESTRICT" ; config_disable
config="CONFIG_HARDENED_USERCOPY" ; config_disable
config="CONFIG_FORTIFY_SOURCE" ; config_enable

#
# Crypto core or helper
#
config="CONFIG_CRYPTO_MANAGER_DISABLE_TESTS" ; config_enable

#
# Random Number Generation
#
config="CONFIG_CRYPTO_DEV_FSL_CAAM" ; config_enable
config="CONFIG_CRYPTO_DEV_OMAP" ; config_enable
config="CONFIG_CRYPTO_DEV_OMAP_SHAM" ; config_enable
config="CONFIG_CRYPTO_DEV_OMAP_AES" ; config_enable
config="CONFIG_CRYPTO_DEV_OMAP_DES" ; config_enable
config="CONFIG_CRYPTO_DEV_SAHARA" ; config_enable
config="CONFIG_CRYPTO_DEV_SUN4I_SS" ; config_enable

#
# Certificates for signature checking
#
config="CONFIG_SYSTEM_TRUSTED_KEYS" ; option="" ; config_value
config="CONFIG_ARM_CRYPTO" ; config_enable
config="CONFIG_CRYPTO_SHA1_ARM" ; config_module
config="CONFIG_CRYPTO_SHA1_ARM_NEON" ; config_module
config="CONFIG_CRYPTO_SHA256_ARM" ; config_module
config="CONFIG_CRYPTO_SHA512_ARM" ; config_module
config="CONFIG_CRYPTO_AES_ARM" ; config_module
config="CONFIG_CRYPTO_AES_ARM_BS" ; config_module

cd ${DIR}/

#