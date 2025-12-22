/*

    Packetsupport.lib
    -----------------

    DOS-Packet support .lib for Lettuce C V5.04

    no © 1990 by Oliver Wagner,
		 Landsberge 5,
		 4322 Sprockhövel,
		 West Germany

    Use at your own risk, for everything you want!

    long getres2();
	-> return res2 of last packet

    long sendpacket(device proc, action, arg1, arg2...)
	-> send packet with type "action" to
	   device proc, with arg1 arg2 arg3
	   return res1 of packet, set res2

*/

#include <proto/dos.h>
#include <proto/exec.h>
#include <string.h>
#include <exec/memory.h>
#include "packetsupport.h"

/* simply return res2 of last packet */
static long res2;
long getres2(void)
{
    return(res2);
}

/* send a packet */
long __stdargs sendpacket(devproc,type,arg1,arg2,arg3,arg4,arg5,arg6,arg7)
struct MsgPort *devproc;
long type;
long arg1,arg2,arg3,arg4,arg5,arg6,arg7;
{
    struct MsgPort *replyport=CreatePort(0,0);
    long res1=0;
    struct StandardPacket *packet=AllocMem(sizeof(struct StandardPacket),
					   MEMF_CLEAR|MEMF_PUBLIC);
    if(!packet||!replyport||!devproc) goto xit;

    packet->sp_Msg.mn_Node.ln_Name=&(packet->sp_Pkt);
    packet->sp_Pkt.dp_Link=&(packet->sp_Msg);
    packet->sp_Pkt.dp_Port=replyport;
    packet->sp_Pkt.dp_Type=type;
    memcpy(&packet->sp_Pkt.dp_Arg1,&arg1,8*4);

    PutMsg(devproc,packet);
    WaitPort(replyport);
    GetMsg(replyport);

    res1=packet->sp_Pkt.dp_Res1;
    res2=packet->sp_Pkt.dp_Res2;

xit:
    if(packet) FreeMem(packet,sizeof(struct StandardPacket));
    if(replyport) DeletePort(replyport);
    return(res1);
}
