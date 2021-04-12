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

.PHONY: all gadget kernel image clean

all: gadget kernel image

image: model/$(UC_MODEL_NAME).model
	ubuntu-image snap $< $(foreach snap,$(LOCAL_SNAPS),--snap $(snap)) \
		-O images/$(UC_MODEL_NAME)

clean-targets :=
clean-objs    := model/$(UC_MODEL_NAME).model

# Usage: $(eval $(call add-snap-rule, <type>, <folder>, <prefix>, <arguments>))
#   <type>      : [ gadget | kernel ]
#   <folder>    : folder containing snapcraft.yaml file
#   <prefix>    : prefix before launching snapcraft command
#   <arguments> : arguments to pass to snapcraft command
define add-snap-rule =
snap-deps :=
-include $2/depends.mk
snapname := $(filter-out name:,$(shell grep 'name:' $2/snapcraft.yaml))
snapver  := $(filter-out version:,$(shell grep 'version:' $2/snapcraft.yaml))
snapfile := $2/$$(snapname)_$$(snapver)_amd64.snap

$1: $$(snapfile)
$$(snapfile): $$(addprefix $2/,snapcraft.yaml $$(snap-deps))
	@echo 'Building $$@ ...'
	cd $2; $3snapcraft $4

.PHONY: $1-clean
clean-objs += $$(snapfile)
clean-targets += $1-clean

$1-clean:
	cd $2; $3snapcraft clean $4
endef

$(eval $(call add-snap-rule, gadget, $(GADGET_DIR),sudo ,))
$(eval $(call add-snap-rule, kernel, $(KERNEL_DIR),,))

clean: $(clean-targets)
	rm -fr images/$(UC_MODEL_NAME)
	rm -f $(clean-objs)

.SUFFIXES: .json .model

%.model: %.json
	sed -e 's/<AuthorityId>/$(SNAP_DEVELOPER_ID)/'                  \
	    -e 's/<BrandId>/$(SNAP_DEVELOPER_ID)/'                      \
	    -e 's/<Model>/$(basename $(notdir $@))/'                    \
	    -e 's/<AssertionCreationTime>/'`date -Iseconds --utc`'/'    \
	    $< | snap sign -k $(SNAP_SIGNING_KEY) > $@
