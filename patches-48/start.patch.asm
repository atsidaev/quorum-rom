        ORG #11CB ; START_NEW (The main entry point)
loc_11CB:
        or      a
        jp      z, loc_399F

loc_11CF:
        ld      b, a
        ld      a, 3Fh ; '?'
        ld      i, a
        ld      h, d
        ld      l, e

loc_11D6:
        ld      (hl), 2
        dec     hl
        cp      h
        jr      nz, loc_11D6

loc_11DC:
        and     a
        sbc     hl, de
        add     hl, de
        inc     hl
        jr      nc, loc_11E9
        dec     (hl)
        jr      z, loc_11E9
        dec     (hl)
        jr      z, loc_11DC

loc_11E9:
        dec     hl
        exx
        ld      (word_5CB4), bc
        ld      (word_5C38), de
        ld      (word_5C7B), hl
        exx
        inc     b
        jr      z, loc_1213
        ld      (word_5CB4), hl
        ld      de, 3EAFh
        ld      bc, 0A8h
        ex      de, hl
        lddr
        ex      de, hl
        inc     hl
        ld      (word_5C7B), hl
        dec     hl
        ld      bc, 1940h
        ld      (word_5C38), bc

loc_1213:
        ld      (word_5CB2), hl
        ld      hl, 5CCAh
        ld      (word_5C57), hl
        inc     hl
        ld      (word_5C53), hl
        ld      (word_5C4B), hl
        ld      (hl), 80h
        inc     hl
        ld      (word_5C59), hl
        ld      (hl), 0Dh
        inc     hl
        ld      (hl), 80h
        inc     hl
        ld      (word_5C61), hl
        ld      (word_5C63), hl
        ld      (word_5C65), hl

loc_1238:
        ld      hl, (word_5CB2)
        ld      (hl), 3Eh ; '>'
        dec     hl
        ld      sp, hl
        dec     hl
        dec     hl
        ld      (word_5C3D), hl
        ld      a, 7
        out     (0FEh), a
        ld      a, 38h ; '8'
        ld      (word_5C8D), a
        ld      (word_5C8F), a
        ld      (byte_5C48), a
        ld      hl, 3C00h
        ld      (word_5C36), hl
        im      1
        ld      iy, 5C3Ah
        ld      de, 5CB6h
        ld      (word_5C4F), de
        ld      hl, 15AFh
        ld      bc, 15h
        ldir
        inc     hl
        inc     hl
        ld      de, 5C10h
        ld      c, 0Eh
        ldir
        ld      hl, 523h
        ld      (word_5C09), hl
        dec     (iy - #3A)
        dec     (iy - #36)
        ei
        set     1, (iy+1)
        call    sub_EEB
        ld      (iy+31h), 2
        call    #0D6B ; CLS routine
        xor     a
        ld      de, 1539h
        call    sub_154D
        set     5, (iy+2)
        jr      #12A9 ; MAIN_1 (main execution loop)
        xor #18