

/*
 *  SETFILEDATE.C
 *
 *  BOOL = setfiledate(filename, date)
 */

#include <local/typedefs.h>
#ifdef LATTICE
#include <string.h>
#endif

#ifndef ACTION_SET_DATE
#define ACTION_SET_DATE 34
#endif

typedef struct StandardPacket STDPKT;

int
setfiledate(file, date)
char *file;
DATESTAMP *date;
{
    STDPKT *packet;
    char   *buf;
    PROC   *proc;
    long	result;
    long	lock;
    long flock = (long)Lock(file, SHARED_LOCK);
    short i;
    char *ptr = file;

    {
	if (flock == NULL)
	    return(NULL);
	lock = (long)ParentDir(flock);
	UnLock(flock);
	if (!lock)
	    return(NULL);
	for (i = strlen(ptr) - 1; i >= 0; --i) {
	    if (ptr[i] == '/' || ptr[i] == ':')
		break;
	}
	file += i + 1;
    }
    proc   = (PROC *)FindTask(NULL);
    packet = (STDPKT   *)AllocMem(sizeof(STDPKT), MEMF_CLEAR|MEMF_PUBLIC);
    buf = AllocMem(strlen(file)+2, MEMF_PUBLIC);
    strcpy(buf+1,file);
    buf[0] = strlen(file);

    packet->sp_Msg.mn_Node.ln_Name = (char *)&(packet->sp_Pkt);
    packet->sp_Pkt.dp_Link = &packet->sp_Msg;
    packet->sp_Pkt.dp_Port = &proc->pr_MsgPort;
    packet->sp_Pkt.dp_Type = ACTION_SET_DATE;
    packet->sp_Pkt.dp_Arg1 = NULL;
    packet->sp_Pkt.dp_Arg2 = (long)lock;        /*  lock on parent dir of file  */
    packet->sp_Pkt.dp_Arg3 = (long)CTOB(buf);   /*  BPTR to BSTR of file name   */
    packet->sp_Pkt.dp_Arg4 = (long)date;        /*  APTR to datestamp structure */
    PutMsg(((LOCK *)BTOC(lock))->fl_Task, (MSG *)packet);
    WaitPort(&proc->pr_MsgPort);
    GetMsg(&proc->pr_MsgPort);
    result = packet->sp_Pkt.dp_Res1;
    FreeMem(packet, sizeof(STDPKT));
    FreeMem(buf, strlen(file)+2);
    UnLock(lock);
    return(result);
}

