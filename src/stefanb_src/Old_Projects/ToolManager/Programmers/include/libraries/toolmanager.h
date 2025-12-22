#ifndef LIBRARIES_TOOLMANAGER_H
#define LIBRARIES_TOOLMANAGER_H

/*
 * libraries/toolmanager.h  V2.1
 *
 * shared library include file
 *
 * (c) 1990-1993 Stefan Becker
 */

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#define TMLIBNAME     "toolmanager.library"
#define TMLIBVERSION  3

/* ToolManager Object Types */
#define TMOBJTYPE_EXEC   0
#define TMOBJTYPE_IMAGE  1
#define TMOBJTYPE_SOUND  2
#define TMOBJTYPE_MENU   3
#define TMOBJTYPE_ICON   4
#define TMOBJTYPE_DOCK   5
#define TMOBJTYPE_ACCESS 6
#define TMOBJTYPES       7

/* ToolManager Object Properties (see Object.doc) */

/* Type: TMOBJTYPE_EXEC */
#define TMOP_Arguments  (TAG_USER +    1)
#define TMOP_Command    (TAG_USER +    2) /* Also used for TMOBJTYPE_SOUND */
#define TMOP_CurrentDir (TAG_USER +    3)
#define TMOP_Delay      (TAG_USER +    4)
#define TMOP_ExecType   (TAG_USER +    5)
#define TMOP_HotKey     (TAG_USER +    6) /* Also used for TMOBJTYPE_DOCK */
#define TMOP_Output     (TAG_USER +    7)
#define TMOP_Path       (TAG_USER +    8)
#define TMOP_Priority   (TAG_USER +    9)
#define TMOP_PubScreen  (TAG_USER +   10) /* Also used for TMOBJTYPE_DOCK */
#define TMOP_Stack      (TAG_USER +   11)
#define TMOP_ToFront    (TAG_USER +   12)

/* Type: TMOBJTYPE_IMAGE */
#define TMOP_File       (TAG_USER +  257)
#define TMOP_Data       (TAG_USER +  258)

/* Type: TMOBJTYPE_SOUND */
#define TMOP_Port       (TAG_USER +  513)

/* Type: TMOBJTYPE_MENU/ICON */
#define TMOP_Exec       (TAG_USER +  769)
#define TMOP_Sound      (TAG_USER +  770)

/* Type: TMOBJTYPE_ICON */
#define TMOP_Image      (TAG_USER + 1025)
#define TMOP_ShowName   (TAG_USER + 1026)

/* Type: TMOBJTYPE_ICON/DOCK */
#define TMOP_LeftEdge   (TAG_USER + 1281)
#define TMOP_TopEdge    (TAG_USER + 1282)

/* Type: TMOBJTYPE_DOCK */
#define TMOP_Activated  (TAG_USER + 1536)
#define TMOP_Centered   (TAG_USER + 1537)
#define TMOP_Columns    (TAG_USER + 1538)
#define TMOP_Font       (TAG_USER + 1539)
#define TMOP_FrontMost  (TAG_USER + 1540)
#define TMOP_Menu       (TAG_USER + 1541)
#define TMOP_Pattern    (TAG_USER + 1542)
#define TMOP_PopUp      (TAG_USER + 1543)
#define TMOP_Text       (TAG_USER + 1544)
#define TMOP_Title      (TAG_USER + 1545)
#define TMOP_Tool       (TAG_USER + 1546)
#define TMOP_Vertical   (TAG_USER + 1547)
#define TMOP_Backdrop   (TAG_USER + 1548)
#define TMOP_Sticky     (TAG_USER + 1549)

/* Type: TMOBJTYPE_ACCESS */
/* None defined yet... */

/* Types for TMOP_ExecType */
#define TMET_CLI       0
#define TMET_WB        1
#define TMET_ARexx     2
#define TMET_Dock      3
#define TMET_HotKey    4
#define TMET_Network   5
#define TMET_Hook    100

/* Data structures for storing image sequences (TMOBJTYPE_IMAGE/TMOP_Data) */
/* TMImageNode contains the data for ONE picture. Several nodes are joined */
/* into a single-linked chain via tmin_Next.                               */
struct TMImageNode {
                    struct TMImageNode *tmin_Next; /* pointer to next node */
                    UWORD              *tmin_Data; /* MEMF_CHIP memory!!   */
                   };

/* TMImageData contains information about the image data, like sizes etc.   */
/* You MUST initialize BOTH Image structures and they MUST BE identical     */
/* except of the ImageData pointer. tmid_Normal.ImageData should point to   */
/* an image data which shows the inactive state and tmid_Selected.ImageData */
/* should point to an image which shows the active state.                   */
struct TMImageData {
                    struct Image        tmid_Normal;   /* inactive state  */
                    struct Image        tmid_Selected; /* active state    */
                    struct TMImageNode *tmid_Data;     /* chain of images */
                   };

#endif /* LIBRARIES_TOOLMANAGER_H */
