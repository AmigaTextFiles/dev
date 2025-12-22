/* $VER: clipboard.h 36.5 (2.11.1990) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes', 'target/exec/lists', 'target/exec/ports'
MODULE 'target/exec/io', 'target/exec/devices'
{MODULE 'devices/clipboard'}

NATIVE {CBD_POST}		CONST CBD_POST		= (CMD_NONSTD+0)
NATIVE {CBD_CURRENTREADID}	CONST CBD_CURRENTREADID	= (CMD_NONSTD+1)
NATIVE {CBD_CURRENTWRITEID}	CONST CBD_CURRENTWRITEID	= (CMD_NONSTD+2)
NATIVE {CBD_CHANGEHOOK}		CONST CBD_CHANGEHOOK		= (CMD_NONSTD+3)

NATIVE {CBERR_OBSOLETEID}	CONST CBERR_OBSOLETEID	= 1


NATIVE {clipboardunitpartial} OBJECT clipboardunitpartial
    {node}	node	:ln	/* list of units */
    {unitnum}	unitnum	:ULONG		/* unit number for this unit */
    /* the remaining unit data is private to the device */
ENDOBJECT


NATIVE {ioclipreq} OBJECT ioclipreq
    {message}	message	:mn
    {device}	device	:PTR TO dd	/* device node pointer	*/
    {unit}	unit	:PTR TO clipboardunitpartial /* unit node pointer */
    {command}	command	:UINT		/* device command */
    {flags}	flags	:UBYTE		/* including QUICK and SATISFY */
    {error}	error	:BYTE		/* error or warning num */
    {actual}	actual	:ULONG		/* number of bytes transferred */
    {length}	length	:ULONG		/* number of bytes requested */
    {data}	data	:ARRAY OF CHAR /*STRPTR*/		/* either clip stream or post port */
    {offset}	offset	:ULONG		/* offset in clip stream */
    {clipid}	clipid	:VALUE		/* ordinal clip identifier */
ENDOBJECT

NATIVE {PRIMARY_CLIP}	CONST PRIMARY_CLIP	= 0	/* primary clip unit */

NATIVE {satisfymsg} OBJECT satisfymsg
    {msg}	msg	:mn	/* the length will be 6 */
    {unit}	unit	:UINT		/* which clip unit this is */
    {clipid}	clipid	:VALUE		/* the clip identifier of the post */
ENDOBJECT

NATIVE {cliphookmsg} OBJECT cliphookmsg
    {type}	type	:ULONG		/* zero for this structure format */
    {changecmd}	changecmd	:VALUE	/* command that caused this hook invocation: */
				/*   either CMD_UPDATE or CBD_POST */
    {clipid}	clipid	:VALUE		/* the clip identifier of the new data */
ENDOBJECT
