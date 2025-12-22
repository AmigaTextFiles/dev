
OPT PREPROCESS
MODULE 'amigalib/io'
MODULE 'amigalib/ports'
MODULE 'devices/scsidisk'
MODULE 'exec/ports','exec/io','exec/nodes'
MODULE 'exec/devices'

->> SCSIUTIL DEFINE


#define BYTES_PER_LINE  16
#define SENSE_LEN 252
#define MAX_DATA_LEN 252
/* max TOC size = 100 TOC track descriptors */
#define MAX_TOC_LEN 804     
#define PAD 0
#define LINE_BUF    (128)
/* 75 frames per second audio */
#define NUM_OF_CDDAFRAMES 75    
/*#define CDDALEN 2352  */  /* 1 frame has 2352 bytes */
/* 1 frame has max. 2448 bytes (subcode 2) */
#define CDDALEN 2448        
#define MAX_CDDALEN CDDALEN * NUM_OF_CDDAFRAMES

#define OFFS_KEY 2
#define OFFS_CODE 12

#define NDBLBUF 8

/*
 * we open ( if no -d option) the first *scsi*.device in the device list.
 */
#define SCSI_STRING "scsi"
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

#define SCSI_CMD_TUR    $00    
/* Test Unit Ready  */
#define SCSI_CMD_RZU    $01    
/* Rezero Unit      */
#define SCSI_CMD_RQS    $03    
/* Request Sense    */
#define SCSI_CMD_FMU    $04    
/* Format unit      */
#define SCSI_CMD_RAB    $07    
/* Reassign Block   */
#define SCSI_CMD_RD $08    
/* Read         */
#define SCSI_CMD_WR $0A    
/* Write        */
#define SCSI_CMD_SK $0B    
/* Seek         */
#define SCSI_CMD_INQ    $12    
/*  6B: Inquiry     */
#define SCSI_CMD_MSL    $15    
/* Mode SELECT      */
#define SCSI_CMD_RU $16    
/* Reserve Unit     */
#define SCSI_CMD_RLU    $17    
/* Release Unit     */
#define SCSI_CMD_MSE    $1A    
/*  6B: Mode Sense  */
#define SCSI_CMD_SSU    $1B    
/*  6B: Start/Stop Unit */
#define SCSI_CMD_RDI    $1C    
/* Receive Diagnostic   */
#define SCSI_CMD_SDI    $1D    
/* Send Diagnostic  */
#define SCSI_CMD_PAMR   $1E    
/*  6B: Prevent Allow Medium Removal */
#define SCSI_CMD_RCP    $25    
/* Read Capacity    */
#define SCSI_CMD_RXT    $28    
/* Read Extended    */
#define SCSI_CMD_WXT    $2A    
/* Write Extended   */
#define SCSI_CMD_SKX    $2B    
/* Seek Extended    */
#define SCSI_CMD_WVF    $2E    
/* Write & Verify   */
#define SCSI_CMD_VF $2F    
/* Verify       */
#define SCSI_CMD_RDD    $37    
/* Read Defect Data */
#define SCSI_CMD_WDB    $3B    
/* Write Data Buffer    */
#define SCSI_CMD_RDB    $3C    
/* Read Data Buffer */

#define SCSI_CMD_COPY       $18    
/*  6B: Copy */
#define SCSI_CMD_COMPARE    $39    
/* 10B: Compare */
#define SCSI_CMD_COPYANDVERIFY  $3A    
/* 10B: Copy AND Verify */
#define SCSI_CMD_CHGEDEF    $40    
/* 10B: Change Definition */
#define SCSI_CMD_READSUBCHANNEL $42    
/* 10B: Read Sub-Channel */
#define SCSI_CMD_READTOC    $43    
/* Read TOC from CD Audio */
#define SCSI_CMD_READHEADER $44    
/* 10B: Read data block address header */
#define SCSI_CMD_PLAYAUDIO10    $45    
/* Play CD Audio */
#define SCSI_CMD_PLAYAUDIOTRACKINDEX    $48    
/* Play CD Audio Track */

/* Toshiba XM3x0x specific commands */

#define SCSI_CMD_READ12     $A8    
/* 12B: Read */

/* Sony CDU 561 / Sony CDU 8003 = Apple CD 300 specific commands */

#define SCSI_CMD_READCDDA   $D8    
/* 12B: read digital audio */
#define SCSI_CMD_READCDDAMSF    $D9    
/* 12B: read digital audio */

-><

DEF nexusio:PTR TO iostd
DEF nexusport:PTR TO mp
DEF myscsi:PTR TO scsicmd
DEF devicename[256]:STRING
DEF deviceunit=0
DEF alldev=FALSE
->> main()
PROC main()
    DEF myargs:PTR TO LONG
    DEF rdargs=NIL,b
    VOID '$VER: SCSINexus 0.1 (01.02.96) © NasGûl'
    myargs:=[0,0,0]
    IF rdargs:=ReadArgs('DEVICE,UNIT/N,ALL/S',myargs,NIL)
        IF myargs[0] THEN StrCopy(devicename,myargs[0],ALL) ELSE StrCopy(devicename,'Nexus.device',ALL)
        IF myargs[1] THEN deviceunit:=Long(myargs[1])
        IF myargs[2] THEN alldev:=TRUE
        IF Not(alldev)
            doInquiry()
        ELSE
            FOR b:=0 TO 6
                deviceunit:=b
                doInquiry()
            ENDFOR
        ENDIF
        IF rdargs THEN FreeArgs(rdargs)
    ELSE
        WriteF('Bad Args.\n')    
    ENDIF
ENDPROC
-><
->> doInquiry()
PROC doInquiry()
    DEF command_inq:PTR TO CHAR
    DEF command_rcp:PTR TO CHAR
    DEF f,sd:PTR TO CHAR,test,i,sc:PTR TO LONG
    DEF resformat:PTR TO LONG,gooddisk=TRUE
    resformat:=['SCSI-1','CCS','SCSI-2','Reserved']
    command_inq:=[SCSI_CMD_INQ,0,0,0,MAX_DATA_LEN,0]:CHAR
    command_rcp:=[SCSI_CMD_RCP,0,0,0,0,0,0,0,0,0]:CHAR
    IF nexusport:=createPort(NIL,NIL)
        IF nexusio:=createStdIO(nexusport)
            f:=OpenDevice(devicename,deviceunit,nexusio,0)
            IF (f)
                IF alldev
                    WriteF('No Unit \s \d\n',devicename,deviceunit)
                ELSE
                    WriteF('OpenDevice(\s,\d) Failed.\n',devicename,deviceunit)
                ENDIF
                deleteStdIO(nexusio)
                deletePort(nexusport)
            ELSE
                IF myscsi:=New(SIZEOF scsicmd)
                    IF sd:=New(252)
                        myscsi.data:=sd
                        myscsi.length:=254
                        myscsi.senseactual:=0
                        myscsi.senselength:=254
                        myscsi.command:=command_inq
                        myscsi.cmdlength:=6
                        myscsi.flags:=SCSIF_READ OR SCSIF_NOSENSE
                        nexusio.length:=SIZEOF scsicmd
                        nexusio.data:=myscsi
                        nexusio.command:=HD_SCSICMD
->                        test:=DoIO(nexusio)
                        test:=SendIO(nexusio)
                        test:=nexusio.error
                        IF test=0
                            WriteF('\s Unit \d\n',devicename,deviceunit)
                            WriteF('----------------------\n')
                            WriteF('Removal medium        :\s\n',IF sd[1] THEN 'Yes' ELSE 'No')
                            WriteF('ANSI-Approved Version :\s\n',IF sd[2]=1 THEN 'SCSI-1' ELSE 'SCSI-2')
                            WriteF('Response Data Format  :\s\n',resformat[(sd[3] AND $F)])
                            WriteF('Vendor Identification :')
                            FOR i:=8 TO 15;WriteF('\c',sd[i]);ENDFOR;WriteF('\n')
                            WriteF('Product identification:')
                            FOR i:=16 TO 31;WriteF('\c',sd[i]);ENDFOR;WriteF('\n')
                            WriteF('Product Revision Level:')
                            FOR i:=32 TO 35;WriteF('\c',sd[i]);ENDFOR;WriteF('\n')
                            WriteF('Vendor specific       :')
                            FOR i:=36 TO 55;WriteF('\c',sd[i]);ENDFOR;WriteF('\n')
                        ELSE
                            IF Not(alldev) THEN WriteF('Inquiry Error:\d\n',test)
                            gooddisk:=FALSE
                        ENDIF
                        IF gooddisk
                            myscsi.command:=command_rcp
                            myscsi.cmdlength:=10
    ->                        nexusio.data:=myscsi
                            test:=DoIO(nexusio)
                            IF test=0
                                sc:=sd
                                WriteF('Capacity              :')
                                WriteF(' Max Sec =\d Sec Size =\d Capacity =\d KB\n',Long(sc),Long(sc+4),Div(Mul(Long(sc),Long(sc+4)),1024))
                            ELSE
                                test:=DoIO(nexusio)
                                IF test=0
                                    sc:=sd
                                    WriteF('Capacity              :')
                                    WriteF(' Max Sec =\d Sec Size =\d Capacity =\d KB\n',Long(sc),Long(sc+4),Div(Mul(Long(sc),Long(sc+4)),1024))
                                ELSE
                                    WriteF('Read Capacity Error :\d\n',test)
                                ENDIF
                            ENDIF
                        ENDIF
                        CloseDevice(nexusio)
                        deleteStdIO(nexusio)
                        deletePort(nexusport)
                        Dispose(sd)
                    ELSE
                        WriteF('NEW() Failed.\n')
                    ENDIF
                    Dispose(myscsi)
                ELSE
                    WriteF('NEW() Failed.\n')
                ENDIF
            ENDIF
        ELSE
            WriteF('createStdIO() Failed.\n')
        ENDIF
    ELSE
        WriteF('createPort() Failed.\n')
    ENDIF
ENDPROC
-><





