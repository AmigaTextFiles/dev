OPT MODULE
OPT EXPORT
/* camd.m */



/************************************************************************
*     C. A. M. D.       (Commodore Amiga MIDI Driver)                   *
*************************************************************************
*                                                                       *
* Design & Development  - Roger B. Dannenberg                           *
*                       - Jean-Christophe Dhellemmes                    *
*                       - Bill Barton                                   *
*                       - Darius Taghavy                                *
*                                                                       *
* Copyright 1990-1999 by Amiga, Inc.                                    *
*************************************************************************
*
* camd.h      - General CAMD include files.
*             - General CAMD definitions.
*
************************************************************************/

MODULE 'exec/lists'
MODULE 'exec/nodes'
MODULE 'exec/types'
MODULE 'utility/tagitem'
/***************************************************************
*
*   Library Name and Version
*
***************************************************************/

#define CamdName 'camd.library'

CONST CAMDVERSION = 2

/***************************************************************
*
*   CAMD internal lists that can be locked
*
***************************************************************/

/***************************************************************
*
*   MIDI Port Definitions
*
*   The default Unit Ports are:
*
*              ports
*       unit  in  out
*       ----  --  ---
*        0     1   0
*        1     3   2
*        2     5   4
*        3     6   5
*
*   These are the values returned by CMP_Out() and CMP_In().
*
*   User ports are allocated starting at CMP_Max and descending.
*
***************************************************************/

#define CMP_Out(unit) ((unit) * 2)            
#define CMP_In(unit) (CMP_Out(unit) + 1)     
CONST CMP_MAX = 31                      

/***************************************************************
*
*   MidiMsg
*
***************************************************************/

/* MidiMsg field definitions */
#define mm_Msg l[0]

#define mm_Time l[1]

#define mm_Status b[0]

#define mm_Data1 b[1]

#define mm_Data2 b[2]

#define mm_Port b[3]

#define mm_Data b

/* MidiMsg macros for quick message type detection.  MidiMsgType()
       generally gives more precise results. */

#define voicemsg(m,a) ( ((m)->mm_Status  AND  MS_StatBits) = (a) )

#define sysmsg(m) ( (m)->mm_Status >= MS_System )

#define noteon(m) ( voicemsg(m,MS_NoteOn)  AND  AND  (m)->mm_Data2 )

#define realtime(m) ( (m)->mm_Status >= MS_RealTime )

#define modemsg(m) ( voicemsg(m,MS_Ctrl)  AND  AND  (m)->mm_Data1 >= MM_Min )

/***************************************************************
*
*   MidiCluster -- a meeting place for linkages
*
*   All fields are READ ONLY.  Modifications to fields may
*   performed only through the appropriate library function
*   calls.
*
***************************************************************/


OBJECT midicluster
   node:ln
   participants:UINT
   receivers:lh
   senders:lh
   publicparticipants:UINT
   flags:INT
ENDOBJECT

/***************************************************************
*
*   MidiLink -- links a cluster and a MidiNode
*
*   All fields are READ ONLY.  Modifications to fields may
*   performed only through the appropriate library function
*   calls.
*
***************************************************************/


OBJECT midilink
   node:ln
   pad:UINT
   ownernode:mln
   midinode:PTR TO midinode
   location:PTR TO midicluster
   clustercomment:PTR TO CHAR
   flags:CHAR
   portid:CHAR
   channelmask:INT
   eventtypemask:LONG
   packed:LONG, b[4]:ARRAY OF CHAR @ packed
   parserdata:ANY
   userdata:ANY
ENDOBJECT

/* SysExFilter members */
#define sxf_Mode b[0]           
#define sxf_ID1 b[1]           
#define sxf_ID2 b[2]

#define sxf_ID3 b[3]

/* MidiLink types */
/* ml_Flags */
CONST MLF_SENDER = 1<<0                  ,
      MLF_PARTCHANGE = 1<<1                  ,
      MLF_PRIVATELINK = 1<<2                  ,
      MLF_DEVICELINK = 1<<3                  ,
/* MidiLink tags */
      MLINK_BASE = TAG_USER+65,
      MLINK_LOCATION = MLINK_BASE+0      ,
      MLINK_CHANNELMASK = MLINK_BASE+1      ,
      MLINK_EVENTMASK = MLINK_BASE+2      ,
      MLINK_USERDATA = MLINK_BASE+3      ,
      MLINK_COMMENT = MLINK_BASE+4      ,
      MLINK_PORTID = MLINK_BASE+5      ,
      MLINK_PRIVATE = MLINK_BASE+6      ,
      MLINK_PRIORITY = MLINK_BASE+7      ,
/* REM: Add tags to change Sysex filter stuff...*/
      MLINK_SYSEXFILTER = MLINK_BASE+8      ,
      MLINK_SYSEXFILTERX = MLINK_BASE+9      ,
      MLINK_PARSE = MLINK_BASE+10     ,
      MLINK_RESERVED = MLINK_BASE+11     ,
      MLINK_ERRORCODE = MLINK_BASE+12     ,
      MLINK_NAME = MLINK_BASE+13     ,
/***************************************************************
*
*   SysExFilter modes
*
*   Contents of sxf_Mode.
*
*   Bit packed as follows: 00000mcc
*       m  - mode bit
*       cc - count bits 0 - 3 (only used for SXFM_1Byte)
*
***************************************************************/

      SXF_MODEBITS = $04,
      SXF_COUNTBITS = $03        ,
      SXFM_OFF = $00        ,
      SXFM_1BYTE = $00        ,
      SXFM_3BYTE = $04        

/***************************************************************
*
*   MidiNode
*
*   All fields are READ ONLY.  Modifications to fields may
*   performed only through the appropriate library function
*   calls.
*
***************************************************************/


OBJECT midinode
   node:ln
   clienttype:INT
   image:PTR TO image
   outlinks:mlh
   inlinks:mlh
   sigtask:PTR TO task
   receivehook:PTR TO hook
   participanthook:PTR TO hook
   receivesigbit:BYTE
   participantsigbit:BYTE
   errfilter:CHAR
   alignment[1]:ARRAY OF CHAR
   timestamp:PTR TO LONG
   msgqueuesize:LONG
   sysexqueuesize:LONG
ENDOBJECT

/* client types */
CONST CCTYPE_SEQUENCER = 1<<0,
      CCTYPE_SAMPLEEDITOR = 1<<1,
      CCTYPE_PATCHEDITOR = 1<<2,
      CCTYPE_NOTATOR = 1<<3          ,
      CCTYPE_EVENTPROCESSOR = 1<<4          ,
      CCTYPE_EVENTFILTER = 1<<5,
      CCTYPE_EVENTROUTER = 1<<6          ,
      CCTYPE_TONEGENERATOR = 1<<7          ,
      CCTYPE_EVENTGENERATOR = 1<<8          ,
      CCTYPE_GRAPHICANIMATOR = 1<<9          ,
/* Tags for CreateMidi() and SetMidiAttrs() */
      MIDI_BASE = TAG_USER+65,
      MIDI_NAME = MIDI_BASE+0   ,
      MIDI_SIGNALTASK = MIDI_BASE+1   ,
      MIDI_RECVHOOK = MIDI_BASE+2   ,
      MIDI_PARTHOOK = MIDI_BASE+3   ,
      MIDI_RECVSIGNAL = MIDI_BASE+4   ,
      MIDI_PARTSIGNAL = MIDI_BASE+5   ,
      MIDI_MSGQUEUE = MIDI_BASE+6   ,
      MIDI_SYSEXSIZE = MIDI_BASE+7   ,
      MIDI_TIMESTAMP = MIDI_BASE+8   ,
      MIDI_ERRFILTER = MIDI_BASE+9   ,
      MIDI_CLIENTTYPE = MIDI_BASE+10  ,
      MIDI_IMAGE = MIDI_BASE+11  ,
      MIDI_ERRORCODE = MIDI_BASE+12  ,
/***************************************************************
*
*   CreateMidi() Error Codes
*
*   These are the IoErr() codes that CreateMidi() can return
*   on failure.
*
*   !!! need specific error code set for each function instead!
*
***************************************************************/

      CME_NOMEM = 801       ,
      CME_NOSIGNALS = 802       ,
      CME_NOTIMER = 803       ,
      CME_BADPREFS = 804       

#define CME_NoUnit(unit) (820 + (unit)) 
/***************************************************************
*
*   MidiNode tag items for use with CreateMidi().
*
***************************************************************/

CONST CMA_BASE = TAG_USER + 64,
      CMA_SYSEX = CMA_BASE + 0  

CONST CMA_ALARM = CMA_BASE + 2  
 CONST CMA_PORTFILTER = CMA_BASE + 4  
 CONST CMA_TYPEFILTER = CMA_BASE + 5  
 CONST CMA_CHANFILTER = CMA_BASE + 6  
 CONST CMA_SYSEXFILTER = CMA_BASE + 7  
 /***************************************************************
*
*   MIDI Message Type Bits
*
*   Returned by MidiMsgType() and used with SetMidiFilters().
*
***************************************************************/

CONST CMB_NOTE = 0
 CONST CMB_PROG = 1
 CONST CMB_PITCHBEND = 2
 CONST CMB_CTRLMSB = 3
 CONST CMB_CTRLLSB = 4
 CONST CMB_CTRLSWITCH = 5
 CONST CMB_CTRLBYTE = 6
 CONST CMB_CTRLPARAM = 7
 CONST CMB_CTRLUNDEF = 8       
 CONST CMB_MODE = 9
 CONST CMB_CHANPRESS = 10
 CONST CMB_POLYPRESS = 11
 CONST CMB_REALTIME = 12
 CONST CMB_SYSCOM = 13
 CONST CMB_SYSEX = 14
 /* (these need to be long for SetMidiFilters()) */
CONST CMF_NOTE = 1 << CMB_NOTE
 CONST CMF_PROG = 1 << CMB_PROG
 CONST CMF_PITCHBEND = 1 << CMB_PITCHBEND
 CONST CMF_CTRLMSB = 1 << CMB_CTRLMSB
 CONST CMF_CTRLLSB = 1 << CMB_CTRLLSB
 CONST CMF_CTRLSWITCH = 1 << CMB_CTRLSWITCH
 CONST CMF_CTRLBYTE = 1 << CMB_CTRLBYTE
 CONST CMF_CTRLPARAM = 1 << CMB_CTRLPARAM
 CONST CMF_CTRLUNDEF = 1 << CMB_CTRLUNDEF
 CONST CMF_MODE = 1 << CMB_MODE
 CONST CMF_CHANPRESS = 1 << CMB_CHANPRESS
 CONST CMF_POLYPRESS = 1 << CMB_POLYPRESS
 CONST CMF_REALTIME = 1 << CMB_REALTIME
 CONST CMF_SYSCOM = 1 << CMB_SYSCOM
 CONST CMF_SYSEX = 1 << CMB_SYSEX
 /* some handy type macros */

CONST CMF_CTRL = CMF_CTRLMSB  OR  CMF_CTRLLSB  OR  CMF_CTRLSWITCH  OR  CMF_CTRLBYTE  OR  CMF_CTRLPARAM  OR  CMF_CTRLUNDEF
 CONST CMF_CHANNEL = CMF_NOTE  OR  CMF_PROG  OR  CMF_PITCHBEND  OR  CMF_CTRL  OR  CMF_MODE  OR  CMF_CHANPRESS  OR  CMF_POLYPRESS
 CONST CMF_ALL = CMF_CHANNEL  OR  CMF_REALTIME  OR  CMF_SYSCOM  OR  CMF_SYSEX
 /***************************************************************
*
*   MIDI Error Flags
*
*   These are error flags that can arrive at a MidiNode.
*   An application may choose to ignore or process any
*   combination of error flags.  See SetMidiErrFilter() and
*   GetMidiErr() for more information.
*
***************************************************************/

CONST CMEB_MSGERR = 0   
 CONST CMEB_BUFFERFULL = 1   
 CONST CMEB_SYSEXFULL = 2   
 CONST CMEB_PARSEMEM = 3   
 CONST CMEB_RECVERR = 4   
 CONST CMEB_RECVOVERFLOW = 5   
 CONST CMEB_SYSEXTOOBIG = 6   
 CONST CMEF_MSGERR = 1 << CMEB_MSGERR
 CONST CMEF_BUFFERFULL = 1 << CMEB_BUFFERFULL
 CONST CMEF_SYSEXFULL = 1 << CMEB_SYSEXFULL
 CONST CMEF_PARSEMEM = 1 << CMEB_PARSEMEM
 CONST CMEF_RECVERR = 1 << CMEB_RECVERR
 CONST CMEF_RECVOVERFLOW = 1 << CMEB_RECVOVERFLOW
 CONST CMEF_SYSEXTOOBIG = 1 << CMEB_SYSEXTOOBIG
 /* a handy macro for SetMidiErrFilter() */
CONST CMEF_ALL = CMEF_MSGERR  OR  CMEF_BUFFERFULL  OR  CMEF_SYSEXFULL  OR  CMEF_SYSEXTOOBIG  OR  CMEF_PARSEMEM  OR  CMEF_RECVERR  OR  CMEF_RECVOVERFLOW
 /***************************************************************
*
*   MidiTickHookMsg
*
*   Message structure passed to Tick Hooks
*
***************************************************************/


OBJECT miditickhookmsg
   id:LONG
   time:LONG
ENDOBJECT

/***************************************************************
*
*   MidiByteHookMsg
*
*   Message structure passed to Byte Hooks
*
***************************************************************/


OBJECT midibytehookmsg
   id:LONG
   unitnum:CHAR
   pad0:CHAR
   recvdata:INT
ENDOBJECT

/***************************************************************
*
*   Hook Message ID's
*
*   Each Hook passes as the "msg" param a pointer to one of these (LONG)
*   Can be extended for some types of messages
*
***************************************************************/

/***************************************************************
*
*   CMSG_Link structure
*
***************************************************************/


OBJECT cmlink
   methodid:LONG
   action:LONG
ENDOBJECT

/***************************************************************
*
*   ClusterNotifyNode
*
***************************************************************/


OBJECT clusternotifynode
   node:mln
   task:PTR TO task
   sigbit:BYTE
   pad[3]:ARRAY OF CHAR
ENDOBJECT

/***************************************************************
*
*   CAMD Macros
*
*   See camd.doc for info.
*
***************************************************************/

#define PackSysExFilter0() ((ULONG)SXFM_Off << 24)

#define PackSysExFilter1(id1) ((ULONG)(SXFM_1Byte  OR  1) << 24  OR  (ULONG)(id1) << 16)

#define PackSysExFilter2(id1,id2) ((ULONG)(SXFM_1Byte  OR  2) << 24  OR  (ULONG)(id1) << 16  OR  (id2) << 8)

#define PackSysExFilter3(id1,id2,id3) ((ULONG)(SXFM_1Byte  OR  3) << 24  OR  (ULONG)(id1) << 16  OR  (id2) << 8  OR  (id3))

#define PutMidiMsg(ml,msg) PutMidi((ml),(msg)->l[0])

/* ---- MidiNode */
#define PackSysExFilterX(xid) ((ULONG)SXFM_3Byte << 24  OR  (xid))

#define ClearSysExFilter(mi) SetSysExFilter ((mi), PackSysExFilter0())

#define SetSysExFilter1(mi,id1) SetSysExFilter ((mi), PackSysExFilter1(id1))

#define SetSysExFilter2(mi,id1,id2) SetSysExFilter ((mi), PackSysExFilter2(id1,id2))

#define SetSysExFilter3(mi,id1,id2,id3) SetSysExFilter ((mi), PackSysExFilter3(id1,id2,id3))

#define SetSysExFilterX(mi,xid) SetSysExFilter ((mi), PackSysExFilterX(xid))

#define ClearSysExQueue(mi) SetSysExQueue ((mi), NIL, 0)

/* ---- Message */
    /* REM: These macros no longer exist... */
    /* REM: We'll need to define a new macro to put MIDI bytes directly to a port */
/* #define PutMidi(mi,msg)                 PutMidiToPort ((msg)->mm_Msg & ~0xff | (mi)->SendPort) */
/* #define PutSysEx(mi,data)               PutSysExToPort ((long)(mi)->SendPort, data) */

    /* ---- Unit */
#define GetMidiInPort(unit) SetMidiInPort ((long)(unit), -1)

#define GetMidiOutMask(unit) SetMidiOutMask ((long)(unit), 0, 0)

#define AndMidiOutMask(unit,mask) SetMidiOutMask ((long)(unit), 0, ~(ULONG)mask)

#define OrMidiOutMask(unit,mask) SetMidiOutMask ((long)(unit), -1, (ULONG)mask)

#define MidiThru(unit,enable) SetMidiOutMask ((long)(unit), (enable) ? -1 : 0, 1 << CMP_Out(unit))

/* ---- Timer */
#define ClearMidiAlarm(mi) SetMidiAlarm ((mi),0)


