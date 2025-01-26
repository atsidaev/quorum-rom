MEMTEST_BEGIN:
                ld      a, 7
                out     (0FEh), a
                ld      (#5CFF), a
                ld      hl, 0
                ld      (#5D00), hl
                ld      hl, TEST_ROM_PROC_BODY
                ld      de, TEST_ROM
                ld      bc, TEST_ROM_PROC_BODY_END - TEST_ROM_PROC_BODY
                ldir
PATCH_ON_TEST_ROM_COPIED:
                ld      hl, OUT_0_A_JP_3D2F_PROC_BODY ; PREPARE TR-DOS JUMPER IN RAM
                ld      de, OUT_0_A_JP_3D2F
                ld      bc, OUT_0_A_JP_3D2F_PROC_BODY_END - OUT_0_A_JP_3D2F_PROC_BODY
                ldir
END_PATCH_ON_TEST_ROM_COPIED:

loc_54F:                                ; CODE XREF: sub_605+E8↓j
                ld      sp, 6000h
                ld      a, 10h
                ld      bc, 7FFDh
                out     (c), a
                ld      hl, 4000h       ; cls
                ld      de, 4001h
                ld      bc, 17FFh
                ld      (hl), 0
                ldir
                inc     hl              ; cls attr
                inc     de
                ld      (hl), 38h ; '8'
                ld      bc, 2FFh
                ldir
                ld      hl, 4000h
                ld      de, aRomMenuQuorumV ; "ROM-MENU QUORUM V.4.2 27.06.1997"
                ld      b, 20h ; ' '
                rst     8
                ld      hl, 50E4h
                ld      de, aPressResForBre ; "Press <RES> for break"
                ld      b, 15h
                rst     8
                ld      hl, 50C5h
                ld      de, aTestRomRamN ; "Test ROM/RAM N "
                ld      b, 0Fh
                rst     8
                ld      de, (#5D00)
                inc     de

loc_58F:
                ld      (#5D00), de
                call    sub_796

loc_596:
                ld      hl, 4040h
                ld      de, aRom64Kbyte ; "ROM  64 Kbyte"
                ld      b, 0Dh
                rst     8
                ld      ix, 5Bh ; '['
                xor     a

loc_5A4:                                ; CODE XREF: sub_605+4C↓j
                ld      hl, 4064h
                push    af
                push    af
                push    af
                sla     a
                sla     a
                sla     a
                sla     a
                sla     a
                add     a, l
                ld      l, a
                ld      de, aPageN      ; "Page N "
                ld      b, 7
                rst     8
                pop     af
                add     a, 30h ; '0'
                rst     10h
                rst     18h
                pop     af
                push    hl
                or      a
                jr      z, loc_611
                dec     a
                jr      nz, loc_601
                in      a, (80h)
                cp      0FFh
                jr      z, loc_5F8
                ld      hl, 5E9h
                push    hl
                ld      hl, 5D11h
                push    hl
                ld      hl, 180Dh
                push    hl
                ld      hl, 0
                ld      de, 0C000h
                ld      bc, 4000h
                ld      a, 0A0h         ; BASIC + TRDOS ; TODO fix
                jp      OUT_0_A_JP_3D2F
; ---------------------------------------------------------------------------
                ld      hl, 0C000h
                ld      de, 0
                ld      bc, 4000h
                ldir
                ld      a, 1
                jr      loc_611
; ---------------------------------------------------------------------------

loc_5F8:                                ; CODE XREF: ROM:05CD↑j
                pop     hl
                ld      de, aNoTrdos    ; "no TRDOS"
                ld      b, 8
                rst     8
                jr      loc_64B
; ---------------------------------------------------------------------------

loc_601:                                ; CODE XREF: ROM:05C7↑j
                dec     a
                ld      bc, 7FFDh

; =============== S U B R O U T I N E =======================================


sub_605:
                jr      nz, loc_60B
                ld      a, 0
                jr      loc_60D
; ---------------------------------------------------------------------------

loc_60B:                                ; CODE XREF: sub_605↑j
                ld      a, 10h

loc_60D:                                ; CODE XREF: sub_605+4↑j
                out     (c), a
                ld      a, 20h ; TODO fix

loc_611:                                ; CODE XREF: ROM:05C4↑j
                                        ; ROM:05F6↑j
                ld      hl, 0
                ld      d, h
                ld      e, l
                call    TEST_ROM
                pop     hl
                ld      a, 7Fh
                in      a, (0FEh)
                rrca
                jr      nc, loc_648
                ld      a, (ix+0)
                cp      e
                jr      nz, loc_62F
                ld      de, aOk         ; "OK"
                ld      b, 2
                rst     8
                jr      loc_64B
; ---------------------------------------------------------------------------

loc_62F:                                ; CODE XREF: sub_605+20↑j
                ld      a, (#5CFF)
                or      18h
                ld      (#5CFF), a
                xor     18h
                push    de
                ld      de, 8000h

loc_63D:                                ; CODE XREF: sub_605+40↓j
                xor     10h
                out     (0FEh), a
                ld      b, d

loc_642:                                ; CODE XREF: sub_605:loc_642↓j
                djnz    $
                dec     e
                jr      nz, loc_63D
                pop     de

loc_648:                                ; CODE XREF: sub_605+1A↑j
                call    sub_796

loc_64B:                                ; CODE XREF: ROM:05FF↑j
                                        ; sub_605+28↑j
                pop     af
                inc     ix
                inc     a
                cp      4
                jp      nz, loc_5A4
                ld      hl, TEST_RAM_PROC_BODY
                ld      de, TEST_RAM
                ld      bc, TEST_RAM_PROC_BODY_END - TEST_RAM_PROC_BODY
                ldir
PATCH_MEMTEST0:
                ld      bc, 7FFDh
                ld      hl, 0C000h
                ld      hl, 40E0h
                ld      de, aRam256Kbyte ; "RAM 256 Kbyte"
PATCH_MEMTEST1:
                ld      b, 0Dh
                rst     8
                ld      e, 0

ITERATE_OVER_RAM_PAGES:
                ld      a, e
                cp      8
PATCH_MEMTEST2:
                jr      c, TEST_RAM_PAGE
                add     a, 38h ; '8'

TEST_RAM_PAGE:
                ld      bc, 7FFDh
                out     (c), a
                push    de
                ld      hl, 4804h
                ld      a, e
                push    af
                and     7
                sla     a
                sla     a
                sla     a
                sla     a
                sla     a
                add     a, l
                ld      l, a
                ld      de, aPageN      ; "Page N "
                ld      b, 0Bh
                rst     8
PATCH_MEMTEST3:
                dec     hl
                dec     hl
                dec     hl
                dec     hl
                pop     af
                add     a, 30h ; '0'
                cp      3Ah ; ':'
                jr      c, loc_6A3
                add     a, 7

loc_6A3:                                ; CODE XREF: sub_605+9A↑j
                rst     10h
                rst     18h             ; print space before 'OK'/error
BEGIN_PATTERNS_TEST:
                ld      iy, MEMORY_TEST_PATTERNS

loc_6A9:                                ; CODE XREF: sub_605+CE↓j
                ld      a, (iy+0)
                cp      0C3h
                jr      z, loc_6D5
                pop     de
                push    de
                ld      a, e
                cp      5
                jr      nz, TEST_BANK_NOT_5
                ld      bc, 20h ; ' '
                ld      ix, 0E000h  ; skip test code and stack area in bank 5
                jr      loc_6C7
; ---------------------------------------------------------------------------

TEST_BANK_NOT_5:
                ld      bc, 40h ; '@'
                ld      ix, 0C000h

loc_6C7:                                ; CODE XREF: sub_605+B9↑j
                push    hl
                ld      h, (iy+0)
                call    TEST_RAM
                jr      nz, loc_6F0
                pop     hl
                inc     iy
                jr      loc_6A9
; ---------------------------------------------------------------------------

loc_6D5:                                ; CODE XREF: sub_605+A9↑j
                ld      de, aOk         ; "OK"
                ld      b, 2
                rst     8

loc_6DB:
                pop     de
                ld      a, e
                inc     a
PATCH_MEMTEST4:
                cp      10h             ; 16 pages - for 256 Kb
                ld      e, a
                jr      nz, ITERATE_OVER_RAM_PAGES
                ld      a, (#5CFF)
                xor     18h
                ld      (#5CFF), a
                out     (0FEh), a
                jp      loc_54F
; ---------------------------------------------------------------------------

loc_6F0:                                ; CODE XREF: sub_605+C9↑j
                ld      c, l
                pop     hl
                push    ix
                pop     de
                push    af
                call    sub_796
                rst     18h
                ld      a, c
                rst     28h
                rst     18h
                pop     af
                rst     28h
                call    sub_782
                call    sub_777
                jr      loc_6DB
; End of function sub_605

; ---------------------------------------------------------------------------

TEST_RAM_PROC_BODY:                     ; DATA XREF: sub_605+4F↑o
                ld      a, 1            ; TODO fix
                out     (PORT_00), a

loc_70B:                                ; CODE XREF: ROM:0717↓j
                                        ; ROM:071A↓j
                ld      (ix+0), h
                ld      l, (ix+0)
                ld      a, h
                cp      l
                jr      nz, loc_71C
                inc     ix
                djnz    loc_70B
                dec     c
                jr      nz, loc_70B

loc_71C:                                ; CODE XREF: ROM:0713↑j
                ld      a, 0            ; TODO fix
                out     (PORT_00), a
                ret
TEST_RAM_PROC_BODY_END:
; ---------------------------------------------------------------------------
aTestRomRamN:   DEFB 'Test ROM/RAM N ' ; DATA XREF: ROM:0584↑o
aNoTrdos:       DEFB 'no TRDOS'       ; DATA XREF: ROM:05F9↑o
aRom64Kbyte:    DEFB 'ROM  64 Kbyte'  ; DATA XREF: ROM:0599↑o
aRam256Kbyte:   DEFB 'RAM 256 Kbyte'  ; DATA XREF: sub_605+63↑o
                db  32h ; 2
                db  35h ; 5
                db  36h ; 6
aPressResForBre:DEFB 'Press <RES> for break'
aPageN:         DEFB 'Page N     '
aOk:            DEFB 'OK'

; =============== S U B R O U T I N E =======================================


sub_777:                                ; CODE XREF: sub_605+FD↑p
                                        ; sub_777+7↓j
                ld      b, 28h ; '('

loc_779:                                ; CODE XREF: sub_777+9↓j
                ld      a, 0F7h
                in      a, (7Eh)
                rrca
                jr      c, sub_777
                djnz    loc_779
; End of function sub_777


; =============== S U B R O U T I N E =======================================


sub_782:                                ; CODE XREF: sub_605+FA↑p
                ld      a, 2
                ld      de, 8000h

loc_787:                                ; CODE XREF: sub_782+D↓j
                xor     17h
                out     (0FEh), a
                ld      b, d

loc_78C:                                ; CODE XREF: sub_782:loc_78C↓j
                djnz    $
                dec     e
                jr      nz, loc_787
                ld      a, 7
                out     (0FEh), a
                ret
; End of function sub_782


; =============== S U B R O U T I N E =======================================


sub_796:                                ; CODE XREF: ROM:0593↑p
                                        ; sub_605:loc_648↑p ...
                ld      a, d
                rst     28h
                ld      a, e