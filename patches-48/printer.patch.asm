        ; ----------------------
        ; PRINTER routines

        ORG #0EAC ; THE 'COPY' COMMAND ROUTINE
        di
        ld      c, 16h
        ld      hl, 4000h
loc_EB2:
        ld      b, 8
loc_EB4:
        push    hl
        push    bc
        ld      d, 1
        call    sub_EF4
        pop     bc
        pop     hl
        ld      de, 20h ; ' '
        add     hl, de
        dec     c
        jr      z, #0EDC
        djnz    loc_EB4
        ld      de, 700h
        add     hl, de
        jr      loc_EB2
        db 0FFh

sub_ECD:
        di
        ld      hl, 5B00h
        ld      d, 0
        call    sub_EF4
        call    sub_39B4
        ei
        jr      sub_EDF
loc_EDC:
        ei
        ret
        db 0FFh
        ; the following block is unchanged
sub_EDF:
        ld      hl, 5B00h
        ld      (iy+46h), l
        xor     a
        ld      b, a
loc_EE7:
        ld      (hl), a
        inc     hl
        djnz    loc_EE7
sub_EEB:
        res     1, (iy+30h)
        ld      c, 21h ; '!'
        jp      #0DD9 ; CL_SET routine

        ASSERT $ == #0EF4 ; THE 'COPY-LINE' SUBROUTINE
sub_EF4:
        call    sub_4AA
        dec     de
        ld      c, e
        nop
        ld      bc, 201Eh
loc_EFD:
        push    de
        ld      c, 8
        ld      e, 0
        ld      a, d
        or      a
        jr      nz, loc_F08
        ld      e, 20h ; ' '
loc_F08:
        ld      b, 8
        push    hl
loc_F0B:
        rlc     (hl)
        rla
        add     hl, de
        djnz    loc_F0B
        call    sub_39BC
        pop     hl
        dec     c
        jr      nz, loc_F08
        inc     hl
        pop     de
        dec     e
        jr      nz, loc_EFD
        call    sub_4AA
        dec     de
        ld      c, d
        jr      loc_F30+1 ; ???
        ret
loc_F25:
        cp      22h ; '"'
        ret     nz
        ld      a, 40h ; '@'
        ret
        db 0FFh
sub_F2C:
        ld      hl, (ERR_SP)
        push    hl
loc_F30:
        ld      hl, 107Fh
        push    hl
        ld      (ERR_SP), sp
        call    #15D4 ; WAIT-KEY
        push    af
        ld      d, 0
        ld      e, 19h
        nop
        ld      hl, 100h