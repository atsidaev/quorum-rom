FIX_OUT_A_RUN_BASIC_128:
                LD C, A
                IN A, (PORT_00)
                AND #14
                OR C
                jp      #FFFD ; out (PORT_00), A8 + JP 00

OUT_0_FROM_NMI48:
                IN A, (PORT_00)
                AND #14
                OUT (PORT_00), A
                JP RETURN_FROM_PATCH_NMI48

PATCH_OUT0_1_CODE:
                LD C, A
                IN A, (PORT_00)
                AND #14
                OR C
                JP OUT_0_A_SWITCH_TO_BASIC_ROM

PATCH_OUT0_2_CODE:
                IN A, (PORT_00)
                AND #14
                OR #20
                OUT (PORT_00), A
                JP PATCH_OUT0_2_END

PATCH_OUT0_3_CODE:
                AND #14
                OUT (PORT_00), A
                jp      loc_34B

PATCH_OUT0_4_CODE:
                IN A, (PORT_00)
                AND #14
                POP BC ; old AF there
                OR B
                LD C, A
                POP AF
                LD A, C
                POP BC
                jp      nz, OUT_0_A_POP_AF_RET
                jp      OUT_0_RET

PATCH_OUT0_5_CODE:
                IN A, (PORT_00)
                AND #14
                OR #0E
                JP OUT_0_A_JP_3D2F

FIXED_OUT_60_RET:
                IN A, (PORT_00)
                AND #14
                OR #60
                JR _exit1
FIXED_OUT_41_RET:
                IN A, (PORT_00)
                AND #14
                OR #41
_exit1:
                JP OUT_0_RET
FIXED_OUT_60_POP_RET:
                IN A, (PORT_00)
                AND #14
                OR #60
                JR _exit2
FIXED_OUT_41_POP_RET:
                IN A, (PORT_00)
                AND #14
                OR #41
_exit2:
                JP OUT_0_A_POP_AF_RET