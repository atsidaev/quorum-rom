                ORG PATCH_MEMTEST0
                CALL PATCH_TEST_RAM_PROC

                ORG PATCH_MEMTEST1
                ld      b, 0Eh      ; String for 1024 is 1 byte longer than for 256
                jp      PREPARE_RAM_PAGE_NUMBERS

                ORG PATCH_MEMTEST2
                jp      nc, MEMTEST_INC_BANK    ; we need more complex logic to select the next RAM page
                nop

                ORG PATCH_MEMTEST3
                rst     #18     ; wipe additional char 
                dec     hl      ; and 
                dec     hl      ;     go
                dec     hl      ;        back 
                dec     hl      ;             5
                dec     hl      ;               pos
                pop     af
                PUSH AF
                call    PRINT_HEX_NUMBER    ; Reuse existing HEX number print function
                POP AF
                JP TEST_PAGE_NUMBER
                ASSERT $ == BEGIN_PATTERNS_TEST

                ORG PATCH_MEMTEST4
                cp      40h             ; 64 pages - for 1024 Kb

                ORG aRam256Kbyte
                DEFB 'RAM 1024 Kbyte'