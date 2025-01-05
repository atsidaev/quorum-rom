TEST_ROM_PROC_BODY:                     ; DATA XREF: ROM:0539↓o
                out     (0), a

loc_516:                                ; CODE XREF: ROM:0521↓j
                ld      a, (hl)
                add     a, e
                ld      e, a
                ld      a, 0
                adc     a, d
                ld      d, a
                inc     hl
                ld      a, 40h ; '@'
                cp      h
                jr      nz, loc_516
                xor     a
                out     (0), a
                ret
TEST_ROM_PROC_BODY_END:

OUT_0_A_JP_3D2F_PROC_BODY:              ; DATA XREF: ROM:0544↓o
                out     (0), a
                jp      #3D2F           ; TR-DOS
OUT_0_A_JP_3D2F_PROC_BODY_END: