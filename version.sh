#!/bin/sh
#
ARCH=$(uname -m)

config="imx_v8_defconfig"

build_prefix="-imx8-x"
branch_prefix="v"
branch_postfix=".x"

#https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation/process/changes.rst?h=v4.19-rc1
#arm
#KERNEL_ARCH=arm
#DEBARCH=armhf
#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_eabi_5"
#toolchain="gcc_linaro_eabi_6"
#toolchain="gcc_linaro_eabi_7"
#toolchain="gcc_arm_eabi_8"
#toolchain="gcc_arm_eabi_9"
#toolchain="gcc_arm_eabi_10"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
#toolchain="gcc_linaro_gnueabihf_4_9"
#toolchain="gcc_linaro_gnueabihf_5"
#toolchain="gcc_linaro_gnueabihf_6"
#toolchain="gcc_linaro_gnueabihf_7"
#toolchain="gcc_arm_gnueabihf_8"
#toolchain="gcc_arm_gnueabihf_9"
#toolchain="gcc_arm_gnueabihf_10"
#arm64
KERNEL_ARCH=arm64
DEBARCH=arm64
#toolchain="gcc_linaro_aarch64_gnu_5"
#toolchain="gcc_linaro_aarch64_gnu_6"
#toolchain="gcc_linaro_aarch64_gnu_7"
toolchain="gcc_arm_aarch64_gnu_8"
#toolchain="gcc_arm_aarch64_gnu_9"
#toolchain="gcc_arm_aarch64_gnu_10"
#riscv64
#KERNEL_ARCH=riscv
#DEBARCH=riscv64
#toolchain="gcc_10_riscv64"

#Kernel
KERNEL_REL=5.4
KERNEL_TAG=${KERNEL_REL}.70
kernel_rt=".X-rtY"
#Kernel Build
BUILD=${build_prefix}1

#v5.X-rcX + upto SHA
#prev_KERNEL_SHA=""
#KERNEL_SHA=""

#git branch
BRANCH="${branch_prefix}${KERNEL_REL}${branch_postfix}"

DISTRO=xross
#
