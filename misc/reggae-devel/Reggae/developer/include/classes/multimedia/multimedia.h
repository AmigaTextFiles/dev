/* 
$VER: multimedia.h 51.4 (23.2.2007)
*/

#ifndef CLASSES_MULTIMEDIA_MULTIMEDIA_H
#define CLASSES_MULTIMEDIA_MULTIMEDIA_H

#include <exec/libraries.h>
#include <intuition/classusr.h>
#include <devices/timer.h>
#include <clib/alib_protos.h>

#define MAKE_ID(a,b,c,d)  ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))

/* data object attributes */

#define MMA_Dummy              0x8EDA0000

#define MMA_MediaType          (MMA_Dummy + 1)    /* [I..] MediaNewObject() */
#define MMA_Priority           (MMA_Dummy + 2)    /* [...] subclasses only! */
#define MMA_Stream             (MMA_Dummy + 3)    /* [I.G] MediaNewObject() */
#define MMA_Recognition        (MMA_Dummy + 4)    /* [I..] MediaNewObject() */
#define MMA_TaskPriority       (MMA_Dummy + 5)    /* [I..] for classes creating subtasks */
#define MMA_ClassName          (MMA_Dummy + 6)    /* [..G] */
#define MMA_ClassDesc          (MMA_Dummy + 7)    /* [..G] */
#define MMA_StreamType         (MMA_Dummy + 8)    /* [I..] MediaNewObject() */
#define MMA_StreamName         (MMA_Dummy + 9)    /* [I..] MediaNewObject() */
#define MMA_MimeType           (MMA_Dummy + 10)   /* [..G] decoders */
#define MMA_DataFormat         (MMA_Dummy + 11)   /* [I.G] general */
#define MMA_ErrorCode          (MMA_Dummy + 12)   /* [I.G] general */
#define MMA_StreamHandle       (MMA_Dummy + 13)   /* [I..] MediaNewObject() */
#define MMA_StreamMode         (MMA_Dummy + 14)
#define MMA_SupportedFormats   (MMA_Dummy + 15)   /* [..G] general */
#define MMA_Ports              (MMA_Dummy + 16)   /* [..G] general */
#define MMA_StreamSeekable     (MMA_Dummy + 17)
#define MMA_StreamPosBytes     (MMA_Dummy + 18)   /* [..G] */
#define MMA_Mark               (MMA_Dummy + 19)   /* [.SG] */
#define MMA_StreamPosFrames    (MMA_Dummy + 20)
#define MMA_RecognizeCode      (MMA_Dummy + 21)   /* for subclasses */
#define MMA_ClassType          (MMA_Dummy + 22)   /* for subclasses */
#define MMA_StreamPosTime      (MMA_Dummy + 23)
#define MMA_StreamLength       (MMA_Dummy + 24)
#define MMA_ObjectName         (MMA_Dummy + 25)   /* [I.G.Q] general */
#define MMA_BlockAlign         (MMA_Dummy + 26)   /* [..G.Q] internal */
#define MMA_AutoDestruction    (MMA_Dummy + 27)   /* [I....] internal */

#define MMA_MAX_ATTR           MMA_BlockAlign

#define MMA_StreamMode_Read        0x0001  /* read only */
#define MMA_StreamMode_Write       0x0002  /* write only, creates new stream */

/* Special values for MediaFindFilter() tags. */

#define MMV_Find_Any                    0x7FFFFFFF  /* any format will go */
#define MMV_Find_AnyCommon              0x7FFFFFFE  /* any common format */
#define MMV_Find_AnyCommonAudio         0x7FFFFFFD  /* any common audio format */
#define MMV_Find_AnyAudio               0x7FFFFFFC  /* any non-common audio format */

/* methods */

#define MMM_GetPort            (MMA_Dummy + 73)
#define MMM_Push               (MMA_Dummy + 74)
#define MMM_Pull               (MMA_Dummy + 75)
#define MMM_SetPort            (MMA_Dummy + 76)
#define MMM_AddPort            (MMA_Dummy + 77)
#define MMM_LockObject         (MMA_Dummy + 78)
#define MMM_UnlockObject       (MMA_Dummy + 79)
#define MMM_Setup              (MMA_Dummy + 80) /* subclasses only */
#define MMM_AddForward         (MMA_Dummy + 81) /* private */
#define MMM_Play               (MMA_Dummy + 82) /* sound/video playback control */
#define MMM_Pause              (MMA_Dummy + 83) /* sound/video playback control */
#define MMM_Stop               (MMA_Dummy + 84) /* sound/video playback control */
#define MMM_Seek               (MMA_Dummy + 85)
#define MMM_IsMember           (MMA_Dummy + 86)
#define MMM_GetPortFwd         (MMA_Dummy + 87)
#define MMM_SetPortFwd         (MMA_Dummy + 88)
#define MMM_Peek               (MMA_Dummy + 92)
#define MMM_Restore            (MMA_Dummy + 93)
#define MMM_ConnectPort        (MMA_Dummy + 94)
#define MMM_DisconnectPort     (MMA_Dummy + 95)

/* MMM_GetPort/SetPort tags */

#define MMA_Port_Object        (MMA_Dummy + 200)  /* [G.] */
#define MMA_Port_Number        (MMA_Dummy + 201)  /* [G.] */
#define MMA_Port_FormatsTable  (MMA_Dummy + 202)  /* [G.] */
#define MMA_Port_Format        (MMA_Dummy + 203)  /* [GS] */
#define MMA_Port_ConnObject    (MMA_Dummy + 204)  /* [GS] */
#define MMA_Port_ConnNumber    (MMA_Dummy + 205)  /* [GS] */
#define MMA_Port_Type          (MMA_Dummy + 206)  /* [G.] */

/* media types */

#define MMT_SOUND     0x00000001
#define MMT_PICTURE   0x00000002
#define MMT_VIDEO     0x00000004

/* recognition type */

#define MMREC_LIGHT  0       /* use fast (but maybe inaccurate) recognition routines */
#define MMREC_HEAVY  1       /* use accurate (but maybe slow) recognition routines */

/* class types */

#define MMCLASS_BASIC           0       /* multimedia.class, processblock.class, multiread.buffer */
#define MMCLASS_DEMUXER         1
#define MMCLASS_DECODER         2
#define MMCLASS_ENCODER         3
#define MMCLASS_MULTIPLEXER     4
#define MMCLASS_OUTPUT          5
#define MMCLASS_FILTER          6
#define MMCLASS_STREAM          7

/* structure describing block port */

struct MediaPort
{
	struct Node  mdp_Node;
	Object      *mdp_Object;
	ULONG        mdp_Port;
	ULONG        mdp_Number;
	ULONG        mdp_Type;
	ULONG        mdp_DataFormat;
	ULONG       *mdp_AvailFormats;
	UBYTE       *mdp_GatherBuffer;
	ULONG        mdp_GatherBytes;
};

struct MediaPortDesc
{
	ULONG   mdd_Type;
	ULONG  *mdd_FormatTable;
};

/* for mdp_Type */

#define MDP_TYPE_INPUT          1
#define MDP_TYPE_OUTPUT         2

/* invalid port number */

#define MM_NO_PORT              0xFFFFFFFF

/* enumerated data formats */

/* general */

#define MMF_UNKNOWN              0x00000000
#define MMF_STREAM               0x00000001    /* port interfaces to stream object */
#define MMF_ANY_FORMAT           0xFFFFFFFF    /* wildchar used e.g. by generic buffers */

/* common formats */

#define MMF_COMMONMASK					 0x00010000
#define MMF_COMMONBIT            17

#define MMFC_UNKNOWN             (MMF_COMMONMASK | 0)
#define MMFC_AUDIO_INT16         (MMF_COMMONMASK | 1)
#define MMFC_AUDIO_INT32         (MMF_COMMONMASK | 2)
#define MMFC_AUDIO_FLOAT32       (MMF_COMMONMASK | 3)
#define MMFC_VIDEO_ARGB32        (MMF_COMMONMASK | 4)

#define MMFC_MAXFORMAT           (MMF_COMMONMASK | 4)

#define IS_COMMON(x) ((x) & MMF_COMMONMASK)
#define IS_COMMON_AUDIO(x) (((x) >= MMFC_AUDIO_INT16) && ((x) <= MMFC_AUDIO_FLOAT32))

/* error values */

#define MMERR_BASE                  1101

#define MMERR_END_OF_DATA           1101    /* data stream has ended [unexpectedly] */
#define MMERR_OUT_OF_MEMORY         1102    /* memory internal allocation failed */
#define MMERR_NOT_SEEKABLE          1103    /* operation requires seekable stream */
#define MMERR_WRONG_ARGUMENTS       1104    /* wrong arguments to a method */
#define MMERR_NO_STREAM             1105    /* missing src/dest stream for operation */
#define MMERR_WRONG_DATA            1106    /* malformed data in stream [header] */
#define MMERR_NO_STREAM_CLASS       1107    /* wrong stream type specified */
#define MMERR_NO_DECODER            1108    /* no decoder for an encoded format */
#define MMERR_NOT_RECOGNIZED        1109    /* no demultiplexer recognized the format */
#define MMERR_IO_ERROR              1110    /* I/O error in source or destination stream */
#define MMERR_FORMAT_NOT_SUPPORTED  1111    /* unsupported format of raw data */
#define MMERR_BROKEN_PIPE           1112    /* pipe of objects is not continuous */
#define MMERR_NOT_IMPLEMENTED       1113    /* functionality not implemented or not supported*/
#define MMERR_RESOURCE_MISSING      1114    /* missing system resource (library or class usually) */

#define MMERR_MAX                   1114

/* method messages */

/* MMM_AddPort, MMM_Setup, MMM_Restore, MMM_DisconnectPort */

struct mmopPort
{
	ULONG MethodID;
	ULONG Port;
};

/* MMM_ConnectPort */

struct mmopConnect
{
	ULONG MethodID;
	ULONG Port;
	Object *DestObj;
	ULONG DestPort;
};

/* MMM_GetPort */

struct mmopGetPort
{
	ULONG MethodID;
	ULONG Port;
	ULONG Attribute;
	ULONG *Storage;
};

/* MMM_SetPort */

struct mmopSetPort
{
	ULONG MethodID;
	ULONG Port;
	ULONG Attribute;
	ULONG Value;
};

/* MMM_Push, MMM_Pull */

struct mmopData
{
	ULONG MethodID;
	ULONG Port;
	APTR  Buffer;
	ULONG Length;
};

/* MMM_Seek */

struct mmopSeek
{
	ULONG MethodID;
	ULONG Port;
	ULONG Type;
	UQUAD *Position;
};

/* seek types */

#define MMM_SEEK_BYTES		0     /* Position in bytes */
#define MMM_SEEK_FRAMES   1     /* Position in frames */
#define MMM_SEEK_TIME     2     /* Position in microseconds */


/* MMM_Get/SetPort wrappers */

#define MediaGetPort(obj, port, attr) ({ ULONG _val = 0; DoMethod(obj, MMM_GetPort, port, attr, (ULONG)&_val); _val; })
#define MediaGetPort64(obj, port, attr) ({ UQUAD _val = 0; DoMethod(obj, MMM_GetPort, port, attr, (ULONG)&_val); _val; })
#define MediaSetPort(obj, port, attr, val) DoMethod(obj, MMM_SetPort, port, attr, val)
#define MediaSetPort64(obj, port, attr, val) ({ UQUAD _val = val; DoMethod(obj, MMM_SetPort, port, attr, (ULONG)&_val); })

/* MMM_Get/SetPortFwd wrappers */

#define MediaGetPortFwd(obj, port, attr) ({ ULONG _val = 0; DoMethod(obj, MMM_GetPortFwd, port, attr, (ULONG)&_val); _val; })
#define MediaGetPortFwd64(obj, port, attr) ({ UQUAD _val = 0; DoMethod(obj, MMM_GetPortFwd, port, attr, (ULONG)&_val); _val; })
#define MediaSetPortFwd(obj, port, attr, val) DoMethod(obj, MMM_SetPortFwd, port, attr, val)
#define MediaSetPortFwd64(obj, port, attr, val) ({ UQUAD _val = val; DoMethod(obj, MMM_SetPortFwd, port, attr, (ULONG)&_val); })


struct DtCodeContext
{
	struct Library  *dcc_SysBase;
	struct Library  *dcc_IntuitionBase;
	struct Library  *dcc_DOSBase;
	struct Library  *dcc_MultimediaBase;
	Object          *dcc_Source;
	ULONG            dcc_Port;
};


/* Log levels. */

#define LOG_NONE        0
#define LOG_ERRORS      1
#define LOG_INFO        2
#define LOG_VERBOSE     3


/* Log message with no parameter. */

#define MLOG(level, msg) MediaLog(level, CLASSNAME, __FUNCTION__, msg, NULL)

/* Log message with variable args (at least one). */

#ifndef __cplusplus
#define MLOGV(level, msg, ...) MediaLog(level, CLASSNAME, __FUNCTION__, msg, __VA_ARGS__)
#else
#define MLOGV(level, msg...) MediaLog(level, CLASSNAME, __FUNCTION__, msg)
#endif

//#endif /* __cplusplus */

/* Message structure sent to MediaLogger */

struct MediaError
{
	struct Message Msg;
	ULONG  Level;
	STRPTR AppName;
	STRPTR ClassName;
	STRPTR FunctionName;
	STRPTR EventDescription;
};

#define seterr(x) SetAttrs(obj, MMA_ErrorCode, x, TAG_END)

/* MMM_AddForward */

struct mmopAddForward
{
	ULONG   MethodID;
	Object *FwdObject;
	ULONG   FwdPort;
};

#endif /* CLASSES_MULTIMEDIA_MULTIMEDIA_H */
