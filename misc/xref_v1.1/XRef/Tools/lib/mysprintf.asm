;
; $PROJECT: xrefsupport.lib
;
; $VER: mysprintf.asm 1.1 (08.09.94)
;
; by
;
; Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
;
; (C) Copyright 1994
; All Rights Reserved !
;
; $HISTORY:
;
; 08.09.94 : 001.001 :  initial
;

   xref _LVORawDoFmt

; my asm functions

   xdef __mysprintf

   section code

; ULONG mysprintf(REGA3 STRPTR buffer,REGA0 fmt,REGA1 APTR data,REGA6 struct Library *SysBase)
__mysprintf:
   movem.l a2,-(sp)

   lea.l   stuffChar(pc),a2
   jsr     _LVORawDoFmt(a6)

   movem.l (sp)+,a2
   rts

;------ PutChProc function used by RawDoFmt -----------
stuffChar:
   move.b  d0,(a3)+        ;Put data to output string
   rts

   end

