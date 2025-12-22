OPT NATIVE
{#include <linux/limits.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
NATIVE {_LINUX_LIMITS_H} DEF

NATIVE {NR_OPEN}	        CONST NR_OPEN	        = 1024

NATIVE {NGROUPS_MAX}    CONST NGROUPS_MAX    = 65536	/* supplemental group IDs are available */
NATIVE {ARG_MAX}       CONST ARG_MAX       = 131072	/* # bytes of args + environ for exec() */
NATIVE {LINK_MAX}         CONST LINK_MAX         = 127	/* # links a file may have */
NATIVE {MAX_CANON}        CONST MAX_CANON        = 255	/* size of the canonical input queue */
NATIVE {MAX_INPUT}        CONST MAX_INPUT        = 255	/* size of the type-ahead buffer */
NATIVE {NAME_MAX}         CONST NAME_MAX         = 255	/* # chars in a file name */
NATIVE {PATH_MAX}        CONST PATH_MAX        = 4096	/* # chars in a path name including nul */
NATIVE {PIPE_BUF}        CONST PIPE_BUF        = 4096	/* # bytes in atomic write to a pipe */
NATIVE {XATTR_NAME_MAX}   CONST XATTR_NAME_MAX   = 255	/* # chars in an extended attribute name */
NATIVE {XATTR_SIZE_MAX} CONST XATTR_SIZE_MAX = 65536	/* size of an extended attribute value (64k) */
NATIVE {XATTR_LIST_MAX} CONST XATTR_LIST_MAX = 65536	/* size of extended attribute namelist (64k) */

NATIVE {RTSIG_MAX}	  CONST RTSIG_MAX	  = 32
