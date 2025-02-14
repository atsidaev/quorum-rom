                ORG PATCH_RUN_BASIC_48_MENU
                jp FIX_OUT_0_AND_RUN_BASIC_48_MENU
                ASSERT $ == END_PATCH_RUN_BASIC_48_MENU

                ORG PATCH_NMI48
                JP OUT_0_FROM_NMI48

                ORG PATCH_RUN_BASIC_128
                JP FIX_OUT_A_RUN_BASIC_128

                ORG PATCH_OUT0_1
                JP PATCH_OUT0_1_CODE

                ORG PATCH_OUT0_2
                JP PATCH_OUT0_2_CODE
                NOP
                ASSERT $ == PATCH_OUT0_2_END

                ORG PATCH_OUT0_3
                IN A, (PORT_00)
                AND #14
                OUT (PORT_00), A
                ASSERT $ == PATCH_OUT0_3_END

                ORG PATCH_OUT0_4

; 0______0  OUT 60, ret
; 0______1  OUT 60, pop af, ret
; 1______0  OUT 41, ret
; 1______1  OUT 41, pop af, ret

                ld      a, (SCREEN_4000)
                AND #81
                JP Z, FIXED_OUT_60_RET
                CP #1
                JP Z, FIXED_OUT_60_POP_RET
                CP #80
                JP Z, FIXED_OUT_41_RET
                JP FIXED_OUT_41_POP_RET
                NOP : NOP
                ASSERT $ == PATCH_OUT0_4_END

                ORG PATCH_OUT0_5
                JP PATCH_OUT0_5_CODE