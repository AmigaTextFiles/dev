;
; ** $VER: rpattr.h 39.2 (31.5.93)
; ** Includes Release 40.15
; **
; ** tag definitions for GetRPAttr, SetRPAttr
; **
;

#RPTAG_Font  = $80000000  ;  get/set font
#RPTAG_APen  = $80000002  ;  get/set apen
#RPTAG_BPen  = $80000003  ;  get/set bpen
#RPTAG_DrMd  = $80000004  ;  get/set draw mode
#RPTAG_OutLinePen = $80000005 ;  get/set outline pen
#RPTAG_OutlinePen = $80000005 ;  get/set outline pen. corrected case.
#RPTAG_WriteMask = $80000006 ;  get/set WriteMask
#RPTAG_MaxPen  = $80000007 ;  get/set maxpen

#RPTAG_DrawBounds = $80000008 ;  get only rastport draw bounds. pass &rect

