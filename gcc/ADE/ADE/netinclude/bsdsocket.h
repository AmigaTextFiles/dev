#ifndef BSDSOCKET_H
#define BSDSOCKET_H


/* These are compiler independent */
#include <unistd.h>
#include <clib/netlib_protos.h>

/* these need gcc, but shouldn't be included when compiling
   GGTCP itself, no way! */
#ifndef KERNEL
#include <proto/socket.h>
#include <proto/usergroup.h>
#endif /* KERNEL */

#endif /* !BSDSOCKET_H */
