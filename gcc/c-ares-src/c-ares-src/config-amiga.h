#ifndef HEADER_CARES_CONFIG_AMIGA_H
#define HEADER_CARES_CONFIG_AMIGA_H

#ifdef AOS3
#include <clib/amitcp_protos.h>
#include <amitcp/socketbasetags.h>
#define ANSI_CONSOLE
int ares_amiga_init(void);
void ares_amiga_cleanup(void);
extern struct Library *SocketBase;
extern char *prog;
#endif

#endif
