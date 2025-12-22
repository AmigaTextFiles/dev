/* $Id: videocontrol.h,v 1.12 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/utility/tagitem'
{#include <graphics/videocontrol.h>}
NATIVE {GRAPHICS_VIDEOCONTROL_H} CONST

NATIVE {VTAG_END_CM}                   CONST VTAG_END_CM                   = $00000000
NATIVE {VTAG_CHROMAKEY_CLR}            CONST VTAG_CHROMAKEY_CLR            = $80000000
NATIVE {VTAG_CHROMAKEY_SET}            CONST VTAG_CHROMAKEY_SET            = $80000001
NATIVE {VTAG_BITPLANEKEY_CLR}          CONST VTAG_BITPLANEKEY_CLR          = $80000002
NATIVE {VTAG_BITPLANEKEY_SET}          CONST VTAG_BITPLANEKEY_SET          = $80000003
NATIVE {VTAG_BORDERBLANK_CLR}          CONST VTAG_BORDERBLANK_CLR          = $80000004
NATIVE {VTAG_BORDERBLANK_SET}          CONST VTAG_BORDERBLANK_SET          = $80000005
NATIVE {VTAG_BORDERNOTRANS_CLR}        CONST VTAG_BORDERNOTRANS_CLR        = $80000006
NATIVE {VTAG_BORDERNOTRANS_SET}        CONST VTAG_BORDERNOTRANS_SET        = $80000007
NATIVE {VTAG_CHROMA_PEN_CLR}           CONST VTAG_CHROMA_PEN_CLR           = $80000008
NATIVE {VTAG_CHROMA_PEN_SET}           CONST VTAG_CHROMA_PEN_SET           = $80000009
NATIVE {VTAG_CHROMA_PLANE_SET}         CONST VTAG_CHROMA_PLANE_SET         = $8000000A
NATIVE {VTAG_ATTACH_CM_SET}            CONST VTAG_ATTACH_CM_SET            = $8000000B
NATIVE {VTAG_NEXTBUF_CM}               CONST VTAG_NEXTBUF_CM               = $8000000C
NATIVE {VTAG_BATCH_CM_CLR}             CONST VTAG_BATCH_CM_CLR             = $8000000D
NATIVE {VTAG_BATCH_CM_SET}             CONST VTAG_BATCH_CM_SET             = $8000000E
NATIVE {VTAG_NORMAL_DISP_GET}          CONST VTAG_NORMAL_DISP_GET          = $8000000F
NATIVE {VTAG_NORMAL_DISP_SET}          CONST VTAG_NORMAL_DISP_SET          = $80000010
NATIVE {VTAG_COERCE_DISP_GET}          CONST VTAG_COERCE_DISP_GET          = $80000011
NATIVE {VTAG_COERCE_DISP_SET}          CONST VTAG_COERCE_DISP_SET          = $80000012
NATIVE {VTAG_VIEWPORTEXTRA_GET}        CONST VTAG_VIEWPORTEXTRA_GET        = $80000013
NATIVE {VTAG_VIEWPORTEXTRA_SET}        CONST VTAG_VIEWPORTEXTRA_SET        = $80000014
NATIVE {VTAG_CHROMAKEY_GET}            CONST VTAG_CHROMAKEY_GET            = $80000015
NATIVE {VTAG_BITPLANEKEY_GET}          CONST VTAG_BITPLANEKEY_GET          = $80000016
NATIVE {VTAG_BORDERBLANK_GET}          CONST VTAG_BORDERBLANK_GET          = $80000017
NATIVE {VTAG_BORDERNOTRANS_GET}        CONST VTAG_BORDERNOTRANS_GET        = $80000018
NATIVE {VTAG_CHROMA_PEN_GET}           CONST VTAG_CHROMA_PEN_GET           = $80000019
NATIVE {VTAG_CHROMA_PLANE_GET}         CONST VTAG_CHROMA_PLANE_GET         = $8000001A
NATIVE {VTAG_ATTACH_CM_GET}            CONST VTAG_ATTACH_CM_GET            = $8000001B
NATIVE {VTAG_BATCH_CM_GET}             CONST VTAG_BATCH_CM_GET             = $8000001C
NATIVE {VTAG_BATCH_ITEMS_GET}          CONST VTAG_BATCH_ITEMS_GET          = $8000001D
NATIVE {VTAG_BATCH_ITEMS_SET}          CONST VTAG_BATCH_ITEMS_SET          = $8000001E
NATIVE {VTAG_BATCH_ITEMS_ADD}          CONST VTAG_BATCH_ITEMS_ADD          = $8000001F
NATIVE {VTAG_VPMODEID_GET}             CONST VTAG_VPMODEID_GET             = $80000020
NATIVE {VTAG_VPMODEID_SET}             CONST VTAG_VPMODEID_SET             = $80000021
NATIVE {VTAG_VPMODEID_CLR}             CONST VTAG_VPMODEID_CLR             = $80000022
NATIVE {VTAG_USERCLIP_GET}             CONST VTAG_USERCLIP_GET             = $80000023
NATIVE {VTAG_USERCLIP_SET}             CONST VTAG_USERCLIP_SET             = $80000024
NATIVE {VTAG_USERCLIP_CLR}             CONST VTAG_USERCLIP_CLR             = $80000025
/* The following tags are V39 specific. They will be ignored
   (returing error -3) by earlier versions */
NATIVE {VTAG_PF1_BASE_GET}             CONST VTAG_PF1_BASE_GET             = $80000026
NATIVE {VTAG_PF2_BASE_GET}             CONST VTAG_PF2_BASE_GET             = $80000027
NATIVE {VTAG_SPEVEN_BASE_GET}          CONST VTAG_SPEVEN_BASE_GET          = $80000028
NATIVE {VTAG_SPODD_BASE_GET}           CONST VTAG_SPODD_BASE_GET           = $80000029
NATIVE {VTAG_PF1_BASE_SET}             CONST VTAG_PF1_BASE_SET             = $8000002a
NATIVE {VTAG_PF2_BASE_SET}             CONST VTAG_PF2_BASE_SET             = $8000002b
NATIVE {VTAG_SPEVEN_BASE_SET}          CONST VTAG_SPEVEN_BASE_SET          = $8000002c
NATIVE {VTAG_SPODD_BASE_SET}           CONST VTAG_SPODD_BASE_SET           = $8000002d
NATIVE {VTAG_BORDERSPRITE_GET}         CONST VTAG_BORDERSPRITE_GET         = $8000002e
NATIVE {VTAG_BORDERSPRITE_SET}         CONST VTAG_BORDERSPRITE_SET         = $8000002f
NATIVE {VTAG_BORDERSPRITE_CLR}         CONST VTAG_BORDERSPRITE_CLR         = $80000030
NATIVE {VTAG_SPRITERESN_SET}           CONST VTAG_SPRITERESN_SET           = $80000031
NATIVE {VTAG_SPRITERESN_GET}           CONST VTAG_SPRITERESN_GET           = $80000032
NATIVE {VTAG_PF1_TO_SPRITEPRI_SET}     CONST VTAG_PF1_TO_SPRITEPRI_SET     = $80000033
NATIVE {VTAG_PF1_TO_SPRITEPRI_GET}     CONST VTAG_PF1_TO_SPRITEPRI_GET     = $80000034
NATIVE {VTAG_PF2_TO_SPRITEPRI_SET}     CONST VTAG_PF2_TO_SPRITEPRI_SET     = $80000035
NATIVE {VTAG_PF2_TO_SPRITEPRI_GET}     CONST VTAG_PF2_TO_SPRITEPRI_GET     = $80000036
NATIVE {VTAG_IMMEDIATE}                CONST VTAG_IMMEDIATE                = $80000037
NATIVE {VTAG_FULLPALETTE_SET}          CONST VTAG_FULLPALETTE_SET          = $80000038
NATIVE {VTAG_FULLPALETTE_GET}          CONST VTAG_FULLPALETTE_GET          = $80000039
NATIVE {VTAG_FULLPALETTE_CLR}          CONST VTAG_FULLPALETTE_CLR          = $8000003A
NATIVE {VTAG_DEFSPRITERESN_SET}        CONST VTAG_DEFSPRITERESN_SET        = $8000003B
NATIVE {VTAG_DEFSPRITERESN_GET}        CONST VTAG_DEFSPRITERESN_GET        = $8000003C

/* all the following tags follow the new, rational standard for
 * videocontrol tags:
 * VC_xxx,state        set the state of attribute 'xxx' to value 'state'
 * VC_xxx_QUERY,&var   get the state of attribute 'xxx' and store it into
 *                     the longword pointed to by &var.
 *
 * The following are new for V40:
 */

NATIVE {VC_IntermediateCLUpdate}       CONST VC_INTERMEDIATECLUPDATE       = $80000080
    /* default=true. When set graphics will update the intermediate copper
     * lists on color changes, etc. When false, it won't, and will be faster.
     */
NATIVE {VC_IntermediateCLUpdate_Query} CONST VC_INTERMEDIATECLUPDATE_QUERY = $80000081

NATIVE {VC_NoColorPaletteLoad}         CONST VC_NOCOLORPALETTELOAD         = $80000082
    /* default = false. When set, graphics will only load color 0
     * for this ViewPort, and so the ViewPort's colors will come
     * from the previous ViewPort's.
     *
     * NB - Using this tag and VTAG_FULLPALETTE_SET together is undefined.
     */
NATIVE {VC_NoColorPaletteLoad_Query}   CONST VC_NOCOLORPALETTELOAD_QUERY   = $80000083

NATIVE {VC_DUALPF_Disable}             CONST VC_DUALPF_DISABLE             = $80000084
    /* default = false. When this flag is set, the dual-pf bit
       in Dual-Playfield screens will be turned off. Even bitplanes
       will still come from the first BitMap and odd bitplanes
       from the second BitMap, and both R[xy]Offsets will be
       considered. This can be used (with appropriate palette
       selection) for cross-fades between differently scrolling
       images.
       When this flag is turned on, colors will be loaded for
       the viewport as if it were a single viewport of depth
       depth1+depth2 */
NATIVE {VC_DUALPF_Disable_Query}       CONST VC_DUALPF_DISABLE_QUERY       = $80000085
