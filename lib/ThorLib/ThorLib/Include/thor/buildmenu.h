/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.01  10th December 1995     © 1995 THOR-Software inc       **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** BuildMenu: automated menu creator á la GadTools                     **
 **                                                                     **
 ** © 1991,1993,1995 THOR - Software                                    **
 *************************************************************************/

#ifndef BUILDMENU_H
#define BUIDLMENU_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef INTUITION_SCREENS_H
#include <intuition/screens.h>
#endif

/* Defines for Menu-Flags */
#define MC_MENU         ((char)1)
#define MC_MENUITEM     ((char)2)
#define MC_SUBITEM      ((char)3)
#define MC_LASTMENU     ((char)0x81)
#define MC_LASTITEM     ((char)0x82)
#define MC_LASTSUBITEM  ((char)0x83)
#define MC_ISLASTF      7               /* bit for last something */
#define MC_ISFUNCF      6               /* for private use */

struct MenuCommand{
        UBYTE   mc_Type;                /* type see above */
        UBYTE   mc_ShortFlags;          /* flags shortcut */
        char    mc_ComKey;              /* command-key (or 0) */
        char    *mc_Text;               /* Menu text itself */
};

typedef struct MenuCommand __asm *(CmdFetcher)(register __a0 struct MenuBuilder *,register __a1 struct MenuCommand *,register __d0 ULONG counter);
typedef char __asm *(TextFetcher)(register __a0 struct MenuBuilder *,register __a1 struct MenuCommand *);


struct MenuBuilder{
        struct MenuCommand      *mb_FirstCommand;       /* Ptr to first cmd */
        CmdFetcher              *mb_GetNextCommand;     /* set to NULL for default */
        struct Remember         *mb_Memory;             /* do not touch */
        struct Screen           *mb_Screen;             /* Base screen of window, need to know the fonts for 1.3 */
        TextFetcher             *mb_GetString;          /* set to NULL for default */
        void                    *mb_UserPointer;
        UBYTE                    mb_DetailPen;
        UBYTE                    mb_BlockPen;           /* pens, set to 0xff for default */
};

struct Menu __asm *BuildMenuStructs(register __a0 struct MenuBuilder *mb);
void __asm FreeMenuStructs(register __a0 struct MenuBuilder *mb);



