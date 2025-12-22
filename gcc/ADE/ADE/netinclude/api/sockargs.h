#ifndef API_SOCKARGS_H
#define API_SOCKARGS_H


#ifndef _SYS_TYPES_H_ 
#include <sys/types.h>
#endif

#ifndef  _SYS_MBUF_H_
#include <sys/mbuf.h>
#endif


/*
 * sockArgs code in amiga_syscalls.c
 */
long sockArgs(struct mbuf **mp, caddr_t buf, long buflen, long type);

#endif /* API_SOCKARGS_H */
