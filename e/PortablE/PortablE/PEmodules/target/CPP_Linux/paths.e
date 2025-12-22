OPT NATIVE
{#include <paths.h>}
/*
 * Copyright (c) 1989, 1993
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
 *	@(#)paths.h	8.1 (Berkeley) 6/2/93
 */

NATIVE {_PATHS_H_} DEF

/* Default search path. */
NATIVE {_PATH_DEFPATH}	CONST
STATIC _PATH_DEFPATH	= '/usr/bin:/bin'
/* All standard utilities path. */
NATIVE {_PATH_STDPATH} CONST
STATIC _PATH_STDPATH = '/usr/bin:/bin:/usr/sbin:/sbin'

NATIVE {_PATH_BSHELL}	CONST
STATIC _PATH_BSHELL	= '/bin/sh'
NATIVE {_PATH_CONSOLE}	CONST
STATIC _PATH_CONSOLE	= '/dev/console'
NATIVE {_PATH_CSHELL}	CONST
STATIC _PATH_CSHELL	= '/bin/csh'
NATIVE {_PATH_DEVDB}	CONST
STATIC _PATH_DEVDB	= '/var/run/dev.db'
NATIVE {_PATH_DEVNULL}	CONST
STATIC _PATH_DEVNULL	= '/dev/null'
NATIVE {_PATH_DRUM}	CONST
STATIC _PATH_DRUM	= '/dev/drum'
NATIVE {_PATH_GSHADOW}	CONST
STATIC _PATH_GSHADOW	= '/etc/gshadow'
NATIVE {_PATH_KLOG}	CONST
STATIC _PATH_KLOG	= '/proc/kmsg'
NATIVE {_PATH_KMEM}	CONST
STATIC _PATH_KMEM	= '/dev/kmem'
NATIVE {_PATH_LASTLOG}	CONST
STATIC _PATH_LASTLOG	= '/var/log/lastlog'
NATIVE {_PATH_MAILDIR}	CONST
STATIC _PATH_MAILDIR	= '/var/mail'
NATIVE {_PATH_MAN}	CONST
STATIC _PATH_MAN	= '/usr/share/man'
NATIVE {_PATH_MEM}	CONST
STATIC _PATH_MEM	= '/dev/mem'
NATIVE {_PATH_MNTTAB}	CONST
STATIC _PATH_MNTTAB	= '/etc/fstab'
NATIVE {_PATH_MOUNTED}	CONST
STATIC _PATH_MOUNTED	= '/etc/mtab'
NATIVE {_PATH_NOLOGIN}	CONST
STATIC _PATH_NOLOGIN	= '/etc/nologin'
NATIVE {_PATH_PRESERVE}	CONST
STATIC _PATH_PRESERVE	= '/var/lib'
NATIVE {_PATH_RWHODIR}	CONST
STATIC _PATH_RWHODIR	= '/var/spool/rwho'
NATIVE {_PATH_SENDMAIL}	CONST
STATIC _PATH_SENDMAIL	= '/usr/sbin/sendmail'
NATIVE {_PATH_SHADOW}	CONST
STATIC _PATH_SHADOW	= '/etc/shadow'
NATIVE {_PATH_SHELLS}	CONST
STATIC _PATH_SHELLS	= '/etc/shells'
NATIVE {_PATH_TTY}	CONST
STATIC _PATH_TTY	= '/dev/tty'
NATIVE {_PATH_UNIX}	CONST
STATIC _PATH_UNIX	= '/boot/vmlinux'
NATIVE {_PATH_UTMP}	CONST
STATIC _PATH_UTMP	= '/var/run/utmp'
NATIVE {_PATH_VI}	CONST
STATIC _PATH_VI	= '/usr/bin/vi'
NATIVE {_PATH_WTMP}	CONST
STATIC _PATH_WTMP	= '/var/log/wtmp'

/* Provide trailing slash, since mostly used for building pathnames. */
NATIVE {_PATH_DEV}	CONST
STATIC _PATH_DEV	= '/dev/'
NATIVE {_PATH_TMP}	CONST
STATIC _PATH_TMP	= '/tmp/'
NATIVE {_PATH_VARDB}	CONST
STATIC _PATH_VARDB	= '/var/lib/misc/'
NATIVE {_PATH_VARRUN}	CONST
STATIC _PATH_VARRUN	= '/var/run/'
NATIVE {_PATH_VARTMP}	CONST
STATIC _PATH_VARTMP	= '/var/tmp/'
