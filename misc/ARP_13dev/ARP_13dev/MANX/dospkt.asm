* repair for aztec's dospkt() routine - now uses Arp library

    if 0
*doc dos_packet
NAME
    dos_packet -- Send an AmigaDOS packet

SYNOPSIS
    result = dos_packet (port, type, arg1, arg2, arg3, arg4, arg5, arg6, arg7)

    long result;
    struct MsgPort *port;
    long type, arg1, arg2, arg3, arg4, arg5, arg6, arg7;

FUNCTION
    Sends a DOS packet to the specified handler.  This is a replacement
    for the Aztec C dos_packet() routine that calls Arp SendPacket().

INPUTS
    port - Handler MsgPort
    type - Packet Action code
    arg1..arg7 - Packet arguments

RESULTS
    result - Res1 from the Packet (return value from SendPacket())
    errno - Res2 from the Packet

MODULE
    dospkt.asm
*end
    endc

	dseg
	public	_ArpBase
	public	_errno

	cseg

	public	_LVOSendPacket

	public	_dos_packet
_dos_packet
	move.l	4(sp),a1
	move.l	8(sp),d0
	lea.l	12(sp),a0

	move.l	_ArpBase,a6
	jsr	_LVOSendPacket(a6)

    if INT32
	move.l	d1,_errno
    else
	move.w	d1,_errno
    endc

	rts
