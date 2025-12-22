
/*
 *  DATETOS.C
 *
 *  leap year:	every four years but 3 out of 4 century marks are not leap years
 *		(2000 is) the year 0 was.  year&3==0 is
 *  timestamp is since 1978
 *
 *  valid range:    Jan 1 1976	to  Dec 31 2099
 */

#include <local/typedefs.h>

#ifdef LATTICE
#include <string.h>
#endif

static char dim[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
static char *Month[12] = { "Jan","Feb","Mar","Apr","May","Jun","Jul",
			   "Aug","Sep","Oct","Nov","Dec" };

char *
DateToS(date, str, ctl)
DATESTAMP *date;
char *str;
char *ctl;
{
    long days, years;
    short leap, month;

    if (ctl == NULL)
	ctl = "D M Y h:m:s";
    days = date->ds_Days + 731; 	    /*	1976	    */
    years = days / (365*3+366);             /*  #quad yrs   */
    days -= years * (365*3+366);
    leap = (days <= 365);                    /*  is a leap yr*/
    years = 1976 + 4 * years;
    if (leap == 0) {
	days -= 366;
	++years;
	years += days / 365;
	days  %= 365;
    }
    for (month = 0; (month==1) ? (days >= 28 + leap) : (days >= dim[month]); ++month)
	days -= (month==1) ? (28 + leap) : dim[month];
    {
	short i = 0;
	for (; *ctl; ++ctl) {
	    switch(*ctl) {
	    case 'h':
		utos(str+i, 1, 2, date->ds_Minute / 60);
		/*sprintf(str+i, "%02d", date->ds_Minute / 60);*/
		break;
	    case 'm':
		utos(str+i, 1, 2, date->ds_Minute % 60);
		/*sprintf(str+i, "%02d", date->ds_Minute % 60);*/
		break;
	    case 's':
		utos(str+i, 1, 2, date->ds_Tick / 50 % 60);
		/*sprintf(str+i, "%02d", date->ds_Tick / 50 % 60);*/
		break;
	    case 'Y':
		utos(str+i, 0, 4, years);
		/*sprintf(str+i, "%ld", years);*/
		break;
	    case 'M':
		strcpy(str+i, Month[month]);
		break;
	    case 'D':
		utos(str+i, 0, 2, days+1);
		/*sprintf(str+i,"%2ld", days+1);*/
		break;
	    default:
		str[i] = *ctl;
		str[i+1] = 0;
		break;
	    }
	    i += strlen(str+i);
	}
    }
    return(str);
}

void
utos(buf, zfill, flen, val)
char *buf;
short flen;
short zfill;
long val;
{
    buf[flen] = 0;
    while (flen--) {
	if (val)
	    buf[flen] = '0' + (val % 10);
	else
	    buf[flen] = (zfill) ? '0' : ' ';
	val /= 10;
    }
}

#ifndef ACTION_SET_DATE
#define ACTION_SET_DATE 34
#endif

typedef struct StandardPacket STDPKT;
typedef struct MsgPort	      MSGPORT;

extern void *AllocMem();

int
SetFileDate(file, date)
char *file;
DATESTAMP *date;
{
    STDPKT *packet;
    char   *buf;
    PROC   *proc;
    long	result;
    long	lock;

    {
	long flock = Lock(file, SHARED_LOCK);
	short i;
	char *ptr = file;

	if (flock == NULL)
	    return(NULL);
	lock = ParentDir(flock);
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
    PutMsg((PORT *)((LOCK *)BTOC(lock))->fl_Task, (MSG *)packet);
    WaitPort(&proc->pr_MsgPort);
    GetMsg(&proc->pr_MsgPort);
    result = packet->sp_Pkt.dp_Res1;
    FreeMem(packet, sizeof(STDPKT));
    FreeMem(buf, strlen(file)+2);
    UnLock(lock);
    return(result);
}

