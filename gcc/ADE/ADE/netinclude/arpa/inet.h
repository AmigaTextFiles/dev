#ifndef ARPA_INET_H
#define ARPA_INET_H

#ifndef KERNEL

#ifndef IN_H
#include <netinet/in.h>
#endif

/*
 * Include socket protos/inlines/pragmas
 */
#ifndef BSDSOCKET_H
#include <bsdsocket.h>
#endif

#endif /* !KERNEL */

#endif /* ARPA_INET_H */
