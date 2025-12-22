extern struct TagItem buffermanagement[];

#ifndef SYS_PARAM_H
#include <sys/param.h>
#endif

BOOL
ioip_alloc_mbuf(struct IOIPReq *s2rp, ULONG MTU);

/*
 * Allocate a new Sana-II IORequest for this task
 */
static inline struct IOSana2Req *
CreateIOSana2Req(register struct sana_softc *ssc)
{
  register struct IOSana2Req *req;
  register struct MsgPort *port;

  port = CreateMsgPort();
  if (!port) return NULL;

  req = CreateIORequest(port, sizeof(*req));
  if (!req) {
    DeleteMsgPort(port);
    return NULL;
  }

  if (ssc) {
    req->ios2_Req.io_Device    = ssc->ss_dev;
    req->ios2_Req.io_Unit      = ssc->ss_unit;
    req->ios2_BufferManagement = ssc->ss_bufmgnt;

    aligned_bcopy(ssc->ss_hwaddr, req->ios2_SrcAddr, ssc->ss_if.if_addrlen);
  }
  return req;
}

/*
 * Delete a Sana-II IORequest 
 */
static inline VOID 
DeleteIOSana2Req(register struct IOSana2Req *open)
{
  register struct MsgPort *port = open->ios2_Req.io_Message.mn_ReplyPort;

  DeleteIORequest((struct IORequest*) open);
  if (port)
    DeleteMsgPort(port);
}

