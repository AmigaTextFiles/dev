/*
 * Copyright (c) 1985, 1989, 1993, 1994
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
 *	@(#)ftp_var.h	8.4 (Berkeley) 10/9/94
 */

/*
 * FTP global variables.
 */

/*#include <sys/param.h>*/
#include <setjmp.h>

#include "extern.h"

#ifndef GLOBAL
#define GLOBAL extern
#endif /* GLOBAL */

/*
 * Options and other state info.
 */
GLOBAL int	trace;			/* trace packets exchanged */
GLOBAL int	hash;			/* print # for each buffer transferred */
GLOBAL int	sendport;		/* use PORT cmd for each data connection */
GLOBAL int	verbose;		/* print messages coming back from server */
GLOBAL int	connected;		/* connected to server */
GLOBAL int	fromatty;		/* input is from a terminal */
GLOBAL int	interactive;		/* interactively prompt on m* cmds */
GLOBAL int	debug;			/* debugging level */
GLOBAL int	bell;			/* ring bell on cmd completion */
GLOBAL int	doglob;			/* glob local file names */
GLOBAL int	autologin;		/* establish user account on connection */
GLOBAL int	proxy;			/* proxy server connection active */
GLOBAL int	proxflag;		/* proxy connection exists */
GLOBAL int	sunique;		/* store files on server with unique name */
GLOBAL int	runique;		/* store local files with unique name */
GLOBAL int	mcase;			/* map upper to lower case for mget names */
GLOBAL int	ntflag;			/* use ntin ntout tables for name translation */
GLOBAL int	mapflag;		/* use mapin mapout templates on file names */
GLOBAL int	code;			/* return/reply code for ftp command */
GLOBAL int	crflag;			/* if 1, strip car. rets. on ascii gets */
GLOBAL char	pasv[64];		/* passive port for proxy data connection */
GLOBAL int	passivemode;		/* passive mode enabled */
GLOBAL char	*altarg;		/* argv[1] with no shell-like preprocessing  */
GLOBAL char	ntin[17];		/* input translation table */
GLOBAL char	ntout[17];		/* output translation table */
GLOBAL char	mapin[MAXPATHLEN];	/* input map template */
GLOBAL char	mapout[MAXPATHLEN];	/* output map template */
GLOBAL char	typename[32];		/* name of file transfer type */
GLOBAL int	type;			/* requested file transfer type */
GLOBAL int	curtype;		/* current file transfer type */
GLOBAL char	structname[32];		/* name of file transfer structure */
GLOBAL int	stru;			/* file transfer structure */
GLOBAL char	formname[32];		/* name of file transfer format */
GLOBAL int	form;			/* file transfer format */
GLOBAL char	modename[32];		/* name of file transfer mode */
GLOBAL int	mode;			/* file transfer mode */
GLOBAL char	bytename[32];		/* local byte size in ascii */
GLOBAL int	bytesize;		/* local byte size in binary */

GLOBAL char	*hostname;		/* name of host connected to */
GLOBAL int	unix_server;		/* server is unix, can use binary for ascii */
GLOBAL int	unix_proxy;		/* proxy is unix, can use binary for ascii */

GLOBAL struct	servent *sp;		/* service spec for tcp/ftp */

GLOBAL jmp_buf	toplevel;		/* non-local goto stuff for cmd scanner */

GLOBAL char	line[200];		/* input line buffer */
GLOBAL char	*stringbase;		/* current scan point in line buffer */
GLOBAL char	argbuf[200];		/* argument storage buffer */
GLOBAL char	*argbase;		/* current storage point in arg buffer */
GLOBAL int	margc;			/* count of arguments on input line */
GLOBAL char	*margv[20];		/* args parsed from input line */
GLOBAL int     cpend;                  /* flag: if != 0, then pending server reply */
GLOBAL int	mflag;			/* flag: if != 0, then active multi command */

GLOBAL int	options;		/* used during socket creation */

/*
 * Format of command table.
 */
struct cmd {
	char	*c_name;	/* name of command */
	char	*c_help;	/* help string */
	char	c_bell;		/* give bell when command completes */
	char	c_conn;		/* must be connected to use command */
	char	c_proxy;	/* proxy server may execute */
	void	(*c_handler) (int, char **); /* function to call */
};

struct macel {
	char mac_name[9];	/* macro name */
	char *mac_start;	/* start of macro in macbuf */
	char *mac_end;		/* end of macro in macbuf */
};

GLOBAL int macnum;			/* number of defined macros */
GLOBAL struct macel macros[16];
GLOBAL char macbuf[4096];
