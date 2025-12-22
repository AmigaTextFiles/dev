#ifndef KERN_AMIGA_NETDB_H
#define KERN_AMIGA_NETDB_H

#ifndef AMIGA_NETDB_H
#define AMIGA_NETDB_H


#ifndef _NETDB_H_
#include <netdb.h>
#endif

#ifndef _NETINET_IN_H_
#include <netinet/in.h>
#endif


#ifndef EXEC_TYPES_H 
#include <exec/types.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif

#ifndef PROTO_EXEC_H
#include <proto/exec.h>
#endif

/* Access control table item */
struct AccessItem {
  UWORD	ai_flags;
  UWORD	ai_port;
  ULONG	ai_host;
  ULONG ai_mask;
};

/* Access control flags */
#define ACF_ALLOW	0x01
#define ACF_LOG		0x02
#define ACF_PRIVONLY	0x04 /* 0 as port matches for privileged ports only */
#define ACF_CONTINUE	(1 << 15)

/* AC table temporary buffer size */
#define TMPACTSIZE	0x4000 

/* NetDataBase */
struct NetDataBase {
  struct SignalSemaphore ndb_Lock;
  struct MinList         ndb_Hosts;
  struct MinList         ndb_Networks;
  struct MinList         ndb_Services;
  struct MinList         ndb_Protocols;
  struct MinList         ndb_NameServers;
  struct MinList         ndb_Domains;
  LONG			 ndb_AccessCount; /* tmp var, but reduces code size */
  struct AccessItem *	 ndb_AccessTable;
};

extern struct NetDataBase *NDB;

/* Locking macros for NDB */
#define LOCK_W_NDB(ndb) (ObtainSemaphore(&(ndb)->ndb_Lock))
#define LOCK_R_NDB(ndb) (ObtainSemaphoreShared(&(ndb)->ndb_Lock))
#define UNLOCK_NDB(ndb) (ReleaseSemaphore(&(ndb)->ndb_Lock))
#define ATTEMPT_NDB(ndb) (AttemptSemaphore(&(ndb)->ndb_Lock))

/*
 * GenEnt has the common part of all NetDataBase Nodes below
 */
struct GenentNode {
  struct MinNode gn_Node;
  short          gn_EntSize;
  struct {
    char dummy[0];
  }              gn_Ent;
};

/* NetDataBase Nodes */
struct HostentNode {
  struct MinNode hn_Node;
  short          hn_EntSize;
  struct hostent hn_Ent;
};

struct NetentNode {
  struct MinNode nn_Node;
  short          nn_EntSize;
  struct netent  nn_Ent;
};

struct ServentNode {
  struct MinNode  sn_Node;
  short           sn_EntSize;
  struct servent  sn_Ent;
};

struct ProtoentNode {
  struct MinNode  pn_Node;
  short           pn_EntSize;
  struct protoent pn_Ent;
};

struct NameserventNode {
  struct MinNode  nsn_Node;
  short           nsn_EntSize;
  struct nameservent {
    struct in_addr ns_addr;
  } nsn_Ent;
};

struct DomainentNode {
  struct MinNode  dn_Node;
  short           dn_EntSize;
  struct domainent {
    char *d_name;
  } dn_Ent;
};
/*
 * netdatabase calls for some GGTCP/IP functions
 */
struct ServentNode * findServentNode(struct NetDataBase * ndb,
				     const char * name, const char * proto);

/*
 * Read NetDB...
 */
LONG do_netdb(struct CSource *cs, UBYTE **errstrp, struct CSource *res);
LONG reset_netdb(struct CSource *cs, UBYTE **errstrp, struct CSource *res);
LONG init_netdb(void);
void netdb_deinit(void);
     
#endif /* AMIGA_NETDB_H */

#endif /*KERN_AMIGA_NETDB_H */
