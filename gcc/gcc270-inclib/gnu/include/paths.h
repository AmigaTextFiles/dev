/*
 * Copyright (c) 1989 The Regents of the University of California.
 * All rights reserved.
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
 *	@(#)paths.h	5.15 (Berkeley) 5/29/91
 */

#ifndef _PATHS_H_
#define	_PATHS_H_

/* Default search path. */
#define	_PATH_DEFPATH	"/bin:/rcs:/c:."

#define	_PATH_BSHELL	"/bin/sh"
#define	_PATH_CONSOLE	"/console"
#define	_PATH_CSHELL	"/bin/csh"
#define	_PATH_DEVDB	"/nil"
#define	_PATH_DEVNULL	"/nil"
#define	_PATH_DRUM	"/nil"
#define	_PATH_KMEM	"/nil"
#define	_PATH_MAILDIR	"/mail"
#define	_PATH_MAN	"/gnu/man"
#define	_PATH_MEM	"/nil"
#define	_PATH_NOLOGIN	"/etc/nologin"
#define	_PATH_SENDMAIL	"/sbin/sendmail"
#define	_PATH_TTY	"console:"
#define	_PATH_UNIX	"/nil"
#define	_PATH_VI	"/c/vim"

/* Provide trailing slash, since mostly used for building pathnames. */
#define	_PATH_DEV	"/dev"
#define	_PATH_TMP	"/tmp"
#define	_PATH_VARRUN	"/var_run"
#define	_PATH_VARTMP	"/tmp"

#endif /* !_PATHS_H_ */
