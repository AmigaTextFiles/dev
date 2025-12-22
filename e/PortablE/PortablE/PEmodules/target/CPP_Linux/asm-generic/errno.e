OPT NATIVE
PUBLIC MODULE 'target/asm-generic/errno-base'
{#include <asm-generic/errno.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
NATIVE {_ASM_GENERIC_ERRNO_H} DEF

NATIVE {EDEADLK}		CONST EDEADLK		= 35	/* Resource deadlock would occur */
NATIVE {ENAMETOOLONG}	CONST ENAMETOOLONG	= 36	/* File name too long */
NATIVE {ENOLCK}		CONST ENOLCK		= 37	/* No record locks available */

/*
 * This error code is special: arch syscall entry code will return
 * -ENOSYS if users try to call a syscall that doesn't exist.  To keep
 * failures of syscalls that really do exist distinguishable from
 * failures due to attempts to use a nonexistent syscall, syscall
 * implementations should refrain from returning -ENOSYS.
 */
NATIVE {ENOSYS}		CONST ENOSYS		= 38	/* Invalid system call number */

NATIVE {ENOTEMPTY}	CONST ENOTEMPTY	= 39	/* Directory not empty */
NATIVE {ELOOP}		CONST ELOOP		= 40	/* Too many symbolic links encountered */
NATIVE {EWOULDBLOCK}	CONST EWOULDBLOCK	= EAGAIN	/* Operation would block */
NATIVE {ENOMSG}		CONST ENOMSG		= 42	/* No message of desired type */
NATIVE {EIDRM}		CONST EIDRM		= 43	/* Identifier removed */
NATIVE {ECHRNG}		CONST ECHRNG		= 44	/* Channel number out of range */
NATIVE {EL2NSYNC}	CONST EL2NSYNC	= 45	/* Level 2 not synchronized */
NATIVE {EL3HLT}		CONST EL3HLT		= 46	/* Level 3 halted */
NATIVE {EL3RST}		CONST EL3RST		= 47	/* Level 3 reset */
NATIVE {ELNRNG}		CONST ELNRNG		= 48	/* Link number out of range */
NATIVE {EUNATCH}		CONST EUNATCH		= 49	/* Protocol driver not attached */
NATIVE {ENOCSI}		CONST ENOCSI		= 50	/* No CSI structure available */
NATIVE {EL2HLT}		CONST EL2HLT		= 51	/* Level 2 halted */
NATIVE {EBADE}		CONST EBADE		= 52	/* Invalid exchange */
NATIVE {EBADR}		CONST EBADR		= 53	/* Invalid request descriptor */
NATIVE {EXFULL}		CONST EXFULL		= 54	/* Exchange full */
NATIVE {ENOANO}		CONST ENOANO		= 55	/* No anode */
NATIVE {EBADRQC}		CONST EBADRQC		= 56	/* Invalid request code */
NATIVE {EBADSLT}		CONST EBADSLT		= 57	/* Invalid slot */

NATIVE {EDEADLOCK}	CONST EDEADLOCK	= EDEADLK

NATIVE {EBFONT}		CONST EBFONT		= 59	/* Bad font file format */
NATIVE {ENOSTR}		CONST ENOSTR		= 60	/* Device not a stream */
NATIVE {ENODATA}		CONST ENODATA		= 61	/* No data available */
NATIVE {ETIME}		CONST ETIME		= 62	/* Timer expired */
NATIVE {ENOSR}		CONST ENOSR		= 63	/* Out of streams resources */
NATIVE {ENONET}		CONST ENONET		= 64	/* Machine is not on the network */
NATIVE {ENOPKG}		CONST ENOPKG		= 65	/* Package not installed */
NATIVE {EREMOTE}		CONST EREMOTE		= 66	/* Object is remote */
NATIVE {ENOLINK}		CONST ENOLINK		= 67	/* Link has been severed */
NATIVE {EADV}		CONST EADV		= 68	/* Advertise error */
NATIVE {ESRMNT}		CONST ESRMNT		= 69	/* Srmount error */
NATIVE {ECOMM}		CONST ECOMM		= 70	/* Communication error on send */
NATIVE {EPROTO}		CONST EPROTO		= 71	/* Protocol error */
NATIVE {EMULTIHOP}	CONST EMULTIHOP	= 72	/* Multihop attempted */
NATIVE {EDOTDOT}		CONST EDOTDOT		= 73	/* RFS specific error */
NATIVE {EBADMSG}		CONST EBADMSG		= 74	/* Not a data message */
NATIVE {EOVERFLOW}	CONST EOVERFLOW	= 75	/* Value too large for defined data type */
NATIVE {ENOTUNIQ}	CONST ENOTUNIQ	= 76	/* Name not unique on network */
NATIVE {EBADFD}		CONST EBADFD		= 77	/* File descriptor in bad state */
NATIVE {EREMCHG}		CONST EREMCHG		= 78	/* Remote address changed */
NATIVE {ELIBACC}		CONST ELIBACC		= 79	/* Can not access a needed shared library */
NATIVE {ELIBBAD}		CONST ELIBBAD		= 80	/* Accessing a corrupted shared library */
NATIVE {ELIBSCN}		CONST ELIBSCN		= 81	/* .lib section in a.out corrupted */
NATIVE {ELIBMAX}		CONST ELIBMAX		= 82	/* Attempting to link in too many shared libraries */
NATIVE {ELIBEXEC}	CONST ELIBEXEC	= 83	/* Cannot exec a shared library directly */
NATIVE {EILSEQ}		CONST EILSEQ		= 84	/* Illegal byte sequence */
NATIVE {ERESTART}	CONST ERESTART	= 85	/* Interrupted system call should be restarted */
NATIVE {ESTRPIPE}	CONST ESTRPIPE	= 86	/* Streams pipe error */
NATIVE {EUSERS}		CONST EUSERS		= 87	/* Too many users */
NATIVE {ENOTSOCK}	CONST ENOTSOCK	= 88	/* Socket operation on non-socket */
NATIVE {EDESTADDRREQ}	CONST EDESTADDRREQ	= 89	/* Destination address required */
NATIVE {EMSGSIZE}	CONST EMSGSIZE	= 90	/* Message too long */
NATIVE {EPROTOTYPE}	CONST EPROTOTYPE	= 91	/* Protocol wrong type for socket */
NATIVE {ENOPROTOOPT}	CONST ENOPROTOOPT	= 92	/* Protocol not available */
NATIVE {EPROTONOSUPPORT}	CONST EPROTONOSUPPORT	= 93	/* Protocol not supported */
NATIVE {ESOCKTNOSUPPORT}	CONST ESOCKTNOSUPPORT	= 94	/* Socket type not supported */
NATIVE {EOPNOTSUPP}	CONST EOPNOTSUPP	= 95	/* Operation not supported on transport endpoint */
NATIVE {EPFNOSUPPORT}	CONST EPFNOSUPPORT	= 96	/* Protocol family not supported */
NATIVE {EAFNOSUPPORT}	CONST EAFNOSUPPORT	= 97	/* Address family not supported by protocol */
NATIVE {EADDRINUSE}	CONST EADDRINUSE	= 98	/* Address already in use */
NATIVE {EADDRNOTAVAIL}	CONST EADDRNOTAVAIL	= 99	/* Cannot assign requested address */
NATIVE {ENETDOWN}	CONST ENETDOWN	= 100	/* Network is down */
NATIVE {ENETUNREACH}	CONST ENETUNREACH	= 101	/* Network is unreachable */
NATIVE {ENETRESET}	CONST ENETRESET	= 102	/* Network dropped connection because of reset */
NATIVE {ECONNABORTED}	CONST ECONNABORTED	= 103	/* Software caused connection abort */
NATIVE {ECONNRESET}	CONST ECONNRESET	= 104	/* Connection reset by peer */
NATIVE {ENOBUFS}		CONST ENOBUFS		= 105	/* No buffer space available */
NATIVE {EISCONN}		CONST EISCONN		= 106	/* Transport endpoint is already connected */
NATIVE {ENOTCONN}	CONST ENOTCONN	= 107	/* Transport endpoint is not connected */
NATIVE {ESHUTDOWN}	CONST ESHUTDOWN	= 108	/* Cannot send after transport endpoint shutdown */
NATIVE {ETOOMANYREFS}	CONST ETOOMANYREFS	= 109	/* Too many references: cannot splice */
NATIVE {ETIMEDOUT}	CONST ETIMEDOUT	= 110	/* Connection timed out */
NATIVE {ECONNREFUSED}	CONST ECONNREFUSED	= 111	/* Connection refused */
NATIVE {EHOSTDOWN}	CONST EHOSTDOWN	= 112	/* Host is down */
NATIVE {EHOSTUNREACH}	CONST EHOSTUNREACH	= 113	/* No route to host */
NATIVE {EALREADY}	CONST EALREADY	= 114	/* Operation already in progress */
NATIVE {EINPROGRESS}	CONST EINPROGRESS	= 115	/* Operation now in progress */
NATIVE {ESTALE}		CONST ESTALE		= 116	/* Stale file handle */
NATIVE {EUCLEAN}		CONST EUCLEAN		= 117	/* Structure needs cleaning */
NATIVE {ENOTNAM}		CONST ENOTNAM		= 118	/* Not a XENIX named type file */
NATIVE {ENAVAIL}		CONST ENAVAIL		= 119	/* No XENIX semaphores available */
NATIVE {EISNAM}		CONST EISNAM		= 120	/* Is a named type file */
NATIVE {EREMOTEIO}	CONST EREMOTEIO	= 121	/* Remote I/O error */
NATIVE {EDQUOT}		CONST EDQUOT		= 122	/* Quota exceeded */

NATIVE {ENOMEDIUM}	CONST ENOMEDIUM	= 123	/* No medium found */
NATIVE {EMEDIUMTYPE}	CONST EMEDIUMTYPE	= 124	/* Wrong medium type */
NATIVE {ECANCELED}	CONST ECANCELED	= 125	/* Operation Canceled */
NATIVE {ENOKEY}		CONST ENOKEY		= 126	/* Required key not available */
NATIVE {EKEYEXPIRED}	CONST EKEYEXPIRED	= 127	/* Key has expired */
NATIVE {EKEYREVOKED}	CONST EKEYREVOKED	= 128	/* Key has been revoked */
NATIVE {EKEYREJECTED}	CONST EKEYREJECTED	= 129	/* Key was rejected by service */

/* for robust mutexes */
NATIVE {EOWNERDEAD}	CONST EOWNERDEAD	= 130	/* Owner died */
NATIVE {ENOTRECOVERABLE}	CONST ENOTRECOVERABLE	= 131	/* State not recoverable */

NATIVE {ERFKILL}		CONST ERFKILL		= 132	/* Operation not possible due to RF-kill */

NATIVE {EHWPOISON}	CONST EHWPOISON	= 133	/* Memory page has hardware error */
