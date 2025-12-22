/* fidonet.c */

#include "sh/sub.h"
#include "exec/io.h"
#include "exec/memory.h"
#include "exec/libraries.h"
#include "exec/execbase.h"
#include "dos/dos.h"
#include "dos/dostags.h"
#include "fidonet.h"
#include "proto/exec_protos.h"
#include "proto/dos_protos.h"

#define TRUE 1
#define FALSE 0

int _main(void);
void error(u_char *),cleanup(void);

struct RdArds *ra;

ULONG args[2];

/* These are required by fidonet.lib. */

u_char DayBuf[48],DateBuf[48],TimeBuf[48];
struct DateTime timedate = { 0,0,0,FORMAT_DOS,0,DayBuf,DateBuf,TimeBuf };
struct DateStamp ds;

u_char template[]="",ver[]="$VER: fidonet packet demo program 1.00",cmd[32],
    buf[128],secbuf[128];

/* This is a little demo to show you how to use fidonet.lib. */

int _main(void) {
LONG i;
BPTR pkt;

    /* This is required by fidonet.lib. Also provide the buffer needed. */

    GetProgramName(cmd,32);

    if(!(ra=ReadArgs(template,args,NULL))) {
        PrintFault(i=IoErr(),cmd);
        exit(i);
    }
    sprintf(buf,"T:%08lx.PKT",clock());
    pkt=MakePkt(buf,"65:10/5","65:10/1","password");
    MakeMsg(pkt,"20 Mar 96  18:30:20",0);
    Write(pkt,"All",4);
    Write(pkt,"Sami Klemola",13);
    Write(pkt,"fidonet.lib",12);
    Write(pkt,"This is a library that provides easy\rmeans to creating fidonet packets.\r",73);
    ClosePkt(pkt);
    printf("Written %s.\n",buf);
    cleanup();
    return(RETURN_OK);
};

/* You MUST provide these functions when using fidonet.lib. When something
   it tries fails, it will call error() or cleanup() and then exit(). */

void error(u_char *str) {
    printf("%s: %s\n",cmd,str);
    cleanup();
    exit(RETURN_FAIL);
};

void cleanup(void) {
    if(ra) FreeArgs(ra);
};

