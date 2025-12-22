/*
 *  HotLinksBase.h -- C include file for defining hotlink.library base
 *
 */
 
#ifndef HOTLINK_HOTLINKSBASE_H
#define HOTLINK_HOTLINKSBASE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif EXEC_TYPES_H

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif EXEC_LISTS_H

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif EXEC_LIBRARIES_H

/* hotlink library base data structure */
struct HotLinksBase
{
        struct Library LibNode;
        UBYTE Flags;
        UBYTE Pad;
        ULONG SysLib;
        ULONG DosLib;
        ULONG SegList;
        ULONG ResPort;
};



#endif HOTLINK_HOTLINKSBASE_H
