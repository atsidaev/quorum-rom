        DEVICE ZXSPECTRUM48
        ORG 0
        INCBIN "quorum48.rom"
        INCLUDE "quorum48.sym"

        ; Patches for port 00

        ORG NMI_CONT
        ld      hl, CHECK_AND_GO_TO_SHADOW_RAM_NEW
        jp      COPY_CHECK_AND_GO_TO_SHADOW_RAM_NEW

        ORG #39D9
COPY_CHECK_AND_GO_TO_SHADOW_RAM_NEW:
        ld      d, h
        ld      e, l
        ld      bc, CHECK_AND_GO_TO_SHADOW_RAM_NEW_END - CHECK_AND_GO_TO_SHADOW_RAM_NEW
        ldir
CHECK_AND_GO_TO_SHADOW_RAM_NEW:
        IN      A, (0)
        AND     #14
        OR      #1
        out     (0), a
        ld      a, (#0066) ; NMI handler
        cp      0C3h
        pop     hl
        pop     de
        pop     bc
        jr      nz, _no_handler
        pop     af
        jp      #0066 ; NMI handler
_no_handler:
        IN      A, (0)
        AND     #14
        OR      #60
        out     (0), a
        jp      0
CHECK_AND_GO_TO_SHADOW_RAM_NEW_END:

        ASSERT $ == #3A01

        SAVEBIN "quorum48-1024plus.rom", 0, 16384