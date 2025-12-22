OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/sys/ioccom', 'target/amitcp/net/if', 'target/amitcp/net/route'
{#include <sys/sockio.h>}
/*
 * $Id: sockio.h,v 1.6 2007-08-26 12:30:26 obarthel Exp $
 *
 * :ts=8
 *
 * 'Roadshow' -- Amiga TCP/IP stack
 * Copyright © 2001-2007 by Olaf Barthel.
 * All Rights Reserved.
 *
 * Amiga specific TCP/IP 'C' header files;
 * Freely Distributable
 */

/*-
 * Copyright (c) 1982, 1986, 1990, 1993, 1994
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)sockio.h	8.1 (Berkeley) 3/28/94
 */

NATIVE {_SYS_SOCKIO_H} DEF

/* Socket ioctl's. */
NATIVE {SIOCSHIWAT}	 CONST SIOCSHIWAT	 = _IOW("s",  0, __LONG)		/* set high watermark */
NATIVE {SIOCGHIWAT}	 CONST SIOCGHIWAT	 = _IOR("s",  1, __LONG)		/* get high watermark */
NATIVE {SIOCSLOWAT}	 CONST SIOCSLOWAT	 = _IOW("s",  2, __LONG)		/* set low watermark */
NATIVE {SIOCGLOWAT}	 CONST SIOCGLOWAT	 = _IOR("s",  3, __LONG)		/* get low watermark */
NATIVE {SIOCATMARK}	 CONST SIOCATMARK	 = _IOR("s",  7, __LONG)		/* at oob mark? */
NATIVE {SIOCSPGRP}	 CONST SIOCSPGRP	 = _IOW("s",  8, __LONG)		/* set process group */
NATIVE {SIOCGPGRP}	 CONST SIOCGPGRP	 = _IOR("s",  9, __LONG)		/* get process group */

NATIVE {SIOCADDRT}	 CONST ->SIOCADDRT	 = _IOW("r", 10, ortentry)	/* add route */
NATIVE {SIOCDELRT}	 CONST ->SIOCDELRT	 = _IOW("r", 11, ortentry)	/* delete route */

NATIVE {SIOCSIFADDR}	 CONST ->SIOCSIFADDR	 = _IOW("i", 12, ifreq)	/* set ifnet address */
NATIVE {OSIOCGIFADDR}	 CONST ->OSIOCGIFADDR	 = _IOWR("i", 13, ifreq)	/* get ifnet address */
NATIVE {SIOCGIFADDR}	 CONST ->SIOCGIFADDR	 = _IOWR("i", 33, ifreq)	/* get ifnet address */
NATIVE {SIOCSIFDSTADDR}	 CONST ->SIOCSIFDSTADDR	 = _IOW("i", 14, ifreq)	/* set p-p address */
NATIVE {OSIOCGIFDSTADDR}	CONST ->OSIOCGIFDSTADDR	= _IOWR("i", 15, ifreq)	/* get p-p address */
NATIVE {SIOCGIFDSTADDR}	 CONST ->SIOCGIFDSTADDR	 = _IOWR("i", 34, ifreq)	/* get p-p address */
NATIVE {SIOCSIFFLAGS}	 CONST ->SIOCSIFFLAGS	 = _IOW("i", 16, ifreq)	/* set ifnet flags */
NATIVE {SIOCGIFFLAGS}	 CONST ->SIOCGIFFLAGS	 = _IOWR("i", 17, ifreq)	/* get ifnet flags */
NATIVE {OSIOCGIFBRDADDR}	CONST ->OSIOCGIFBRDADDR	= _IOWR("i", 18, ifreq)	/* get broadcast addr */
NATIVE {SIOCGIFBRDADDR}	 CONST ->SIOCGIFBRDADDR	 = _IOWR("i", 35, ifreq)	/* get broadcast addr */
NATIVE {SIOCSIFBRDADDR}	 CONST ->SIOCSIFBRDADDR	 = _IOW("i", 19, ifreq)	/* set broadcast addr */
NATIVE {OSIOCGIFCONF}	 CONST ->OSIOCGIFCONF	 = _IOWR("i", 20, ifconf)	/* get ifnet list */
NATIVE {SIOCGIFCONF}	 CONST ->SIOCGIFCONF	 = _IOWR("i", 36, ifconf)	/* get ifnet list */
NATIVE {OSIOCGIFNETMASK}	CONST ->OSIOCGIFNETMASK	= _IOWR("i", 21, ifreq)	/* get net addr mask */
NATIVE {SIOCGIFNETMASK}	 CONST ->SIOCGIFNETMASK	 = _IOWR("i", 37, ifreq)	/* get net addr mask */
NATIVE {SIOCSIFNETMASK}	 CONST ->SIOCSIFNETMASK	 = _IOW("i", 22, ifreq)	/* set net addr mask */
NATIVE {SIOCGIFMETRIC}	 CONST ->SIOCGIFMETRIC	 = _IOWR("i", 23, ifreq)	/* get IF metric */
NATIVE {SIOCSIFMETRIC}	 CONST ->SIOCSIFMETRIC	 = _IOW("i", 24, ifreq)	/* set IF metric */
NATIVE {SIOCDIFADDR}	 CONST ->SIOCDIFADDR	 = _IOW("i", 25, ifreq)	/* delete IF addr */
NATIVE {SIOCAIFADDR}	 CONST ->SIOCAIFADDR	 = _IOW("i", 26, ifaliasreq)/* add/chg IF alias */

NATIVE {SIOCADDMULTI}	 CONST ->SIOCADDMULTI	 = _IOW("i", 49, ifreq)	/* add m'cast addr */
NATIVE {SIOCDELMULTI}	 CONST ->SIOCDELMULTI	 = _IOW("i", 50, ifreq)	/* del m'cast addr */

->"SIZEOF object" is not a constant in PortablE, so have to fake the constants using macros
#define SIOCADDRT	 _IOW("r", 10, ortentry)
#define SIOCDELRT	 _IOW("r", 11, ortentry)
#define SIOCSIFADDR	 _IOW("i", 12, ifreq)
#define OSIOCGIFADDR	 _IOWR("i", 13, ifreq)
#define SIOCGIFADDR	 _IOWR("i", 33, ifreq)
#define SIOCSIFDSTADDR	 _IOW("i", 14, ifreq)
#define OSIOCGIFDSTADDR	 _IOWR("i", 15, ifreq)
#define SIOCGIFDSTADDR	 _IOWR("i", 34, ifreq)
#define SIOCSIFFLAGS	 _IOW("i", 16, ifreq)
#define SIOCGIFFLAGS	 _IOWR("i", 17, ifreq)
#define OSIOCGIFBRDADDR	 _IOWR("i", 18, ifreq)
#define SIOCGIFBRDADDR	 _IOWR("i", 35, ifreq)
#define SIOCSIFBRDADDR	 _IOW("i", 19, ifreq)
#define OSIOCGIFCONF	 _IOWR("i", 20, ifconf)
#define SIOCGIFCONF	 _IOWR("i", 36, ifconf)
#define OSIOCGIFNETMASK	 _IOWR("i", 21, ifreq)
#define SIOCGIFNETMASK	 _IOWR("i", 37, ifreq)
#define SIOCSIFNETMASK	 _IOW("i", 22, ifreq)
#define SIOCGIFMETRIC	 _IOWR("i", 23, ifreq)
#define SIOCSIFMETRIC	 _IOW("i", 24, ifreq)
#define SIOCDIFADDR	 _IOW("i", 25, ifreq)
#define SIOCAIFADDR	 _IOW("i", 26, ifaliasreq)
#define SIOCADDMULTI	 _IOW("i", 49, ifreq)
#define SIOCDELMULTI	 _IOW("i", 50, ifreq)
