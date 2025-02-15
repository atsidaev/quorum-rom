        ORG #386E
KB_DECODE_PATCH:
        ld      a, e
        cp      60h ; '`'
        jr      nc, loc_3888
        cp      20h ; ' '
        jr      c, loc_3888
        cp      3Ah ; ':'
        jp      KB_DECODE_CONT

        DB      2Fh, 51h, 52h, 36h, 2Ah, 32h, 41h, 40h, 39h, 3Ah, 49h, 4Bh

loc_3888:
        cp      10h
        ret     c
        add     a, 0C8h
        jp      p, loc_3892
        add     a, 70h ; 'p'
loc_3892:
        ld      e, a
        ld      d, 0
        bit     5, (iy+30h)
        jr      z, loc_38B1
        push    bc
        ld      bc, 6
        ld      hl, 387Ch
        cpir
        pop     bc
        jr      nz, loc_38B1
        ld      e, 5
        add     hl, de
        ld      e, (hl)
        bit     3, (iy+30h)
        jr      nz, loc_38B8
loc_38B1:
        ld      hl, 3A77h
        bit     7, b
        jr      nz, loc_38BB
loc_38B8:
        ld      hl, 3AA7h
loc_38BB:
        add     hl, de
        ld      a, (hl)
        ret

sub_38BE:
        ld      d, b
        bit     5, (iy+30h)
        jr      z, loc_38D4
        ld      bc, 27h ; '''
        ld      hl, 205h
        cpir
        jr      nz, loc_38D4
        ld      bc, 3871h
        add     hl, bc
        ld      a, (hl)
loc_38D4:
        bit     3, (iy+30h)
        ret

sub_38D9:
        ld      bc, (word_5C36)
        cp      40h ; '@'
        ret     nc
        push    af
        ld      a, b
        cp      39h ; '9'
        jr      nz, loc_38E8
        ld      b, 3Ch ; '<'
loc_38E8:
        pop     af
        ret

sub_38EA:
        and     b
        push    af
        ld      a, h
        cp      3Dh ; '='
        jr      nc, loc_38F8
        ld      a, l
        or      a
        jr      z, loc_38FC
        inc     a
        jr      z, loc_38FC
loc_38F8:
        pop     af
        xor     (hl)
        xor     c
        ret

loc_38FC:
        pop     af
        xor     c
        ret

        db 0FFh
        db 0FFh

sub_3901:
        ld      hl, 3900h
        ld      e, a
        cp      2
        jr      c, loc_391E
        ld      h, 3Ch ; '<'
        jr      z, loc_3916
        cp      0Dh
        jr      z, loc_3916
        cp      22h ; '"'
loc_3913:
        jp      nz, #0B03 ; KB_DECODE_CONT
loc_3916:
        ld      a, (word_5C36+1)
        cp      39h ; '9'
        ld      a, e
        jr      nz, loc_3921
loc_391E:
        ld      (word_5C36), hl
loc_3921:
        cp      0Ch
        jr      nc, loc_3913
        pop     hl
        ret

loc_3927:
        ld      l, 5Fh ; '_'
        ld      bc, 0FE7Eh
loc_392C:
        in      a, (c)
        cpl
        and     3Fh ; '?'
        jr      z, loc_3941
        ld      h, a
        ld      a, l
loc_3935:
        inc     d
        ret     nz
loc_3937:
        sub     8
        srl     h
        jr      nc, loc_3937
        ld      d, e
        ld      e, a
        jr      nz, loc_3935
loc_3941:
        dec     l
        rlc     b
        jr      c, loc_392C
        ld      a, d
        inc     a
        ret     z
        jp      KB_SCAN_CONTINUE

sub_394C:
        cp      28h ; '('
        jr      nc, loc_3958
        ld      hl, 205h
        cp      27h ; '''
        ret     c
        pop     hl
        ret

loc_3958:
        add     a, 38h ; '8'
        jp      p, loc_395F
        add     a, 90h
loc_395F:
        pop     hl
        scf
        ret

sub_3962:
        push    af
        ld      a, (word_5C36+1)
        cp      39h ; '9'
        res     5, (iy+30h)
        jr      nz, loc_3972
        set     5, (iy+30h)
loc_3972:
        pop     af
        jp      #18C1 ; THE 'PRINT A FLASHING CHARACTER' SUBROUTINE
loc_3976:
        pop     af
        cp      0A3h
        jr      z, loc_3984
        cp      0A4h
        jr      z, loc_3984
        cp      20h ; ' '

        jp      KB_INPUT_CONTINUE

loc_3984:
                                ; ROM:397D↑j
        sub     0A2h
        scf
        ret

sub_3988:
        push    af
        call    sub_3993
        pop     af
        jp      #0C41 ;  THE 'TABLE SEARCH' SUBROUTINE

sub_3990:
        ld      (word_5C3D), hl
sub_3993:
        ld      a, (word_5C36+1)
        cp      39h ; '9'
        ret     nz
        ld      a, 3Ch ; '<'
        ld      (word_5C36+1), a
        ret

loc_399F:
        ld      (byte_5C3B), a
        ld      a, (byte_5C10)
        dec     a
        jr      nz, loc_39B0
        ld      a, 0FEh
        in      a, (0FEh)
        rra
        jp      c, loc_1238

loc_39B0:
        xor     a
        jp      loc_11CF

sub_39B4:
        call    sub_4AA
        dec     de
        ld      c, d
        ld      b, 0Dh
        ret

sub_39BC:
        push    bc
        push    af
loc_39BE:
        call    #1F54 ; THE 'BREAK-KEY' SUBROUTINE
        jr      c, loc_39C9
        ei
        call    sub_EDF
        rst     8
        inc     c
loc_39C9:
        in      a, (1Fh)
        bit     7, a
        jr      nz, loc_39BE
        pop     af
        out     (0FBh), a
        out     (1Bh), a
        out     (0FBh), a
        pop     bc
        ret

        db 0FFh
        db 0FFh
        db 0FFh
        db 0FFh
        db 0FFh
        db 0FFh
        db 0FFh

loc_39DF:
        ld      d, h
        ld      e, l
        ld      bc, CHECK_AND_GO_TO_SHADOW_RAM_END - CHECK_AND_GO_TO_SHADOW_RAM
        ldir
CHECK_AND_GO_TO_SHADOW_RAM:
        ld      a, 1
        out     (0), a
        ld      a, (#0066) ; NMI handler
        cp      0C3h
        pop     hl
        pop     de
        pop     bc
        jr      nz, loc_39F8
        pop     af
        jp      #0066 ; NMI handler
loc_39F8:
        ld      a, 60h ; '`'
        out     (0), a
        jp      0
CHECK_AND_GO_TO_SHADOW_RAM_END:

        db 0FFh
        db 0FFh

sub_3A01:
        bit     4, (iy+1)
        jr      nz, loc_3A0C
        xor     a
        ld      de, 1536h
        ret

loc_3A0C:
        ld      hl, 10Fh
loc_3A0F:
        ex      (sp), hl
        jp      #5B00

sub_3A13:
        bit     4, (iy+1)
        jr      nz, loc_3A1E
        bit     7, (iy+0Ah)
        ret

loc_3A1E:
        ld      hl, 112h
        jr      loc_3A0F

sub_3A23:
        bit     4, (iy+1)
        jr      nz, loc_3A2D
        rst     18h
        cp      0Dh
        ret

loc_3A2D:
        ld      hl, 115h
        jr      loc_3A0F

loc_3A32:
        cp      0A3h
        jr      z, loc_3A42
        cp      0A4h
        jr      z, loc_3A42
loc_3A3A:
        sub     0A5h
        jp      nc, #0B5F ; CALL PO_TOKENS there
        jp      #0B56 ; print UDG

loc_3A42:
        bit     4, (iy+1)
        jr      z, loc_3A3A
        ld      de, 3A5Ch
        push    de
        sub     0A3h
        ld      de, aSpectru    ; "SPECTRU"
        jr      z, loc_3A56
        ld      de, aPla        ; "PLA"
loc_3A56:
        ld      a, 4
        push    af
        jp      PO_TABLE_CONTINUE

        scf
        bit     1, (iy+1)
        ret     nz
        jp      #0B03 ; KB_DECODE_CONT

aSpectru:       DB 'SPECTRU', 0CDh
aPla:           DB 'PLA', 0D9h
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh, 49h, 52h
        db  4Eh, 36h, 35h, 45h, 50h, 4Dh, 54h, 4Fh
        db  47h, 37h, 34h, 4Bh, 41h, 53h, 58h, 4Ch
        db  5Bh, 38h, 33h, 55h, 57h, 5Eh, 0Eh, 44h
        db  5Dh, 39h, 32h, 43h, 59h, 51h, 20h, 0Dh
        db  5Ah, 30h, 31h, 4Ah, 46h,0FFh, 2Bh, 33h
        db  5Bh, 0Fh, 2Dh, 39h, 36h, 2Eh, 2Eh, 2Fh
        db  5Dh, 2Ah, 38h, 35h, 27h, 32h, 30h, 76h
        db  7Ch, 0Ch, 2Fh, 37h, 34h, 31h, 62h, 60h
        db  5Ch, 3Dh,   8,0FFh, 60h,0FFh,0D7h, 68h
        db 0DAh, 7Fh,0DCh,0DBh,0D9h,0A4h,0FFh, 2Ch
        db  3Bh, 5Eh, 0Eh,   7,   6,0A3h,0B0h,0ACh
        db  7Bh, 0Fh,0B3h,0ADh,0AEh, 3Eh,0AAh, 3Fh
        db  7Dh,0B2h,0A8h,0A9h, 22h,0A7h,0B1h, 56h
        db  5Ch, 0Ch,0B4h,0A6h,0AFh,0A5h, 42h, 40h
        db  7Ch, 2Bh,   8,0FFh, 7Eh,0FFh,0D6h, 48h
        db 0CAh, 5Fh,0C0h,0AFh,0D5h,0A4h,0FFh, 3Ch
        db  3Ah, 2Dh, 0Eh,   7,   6,0A3h,0FFh
