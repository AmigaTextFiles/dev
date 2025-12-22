@DATABASE "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h"
@MASTER   "gg:os-include/gadgets/datebrowser.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:25
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/datebrowser.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/datebrowser.h" LINK File}


@{b}#defines@{ub}

@{"DATEBROWSER_Day" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 38}        @{"DATEBROWSER_DayTitles" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 100}     @{"DATEBROWSER_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 36}
@{"DATEBROWSER_FirstWDay" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 70}  @{"DATEBROWSER_Month" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 44}         @{"DATEBROWSER_MultiSelect" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 95}
@{"DATEBROWSER_NumDays" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 77}    @{"DATEBROWSER_SelectedDays" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 55}  @{"DATEBROWSER_ShowTitle" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 84}
@{"DATEBROWSER_WeekDay" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 63}    @{"DATEBROWSER_Year" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 49}          @{"DateBrowserObject" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 28}
@{"EndDateBrowser" LINK "gg:doc/NDK/Guide/Include/gadgets/datebrowser.h/File" 31}         

@ENDNODE
@NODE File "gadgets/datebrowser.h"
#ifndef GADGETS_DATEBROWSER_H
#define GADGETS_DATEBROWSER_H
/*
**      $VER: datebrowser.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the @{"datebrowser.gadget" LINK "gg:doc/NDK/Guide/datebrowser_gc/MAIN"} BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <@{"intuition/gadgetclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File"}>
#endif

/*****************************************************************************/

/* Object creation macro to ease readability of layout groups, etc.
 */
#ifndef DateBrowserObject
#define DateBrowserObject NewObject( @{"DATEBROWSER_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 23}(), @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}
#endif
#ifndef EndDateBrowser
#define EndDateBrowser    @{"TAG_DONE" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 39})
#endif

/* Additional attributes defined by the @{"datebrowser.gadget" LINK "gg:doc/NDK/Guide/datebrowser_gc/MAIN"} class
 */
#define DATEBROWSER_Dummy                       (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x61000)

#define DATEBROWSER_Day                         (@{"DATEBROWSER_Dummy" LINK File 36})
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * Selected/Current day of the month. Defaults to 1, which
         * is the first of the current month.
         */

#define DATEBROWSER_Month                       (@{"DATEBROWSER_Dummy" LINK File 36} + 1)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * Calendar month to display. Defaults to 1, which is January.
         */

#define DATEBROWSER_Year                        (@{"DATEBROWSER_Dummy" LINK File 36} + 2)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * Calendar year to display. Defaults to 1978, which is
         * a long time ago now, back when dinosaurs walked the earth.
         */

#define DATEBROWSER_SelectedDays        (@{"DATEBROWSER_Dummy" LINK File 36} + 3)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * A 32 bit value, each bit represents a day of the month,
         * if set, the corrisponding calendar day is selected.
         * This is useful for multi-select mode to find out what
         * days are selected via one packed return value.
         */

#define DATEBROWSER_WeekDay                     (@{"DATEBROWSER_Dummy" LINK File 36} + 4)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * Returns the day of the week for the currently
         * selected '@{"DATEBROWSER_Day" LINK File 38}'. A better solution may be
         * using datebrowser's public julian date functions.
         */

#define DATEBROWSER_FirstWDay           (@{"DATEBROWSER_Dummy" LINK File 36} + 5)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * Returns the day of the week the first of the month
         * will fall on with the julian calendar.
         * Starting with 0 for Sunday, and 6 for Saterday.
         */

#define DATEBROWSER_NumDays                     (@{"DATEBROWSER_Dummy" LINK File 36} + 6)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * Returns the number of days in the currently set month.
         * A better solution may be using datebrowser's public
         * julian date functions.
         */

#define DATEBROWSER_ShowTitle           (@{"DATEBROWSER_Dummy" LINK File 36} + 7)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * Enables display of the week-day title bar.
         * NOTE: If turned ON after layout group creation, you must be sure
         * to @{"FlushLayoutDomainCache()" LINK "gg:doc/NDK/Guide/layout_gc/FlushLayoutDomainCache"} and @{"RethinkLayout()" LINK "gg:doc/NDK/Guide/layout_gc/RethinkLayout"}, and potentially
         * increase the window size to accomodate the possibly larger layout.
         * Simply toggling iconify on/off, or close & open of the window
         * class will achieve simular results.
         * NOTE: If using a recent window.class you should use @{"WM_RETHINK" LINK "gg:doc/NDK/Guide/window_cl/WM_RETHINK"}!!
         */

#define DATEBROWSER_MultiSelect         (@{"DATEBROWSER_Dummy" LINK File 36} + 8)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
         * Enables multi-selection of calendar days.
         */

#define DATEBROWSER_DayTitles           (@{"DATEBROWSER_Dummy" LINK File 36} + 9)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} *) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70}
         * Pointer to an array of @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} containing day titles.
         * Defaults to non-localized internal "Mon", "Tue", etc.
         */

#endif /* GADGETS_DATEBROWSER_H */
@ENDNODE
