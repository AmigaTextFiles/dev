/* setf.e -- a SnoopDos-like program to monitor calls to OpenLibrary() */
/* Exemple en E remagnier pour patcher la fonction DoIO() */

OPT OSVERSION=37
OPT PREPROCESS
MODULE 'dos/dos', 'exec/ports', 'exec/tasks', 'exec/nodes', 'exec/memory'
MODULE 'exec/io'
MODULE 'exec/lists'
MODULE 'devices/scsidisk'
MODULE 'other/plist'

->> SCSIUTIL DEFINE

-> SCSIUtil Includes.


#define  BYTES_PER_LINE  16
#define  SENSE_LEN 252
#define  MAX_DATA_LEN 252
/* max TOC size = 100 TOC track descriptors */
#define  MAX_TOC_LEN 804
#define  PAD 0
#define  LINE_BUF    (128)
/* 75 frames per second audio */
#define  NUM_OF_CDDAFRAMES 75
/*CONST  CDDALEN 2352  */  /* 1 frame has 2352 bytes */
/* 1 frame has max. 2448 bytes (subcode 2) */
#define  CDDALEN 2448
#define  MAX_CDDALEN CDDALEN * NUM_OF_CDDAFRAMES

#define  OFFS_KEY 2
#define  OFFS_CODE 12

#define  NDBLBUF 8

/*
 * we open ( if no -d option) the first *scsi*.device in the device list.
 */
#define  SCSI_STRING 'scsi'
/*
typedef struct MsgPort MSGPORT;
typedef struct IOStdReq IOSTDREQ;
typedef struct List LIST;
typedef struct Node NODE;
typedef struct SCSICmd SCSICMD;

typedef struct
 {
   BYTE   code;
   UBYTE  *ptr;
 } IDTOSTRING;


#undef  FALSE
#undef TRUE
typedef enum
{
  FALSE = 0, TRUE
} BOOLEAN;

typedef enum
{
  UNKNOWN      = -1,
  APPLECD300   =  0,
  APPLECD150   =  1,
  TOSHIBA3401  =  2
} DRIVETYPE;

/* type used for a 6 byte SCSI command */
typedef struct
 {
   UBYTE  opcode;
   UBYTE  b1;
   UBYTE  b2;
   UBYTE  b3;
   UBYTE  b4;
   UBYTE  control;
 } SCSICMD6;

/* type used for a 10 byte SCSI command */
typedef struct
 {
   UBYTE  opcode;
   UBYTE  b1;
   UBYTE  b2;
   UBYTE  b3;
   UBYTE  b4;
   UBYTE  b5;
   UBYTE  b6;
   UBYTE  b7;
   UBYTE  b8;
   UBYTE  control;
 } SCSICMD10;

/* type used for a 12 byte SCSI command */
typedef struct
 {
   UBYTE  opcode;
   UBYTE  b1;
   UBYTE  b2;
   UBYTE  b3;
   UBYTE  b4;
   UBYTE  b5;
   UBYTE  b6;
   UBYTE  b7;
   UBYTE  b8;
   UBYTE  b9;
   UBYTE  b10;
   UBYTE  control;
 } SCSICMD12;


/* SCSI commands */
*/

CONST SCSI_CMD_TUR=                $00      -> Test Unit Ready
CONST SCSI_CMD_RZU=                $01      -> Rezero Unit
CONST SCSI_CMD_RQS=                $03      -> Request Sense
CONST SCSI_CMD_FMU=                $04      -> Format unit
CONST SCSI_CMD_RAB=                $07      -> Reassign Block
CONST SCSI_CMD_RD=                 $08      -> Read
CONST SCSI_CMD_WR=                 $0A      -> Write (6)
CONST SCSI_CMD_SK=                 $0B      -> Seek  (6)
CONST SCSI_CMD_INQ=                $12      -> 6B: Inquiry
CONST SCSI_CMD_MSL=                $15      -> Mode SELECT
CONST SCSI_CMD_RU=                 $16      -> Reserve Unit
CONST SCSI_CMD_RLU=                $17      -> Release Unit
CONST SCSI_CMD_COPY=               $18      -> Copy
CONST SCSI_CMD_MSE=                $1A      -> 6B: Mode Sense
CONST SCSI_CMD_SSU=                $1B      -> 6B: Start/Stop Unit
CONST SCSI_CMD_RDI=                $1C      -> Receive Diagnostic
CONST SCSI_CMD_SDI=                $1D      -> Send Diagnostic
CONST SCSI_CMD_PAMR=               $1E      -> 6B: Prevent Allow Medium Removal
CONST SCSI_CMD_RCP=                $25      -> Read Capacity
CONST SCSI_CMD_RXT=                $28      -> Read Extended (10)
CONST SCSI_CMD_WXT=                $2A      -> Write Extended (10)
CONST SCSI_CMD_SKX=                $2B      -> Seek Extended
CONST SCSI_CMD_WVF=                $2E      -> Write & Verify
CONST SCSI_CMD_VF=                 $2F      -> Verify

CONST SCSI_CMD_SDH=                $30      -> Search Data Hight (10) NEW (optional)
CONST SCSI_CMD_SDE=                $31      -> Search Data Equal (10) NEW (optional)
CONST SCSI_CMD_SDL=                $32      -> Search Data Low (10) NEW (optional)
CONST SCSI_CMD_SL=                 $33      -> SET Limits (10) NEW (optional)
CONST SCSI_CMD_PF=                 $34      -> Pre-Fetch NEW (optional)
CONST SCSI_CMD_SC=                 $35      -> Synchronize Cache NEW (optional)
CONST SCSI_CMD_LUC=                $36      -> Lock Unlock Cache NEW (optional)

CONST SCSI_CMD_RDD=                $37      -> Read Defect Data
CONST SCSI_CMD_COMPARE=            $39      -> 10B: Compare
CONST SCSI_CMD_COPYANDVERIFY=      $3A      -> 10B: Copy AND Verify
CONST SCSI_CMD_WDB=                $3B      -> Write Data Buffer
CONST SCSI_CMD_RDB=                $3C      -> Read Data Buffer

CONST SCSI_CMD_READLONG=           $3E      -> Read Long NEW (optional)

CONST SCSI_CMD_CHGEDEF=            $40      -> 10B: Change Definition

CONST SCSI_CMD_WRITESAME=          $41      -> Write Same NEW (optional)

CONST SCSI_CMD_READSUBCHANNEL=     $42      -> 10B: Read Sub-Channel
CONST SCSI_CMD_READTOC=            $43      -> Read TOC from CD Audio
CONST SCSI_CMD_READHEADER=         $44      -> 10B: Read data block address header
CONST SCSI_CMD_PLAYAUDIO10=        $45      -> Play CD Audio
CONST SCSI_CMD_PLAYAUDIOTRACKINDEX=$48      -> Play CD Audio Track

CONST SCSI_CMD_LOGSELECT=          $4C      -> Log SELECT NEW (optional)
CONST SCSI_CMD_LOGSENSE=           $4D      -> Log Sense NEW (optional)
CONST SCSI_CMD_MODESELECT=         $55      -> Mode SELECT NEW (optional)
CONST SCSI_CMD_MODESENSE=          $5A      -> Mode Sense NEW (optional)

/* Toshiba XM3x0x specific commands */
CONST SCSI_CMD_READ12=             $A8      -> 12B: Read

/* Sony CDU 561 / Sony CDU 8003 = Apple CD 300 specific commands */

CONST SCSI_CMD_READCDDA=           $D8      -> 12B: read digital audio
CONST SCSI_CMD_READCDDAMSF=        $D9      -> 12B: read digital audio

-><

->CONST OFFSET=$fdd8  /* execbase offset OF OpenLibrary() */
CONST OFFSET=$FE38    -> DoIO() offset
->CONST OFFSET=$F332    -> SendIO() offset
->CONST OFFSET=$FE2C    -> CheckIO() offset
->CONST OFFSET=$FE26    -> WaitIO() offset
->CONST OFFSET=$FE20    -> AbortIO() offset

/* "mymsg" must begin with the standard message object "mn", followed by
   any kind of data (in this case, two pointers [to strings]).
*/
OBJECT mymsg
  msg:mn
  s, t
ENDOBJECT

/* "port" will be used from the patched routine, too, so it's global */
DEF port:PTR TO mp
DEF mylist:PTR TO lh
/* You can change the library function to be patched by changing OFFSET
   and the "execbase" in the *two* calls to SetFunction().  If you want to
   patch a library other than dos, exec, graphics and intuition you need
   to OpenLibrary() it first.
   (Note: some [old?] libraries cannot be patched in this way.  Also, some
   functions in some libraries can't be patched like this either!  Even the
   RKRM's aren't too clear about this...)
*/
PROC main()
    DEF myargs:PTR TO LONG,rdargs=NIL
    DEF marg:PTR TO LONG,b=20
    DEF n[256]:STRING
    DEF ps, us,boucle, sig, oldf
    myargs:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    mylist:=initList()
    IF rdargs:=ReadArgs('EXECNAME/M',myargs,NIL)
        marg:=myargs[]
        IF myargs[0]
            FOR b:=0 TO 19
                IF marg[b]<>0
                    IF b=0 THEN StrCopy(n,Long(myargs[0]),ALL) ELSE StrCopy(n,marg[b],ALL)
                    addNode(mylist,n,0)
                ENDIF
            ENDFOR
        ENDIF
        FreeArgs(rdargs)
    ELSE
        NOP
    ENDIF
  IF emptyList(mylist)=-1
    WriteF('No Program TO patch !!\n')
    IF mylist THEN cleanList(mylist,0,0,LIST_REMOVE)
    CleanUp(20)
  ENDIF
  IF port:=CreateMsgPort()
    Forbid()     /* Don't let anyone mess things up... */
    IF oldf:=SetFunction(execbase, OFFSET, {newf})
      PutLong({patch}, oldf)
      Permit()    /* Now we can let everyone else back in */
      LEA store(PC), A0
      MOVE.L A4, (A0)    /* Store the A4 register... */
      ps:=Shl(1,port.sigbit)   /* Set up port and user signal bits */
      us:=SIGBREAKF_CTRL_C
      boucle:=TRUE
      WHILE boucle
        sig:=Wait(ps OR us)
        IF sig AND ps
          printmsgs()
        ENDIF
        IF sig AND us
          boucle:=FALSE
        ENDIF
      ENDWHILE
      Forbid()   /* Paranoid... */
      SetFunction(execbase, OFFSET, oldf)
    ENDIF
    Permit()
    printmsgs()   /* Make sure the port is empty */
    DeleteMsgPort(port)
  ENDIF
  IF mylist THEN cleanList(mylist,0,0,LIST_REMOVE)
ENDPROC

/* Nicely (?) print the messages out... */
PROC printmsgs()
  DEF msg:PTR TO mymsg
  DEF myio:PTR TO iostd
  DEF myscsi:PTR TO scsicmd
  DEF mycom:PTR TO CHAR,te,p
  WHILE msg:=GetMsg(port)
    IF FindName(mylist,msg.t)
        myio:=msg.s
        myscsi:=myio.data
        mycom:=myscsi.command
        te:=mycom[0]
            WriteF('\h \d \l\s[13] IOCom/Flags[\d[2]/\d[2]]',te,myscsi.flags,msg.t,myio.command,myio.flags)
            WriteF(' f/s (\d[2]/\d[2]) :($\h[8]) $\h[2] ',myscsi.flags,myscsi.status,myio,te)
            SELECT te
                CASE SCSI_CMD_TUR;  WriteF('Test Unit Ready\n')
                CASE SCSI_CMD_RZU;  WriteF('Rezero Unit\n')
                CASE SCSI_CMD_RQS;  WriteF('Request Sense\n')
                CASE SCSI_CMD_FMU;  WriteF('Format Unit\n')
                CASE SCSI_CMD_RAB;  WriteF('Reassign Block\n')
                CASE SCSI_CMD_RD;   WriteF('Read\n')
                CASE SCSI_CMD_WR;   WriteF('Write\n')
                CASE SCSI_CMD_SK;   WriteF('Seek\n')
                CASE SCSI_CMD_INQ
                    WriteF('Inquiry\n')
->                    p:=myscsi.flags
->                    PutChar(p,SCSIF_READ OR SCSIF_NOSENSE)
                CASE SCSI_CMD_MSL;  WriteF('Mode SELECT\n')
                CASE SCSI_CMD_RU;   WriteF('Reserve Unit\n')
                CASE SCSI_CMD_RLU;  WriteF('Release Unit\n')
                CASE SCSI_CMD_MSE;  WriteF('Mode Sense\n')
                CASE SCSI_CMD_SSU;  WriteF('Start/Stop Unit\n')
                CASE SCSI_CMD_RDI;  WriteF('Receive  Diagnostic\n')
                CASE SCSI_CMD_SDI;  WriteF('Send Diagnostic\n')
                CASE SCSI_CMD_RCP;  WriteF('Read Capacity\n')
                CASE SCSI_CMD_RXT;  WriteF('Read Extended\n')
                CASE SCSI_CMD_WXT;  WriteF('Write Extened\n')
                CASE SCSI_CMD_SKX;  WriteF('Seek Extended\n')
                CASE SCSI_CMD_WVF;  WriteF('Write & Verify\n')
                CASE SCSI_CMD_VF;   WriteF('Verify\n')
                CASE SCSI_CMD_RDD;  WriteF('Read Defect Data\n')
                CASE SCSI_CMD_WDB;  WriteF('Write Data Buffer\n')
                CASE SCSI_CMD_RDB;  WriteF('Read Data Buffer\n')
                CASE SCSI_CMD_COPY; WriteF('Copy\n')
                CASE SCSI_CMD_COMPARE;  WriteF('Compare\n')
                CASE SCSI_CMD_COPYANDVERIFY;    WriteF('Copy AND Verify\n')
                CASE SCSI_CMD_CHGEDEF;  WriteF('Change Definition\n')
                CASE SCSI_CMD_READSUBCHANNEL;   WriteF('Read Sub-Channel\n')
                CASE SCSI_CMD_READTOC;  WriteF('Read TOC from CD Audio\n')
                CASE SCSI_CMD_READHEADER;   WriteF('Read Data Block Address Header\n')
                CASE SCSI_CMD_PLAYAUDIO10;  WriteF('Play CD Audio\n')
                CASE SCSI_CMD_PLAYAUDIOTRACKINDEX;  WriteF('Play CD Audio Track\n')
                CASE SCSI_CMD_READ12;   WriteF('Read (Toshiba xM3x0x specific command)\n')
                CASE SCSI_CMD_READCDDA; WriteF('Read Digital Audio (Sony CDU 561/Sony CDU 8003/Apple CD300 specific command)\n')
                CASE SCSI_CMD_SDH;  WriteF('Search Data Hight (10) (optional)\n')
                CASE SCSI_CMD_SDE;  WriteF('Search Data Equal (10) (optional)\n')
                CASE SCSI_CMD_SDL;  WriteF('Search Data Low (10) (optional)\n')
                CASE SCSI_CMD_SL;   WriteF('SET Limits (10) (optional)\n')
                CASE SCSI_CMD_PF;   WriteF('Pre-Fetch (optional)\n')
                CASE SCSI_CMD_SC;   WriteF('Synchronize Cache (optional)\n')
                CASE SCSI_CMD_LUC;  WriteF('Lock Unlock Cache (optional)\n')
                CASE SCSI_CMD_READLONG; WriteF('Read Long (optional)\n')
                CASE SCSI_CMD_WRITESAME;    WriteF('Write Same (optional)\n')
                CASE SCSI_CMD_LOGSELECT;    WriteF('Log SELECT (optional)\n')
                CASE SCSI_CMD_LOGSENSE;     WriteF('Log Sense (optional)\n')
                CASE SCSI_CMD_MODESELECT;   WriteF('Mode SELECT (optional)\n')
                CASE SCSI_CMD_MODESENSE;    WriteF('Mode Sense (optional)\n')
                DEFAULT;    WriteF('Unknown Command :$\h\n',te)
            ENDSELECT
    ENDIF
    ReplyMsg(msg)
    DisposeLink(msg.t)
    Dispose(msg)
  ENDWHILE
ENDPROC

/* Send a message to the patching process */
PROC sendmsg()
  DEF m:PTR TO mymsg, s:PTR TO iostd, tsk:tc, l:ln
  MOVE.L A1, s

  /* Allocate a new message */
  m:=New(SIZEOF mymsg)
  IF s
    m.s:=s
  ENDIF
  tsk:=FindTask(NIL)   /* Find out who we are */
  m.t:=NIL
  IF tsk
    l:=tsk.ln
    IF l AND l.name
      m.t:=String(StrLen(l.name))
      StrCopy(m.t, l.name, ALL)
    ENDIF
  ENDIF
  PutMsg(port, m)

ENDPROC

/* Place to store A4 register */
store:  LONG 0
/* Place to store real call */
patch:  LONG 0

/* The new routine which will replace the original library function */
newf:
  MOVEM.L D0-D7/A0-A6, -(A7)
  LEA store(PC), A0
  MOVE.L (A0), A4 /* Reinstate the A4 register so we can use E code */
  sendmsg()
  MOVEM.L (A7)+, D0-D7/A0-A6
  MOVE.L patch(PC), -(A7)
  RTS
