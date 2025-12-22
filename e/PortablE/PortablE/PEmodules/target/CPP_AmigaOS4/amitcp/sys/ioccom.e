OPT NATIVE, PREPROCESS
{#include <sys/ioccom.h>}
/*
 * $Id: ioccom.h,v 1.6 2007-08-26 12:30:26 obarthel Exp $
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
 *	@(#)ioccom.h	8.3 (Berkeley) 1/9/95
 */

NATIVE {_SYS_IOCCOM_H} DEF

/*
 * Ioctl's have the command encoded in the lower word, and the size of
 * any in or out parameters in the upper word.  The high 3 bits of the
 * upper word are used to encode the in/out status of the parameter.
 */
NATIVE {IOCPARM_MASK}	CONST IOCPARM_MASK	= $1fff		/* parameter length, at most 13 bits */
NATIVE {IOCPARM_LEN} CONST
NATIVE {IOCBASECMD} CONST
NATIVE {IOCGROUP} CONST

->#define	IOCPARM_LEN(x)	(((x) SHR 16) AND IOCPARM_MASK)
->#define	IOCBASECMD(x)	((x) AND NOT (IOCPARM_MASK SHL 16))
->#define	IOCGROUP(x)	(((x) SHR 8) AND $ff)
PROC iocparm_len(x) IS NATIVE {IOCPARM_LEN(} x {)} ENDNATIVE !!INT
#define	IOCPARM_LEN(x) iocparm_len(x)
PROC iocbasecmd(x) IS NATIVE {IOCBASECMD(} x {)} ENDNATIVE !!LONG
#define	IOCBASECMD(x) iocbasecmd(x)
PROC iocgroup(x) IS NATIVE {IOCGROUP(} x {)} ENDNATIVE !!BYTE
#define	IOCGROUP(x) iocgroup(x)


NATIVE {IOCPARM_MAX}	CONST ->no idea where NBPG comes from: IOCPARM_MAX	= NBPG	/* max size of ioctl args, mult. of NBPG */
				/* no parameters */
NATIVE {IOC_VOID}	CONST IOC_VOID	= ($20000000)
				/* copy parameters out */
NATIVE {IOC_OUT}	CONST IOC_OUT		= ($40000000)
				/* copy parameters in */
NATIVE {IOC_IN}		CONST IOC_IN		= ($80000000)
				/* copy paramters in and out */
NATIVE {IOC_INOUT}	CONST IOC_INOUT	= (IOC_IN OR IOC_OUT)
				/* mask for IN/OUT/VOID */
NATIVE {IOC_DIRMASK}	CONST IOC_DIRMASK	= ($e0000000)

NATIVE {_IOC} PROC
NATIVE {_IO}  PROC
NATIVE {_IOR} PROC
NATIVE {_IOW} PROC
/* this should be _IORW, but stdio got there first */
NATIVE {_IOWR} PROC

#define	_IOC(inout,group,num,len) (inout OR ((len AND IOCPARM_MASK) SHL 16) OR ((group) SHL 8) OR (num))
#define	_IO(g,n)	_IOC(IOC_VOID,	(g), (n), 0)
#define	_IOR(g,n,t)	_IOC(IOC_OUT,	(g), (n), SIZEOF t)
#define	_IOW(g,n,t)	_IOC(IOC_IN,	(g), (n), SIZEOF t)
/* this should be _IORW, but stdio got there first */
#define	_IOWR(g,n,t)	_IOC(IOC_INOUT,	(g), (n), SIZEOF t)
