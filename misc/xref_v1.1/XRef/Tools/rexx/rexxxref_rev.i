VERSION         EQU      1
REVISION        EQU      1
DATE    MACRO
                dc.b     '8.1.95'
        ENDM
VERS    MACRO
                dc.b     'rexxxref 1.1'
        ENDM
VSTRING MACRO
                dc.b     'rexxxref 1.1 (8.1.95)',13,10,0
        ENDM
VERSTAG MACRO
                dc.b     0,'$VER: rexxxref 1.1 (8.1.95)',0
        ENDM
