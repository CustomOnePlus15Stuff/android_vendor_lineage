# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

# Exclude repos from bp scanning
PRODUCT_SOURCE_ROOT_DIRS += -kernel/platform
PRODUCT_SOURCE_ROOT_DIRS += -prebuilts/misc/protobuf_vendorcompat

# Allow vendor prebuilt repos to exclude themselves from bp scanning
-include $(sort $(wildcard vendor/*/*/exclude-bp.mk))

PRODUCT_BRAND ?= LineageOS

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(PRODUCT_IS_ATV),true)
ifeq ($(PRODUCT_ATV_CLIENTID_BASE),)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.oem.key1=ATV00100020
else
PRODUCT_PRODUCT_PROPERTIES += \
    ro.oem.key1=$(PRODUCT_ATV_CLIENTID_BASE)
endif
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=0
else
ifdef WITH_ADB_INSECURE
# Forcebly disable ADB authentication
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=1

# Set ro.debuggable=0 for userdebug
PRODUCT_NOT_DEBUGGABLE_IN_USERDEBUG := true
endif

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_PRODUCT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/lineage/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions

PRODUCT_PACKAGES += \
    50-lineage.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-lineage.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/lineage/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/lineage/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Lineage-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/lineage/config/permissions/lineage-sysconfig.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/lineage-sysconfig.xml

# Lineage-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.lineage-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-system_ext.rc

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Credential storage
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Component overrides
PRODUCT_PACKAGES += \
    lineage-component-overrides.xml

# This is Lineage!
PRODUCT_COPY_FILES += \
    vendor/lineage/config/permissions/org.lineageos.android.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.android.xml

# Enforce privapp-permissions whitelist
PRODUCT_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

ifneq ($(TARGET_DISABLE_LINEAGE_SDK), true)
# Lineage SDK
include vendor/lineage/config/lineage_sdk_common.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false


##############################
##        PROPERTIES        ##
##############################


# Disable ADB authentication
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=0

# Forcebly disable ADB authentication
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=0

# Enable ADB authentication
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=1

# Set ro.debuggable=0 for userdebug
PRODUCT_NOT_DEBUGGABLE_IN_USERDEBUG := true

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_PRODUCT_PROPERTIES += persist.sys.strictmode.disable=true


# Additional props
PRODUCT_PRODUCT_PROPERTIES += \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.com.google.ime.theme_id=5 \
    ro.opa.eligible_device=true \
    ro.com.android.wifi-watchlist=GoogleGuest \
    drm.service.enabled=true \
    persist.sys.dun.override=0 \
    persist.sys.disable_rescue=true

# GAPPS
ifeq ($(TARGET_BUILD_PACKAGE),3)
    # Default notification/alarm sounds
    PRODUCT_PRODUCT_PROPERTIES += \
        ro.config.notification_sound=Popcorn.ogg \
        ro.config.alarm_alert=Bright_morning.ogg

    # Default ringtone
    PRODUCT_PRODUCT_PROPERTIES += \
        ro.config.ringtone=The_big_adventure.ogg

    # Gboard Props
    PRODUCT_PRODUCT_PROPERTIES += \
        ro.com.google.ime.bs_theme=true \
        ro.com.google.ime.system_lm_dir=/product/usr/share/ime/google/d3_lms

    # Conditionally include pixel launcher and theme picker squad
    ifeq ($(TARGET_INCLUDE_PIXEL_LAUNCHER),true)
        PRODUCT_PRODUCT_PROPERTIES += \
            persist.sys.nexuslauncher=1

        $(call inherit-product, vendor/pixel/launcher/products/launcher.mk)
        $(call inherit-product, vendor/pixel/themepicker/products/themepicker.mk)
        $(call inherit-product, vendor/pixel/sounds/products/sounds.mk)
    else
        PRODUCT_PRODUCT_PROPERTIES += \
            persist.sys.nexuslauncher=0
    endif

    # SetupWizard Props
    PRODUCT_PRODUCT_PROPERTIES += \
        ro.setupwizard.enterprise_mode=1 \
        ro.setupwizard.esim_cid_ignore=00000001 \
        setupwizard.feature.baseline_setupwizard_enabled=true \
        setupwizard.feature.day_night_mode_enabled=true \
        setupwizard.feature.default_locale_enhancement_enabled=true \
        setupwizard.feature.device_info_icon_enabled=true \
        setupwizard.feature.enable_gil= \
        setupwizard.feature.enable_gil_logging=true \
        setupwizard.feature.enable_minors_setup_flow=true \
        setupwizard.feature.enable_parental_notice_activity=true \
        setupwizard.feature.enable_parental_setup=true \
        setupwizard.feature.enhanced_setup_design_metrics=true \
        setupwizard.feature.is_suw_onboarding_contract_enabled=true \
        setupwizard.feature.joined_up_loading=true \
        setupwizard.feature.locale_agnostic_enabled=true \
        setupwizard.feature.enable_quick_start_flow=true \
        setupwizard.feature.enable_restore_anytime=true \
        setupwizard.feature.enable_wifi_tracker=true \
        setupwizard.feature.lifecycle_refactoring=true \
        setupwizard.feature.notification_refactoring=true \
        setupwizard.feature.portal_notification=true \
        setupwizard.feature.provisioning_profile_mode=true \
        setupwizard.theme=glif_expressive

    $(call inherit-product, vendor/pixel/gms/products/gms.mk)
else
    ifeq ($(TARGET_BUILD_PACKAGE),2)
        $(call inherit-product, vendor/microg/product.mk)
    endif

    PRODUCT_PRODUCT_PROPERTIES += \
        persist.sys.nexuslauncher=0

    PRODUCT_PRODUCT_PROPERTIES += \
        ro.config.notification_sound=Argon.ogg \
        ro.config.alarm_alert=Hassium.ogg \
        ro.config.ringtone=Orion.ogg

    PRODUCT_PRODUCT_PROPERTIES += \
        ro.setupwizard.enterprise_mode=1 \
        ro.setupwizard.network_required=false \
        ro.setupwizard.gservices_delay=-1 \
        ro.setupwizard.mode=OPTIONAL \
        setupwizard.feature.predeferred_enabled=false \
        setupwizard.feature.day_night_mode_enabled=true \
        setupwizard.theme=glif_expressive
endif

# Blur
ifneq ($(TARGET_SUPPORTS_BLUR),false)
    PRODUCT_PRODUCT_PROPERTIES += \
        ro.surface_flinger.supports_background_blur=1
endif

# Media
PRODUCT_PRODUCT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# Disable async MTE on a few processes
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.app.com.android.se=off \
    persist.arm64.memtag.app.com.google.android.bluetooth=off \
    persist.arm64.memtag.app.com.android.nfc=off \
    persist.arm64.memtag.process.system_server=off

# Enable dex2oat64 to do dexopt
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

PRODUCT_PRODUCT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

ifeq ($(TARGET_BUILD_VARIANT),userdebug)
    PRODUCT_PRODUCT_PROPERTIES += \
        debug.sf.enable_transaction_tracing=false
endif

# Log privapp-permissions whitelist
PRODUCT_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions=log


#################################
##        INIT SCRIPTS         ##
#################################

# Backup Tool
ifneq ($(TARGET_EXCLUDE_BACKUPTOOL),true)
    PRODUCT_PACKAGES += \
        50-alpha.sh

    PRODUCT_COPY_FILES += \
        vendor/alpha/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
        vendor/alpha/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions

    PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
        system/addon.d/50-alpha.sh

    ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
        PRODUCT_COPY_FILES += \
            vendor/alpha/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
            vendor/alpha/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
            vendor/alpha/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

        PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
            system/bin/backuptool_ab.sh \
            system/bin/backuptool_ab.functions \
            system/bin/backuptool_postinstall.sh

        PRODUCT_PRODUCT_PROPERTIES += \
            ro.ota.allow_downgrade=true
    endif
endif

# Init
PRODUCT_COPY_FILES += \
    vendor/alpha/prebuilt/common/etc/init/init.alpha-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.alpha-system_ext.rc \
    vendor/alpha/prebuilt/common/etc/init/init.alpha-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.alpha-updater.rc \
    vendor/alpha/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc \

# FRP
PRODUCT_COPY_FILES += \
    vendor/alpha/prebuilt/common/bin/wipe-frp.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/wipe-frp


#############################
##        CONFIGS          ##
#############################

# Cloned app exemption
PRODUCT_COPY_FILES += \
    vendor/alpha/prebuilt/common/etc/sysconfig/preinstalled-packages-platform-alpha-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-platform-alpha-product.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Credential storage
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Component overrides
PRODUCT_PACKAGES += \
    alpha-component-overrides.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl


####################################
##        LINEAGE FEATURES        ##
####################################

# Broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/alpha/config/permissions/lineage-sysconfig.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/lineage-sysconfig.xml

# Enforce privapp-permissions whitelist
PRODUCT_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

ifneq ($(TARGET_DISABLE_LINEAGE_SDK), true)
# Lineage SDK
include vendor/lineage/config/lineage_sdk_common.mk
endif

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

ifneq ($(TARGET_DISABLE_EPPE),true)
# Require all requested packages to exist
$(call enforce-product-packages-exist-internal,$(lastword $(_include_stack)),product_manifest.xml rild Calendar android.hidl.memory@1.0-impl.vendor vndk_apex_snapshot_package)
endif

# Charger
PRODUCT_PACKAGES += \
    bootanimation.zip \

# Lineage interfaces
PRODUCT_PACKAGES += \
    framework_compatibility_matrix.lineage.xml


PRODUCT_PACKAGES += \
    LineageParts \

PRODUCT_PACKAGES += \
    LineageSettingsProvider \

PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.lineage-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-updater.rc

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig \
    SimpleSettingsConfig

# Extra tools in Lineage
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_PACKAGES += \
    nano_recovery

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap \
    system/%/libzstd.so

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# FRP
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/bin/wipe-frp.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/wipe-frp

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# OverlayFS
PRODUCT_PACKAGES_DEBUG += \
    disable-overlays

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_PRODUCT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/xbin/su
endif
endif

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/xbin/su
endif
endif

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    CarSystemUI \
    Settings \
    SystemUI

PRODUCT_PRODUCT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

# Audio files
$(call inherit-product, vendor/lineage/audio/audio.mk)

# SetupWizard
ifneq ($(WITH_GMS), true)
PRODUCT_PRODUCT_PROPERTIES += \
    setupwizard.feature.day_night_mode_enabled=true
endif

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/lineage/overlay/no-rro
PRODUCT_PACKAGE_OVERLAYS += \
    vendor/lineage/overlay/common \
    vendor/lineage/overlay/no-rro

PRODUCT_PACKAGES += \
    NetworkStackOverlay \
    PermissionControllerOverlay

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/crowdin/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/crowdin/overlay

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/lineage/build/target/product/security/lineage

include vendor/lineage/config/version.mk

-include vendor/lineage-priv/keys/keys.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/lineage/config/partner_gms.mk
