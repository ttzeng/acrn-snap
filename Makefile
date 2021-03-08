-include config.mk

ifeq ($(UC_MODEL_NAME),)
$(error Model assertion name 'UC_MODEL_NAME' must be specified in config.mk)
endif
ifeq ($(SNAP_SIGNING_KEY),)
$(error No signing key 'SNAP_SIGNING_KEY' is specified)
endif

GADGET_DIR  ?= gadget
KERNEL_DIR  ?= kernel
LOCAL_SNAPS += $(wildcard $(foreach d,$(GADGET_DIR) $(KERNEL_DIR),$d/*.snap))

.PHONY: all clean

all: model/$(UC_MODEL_NAME).model
	ubuntu-image snap $< $(foreach snap,$(LOCAL_SNAPS),--snap $(snap))

clean:
	rm -f seed.manifest snaps.manifest *.img *.img.xz
	rm -f model/$(UC_MODEL_NAME).model

.SUFFIXES: .json .model

%.model: %.json
	sed -e 's/<AuthorityId>/$(SNAP_DEVELOPER_ID)/'                  \
	    -e 's/<BrandId>/$(SNAP_DEVELOPER_ID)/'                      \
	    -e 's/<Model>/$(basename $(notdir $@))/'                    \
	    -e 's/<AssertionCreationTime>/'`date -Iseconds --utc`'/'    \
	    $< | snap sign -k $(SNAP_SIGNING_KEY) > $@
