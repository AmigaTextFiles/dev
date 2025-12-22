/* resend.c */

#include "sh/sub.h"
#include "exec/io.h"
#include "exec/memory.h"
#include "exec/libraries.h"
#include "exec/execbase.h"
#include "dos/dos.h"
#include "dos/dostags.h"
#include "fidonet.h"
#include "techprg.h"
#include "proto/exec_protos.h"
#include "proto/dos_protos.h"

#define TRUE 1
#define FALSE 0

/* Here are the tech.lib function prototypes. */

extern ULONG stoa(u_char *,struct NetAddr *),RexxCmd(UBYTE *);
extern long NumRexxFnc(u_char *);
extern u_char *RexxFnc(u_char *);
extern void *SendBBSMsg(UWORD,void *),InitTech(void),CloseTech(void);

int _main(void);
ULONG FindMsg(void),getdate(u_char *);
struct FMsg *LoadMsg(ULONG);
void error(u_char *),cleanup(void);

extern u_char APortName[32];

struct RdArds *ra;
struct MsgReq mr;
struct NetAddr addr;
struct DateStamp ds;

ULONG args[8],area,date,msg,max;

BPTR pkt;

#define arg_pkt     (u_char *)args[0]
#define arg_from   *((ULONG *)args[1])
#define arg_to     *((ULONG *)args[2])
#define arg_date    (u_char *)args[3]
#define arg_origin  (u_char *)args[4]
#define arg_dest    (u_char *)args[5]
#define arg_pw      (u_char *)args[6]
#define arg_netmail (u_char *)args[7]

u_char DayBuf[48],DateBuf[48],TimeBuf[48];

struct DateTime timedate = { 0,0,0,FORMAT_DOS,0,DayBuf,DateBuf,TimeBuf };

u_char template[]="PKTNAME/A,FROM/A/N,TO/A/N,DATE/A,ORIGIN/A,DESTINATION/A,PASSWORD/K,NETMAIL/S",ver[]="$VER: resend 1.00",
    cmd[32],buf[128],secbuf[128],err_are[]="ARexx error";

int _main(void) {
LONG i,o,p,e,t;
u_char *s;
struct FMsg *fmsg;
    GetProgramName(cmd,32);
    if(!(ra=ReadArgs(template,args,NULL))) {
        PrintFault(i=IoErr(),cmd);
        exit(i);
    }
    InitTech();
    pkt=MakePkt(arg_pkt,arg_origin,arg_dest,arg_pw);
    strcpy(APortName,"Tech_0");
    strcpy(DateBuf,arg_date);
    strcpy(TimeBuf,"00:00:00");
    StrToDate(&timedate);
    stoa(arg_origin,&addr);
    t=0;
    date=timedate.dat_Stamp.ds_Days;
    for(area=arg_from;area<=arg_to;area++) {
        if(!(p=FindMsg())) printf("\n\nNo messages.\n"); else {
            printf("\n\nFirst message: %ld. Exporting: ",p);
            Flush(Output());
            e=0;
            for(i=p;i<=max;i++) {
                if(fmsg=LoadMsg(i)) {
                    if(addr.Zone==fmsg->OrigZone)
                    if(addr.Net==fmsg->OrigNet)
                    if(addr.Node==fmsg->OrigNode)
                    if(addr.Point==fmsg->OrigPoint) {
                        printf("%ld ",i);
                        s=fmsg->DateTime;
                        for(p=0;p<9;p++) {
                            if(*s=='-') *s=32;
                            s++;
                        }
                        MakeMsg(pkt,fmsg->DateTime,arg_netmail?MSGF_PRIVATE:0);
                        s=(u_char *)fmsg->DateTime+20;
                        while(*s++);
                        strcpy(buf,s);
                        while(*s++);
                        Write(pkt,s,strlen(s)+1);
                        Write(pkt,buf,strlen(buf)+1);
                        while(*s++);
                        Write(pkt,s,strlen(s)+1);
                        while(*s++);
                        Write(pkt,s,strlen(s)+1);
                        e++;
                        Flush(Output());
                    }
                    FreeVec(fmsg);
                }
            }
            printf("%ld messages.\n",e);
            t+=e;
        }
    }
    printf("\nDone! Exported %ld messages.\n",t);
    cleanup();
    return(RETURN_OK);
};

/* Find the first message entered at the specified date or later. */

ULONG FindMsg(void) {
LONG msg,flag,temp;
struct FMsg *fmsg;
    printf("\nArea %ld. Scanning: ",area);
    sprintf(buf,"GetHighMsg 0 %ld",area);
    if(!(max=NumRexxFnc(buf))) error(err_are);
    msg=max;
    if(area==52) {
        printf("1715 ");
        return(1715);
    }
    flag=FALSE;
    while(TRUE) {
        printf("%ld ",msg);
        Flush(Output());
        if(fmsg=LoadMsg(msg)) {
            temp=getdate(fmsg->DateTime);
            FreeVec(fmsg);
            if(!flag) if(temp>=date) {
                msg-=50;
                if(msg<1) { msg=1; flag=TRUE; }
            } else { flag=TRUE; msg++; } else if(temp>=date) return(msg);
                else if(++msg>max) return(0);
        } else if(msg<max) msg++; else return(0);
    }
};

/* This function returns the date of the message as number of days. */

ULONG getdate(u_char *datestring) {
    strcpy(DateBuf,datestring);
    StrToDate(&timedate);
    return(timedate.dat_Stamp.ds_Days);
};

/* This function loads a message from the message base. */

struct FMsg *LoadMsg(ULONG MsgNum) {
struct LoadedMsg *LM;
    mr.Area=area;
    mr.MsgNum=MsgNum;
    LM=SendBBSMsg(ID_LOADMSG,&mr);
    return(LM?LM->msg:NULL);
};

/* This function is required by tech.lib. */

void error(u_char *str) {
    printf("%s: %s\n",cmd,str);
    cleanup();
    exit(RETURN_FAIL);
};

void cleanup(void) {
    if(pkt) ClosePkt(pkt);
    CloseTech();
    if(ra) FreeArgs(ra);
};

