@DATABASE "gg:doc/NDK/Guide/Include/graphics/rpattr.h"
@MASTER   "gg:os-include/graphics/rpattr.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/rpattr.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/rpattr.h" LINK File}


@{b}#defines@{ub}

@{"RPTAG_APen" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 12}    @{"RPTAG_BPen" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 13}        @{"RPTAG_DrawBounds" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 20}  @{"RPTAG_DrMd" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 14}       @{"RPTAG_Font" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 11}
@{"RPTAG_MaxPen" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 18}  @{"RPTAG_OutLinePen" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 15}  @{"RPTAG_OutlinePen" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 16}  @{"RPTAG_WriteMask" LINK "gg:doc/NDK/Guide/Include/graphics/rpattr.h/File" 17}  

@ENDNODE
@NODE File "graphics/rpattr.h"
#ifndef GRAPHICS_RPATTR_H
#define GRAPHICS_RPATTR_H
/*
**      $VER: rpattr.h 39.2 (31.5.1993)
**      Includes Release 45.1
**
**      tag definitions for GetRPAttr, SetRPAttr
**
*/

#define RPTAG_Font              0x80000000              /* get/set font */
#define RPTAG_APen              0x80000002              /* get/set apen */
#define RPTAG_BPen              0x80000003              /* get/set bpen */
#define RPTAG_DrMd              0x80000004              /* get/set draw mode */
#define RPTAG_OutLinePen        0x80000005      /* get/set outline pen */
#define RPTAG_OutlinePen        0x80000005      /* get/set outline pen. corrected case. */
#define RPTAG_WriteMask 0x80000006      /* get/set WriteMask */
#define RPTAG_MaxPen            0x80000007      /* get/set maxpen */

#define RPTAG_DrawBounds        0x80000008      /* get only rastport draw bounds. pass &rect */

#endif  /* GRAPHICS_RPATTR_H */
@ENDNODE
