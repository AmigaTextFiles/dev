/* $Id: clipboard.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/lists', 'target/exec/nodes', 'target/exec/ports', 'target/exec/types'
MODULE 'target/exec/io', 'target/exec/devices'
{#include <devices/clipboard.h>}
NATIVE {DEVICES_CLIPBOARD_H} CONST

NATIVE {ClipboardUnitPartial} OBJECT clipboardunitpartial
    {cu_Node}	node	:ln
    {cu_UnitNum}	unitnum	:ULONG
ENDOBJECT

NATIVE {PRIMARY_CLIP} CONST PRIMARY_CLIP = 0

NATIVE {CBD_POST}           CONST CBD_POST           = (CMD_NONSTD + 0)
NATIVE {CBD_CURRENTREADID}  CONST CBD_CURRENTREADID  = (CMD_NONSTD + 1)
NATIVE {CBD_CURRENTWRITEID} CONST CBD_CURRENTWRITEID = (CMD_NONSTD + 2)
NATIVE {CBD_CHANGEHOOK}     CONST CBD_CHANGEHOOK     = (CMD_NONSTD + 3)

NATIVE {CBR_OBSOLETEID} CONST CBR_OBSOLETEID = 1

NATIVE {IOClipReq} OBJECT ioclipreq
    {io_Message}	message	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO clipboardunitpartial

    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
    {io_Actual}	actual	:ULONG
    {io_Length}	length	:ULONG
    {io_Data}	data	:/*STRPTR*/ ARRAY OF CHAR
    {io_Offset}	offset	:ULONG
    {io_ClipID}	clipid	:VALUE
ENDOBJECT

NATIVE {SatisfyMsg} OBJECT satisfymsg
    {sm_Msg}	msg	:mn
    {sm_Unit}	unit	:UINT
    {sm_ClipID}	clipid	:VALUE
ENDOBJECT

NATIVE {ClipHookMsg} OBJECT cliphookmsg
    {chm_Type}	type	:ULONG
    {chm_ChangeCmd}	changecmd	:VALUE
    {chm_ClipID}	clipid	:VALUE
ENDOBJECT
