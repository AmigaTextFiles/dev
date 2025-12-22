@DATABASE "gg:doc/NDK/Guide/Include/datatypes/datatypes.h"
@MASTER   "gg:os-include/datatypes/datatypes.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "datatypes/datatypes.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"datatypes/datatypes.h" LINK File}


@{b}Structures@{ub}

@{"DataType" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 175}  @{"DataTypeHeader" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 40}  @{"DTHookContext" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 124}  @{"Tool" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 145}


@{b}#defines@{ub}

@{"DATATYPE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 174}                        @{"DTERROR_COULDNT_OPEN" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 211}
@{"DTERROR_COULDNT_OPEN_CLIPBOARD" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 215}  @{"DTERROR_COULDNT_SAVE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 210}
@{"DTERROR_COULDNT_SEND_MESSAGE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 212}    @{"DTERROR_INVALID_DATA" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 219}
@{"DTERROR_NOT_AVAILABLE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 222}           @{"DTERROR_NOT_ENOUGH_DATA" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 218}
@{"DTERROR_Reserved" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 216}                @{"DTERROR_UNKNOWN_COMPRESSION" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 217}
@{"DTERROR_UNKNOWN_DATATYPE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 209}        @{"DTHSIZE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 54}
@{"DTMSG_TYPE_OFFSET" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 225}               @{"DTNSIZE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 187}
@{"GID_ANIMATION" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 111}                   @{"GID_DOCUMENT" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 96}
@{"GID_INSTRUMENT" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 102}                  @{"GID_MOVIE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 114}
@{"GID_MUSIC" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 105}                       @{"GID_PICTURE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 108}
@{"GID_SOUND" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 99}                       @{"GID_TEXT" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 93}
@{"ID_CODE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 120}                         @{"ID_DTHD" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 38}
@{"ID_DTYP" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 34}                         @{"ID_TOOL" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 143}
@{"TNSIZE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 198}                          @{"TSIZE" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypes.h/File" 152}

@ENDNODE
@NODE File "datatypes/datatypes.h"
#ifndef  DATATYPES_DATATYPES_H
#define  DATATYPES_DATATYPES_H
/*
**      $VER: datatypes.h 39.6 (22.4.1993)
**      Includes Release 45.1
**
**      Copyright © 1991-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef  EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif
#ifndef  EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif
#ifndef  LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif
#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif

/*****************************************************************************/

#define ID_DTYP @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('D','T','Y','P')

/*****************************************************************************/

#define ID_DTHD @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('D','T','H','D')

struct DataTypeHeader
{
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}       dth_Name;                              /* Descriptive name of the data type */
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}       dth_BaseName;                          /* Base name of the data type */
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}       dth_Pattern;                           /* Match pattern for file name. */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}        *dth_Mask;                              /* Comparision mask */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        dth_GroupID;                           /* Group that the DataType is in */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        dth_ID;                                /* ID for DataType (same as IFF FORM type) */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}         dth_MaskLen;                           /* Length of comparision mask */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}         dth_Pad;                               /* Unused at present (must be 0) */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        dth_Flags;                             /* Flags */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        dth_Priority;                          /* Priority */
};

#define DTHSIZE sizeof(@{"struct DataTypeHeader" LINK File 40})

/*****************************************************************************/

/* Basic type */
#define DTF_TYPE_MASK   0x000F
#define DTF_BINARY      0x0000
#define DTF_ASCII       0x0001
#define DTF_IFF         0x0002
#define DTF_MISC        0x0003

/* Set if case is important */
#define DTF_CASE        0x0010

/* Reserved for system use */
#define DTF_SYSTEM1     0x1000

/*****************************************************************************
 *
 * GROUP ID and ID
 *
 * This is used for filtering out objects that you don't want.  For
 * example, you could make a filter for the ASL file requester so
 * that it only showed the files that were pictures, or even to
 * narrow it down to only show files that were ILBM pictures.
 *
 * Note that the Group ID's are in lower case, and always the first
 * four characters of the word.
 *
 * For ID's; If it is an IFF file, then the ID is the same as the
 * FORM type.  If it isn't an IFF file, then the ID would be the
 * first four characters of name for the file type.
 *
 *****************************************************************************/

/* System file, such as; directory, executable, library, device, font, etc. */
#define GID_SYSTEM      MAKE_ID ('s','y','s','t')

/* Formatted or unformatted text */
#define GID_TEXT        @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182} ('t','e','x','t')

/* Formatted text with graphics or other DataTypes */
#define GID_DOCUMENT    @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182} ('d','o','c','u')

/* Sound */
#define GID_SOUND       @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182} ('s','o','u','n')

/* Musical instruments used for musical scores */
#define GID_INSTRUMENT  @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182} ('i','n','s','t')

/* Musical score */
#define GID_MUSIC       @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182} ('m','u','s','i')

/* Still picture */
#define GID_PICTURE     @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182} ('p','i','c','t')

/* Animated picture */
#define GID_ANIMATION   @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182} ('a','n','i','m')

/* Animation with audio track */
#define GID_MOVIE       @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182} ('m','o','v','i')

/*****************************************************************************/

/* A code chunk contains an embedded executable that can be loaded
 * with @{"InternalLoadSeg" LINK "gg:doc/NDK/Guide/dos/InternalLoadSeg"}. */
#define ID_CODE @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('D','T','C','D')

/* DataTypes comparision hook context (Read-Only).  This is the
 * argument that is passed to a custom comparision routine. */
struct DTHookContext
{
    /* Libraries that are already opened for your use */
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}              *dthc_SysBase;
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}              *dthc_DOSBase;
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}              *dthc_IFFParseBase;
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}              *dthc_UtilityBase;

    /* File context */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                         dthc_Lock;             /* Lock on the file */
    @{"struct FileInfoBlock" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 61}        *dthc_FIB;              /* Pointer to a FileInfoBlock */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                         dthc_FileHandle;       /* Pointer to the file handle (may be @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}) */
    @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44}            *dthc_IFF;              /* Pointer to an IFFHandle (may be @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}) */
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}                       dthc_Buffer;           /* Buffer */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                        dthc_BufferLength;     /* Length of the buffer */
};

/*****************************************************************************/

#define ID_TOOL @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('D','T','T','L')

struct Tool
{
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        tn_Which;                              /* Which tool is this */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        tn_Flags;                              /* Flags */
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}       tn_Program;                            /* Application to use */
};

#define TSIZE   sizeof(@{"struct Tool" LINK File 145})

/* defines for tn_Which */
#define TW_INFO                 1
#define TW_BROWSE               2
#define TW_EDIT                 3
#define TW_PRINT                4
#define TW_MAIL                 5

/* defines for tn_Flags */
#define TF_LAUNCH_MASK          0x000F
#define TF_SHELL                0x0001
#define TF_WORKBENCH            0x0002
#define TF_RX                   0x0003

/*****************************************************************************/

#define ID_TAGS MAKE_ID('D','T','T','G')

/*****************************************************************************/

#ifndef DATATYPE
#define DATATYPE
struct DataType
{
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}                  dtn_Node1;             /* Reserved for system use */
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}                  dtn_Node2;             /* Reserved for system use */
    @{"struct DataTypeHeader" LINK File 40}       *dtn_Header;            /* Pointer to the DataTypeHeader */
    @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}                  dtn_ToolList;          /* List of tool nodes */
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}                       dtn_FunctionName;      /* Name of comparision routine */
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32}              *dtn_AttrList;          /* Object creation tags */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                        dtn_Length;            /* Length of the memory block */
};
#endif

#define DTNSIZE sizeof(@{"struct DataType" LINK File 175})

/*****************************************************************************/

struct ToolNode
{
    struct Node  tn_Node;                               /* Embedded node */
    @{"struct Tool" LINK File 145}  tn_Tool;                               /* Embedded tool */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        tn_Length;                             /* Length of the memory block */
};

#define TNSIZE  sizeof(struct ToolNode)

/*****************************************************************************/

#ifndef ID_NAME
#define ID_NAME MAKE_ID('N','A','M','E')
#endif

/*****************************************************************************/

/* Text ID's */
#define DTERROR_UNKNOWN_DATATYPE                2000
#define DTERROR_COULDNT_SAVE                    2001
#define DTERROR_COULDNT_OPEN                    2002
#define DTERROR_COULDNT_SEND_MESSAGE            2003

/* New for V40 */
#define DTERROR_COULDNT_OPEN_CLIPBOARD          2004
#define DTERROR_Reserved                        2005
#define DTERROR_UNKNOWN_COMPRESSION             2006
#define DTERROR_NOT_ENOUGH_DATA                 2007
#define DTERROR_INVALID_DATA                    2008

/* New for V44 */
#define DTERROR_NOT_AVAILABLE                   2009

/* Offset for types */
#define DTMSG_TYPE_OFFSET                       2100

/*****************************************************************************/

#endif   /* DATATYPES_DATATYPES_H */
@ENDNODE
