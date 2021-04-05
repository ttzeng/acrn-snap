# filtered list of modules to be included in the signed EFI grub image
GRUB_MODULES = \
	all_video \
	boot \
	cat \
	chain \
	configfile \
	echo \
	ext2 \
	fat \
	font \
	gettext \
	gfxmenu \
	gfxterm \
	gfxterm_background \
	gzio \
	halt \
	jpeg \
	keystatus \
	loadenv \
	loopback \
	linux \
	memdisk \
	minicmd \
	normal \
	multiboot \
	multiboot2 \
	part_gpt \
	png \
	reboot \
	regexp \
	search \
	search_fs_uuid \
	search_fs_file \
	search_label \
	sleep \
	squash4 \
	test \
	true \
	video

all:
	dd if=$(SNAPCRAFT_STAGE)/usr/lib/grub/i386-pc/boot.img of=pc-boot.img bs=440 count=1
	/bin/echo -n -e '\x90\x90' | dd of=pc-boot.img seek=102 bs=1 conv=notrunc
	grub-mkimage -d $(SNAPCRAFT_STAGE)/usr/lib/grub/i386-pc/ -O i386-pc -o pc-core.img -p '(,gpt2)/EFI/ubuntu' $(GRUB_MODULES) biosdisk
	# The first sector of the core image requires an absolute pointer to the
	# second sector of the image.  Since this is always hard-coded, it means our
	# BIOS boot partition must be defined with an absolute offset.  The
	# particular value here is 2049, or 0x01 0x08 0x00 0x00 in little-endian.
	/bin/echo -n -e '\x01\x08\x00\x00' | dd of=pc-core.img seek=500 bs=1 conv=notrunc
	grub-mkimage -d $(SNAPCRAFT_STAGE)/usr/lib/grub/x86_64-efi/ -O x86_64-efi -o grubx64.efi -p '/EFI/ubuntu' $(GRUB_MODULES) linuxefi

install:
	mkdir -p $(DESTDIR)/grub/
	install -m 644 pc-boot.img pc-core.img grubx64.efi $(DESTDIR)/grub/
	install -m 644 $(SNAPCRAFT_STAGE)/usr/lib/shim/shimx64.efi.signed $(DESTDIR)/grub/shim.efi.signed
	install -m 644 $(SNAPCRAFT_STAGE)/usr/lib/shim/mmx64.efi $(DESTDIR)/grub/mmx64.efi
	install -m 644 grub.conf $(DESTDIR)/
