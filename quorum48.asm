        DEVICE ZXSPECTRUM48
        ORG 0
        INCBIN "generated/48.rom"

        INCLUDE "generated/48.sym"

ERR_SP  EQU #5C3D
word_5CB4   EQU #5CB4
word_5C38   EQU #5C38
word_5C7B   EQU #5C7B
word_5CB2   EQU #5CB2
word_5C53   EQU #5C53
word_5C57   EQU #5C57
word_5C4B   EQU #5C4B
word_5C59   EQU #5C59
word_5C61   EQU #5C61
word_5C63   EQU #5C63
word_5C65   EQU #5C65
word_5C3D   EQU #5C3D
word_5C8D   EQU #5C8D
word_5C8F   EQU #5C8F
byte_5C48   EQU #5C48
word_5C36   EQU #5C36
word_5C4F   EQU #5C4F
word_5C09   EQU #5C09
byte_5C10   EQU #5C10
byte_5C3B   EQU #5C3B

        ORG #0013
        out     (0), a
        pop     af
        ei
        ret

        ORG #002B
        out     (0), a
        pop     af
        ret
        db    5; ???

        ORG #005F
        di
_NMI2:
        push    af
        push    bc
        push    de
        push    hl
        jr      _NMI_CONT

        ORG #0066 ; NMI handler
        jr      _NMI2
_NMI_CONT:
        ld      hl, CHECK_AND_GO_TO_SHADOW_RAM
        jp      loc_39DF

        INCLUDE "patches-48/keyboard.patch.asm"

        ORG #03CF   ; inside THE 'BEEPER' SUBROUTINE
        or      0   ; do not turn off the MIC output (but why?)

        ORG #04AA ; THE 'PROGRAM NAME' SUBROUTINE (ZX81)
        ; Was used in ZX81 only, so this space might be utilized
sub_4AA:
        ex      (sp), hl
        ld      b, 4
loc_4AD:
        ld      a, (hl)
        call    sub_39BC
        inc     hl
        djnz    loc_4AD
        ex      (sp), hl
        ret
        ; 11 bytes of THE 'PROGRAM NAME' SUBROUTINE are remaining

        ORG #09F4 ; THE 'PRINT-OUT' ROUTINES
        call    sub_3901

        ORG #0A32 ; inside THE 'CURSOR LEFT' SUBROUTINE
        ld      a, #19

        ORG #0B52 ; inside THE 'PRINT ANY CHARACTER(S)' SUBROUTINE
        jp      loc_3A32
        nop

        ORG #0B66 ; inside THE 'PRINT ANY CHARACTER(S)' SUBROUTINE
        call    sub_38D9
        nop

        ORG #0BB9 ; THE 'PRINT ANY CHARACTER(S)' SUBROUTINE
        call    sub_38EA

        ORG #0C14 ; PO_TABLE inside THE 'MESSAGE PRINTING' SUBROUTINE
        call    sub_3988
PO_TABLE_CONTINUE:

        INCLUDE "patches-48/printer.patch.asm"

        ORG #1027 ; inside THE 'ENTER EDITING' SUBROUTINE
        call    sub_3990

        ORG #10C4 ; inside THE 'KEYBOARD INPUT' SUBROUTINE
        jp      loc_3976
KB_INPUT_CONTINUE:

        INCLUDE "patches-48/start.patch.asm"

        ORG #1349 ; inside THE 'MAIN EXECUTION' LOOP (error printing subroutine)
        call    sub_3A01
        nop

        ORG #1539 ; THE COPYRIGHT MESSAGE
        DEFB  17h, 8, 0
        DEFB #7F, #01," 1993 'Kworum'", #02
sub_154D:
        ld      a, (de)
        cp      1Ah
        ret     z
        rst     10h
        inc     de
        jr      sub_154D

        ORG #190A; inside THE 'PRINT THE CURSOR' SUBROUTINE
        call    sub_3962 ; replace for CALL OUT_FLASH

        ORG #1B7D ; STMT_R_1 in THE 'STMT-RET' SUBROUTINE
        call    sub_3A13
        nop

        ORG #1BF4 ;  THE 'STMT-NEXT' ROUTINE
        call    sub_3A23

        INCLUDE "patches-48/main.code.asm"

        ORG #3B00
        INCBIN "generated/font_quorum.bin"

        SAVEBIN "quorum48.rom", 0, 16384