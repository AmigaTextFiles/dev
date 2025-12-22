    include "exec/types.i"
    include "exec/macros.i"
    include "exec/lists.i"
    include "exec/nodes.i"
    include "utility/tagitem.i"

    ENUM
    EITEM   CD_Linkages
    EITEM   CD_NLocks

    STRUCTURE MidiMsg,0
        LABEL   mm_Msg
        UBYTE   mm_Status
        UBYTE   mm_Data1
        UBYTE   mm_Data2
        UBYTE   mm_Port
        ULONG   mm_Time
        LABEL   mm_SIZE

    STRUCTURE MidiCluster,LN_SIZE
        WORD    mcl_Pad
        STRUCT  mcl_Receivers,LH_SIZE
        STRUCT  mcl_Senders,LH_SIZE
        WORD    mcl_PublicParticipants
        UWORD   mcl_Flags
        LABEL   mcl_SIZE

    STRUCTURE SysExFilter,0
        LABEL   sxf_Packed
        UBYTE   sxf_Mode
        STRUCT  sxf_ID,3
        LABEL   sxf_SIZE

    STRUCTURE MidiLink,LN_SIZE
        WORD    ml_Pad
        STRUCT  ml_OwnerNode,MLN_SIZE
        APTR    ml_MidiNode
        APTR    ml_Location
        APTR    ml_ClusterComment
        UBYTE   ml_Flags
        UBYTE   ml_PortID
        UWORD   ml_ChannelMask
        ULONG   ml_EventTypeMask
        ULONG   ml_SysExFilter
        APTR    ml_ParserData
        APTR    ml_UserData
        LABEL   ml_SIZE

    ENUM
    EITEM   MLTYPE_Receiver
    EITEM   MLTYPE_Sender
    EITEM   MLTYPE_NTypes

    BITDEF  ML,SENDER,0
    BITDEF  ML,PARTCHANGE,1
    BITDEF  ML,PRIVATELINK,2
    BITDEF  ML,DEVICELINK,3

    ENUM    TAG_USER+65

    EITEM   MLINK_Location
    EITEM   MLINK_ChannelMask
    EITEM   MLINK_EventMask
    EITEM   MLINK_UserData
    EITEM   MLINK_Comment
    EITEM   MLINK_PortID
    EITEM   MLINK_Private
    EITEM   MLINK_Priority
    EITEM   MLINK_SysExFilter
    EITEM   MLINK_SysExFilterX
    EITEM   MLINK_Parse
    EITEM   MLINK_DeviceLink
    EITEM   MLINK_ErrorCode
    EITEM   MLINK_Name

    STRUCTURE MidiNode,LN_SIZE
        UWORD   mi_ClientType
        APTR    mi_Image
        STRUCT  mi_OutLinks,MLH_SIZE
        STRUCT  mi_InLinks,MLH_SIZE
        APTR    mi_SigTask
        APTR    mi_ReceiveHook
        APTR    mi_ParticipantHook
        BYTE    mi_ReceiveSigBit
        BYTE    mi_ParticipantSigBit
        UBYTE   mi_ErrFilter
        UBYTE   mi_Alignment
        APTR    mi_TimeReference
        ULONG   mi_MsgQueueSize
        ULONG   mi_SysExQueueSize
        LABEL   mi_SIZE

CCType_Sequencer        equ     (1<<0)
CCType_SampleEditor     equ     (1<<1)
CCType_PatchEditor      equ     (1<<2)
CCType_Notator          equ     (1<<3)
CCType_EventProcessor   equ     (1<<4)
CCType_EventFilter      equ     (1<<5)
CCType_EventRouter      equ     (1<<6)
CCType_ToneGenerator    equ     (1<<7)
CCType_EventGenerator   equ     (1<<8)
CCType_GraphicAnimator  equ     (1<<9)

    ENUM    TAG_USER+65
    EITEM   MIDI_Name
    EITEM   MIDI_SignalTask
    EITEM   MIDI_RecvHook
    EITEM   MIDI_PartHook
    EITEM   MIDI_RecvSignal
    EITEM   MIDI_PartSignal
    EITEM   MIDI_BufferSize
    EITEM   MIDI_SysExSize
    EITEM   MIDI_TimeStamp
    EITEM   MIDI_ErrFilter
    EITEM   MIDI_ClientType
    EITEM   MIDI_Image
    EITEM   MIDI_ErrorCode

    BITDEF  CM,Note,0
    BITDEF  CM,Prog,1
    BITDEF  CM,PitchBend,2
    BITDEF  CM,CtrlMSB,3
    BITDEF  CM,CtrlLSB,4
    BITDEF  CM,CtrlSwitch,5
    BITDEF  CM,CtrlByte,6
    BITDEF  CM,CtrlParam,7
    BITDEF  CM,CtrlUndef,8
    BITDEF  CM,Mode,9
    BITDEF  CM,ChanPress,10
    BITDEF  CM,PolyPress,11
    BITDEF  CM,RealTime,12
    BITDEF  CM,SysCom,13
    BITDEF  CM,SysEx,14

CMF_Ctrl    equ CMF_CtrlMSB!CMF_CtrlLSB!CMF_CtrlSwitch!CMF_CtrlByte!CMF_CtrlParam!CMF_CtrlUndef
CMF_Channel equ CMF_Note!CMF_Prog!CMF_PitchBend!CMF_Ctrl!CMF_Mode!CMF_ChanPress!CMF_PolyPress
CMF_All     equ CMF_Channel!CMF_RealTime!CMF_SysCom!CMF_SysEx

SXF_ModeBits    equ $04
SXF_CountBits   equ $03
SXFM_Off        equ $00
SXFM_1Byte      equ $00
SXFM_3Byte      equ $04

    BITDEF  CME,MsgErr,0
    BITDEF  CME,BufferFull,1
    BITDEF  CME,SysExFull,2
    BITDEF  CME,ParseMem,3
    BITDEF  CME,RecvErr,4
    BITDEF  CME,RecvOverflow,5
    BITDEF  CME,SysExTooBig,6

CMEF_All    equ CMEF_MsgErr!CMEF_BufferFull!CMEF_SysExFull!CMEF_SysExTooBig!CMEF_ParseMem!CMEF_RecvErr!CMEF_RecvOverflow

CME_NoMem       equ 801
CME_NoSignals   equ 802
CME_NoTimer     equ 803
CME_BadPrefs    equ 804
CME_NoUnit      equ 820

    ENUM
    EITEM   CMSG_Recv
    EITEM   CMSG_Link
    EITEM   CMSG_StateChange
    EITEM   CMSG_Alarm

    STRUCTURE ClusterNotifyNode,MLN_SIZE
        APTR	cnn_Task
	BYTE	cnn_SigBit
        STRUCT	cnn_pad,3
	LABEL	cnn_SIZE
