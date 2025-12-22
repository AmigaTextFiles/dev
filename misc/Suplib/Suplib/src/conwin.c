

/*
 *  CONWIN.C
 *
 *  Win = GetConWindow()
 *
 *  Returns console window associated with the current task or NULL if
 *  no console task associated.
 *
 *  The intuition.library and graphics.library must be openned.
 */

#include <local/typedefs.h>

typedef struct StandardPacket STDPKT;
typedef struct InfoData       INFODATA;

/*
 *  GETCONWINDOW()
 *
 *  Return the window used by the console of the current process.  We can
 *  use our process's message port as the reply port since it is a
 *  synchronous packet (we wait for the result to come back).  WARNING:
 *  This routine does not check if the 'console' of the current process
 *  is really a console device.
 *
 *  The DISK_INFO packet is sent to the console device.  Although this
 *  packet is normally used to retrieve disk information from disk
 *  devices, the console device recognizes the packet and places a pointer
 *  to the window in id_VolumeNode of the infodata structure.  A pointer
 *  to the console unit is also placed in id_InUse of the infodata structure.
 */

WIN *
GetConWindow()
{
    PROC	*proc;
    STDPKT	*packet;
    INFODATA	*infodata;
    long	result;
    WIN 	*win;

    proc   = (PROC *)FindTask(NULL);
    if (!proc->pr_ConsoleTask)
	return(NULL);
    /*
     *	NOTE: Since DOS requires the packet and infodata structures to
     *	be longword aligned, we cannot declare them globally or on the
     *	stack (word aligned).  AllocMem() always returns longword
     *	aligned pointers.
     */

    packet   = (STDPKT   *)AllocMem(sizeof(STDPKT)  , MEMF_CLEAR|MEMF_PUBLIC);
    infodata = (INFODATA *)AllocMem(sizeof(INFODATA), MEMF_CLEAR|MEMF_PUBLIC);

    packet->sp_Msg.mn_Node.ln_Name = (char *)&(packet->sp_Pkt);
    packet->sp_Pkt.dp_Link = &packet->sp_Msg;
    packet->sp_Pkt.dp_Port = &proc->pr_MsgPort;
    packet->sp_Pkt.dp_Type = ACTION_DISK_INFO;
    packet->sp_Pkt.dp_Arg1 = CTOB(infodata);
    PutMsg((PORT *)proc->pr_ConsoleTask, (MSG *)packet);
    WaitPort(&proc->pr_MsgPort);
    GetMsg(&proc->pr_MsgPort);

    result = packet->sp_Pkt.dp_Res1;
    win = (WIN *)infodata->id_VolumeNode;
    /* note: id_InUse holds a pointer to the console unit also */
    FreeMem(packet  , sizeof(STDPKT));
    FreeMem(infodata, sizeof(INFODATA));
    if (!result)
	return(NULL);
    return(win);
}


