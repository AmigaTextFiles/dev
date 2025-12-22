#include <exec/types.h>
#include <exec/io.h>
#include <devices/scsidisk.h>
#include <clib/exec_protos.h>

struct scsichan {
                 char *name; /* Name des Device */
                 ULONG unit; /* Unitnummer */
                 ULONG flags; /* Flags */
                 struct MsgPort *iop;
                 struct IOStdReq *ior;
                };

BYTE OpenSCSIchan(struct scsichan *);
BYTE DoSCSIcmd(struct scsichan *, struct SCSICmd *);
BYTE CloseSCSIchan(struct scsichan *);
