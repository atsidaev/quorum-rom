	DEVICE ZXSPECTRUM48
	ORG 0
BEGIN
	INCBIN "quorum-menu.rom"
	INCBIN "resources/trdos.rom"
	INCBIN "resources/128.rom"
	INCBIN "resources/quorum48.rom"
END
	SAVEBIN "quorum.rom", 0, END-BEGIN