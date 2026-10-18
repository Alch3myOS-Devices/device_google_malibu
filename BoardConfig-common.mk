#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Shared board configuration for the malibu family. Device trees set
# MALIBU_KERNEL_DIR, TARGET_BOOTLOADER_BOARD_NAME and TARGET_SCREEN_DENSITY,
# then include this file.

MALIBU_PATH := device/google/malibu

# Feeds ro.board.platform; unset, zygote aborts in preload and the malibu
# recovery rc never imports.
TARGET_BOARD_PLATFORM := malibu

# From the stock build the firmware comes from (CD1A.261005.003). Deliberately
# ahead of the platform patch, and never below the firmware's level: it feeds
# the AVB rollback index below.
BOOT_SECURITY_PATCH := 2026-10-05
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# No 32-bit userspace on any family member.
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv9-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a55

# Identical across the family; super is a fixed 10 GiB regardless of storage.
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_DTBOIMG_PARTITION_SIZE := 16777216

# A/B with Virtual A/B + compression, and dynamic partitions in super.
AB_OTA_UPDATER := true
BOARD_USES_METADATA_PARTITION := true
BOARD_SUPER_PARTITION_GROUPS := google_dynamic_partitions
BOARD_GOOGLE_DYNAMIC_PARTITIONS_SIZE := 10733223936
BOARD_GOOGLE_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_dlkm system_ext product vendor vendor_dlkm
BOARD_SUPER_PARTITION_SIZE := 10737418240
BOARD_SUPER_PARTITION_METADATA_DEVICE := super

BOARD_USES_RECOVERY_AS_BOOT :=

# Every partition is EROFS as on stock. Alch3myOS builds GMS in, so nothing
# installs into system, system_ext or product afterwards; stock's fstab mounts
# EROFS first and keeps the ext4 entries as a fallback.
TARGET_USERIMAGES_USE_F2FS := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs

include vendor/alch3my/config/BoardConfigReservedSize.mk

# Alch3myOS vendor/gms installs apps into /system, which generic_system.mk's
# artifact-path check rejects for device builds, and copies a few sysconfig
# files the stock blob list carries too (same as caimito).
BUILD_BROKEN_DUP_RULES := true
DISABLE_ARTIFACT_PATH_REQUIREMENTS := true

TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm

# Kernel: prebuilt. The Image is the family's one GKI build; each kernels repo
# carries it beside that device's vendor_dlkm and dtbo.
BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_PREBUILT_KERNEL := $(MALIBU_KERNEL_DIR)/Image.lz4
TARGET_NO_BOOTLOADER := true

BOARD_BOOT_HEADER_VERSION := 4
BOARD_INIT_BOOT_HEADER_VERSION := 4
# init_boot takes BOARD_MKBOOTIMG_INIT_ARGS, not BOARD_MKBOOTIMG_ARGS; without
# this line it gets a v0 header and the bootloader rejects the image.
BOARD_MKBOOTIMG_INIT_ARGS += --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# Stock zeroes os_version in the boot header; a populated value claims a patch
# level below what the device last ran and disagrees with the AVB footer.
BOARD_MKBOOTIMG_ARGS += --os_version none --os_patch_level none

# Byte-identical across the family. boot_devices is what first-stage init
# resolves /dev/block/by-name through.
BOARD_KERNEL_CMDLINE := spmi_smartdv.load_sequential=1 regmap-goog-spmi.load_sequential=1
BOARD_KERNEL_CMDLINE += max77779_pic.load_sequential=1 max77779_pmic_spmi.load_sequential=1
BOARD_KERNEL_CMDLINE += max77779_pmic_pinctrl.load_sequential=1
BOARD_KERNEL_CMDLINE += samsung_dma_heap.gcma_skip_heaps=gcma_camera_internal
BOARD_KERNEL_CMDLINE += dyndbg=\"func alloc_contig_dump_pages +p\"
BOARD_KERNEL_CMDLINE += cma_sysfs.experimental=Y init_on_alloc=0 init_on_free=1
BOARD_KERNEL_CMDLINE += rcupdate.rcu_expedited=1 rcu_nocbs=all rcutree.enable_rcu_lazy
BOARD_KERNEL_CMDLINE += swiotlb=noforce disable_dma32=on rodata=on
BOARD_KERNEL_CMDLINE += sysctl.kernel.sched_pelt_multiplier=4 arm64.nomops
BOARD_KERNEL_CMDLINE += aoc_core.aoc_panic_on_ssr_failure=1 aoc_core.aoc_enable_gsa_boot=1
BOARD_KERNEL_CMDLINE += ufs.async_probe=1 vs_drm.async_probe=1 gs_governor_dsulat.async_probe=1
BOARD_KERNEL_CMDLINE += kasan=off at24.write_timeout=100 log_buf_len=1024K
BOARD_KERNEL_CMDLINE += android_arch_task_struct_size=784 bootconfig

BOARD_BOOTCONFIG := androidboot.load_modules_parallel=performance
BOARD_BOOTCONFIG += androidboot.boot_devices=3c2d0000.ufs

# Recovery rides in vendor_boot; its ramdisk is first-stage userspace with zero
# .ko, since the modules live in vendor_kernel_boot.
BOARD_BUILD_VENDOR_RAMDISK_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864

# Recovery cannot use the hardware-wrapped key path, so the recovery fstab drops
# inlinecrypt for plain aes-256-xts.
TARGET_RECOVERY_FSTAB := $(MALIBU_PATH)/recovery/recovery.fstab

# minui draws RGBA8888 under ABGR and these panels come back with red and blue
# swapped.
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# AVB. boot, init_boot, vbmeta_system and vbmeta_vendor are chained at rollback
# index locations 2, 4, 1 and 3; everything else carries a hash or hashtree
# descriptor in the main vbmeta. Needs openssl 3.5+ on the host for ML-DSA.
BOARD_AVB_ENABLE := true

# The bootloader does not trust our key and reports hastree-error-mode restart,
# so with verification on it restarts rather than boots.
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_ALGORITHM := MLDSA65
BOARD_AVB_KEY_PATH := external/avb/test/data/testkey_mldsa65.pem

# The patch date as a Unix epoch, reproducing stock's value. Do not lower it.
BOARD_AVB_ROLLBACK_INDEX := $(shell date -u -d "$(BOOT_SECURITY_PATCH)" +%s)

BOARD_AVB_BOOT_KEY_PATH := $(BOARD_AVB_KEY_PATH)
BOARD_AVB_BOOT_ALGORITHM := $(BOARD_AVB_ALGORITHM)
BOARD_AVB_BOOT_ROLLBACK_INDEX := $(BOARD_AVB_ROLLBACK_INDEX)
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_INIT_BOOT_KEY_PATH := $(BOARD_AVB_KEY_PATH)
BOARD_AVB_INIT_BOOT_ALGORITHM := $(BOARD_AVB_ALGORITHM)
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX := $(BOARD_AVB_ROLLBACK_INDEX)
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX_LOCATION := 4

BOARD_AVB_VBMETA_SYSTEM := system system_ext product system_dlkm
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := $(BOARD_AVB_KEY_PATH)
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := $(BOARD_AVB_ALGORITHM)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(BOARD_AVB_ROLLBACK_INDEX)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := $(BOARD_AVB_KEY_PATH)
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := $(BOARD_AVB_ALGORITHM)
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := $(BOARD_AVB_ROLLBACK_INDEX)
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 3

# Stock uses sha256 on every hashtree; avbtool defaults to sha1.
BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_PRODUCT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

# Pixel-sepolicy dirs picked by matching what their file_contexts label against
# our blob list. The shared rules and the per-device generated policy are separate
# trees: contexts cannot be merged, so each device carries its own generated set.
# The device dir comes first because the policy concatenates in this order and
# checkpolicy resolves sequentially: the shared files' typeattribute lines need
# the device's type declarations ahead of them.
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy/vendor \
    $(MALIBU_PATH)/sepolicy/vendor \
    hardware/google/pixel-sepolicy/citadel \
    hardware/google/pixel-sepolicy/power-libperfmgr \
    hardware/google/pixel-sepolicy/powerstats \
    hardware/google/pixel-sepolicy/sscoredump \
    hardware/google/pixel-sepolicy/lineage_health \
    hardware/google/pixel-sepolicy/powershare \
    hardware/google/pixel-sepolicy/touch \
    hardware/google/pixel-sepolicy/wifi_ext

# Platform-side rules stock carries in its own system_ext and platform policy;
# vendor policy cannot name the platform's private types.
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private $(MALIBU_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(MALIBU_PATH)/sepolicy/public

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += hardware/google/pixel-sepolicy/common/system_ext

# Reverse wireless charging
SOONG_CONFIG_NAMESPACES += lineage_powershare
SOONG_CONFIG_lineage_powershare += powershare_path
SOONG_CONFIG_lineage_powershare_powershare_path := /sys/class/power_supply/wireless/device/rtx

# Both toggle modes must be off: their node probes loop with no exit condition
# and system_server blocks on IChargingControl until the watchdog kills it. The
# bools must go through soong_config_set_bool; a plain assignment declares a
# string, and the macro spells false as the empty value.
ifeq ($(filter undefined,$(origin soong_config_set_bool)),undefined)
  $(error soong_config_set_bool is not defined at BoardConfig time)
endif
$(call soong_config_set_bool,lineage_health,charging_control_supports_toggle,false)
$(call soong_config_set_bool,lineage_health,charging_control_supports_bypass,false)
$(call soong_config_set_bool,lineage_health,charging_control_supports_deadline,true)
$(call soong_config_set_bool,lineage_health,charging_control_supports_limit,true)

# dtbo: stock's, we build no device tree of our own.
BOARD_PREBUILT_DTBOIMAGE := $(MALIBU_KERNEL_DIR)/dtbo.img

# vendor_dlkm is stock's (built from private/, no public tree has it);
# system_dlkm is from our own kernel build so the GKI modules match. The load
# list and blocklist are stock's own, byte-identical across the family.
KERNEL_MODULE_DIR := $(MALIBU_KERNEL_DIR)

BOARD_VENDOR_KERNEL_MODULES := \
    $(wildcard $(KERNEL_MODULE_DIR)/vendor_dlkm/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD := \
    $(addprefix $(KERNEL_MODULE_DIR)/vendor_dlkm/,\
        $(shell cat $(KERNEL_MODULE_DIR)/vendor_dlkm.modules.load 2>/dev/null))

BOARD_SYSTEM_KERNEL_MODULES := \
    $(wildcard $(KERNEL_MODULE_DIR)/system_dlkm/*.ko)

BOARD_SYSTEM_KERNEL_MODULES_LOAD := \
    $(addprefix $(KERNEL_MODULE_DIR)/system_dlkm/,\
        $(shell cat $(MALIBU_PATH)/system_dlkm.modules.load))
BOARD_SYSTEM_KERNEL_MODULES_BLOCKLIST_FILE := $(MALIBU_PATH)/system_dlkm.modules.blocklist

include $(MALIBU_PATH)/wifi/BoardConfig-wifi.mk
