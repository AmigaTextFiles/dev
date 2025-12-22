/* $VER: clipboard.h 36.5 (2.11.1990) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes', 'target/exec/lists', 'target/exec/ports'
MODULE 'target/exec/io', 'target/exec/devices'
{#include <devices/clipboard.h>}
NATIVE {DEVICES_CLIPBOARD_H} CONST

NATIVE {CBD_POST}		CONST CBD_POST		= (CMD_NONSTD+0)
NATIVE {CBD_CURRENTREADID}	CONST CBD_CURRENTREADID	= (CMD_NONSTD+1)
NATIVE {CBD_CURRENTWRITEID}	CONST CBD_CURRENTWRITEID	= (CMD_NONSTD+2)
NATIVE {CBD_CHANGEHOOK}		CONST CBD_CHANGEHOOK		= (CMD_NONSTD+3)

NATIVE {CBERR_OBSOLETEID}	CONST CBERR_OBSOLETEID	= 1


NATIVE {ClipboardUnitPartial} OBJECT clipboardunitpartial
    {cu_Node}	node	:ln	/* list of units */
    {cu_UnitNum}	unitnum	:ULONG		/* unit number for this unit */
    /* the remaining unit data is private to the device */
ENDOBJECT


NATIVE {IOClipReq} OBJECT ioclipreq
    {io_Message}	message	:mn
    {io_Device}	device	:PTR TO dd	/* device node pointer	*/
    {io_Unit}	unit	:PTR TO clipboardunitpartial /* unit node pointer */
    {io_Command}	command	:UINT		/* device command */
    {io_Flags}	flags	:UBYTE		/* including QUICK and SATISFY */
    {io_Error}	error	:BYTE		/* error or warning num */
    {io_Actual}	actual	:ULONG		/* number of bytes transferred */
    {io_Length}	length	:ULONG		/* number of bytes requested */
    {io_Data}	data	:ARRAY OF CHAR /*STRPTR*/		/* either clip stream or post port */
    {io_Offset}	offset	:ULONG		/* offset in clip stream */
    {io_ClipID}	clipid	:VALUE		/* ordinal clip identifier */
ENDOBJECT

NATIVE {PRIMARY_CLIP}	CONST PRIMARY_CLIP	= 0	/* primary clip unit */

NATIVE {SatisfyMsg} OBJECT satisfymsg
    {sm_Msg}	msg	:mn	/* the length will be 6 */
    {sm_Unit}	unit	:UINT		/* which clip unit this is */
    {sm_ClipID}	clipid	:VALUE		/* the clip identifier of the post */
ENDOBJECT

NATIVE {ClipHookMsg} OBJECT cliphookmsg
    {chm_Type}	type	:ULONG		/* zero for this structure format */
    {chm_ChangeCmd}	changecmd	:VALUE	/* command that caused this hook invocation: */
				/*   either CMD_UPDATE or CBD_POST */
    {chm_ClipID}	clipid	:VALUE		/* the clip identifier of the new data */
ENDOBJECT
