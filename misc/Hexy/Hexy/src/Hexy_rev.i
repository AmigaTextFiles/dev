
; StampSource 1.2 by Andrew Bell was here :)

VERSION  EQU 1
REVISION EQU 6
DATE     MACRO
         dc.b '22.08.99'
         ENDM
VERS     MACRO
         dc.b 'Hexy 1.6'
         ENDM
VSTRING  MACRO
         dc.b 'Hexy 1.6 (22.08.99)'
         ENDM
VERSTAG  MACRO
         dc.b 0,'$VER: Hexy 1.6 (22.08.99)'
         ENDM

