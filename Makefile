all: quorum-menu.rom
	md5sum -c checksums.md5

clean:
	rm quorum-menu.rom generated/q48_vs_orig48_patch.bin generated/48_turbo_vs_48_patch.bin || true

generated/q48_vs_orig48_patch.bin: resources/quorum48.rom resources/48.rom
	python3 scripts/patch48_gen.py --seq --ignore=0013-0017,0330-0332,3800-4000 --force=005F,16 $^ $@

generated/48_turbo_vs_48_patch.bin: resources/48.rom resources/48_turbo.rom
	python3 scripts/patch48_gen.py --ignore=0000-0400 $^ $@

generated/taper_packed.bin: resources/taper.bin
	python3 scripts/compress_block.py $^ $@

quorum-menu.rom: main.asm generated/q48_vs_orig48_patch.bin generated/48_turbo_vs_48_patch.bin generated/taper_packed.bin
	sjasmplus $<