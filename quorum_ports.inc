PORT_FE         EQU #FE
PORT_7FFD       EQU #7FFD

PORT_00         EQU #0
PORT_80         EQU #80 ; VG93 command/status port
PORT_81         EQU #81 ; VG93 track port
PORT_82         EQU #82 ; VG93 sector port
PORT_83         EQU #83 ; VG93 data port
PORT_85         EQU #85 ; FDD controller port

FDD_DRIVE1      EQU #01
FDD_DRIVE2      EQU #02
FDD_DRIVE3      EQU #04
FDD_DRIVE4      EQU #08
FDD_SIDE0       EQU 0
FDD_SIDE1       EQU #10
FDD_MOTOR_OFF   EQU 0
FDD_MOTOR_ON    EQU #20