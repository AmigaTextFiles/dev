VERSION  EQU 39
REVISION EQU 3
DATE     MACRO
          dc.b '23.4.2002'
         ENDM
VERS     MACRO
          dc.b 'suomi.language 39.3'
         ENDM
VSTRING  MACRO
          dc.b 'suomi.language 39.3 (23.4.2002)',13,10,0
         ENDM
VERSTAG  MACRO
          dc.b 0,'$VER: suomi.language 39.3 (23.4.2002)',0
         ENDM
