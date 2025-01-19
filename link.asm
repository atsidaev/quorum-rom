	DEVICE ZXSPECTRUM48
	ORG 0
BEGIN
	INCBIN INPUT
	INCBIN "resources/trdos.rom"
	INCBIN "resources/128.rom"
	INCBIN "resources/quorum48.rom"
END
	SAVEBIN OUTPUT, 0, END-BEGIN