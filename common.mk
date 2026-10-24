#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Shared product configuration for the malibu family; the including product
# makefile must set DEVICE_PATH, VENDOR_PATH and DEVICE_CODENAME.

MALIBU_PATH := device/google/malibu

# Two logical slots by default, so the eSIM is mapped on a clean install.
PRODUCT_SYSTEM_PROPERTIES += \
    persist.radio.multisim.config=dsds

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    init_boot \
    product \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot \
    vendor_dlkm

# The touch service lives in a soong namespace, hence the declaration.
PRODUCT_SOONG_NAMESPACES += \
    hardware/google/pixel

PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default \
    vendor.lineage.powershare-service.default \
    vendor.lineage.touch-service.pixel

PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

# Recovery rides in the stock vendor_boot, so nothing assigns recovery_fstab and the
# OTA package would not be built.
PRODUCT_BUILD_GENERIC_OTA_PACKAGE := true

# Installed under the plain name, matched to stock by the version each file declares.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2026-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-latest.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

# Hardware capability declarations, stock's own set minus what handheld_core_hardware
# already covers. The family differences (UWB off cubs, the hinge on the fold) are
# declared by the device trees.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.channel_sounding.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.channel_sounding.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.context_hub.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.context_hub.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.telephony.carrierlock.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.carrierlock.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.biometrics.face.xml

# NFC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml

PRODUCT_PACKAGES += \
    com.android.nfc_extras

# IMS; without ImsStack nothing implements ImsService and voice calls never register.
PRODUCT_PACKAGES += \
    ImsStack \
    Iwlan

# The Bluetooth audio provider (A2DP, LE Audio, HFP and hearing aids). The stock audio HAL
# loads it and registers IBluetoothAudioProviderFactory; the blob list skips stock's copy and
# its VINTF fragment, which come with this module, along with the LE Audio and HFP configs.
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl

# wpa_supplicant.conf is the template the supplicant copies to /data; without it
# addStaInterface fails and wifi never turns on.
PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf

# The default KeyMint is what FBE key derivation goes through; the sensors multihal
# is the only sensors provider.
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service.rust.trusty \
    android.hardware.gatekeeper-service.trusty \
    android.hardware.security.secretkeeper.trusty \
    android.hardware.sensors-service.multihal \
    android.hardware.drm-service.clearkey

# The system_ext declaration names this jar, so it has to be installed too.
PRODUCT_PACKAGES += \
    com.android.extensions.computercontrol

# Decides which LPA serves where GMS is absent.
PRODUCT_PACKAGES += \
    EuiccPolicy

# EuiccGoogle is presigned, so it cannot pick up a signature|privileged permission
# by signature; with privapp enforcement the first missing entry throws on boot.
PRODUCT_COPY_FILES += \
    $(MALIBU_PATH)/permissions/privapp-permissions-google-euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-google-euicc.xml \
    $(MALIBU_PATH)/permissions/privapp-permissions-google-carrier.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-google-carrier.xml

# WfcActivation; its allowlist shares the carrier file with CarrierSettings.
PRODUCT_COPY_FILES += \
    $(MALIBU_PATH)/permissions/hidden-api-whitelist-com.google.android.wfcactivation.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/hidden-api-whitelist-com.google.android.wfcactivation.xml \
    $(MALIBU_PATH)/permissions/default-permissions-com.google.android.wfcactivation.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions-com.google.android.wfcactivation.xml

# stargate and SCONE; stock keeps these in GMS-wide lists this build does not carry.
PRODUCT_COPY_FILES += \
    $(MALIBU_PATH)/permissions/sysconfig-google-satellite.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/sysconfig-google-satellite.xml \
    $(MALIBU_PATH)/permissions/privapp-permissions-google-scone.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-google-scone.xml \
    $(MALIBU_PATH)/permissions/hidden-api-whitelist-com.google.android.apps.scone.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/hidden-api-whitelist-com.google.android.apps.scone.xml

PRODUCT_PACKAGES += \
    android.hardware.secure_element-service.thales

# eSIM
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.mep.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.mep.xml

# The camera HAL's apex namespace sees only what this grants; the blob list drops
# stock's copy, and public.libraries.txt does not cover an apex namespace.
PRODUCT_VENDOR_LINKER_CONFIG_FRAGMENTS += $(MALIBU_PATH)/linker.config.json

# Vendor AIDs
TARGET_FS_CONFIG_GEN += $(MALIBU_PATH)/config.fs

# Four stock fragments are merged here rather than installed separately, because the
# module names are taken by HALs the tree builds itself and VINTF metadata cannot
# go through PRODUCT_COPY_FILES.
DEVICE_MANIFEST_FILE += \
    $(MALIBU_PATH)/vintf/manifest.xml \
    $(VENDOR_PATH)/proprietary/vendor/etc/vintf/manifest/android.hardware.thermal-service.pixel.xml \
    $(VENDOR_PATH)/proprietary/vendor/etc/vintf/manifest/gnss-default.xml \
    $(VENDOR_PATH)/proprietary/vendor/etc/vintf/manifest/nfc2-service-default.xml \
    $(VENDOR_PATH)/proprietary/vendor/etc/vintf/manifest/pixel-display-default.xml

# The manifest declares vendor HALs no AOSP framework matrix knows about.
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    $(MALIBU_PATH)/vintf/radio_framework_matrix_system_ext.xml \
    $(MALIBU_PATH)/vintf/aocx_framework_matrix_system_ext.xml \
    $(MALIBU_PATH)/vintf/camera_interference_avoidance_framework_matrix_system_ext.xml \
    $(MALIBU_PATH)/vintf/imageprocessing_hal_framework_matrix_system_ext.xml

DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += \
    $(MALIBU_PATH)/vintf/device_framework_matrix_product.xml

# CONFIG_SYSVIPC and IP6_NF_NAT deviate from the FCM 202504 requirements, so the
# OTA kernel check cannot pass; it gates GMS compliance, not function.
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# generic_ramdisk and compression_with_xor supply what a soc-common tree would.
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4
PRODUCT_VIRTUAL_AB_COW_VERSION := 3

# Recovery; the device rc installs under the codename init imports it by.
PRODUCT_COPY_FILES += \
    $(MALIBU_PATH)/recovery/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.$(DEVICE_CODENAME).rc \
    $(MALIBU_PATH)/recovery/init.recovery.malibu.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.malibu.rc

# Recovery runs with /vendor unmounted, so the USB PHY firmware has to be in the
# ramdisk or there is no adb and no sideload.
PRODUCT_COPY_FILES += \
    $(VENDOR_PATH)/proprietary/vendor/firmware/usb_phy_fw.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/usb_phy_fw.bin \
    $(VENDOR_PATH)/proprietary/vendor/firmware/usb_phy_fw_2.27.0.bin:$(TARGET_COPY_OUT_RECOVERY)/root/lib/firmware/usb_phy_fw_2.27.0.bin

PRODUCT_PACKAGES += \
    android.hardware.boot-service.default_recovery-pixel \
    android.hardware.health-service.malibu_recovery \
    android.hardware.fastboot@1.1-impl.pixel

# Stock's fstab with ext4 entries added for system_ext and product.
PRODUCT_COPY_FILES += \
    $(MALIBU_PATH)/fstab.malibu:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.malibu \
    $(MALIBU_PATH)/fstab.malibu:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/system/etc/fstab.malibu

# vndservicemanager: with no context manager on /dev/vndbinder, citadeld and the
# citadel strongbox keymint never register and keystore2 will not continue.
PRODUCT_PACKAGES += \
    vndservicemanager \
    rebalance_interrupts-vendor

# The off-mode charger's battery images, which the stock health service reads from
# /vendor/etc/res/images/charger. The blob list skips stock's copies.
PRODUCT_PACKAGES += \
    charger_res_images_vendor

# Built from source; blob copies collide with the tree's modules.
PRODUCT_PACKAGES += \
    android.hidl.allocator@1.0-service \
    userdata_alias_remove

# Google app props, set only when a GApps package is installed; see the header
# in that file.
PRODUCT_COPY_FILES += \
    $(MALIBU_PATH)/google-props.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/google-props.rc
