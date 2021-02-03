LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := i2cdetect
LOCAL_SRC_FILES := ./bins/$(LOCAL_MODULE)
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := i2cget
LOCAL_SRC_FILES := ./bins/$(LOCAL_MODULE)
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := i2cset
LOCAL_SRC_FILES := ./bins/$(LOCAL_MODULE)
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := i2cdump
LOCAL_SRC_FILES := ./bins/$(LOCAL_MODULE)
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ethtool
LOCAL_SRC_FILES := ./bins/$(LOCAL_MODULE)
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

SAMPLE_AUDIO_PATH := vendor/adlink/sample_audio

$(shell mkdir -p $(TARGET_OUT_VENDOR)/sample_audio)
$(shell cp $(SAMPLE_AUDIO_PATH)/sample_32000Hz.wav $(TARGET_OUT_VENDOR)/sample_audio)
$(shell cp $(SAMPLE_AUDIO_PATH)/sample_48000Hz.wav $(TARGET_OUT_VENDOR)/sample_audio)
$(shell cp $(SAMPLE_AUDIO_PATH)/sample_8000Hz.wav $(TARGET_OUT_VENDOR)/sample_audio)

$(shell cp -R vendor/adlink/ads1115 $(TARGET_OUT_VENDOR))

