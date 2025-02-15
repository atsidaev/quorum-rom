        ORG #02B0
        jp      loc_3927
KB_SCAN_CONTINUE:

        ; K-TEST
        ORG #0322
        cp      60h

        ORG #032C
        call    sub_394C

        ORG #0333
        jp      KB_DECODE_PATCH
KB_DECODE_CONT:

        ORG #035A
        call    sub_38BE
        ld      b, d

        ORG #039F
        cp      3Ah ; ':'
        jr      nc, loc_3AB
        bit     5, b
        ld      hl, 230h
        jp      nz, L034A ; K_LOOK_UP
loc_3AB:
        sub     10h
        cp      20h ; ' '
        jp      nz, #0F25 ; ???
        ld      a, 5Fh ; '_'
        ret