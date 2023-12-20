#
# Copyright (C) 2021 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_KERNEL_DIR ?= device/google/comet-kernel
TARGET_BOARD_KERNEL_HEADERS := device/google/comet-kernel/kernel-headers
TARGET_RECOVERY_DEFAULT_ROTATION := ROTATION_RIGHT

ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    USE_UWBFIELDTESTQM := true
endif
ifeq ($(filter factory_comet, $(TARGET_PRODUCT)),)
    include device/google/comet/uwb/uwb_calibration.mk
endif

$(call inherit-product-if-exists, vendor/google_devices/comet/prebuilts/device-vendor-comet.mk)
$(call inherit-product-if-exists, vendor/google_devices/zumapro/prebuilts/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/zumapro/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/comet/proprietary/comet/device-vendor-comet.mk)
$(call inherit-product-if-exists, vendor/qorvo/uwb/qm35-hal/Device.mk)

DEVICE_PACKAGE_OVERLAYS += device/google/comet/comet/overlay

include device/google/zumapro/device-shipping-common.mk
include device/google/comet/audio/comet/audio-tables.mk
include hardware/google/pixel/vibrator/cs40l26/device.mk
include device/google/gs-common/bcmbt/bluetooth.mk
include device/google/gs-common/touch/gti/gti.mk
include device/google/gs-common/display/dump_second_display.mk
-include vendor/samsung_slsi/gps/s5400/location/gnssd/device-gnss.mk

# go/lyric-soong-variables
$(call soong_config_set,lyric,camera_hardware,comet)
$(call soong_config_set,lyric,tuning_product,comet)
$(call soong_config_set,google3a_config,target_device,comet)

# Init files
PRODUCT_COPY_FILES += \
	device/google/comet/conf/init.comet.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.comet.rc

# Recovery files
PRODUCT_COPY_FILES += \
        device/google/comet/conf/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.comet.rc

# Display brightness curve
PRODUCT_COPY_FILES += \
	device/google/comet/comet/panel_config_google-ct3a_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/panel_config_google-ct3a_cal0.pb \
	device/google/comet/comet/panel_config_google-ct3c_cal1.pb:$(TARGET_COPY_OUT_VENDOR)/etc/panel_config_google-ct3c_cal1.pb \
	device/google/comet/comet/panel_config_google-ct3d_cal1.pb:$(TARGET_COPY_OUT_VENDOR)/etc/panel_config_google-ct3d_cal1.pb

PRODUCT_PROPERTY_OVERRIDES += \
	vendor.camera.debug.enable_software_post_sharpen_node=false

# Display Config
PRODUCT_COPY_FILES += \
        device/google/comet/display/display_colordata_cal1.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_colordata_cal1.pb

# Coex Config
PRODUCT_SOONG_NAMESPACES += device/google/comet/radio/coex
PRODUCT_PACKAGES += \
		display_secondary_mipi_coex_table \
		camera_front_inner_mipi_coex_table \
		camera_front_outer_mipi_coex_table \
		camera_rear_tele_mipi_coex_table \
		camera_rear_wide_mipi_coex_table

# NFC
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
	frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
	frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
	frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
	frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
	device/google/comet/nfc/libnfc-hal-st.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st.conf \
	device/google/comet/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_PRODUCT)/etc/libnfc-nci.conf

PRODUCT_PACKAGES += \
	$(RELEASE_PACKAGE_NFC_STACK) \
	Tag \
	android.hardware.nfc-service.st \
	NfcOverlayComet

# SecureElement
PRODUCT_PACKAGES += \
	android.hardware.secure_element-service.thales

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
	frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
	device/google/comet/nfc/libse-gto-hal.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libse-gto-hal.conf

# Thermal Config
ifeq (,$(TARGET_VENDOR_THERMAL_CONFIG_PATH))
TARGET_VENDOR_THERMAL_CONFIG_PATH := device/google/comet/thermal
endif

PRODUCT_COPY_FILES += \
	$(TARGET_VENDOR_THERMAL_CONFIG_PATH)/thermal_info_config_charge_comet.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config_charge.json \
	$(TARGET_VENDOR_THERMAL_CONFIG_PATH)/thermal_info_config_comet.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json \
	$(TARGET_VENDOR_THERMAL_CONFIG_PATH)/thermal_info_config_backup_comet.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config_backup.json \

PRODUCT_PACKAGES += \
	init_thermal_config

# Power HAL config
PRODUCT_COPY_FILES += \
	device/google/comet/powerhint-comet.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Bluetooth HAL
PRODUCT_COPY_FILES += \
	device/google/comet/bluetooth/bt_vendor_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor_overlay.conf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.a2dp_offload.supported=true \
    persist.bluetooth.a2dp_offload.disabled=false \
    persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac

# Bluetooth Tx power caps
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bluetooth/bluetooth_power_limits_comet.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits.csv \
    $(LOCAL_PATH)/bluetooth/bluetooth_power_limits_comet_US.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_US.csv

# DCK properties based on target
PRODUCT_PROPERTY_OVERRIDES += \
    ro.gms.dck.eligible_wcc=3 \
    ro.gms.dck.se_capability=1

# Bluetooth hci_inject test tool
PRODUCT_PACKAGES_DEBUG += \
    hci_inject

# Bluetooth SAR test tool
PRODUCT_PACKAGES_DEBUG += \
    sar_test

# Bluetooth EWP test tool
PRODUCT_PACKAGES_DEBUG += \
    ewp_tool

# Bluetooth AAC VBR
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.a2dp_aac.vbr_supported=true

# Spatial Audio
PRODUCT_PACKAGES += \
	libspatialaudio \
	librondo

# Audio CCA property
PRODUCT_PROPERTY_OVERRIDES += \
	persist.vendor.audio.cca.enabled=false

# Keymaster HAL
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# Gatekeeper HAL
#LOCAL_GATEKEEPER_PRODUCT_PACKAGE ?= android.hardware.gatekeeper@1.0-service.software


# Gatekeeper
# PRODUCT_PACKAGES += \
# 	android.hardware.gatekeeper@1.0-service.software

# Keymint replaces Keymaster
# PRODUCT_PACKAGES += \
# 	android.hardware.security.keymint-service

# Keymaster
#PRODUCT_PACKAGES += \
#	android.hardware.keymaster@4.0-impl \
#	android.hardware.keymaster@4.0-service

#PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.remote
#PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.remote
#LOCAL_KEYMASTER_PRODUCT_PACKAGE := android.hardware.keymaster@4.1-service
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# PRODUCT_PROPERTY_OVERRIDES += \
# 	ro.hardware.keystore_desede=true \
# 	ro.hardware.keystore=software \
# 	ro.hardware.gatekeeper=software

# PowerStats HAL
PRODUCT_SOONG_NAMESPACES += \
    device/google/comet/powerstats/comet

# WiFi Overlay
PRODUCT_PACKAGES += \
	WifiOverlay2024Mid_CT3 \
	PixelWifiOverlay2024

# Trusty liboemcrypto.so
PRODUCT_SOONG_NAMESPACES += vendor/google_devices/comet/prebuilts

# UWB
PRODUCT_SOONG_NAMESPACES += \
    device/google/comet/uwb

# Location
# SDK build system
$(call soong_config_set, include_libsitril-gps-wifi, board_without_radio, $(BOARD_WITHOUT_RADIO))
include device/google/gs-common/gps/brcm/device.mk

PRODUCT_SOONG_NAMESPACES += device/google/comet/location
SOONG_CONFIG_NAMESPACES += gpssdk
SOONG_CONFIG_gpssdk += gpsconf
SOONG_CONFIG_gpssdk_gpsconf ?= $(TARGET_BUILD_VARIANT)
PRODUCT_PACKAGES += \
	gps.cer \
	gps.xml \
	scd.conf \
	lhd.conf

# Display LBE
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.lbe.supported=1

# Install product specific framework compatibility matrix
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/google/comet/device_framework_matrix_product.xml


# Set zram size
PRODUCT_VENDOR_PROPERTIES += \
	vendor.zram.size=3g \
	persist.device_config.configuration.disable_rescue_party=true

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.udfps.als_feed_forward_supported=true \
    persist.vendor.udfps.lhbm_controlled_in_hal_supported=true

# Camera
# Disable camera DPM
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.camera.debug.force_dpm_on=0

# OIS with system imu
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.ois_with_system_imu=true

# Haptics
# Placeholders for updates later, need to update:
# edit device.mass
# edit loc.coeff
# remove dbc.enable
# remove pm.activetimeout
ACTUATOR_MODEL := luxshare_ict_081545
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.vibrator.hal.chirp.enabled=1 \
    ro.vendor.vibrator.hal.device.mass=0.222 \
    ro.vendor.vibrator.hal.loc.coeff=2.8 \
    ro.vendor.vibrator.hal.dbc.enable=1 \
    ro.vendor.vibrator.hal.pm.activetimeout=5

# Hinge angle sensor
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.sensor.hinge_angle.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hinge_angle.xml

# Keyboard height ratio and bottom padding in dp for portrait mode
PRODUCT_PRODUCT_PROPERTIES += \
          ro.com.google.ime.kb_pad_port_b=11.2 \
          ro.com.google.ime.height_ratio=1.18
