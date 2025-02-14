RAM_BANK_EXRAM_BIT:
                ; Since EXRAM is D6, E2RAM is D7 and E3RAM is D5 it seems easier to use the table rather
                ; than reorder bits in runtime
                db 0b00000000 ; bank set 0
                db 0b01000000 ; bank set 1
                db 0b10000000 ; bank set 2
                db 0b11000000 ; bank set 3
                db 0b00100000 ; bank set 4
                db 0b01100000 ; bank set 5
                db 0b10100000 ; bank set 6
                db 0b11100000 ; bank set 7
MEMTEST_INC_BANK:
                ; input:  E - sequential page number
                ; output: A - 7ffd value for the page
                PUSH HL
                PUSH DE
                AND #07
                LD HL, RAM_BANK_EXRAM_BIT
                LD D, 0
                SRA E
                SRA E
                SRA E
                ADD HL, DE
                ADD A, (HL)
                POP DE
                POP HL
                jp TEST_RAM_PAGE

; -------------------
PATCH_TEST_RAM_PROC:
                ; FIX OUT (0) arguments in TEST_RAM
                ; Fix OUT (0), 1 at the beginning
                IN A, (0)
                AND #14 ; D2=QUORUM/PENT | D4=128/1024
                LD L, A
                OR #01
                LD DE, TEST_RAM + 1
                LD (DE), A

                ; Fix OUT (0), 0 at the end
                LD A, L
                LD DE, TEST_RAM + (TEST_RAM_PROC_BODY_END - TEST_RAM_PROC_BODY) - 4
                LD (DE), A
                
                RET
; -------------------

PREPARE_RAM_PAGE_NUMBERS:
                rst     8
                
                LD DE, RAM_BANK_EXRAM_BIT + 7
                LD L, 64 ; pages count

_loop_prepare_ram1:
                LD A, L
                OR A
                JR Z, END_PREPARE_RAM_PAGE_NUMBERS

                LD B, 8
_loop_prepare_ram2:
                DEC B
                LD A, (DE)
                OR B
                INC B
                PUSH BC
                LD BC, #7ffd
                OUT (C), A
                POP BC
                LD A, L
                LD (#C000 + #1B00), A
                DEC L
                DJNZ _loop_prepare_ram2
                DEC DE
                JR _loop_prepare_ram1
END_PREPARE_RAM_PAGE_NUMBERS:
                ld      e, 0
                JP ITERATE_OVER_RAM_PAGES

                ; A - page number
                ; HL - screen print position
TEST_PAGE_NUMBER:
                LD C, A
                LD A, (#C000 + #1B00)
                DEC A
                CP C
                LD A, C
                JR Z, GOOD_PAGE
                LD A, '!'
                RST #10
                JR END_TEST_PAGE_NUMBER
GOOD_PAGE:
                rst     18h             ; print space before 'OK'/error
END_TEST_PAGE_NUMBER:
                JP BEGIN_PATTERNS_TEST