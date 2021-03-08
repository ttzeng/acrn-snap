# filtered list of modules to be included in the signed EFI grub image
GRUB_MODULES = \
	ext2 \
	loopback \
	linux \
	multiboot \
	part_gpt \

all:
	dd if=$(SNAPCRAFT_STAGE)/usr/lib/grub/i386-pc/boot.img of=pc-boot.img bs=440 count=1
	/bin/echo -n -e '\x90\x90' | dd of=pc-boot.img seek=102 bs=1 conv=notrunc
	grub-mkimage -d $(SNAPCRAFT_STAGE)/usr/lib/grub/x86_64-efi/ -O x86_64-efi -o pc-core.img -p '(,gpt2)/EFI/ubuntu' $(GRUB_MODULES)
	# The first sector of the core image requires an absolute pointer to the
	# second sector of the image.  Since this is always hard-coded, it means our
	# BIOS boot partition must be defined with an absolute offset.  The
	# particular value here is 2049, or 0x01 0x08 0x00 0x00 in little-endian.
	/bin/echo -n -e '\x01\x08\x00\x00' | dd of=pc-core.img seek=500 bs=1 conv=notrunc

install:
	mkdir -p $(DESTDIR)/grub/
	install -m 644 pc-boot.img pc-core.img $(DESTDIR)/grub/
	install -m 644 $(SNAPCRAFT_STAGE)/usr/lib/shim/shimx64.efi.signed $(DESTDIR)/grub/shim.efi.signed
	install -m 644 $(SNAPCRAFT_STAGE)/usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed $(DESTDIR)/grub/grubx64.efi
	install -m 644 $(SNAPCRAFT_STAGE)/usr/lib/shim/mmx64.efi $(DESTDIR)/grub/mmx64.efi
	install -m 644 grub.conf $(DESTDIR)/
