/*
 * serio.h  V0.00
 *
 * Include file for "serial.device" utility routines
 *
 * (c) 1992 Stefan Becker
 *
 */

/* Include files */
#include <exec/memory.h>
#include <devices/serial.h>
#include <devices/timer.h>
#include <utility/tagitem.h>
#include <clib/exec_protos.h>
#include <clib/utility_protos.h>

/* data structure for a serial stream */
/* ss_Status and ss_Unread are only valid after QuerySerial()! */
struct SerialStream
{
 struct MsgPort     *ss_RPort;  /* I/O request reply port *PRIVATE*   */
 ULONG               ss_Mask;   /* Reply port signal bit  *READ ONLY* */
 struct IOExtSer    *ss_Cmd;    /* I/O Command request    *PRIVATE*   */
 struct IOExtSer    *ss_Read;   /* I/O Read request       *PRIVATE*   */
 struct IOExtSer    *ss_Write;  /* I/O Write request      *PRIVATE*   */
 ULONG               ss_Baud;   /* bps rate               *READ ONLY* */
 ULONG               ss_Status; /* Serial line status     *READ ONLY* */
 ULONG               ss_Unread; /* Unread characters      *READ ONLY* */
};

/* serio TagItems */
#define SIO_CtlChar     (TAG_USER+ 1) /* ULONG */
#define SIO_RBufLen     (TAG_USER+ 2) /* ULONG */
#define SIO_ExtFlags    (TAG_USER+ 3) /* ULONG */
#define SIO_Baud        (TAG_USER+ 4) /* ULONG */
#define SIO_BrkTime     (TAG_USER+ 5) /* ULONG */
#define SIO_TermArray   (TAG_USER+ 6) /* struct IOTArray * */
#define SIO_ReadLen     (TAG_USER+ 7) /* UBYTE */
#define SIO_WriteLen    (TAG_USER+ 8) /* UBYTE */
#define SIO_StopBits    (TAG_USER+ 9) /* UBYTE */
#define SIO_SerFlags    (TAG_USER+10) /* ULONG */

/* Flags returned by CheckSerial() */
#define SIOB_ReadReady  0
#define SIOF_ReadReady  (1L<<SIOB_ReadReady)
#define SIOB_WriteReady 1
#define SIOF_WriteReady (1L<<SIOB_WriteReady)

/* Function prototypes */
struct SerialStream *CreateSerialStream(char *DeviceName, ULONG Unit,
                                        ULONG SerFlags);
void DeleteSerialStream(struct SerialStream *stream);
BOOL SetSerialParamsTagList(struct SerialStream *stream,
                            struct TagItem *TagArray);
BOOL SetSerialParamsTags(struct SerialStream *stream, Tag Tag1, ...);
ULONG ReadSerialSynch(struct SerialStream *stream, void *buf, ULONG buflen);
void ReadSerialASynchStart(struct SerialStream *stream, void *buf,
                           ULONG buflen);
ULONG ReadSerialASynchEnd(struct SerialStream *stream);
ULONG WriteSerialSynch(struct SerialStream *stream, void *buf, ULONG buflen);
void WriteSerialASynchStart(struct SerialStream *stream, void *buf,
                           ULONG buflen);
ULONG WriteSerialASynchEnd(struct SerialStream *stream);
BOOL QuerySerial(struct SerialStream *stream);
BOOL ClearSerial(struct SerialStream *stream);
void RemoveIORequest(struct IORequest *ior);
