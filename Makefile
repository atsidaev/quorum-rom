all: roms
	md5sum -c checksums.md5

roms: quorum-menu.rom quorum-menu-1024plus.rom quorum.rom quorum-1024plus.rom

clean:
	rm quorum*.rom *.sym  generated/*.bin || true

quorum48.rom: quorum48.asm generated/48.rom generated/font_quorum.bin
	sjasmplus --sym=$(@:.rom=.sym) $<

quorum48-1024plus.rom: quorum48-1024plus.asm quorum48.rom
	sjasmplus --sym=$(@:.rom=.sym) $<

generated/48.rom: sinclair48rom/spectrum48.asm generated/font_zx.bin
	sjasmplus --sym=$(@:.rom=.sym) $<
	mv 48.rom generated/

generated/48_turbo.rom: sinclair48rom/spectrum48.asm generated/font_zx.bin
	sjasmplus -DTURBO $<
	mv 48_turbo.rom generated/

generated/q48_vs_orig48_patch.bin: quorum48.rom generated/48.rom
	python3 scripts/patch48_gen.py --seq --ignore=0013-0017,0330-0332,3800-4000 --force=005F,16 $^ $@

generated/48_turbo_vs_48_patch.bin: generated/48.rom generated/48_turbo.rom
	python3 scripts/patch48_gen.py $^ $@

generated/taper_packed.bin: resources/taper.bin
	python3 scripts/compress_block.py $^ $@

generated/font_%.bin: resources/font_%.png
	python3 scripts/fontbin.py $^ $@

quorum-menu.rom: main.asm memtest.asm memtest_proc.asm\
                 generated/q48_vs_orig48_patch.bin generated/48_turbo_vs_48_patch.bin \
                 generated/taper_packed.bin \
                 generated/font_zx.bin generated/font_pseudograph.bin
	sjasmplus --sym=$(@:.rom=.sym) $<
	python3 scripts/fix_crc.py $@ $(@:.rom=.sym) ROM_CRC_VALUE

quorum-menu-1024plus.rom: quorum-menu-1024plus.asm quorum-menu.rom
	sjasmplus --sym=$(@:.rom=.sym) $<
	python3 scripts/fix_crc.py $@ quorum-menu.sym ROM_CRC_VALUE

quorum.rom: quorum-menu.rom resources/trdos.rom resources/128.rom quorum48.rom
	[ -f $@ ] && rm $@ || true
	cat $^ >> $@

quorum-1024plus.rom: quorum-menu-1024plus.rom resources/trdos.rom resources/128.rom quorum48-1024plus.rom
	[ -f $@ ] && rm $@ || true
	cat $^ >> $@

prepare_worker:
	sudo apt-get -y update
	sudo apt-get -y install python3-pil
	wget https://github.com/atsidaev/quorum-rom/wiki/bin/sjasmplus -O sjasmplus
	chmod +x sjasmplus
	sudo mv sjasmplus /usr/bin