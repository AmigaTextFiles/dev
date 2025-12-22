/*
 *  This file is part of ixemul.library for the Amiga.
 *  Copyright (C) 1991, 1992  Markus M. Wild
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */


#include <sys/time.h>
#include <sys/resource.h>
#include <setjmp.h>

/* internal structure used by malloc(), kmalloc() and friends */
#if 0
struct malloc_data {
  struct Remember	*md_key;
  unsigned int		md_malloc_sbrk_used;
  struct mhead		*md_nextf[30];
  char			md_busy[30];
  int			md_gotpool;
};
#else
struct malloc_data {
  struct MinList	md_list;
  unsigned int		md_malloc_sbrk_used;
};
#endif

/*
 * One structure allocated per session.
 */
struct	session {
	int	s_count;		/* ref cnt; pgrps in session */
	struct	proc *s_leader;		/* session leader */
	struct	vnode *s_ttyvp;		/* vnode of controlling terminal */
	struct	tty *s_ttyp;		/* controlling terminal */
	char	s_login[MAXLOGNAME];	/* setlogin() name */
};

/*
 * One structure allocated per process group.
 */
struct	pgrp {
	struct	pgrp *pg_hforw;		/* forward link in hash bucket */
	struct	proc *pg_mem;		/* pointer to pgrp members */
	struct	session *pg_session;	/* pointer to session */
	pid_t	pg_id;			/* pgrp id */
	int	pg_jobc;	/* # procs qualifying pgrp for job control */
};

/*
 * Per process structure
 */
 
struct user {
	/* both a magic cookie and a way to get at the library base thru u */
	struct  ixemul_base *u_ixbase;

/* 1.3 - signal management */
	sig_t	u_signal[NSIG];		/* disposition of signals */
	int	u_sigmask[NSIG];	/* signals to be blocked */
	sigset_t	u_sigonstack;		/* signals to take on sigstack */
	sigset_t	u_sigintr;		/* signals that interrupt syscalls */
	sigset_t	u_oldmask;		/* saved mask from before sigpause */
	struct	sigstack u_sigstack;	/* sp & on stack state variable */
#define	u_onstack	u_sigstack.ss_onstack
#define	u_sigsp		u_sigstack.ss_sp
	int	u_sig;			/* for core dump/debugger XXX */
	int	u_code;			/* for core dump/debugger XXX */
	
	int	p_flag;			/* process flags, as necessary.. */
	char	p_stat;
	char	p_xstat;		/* what does this do... ? */
	char	p_cursig;
	sigset_t	p_sig;			/* signals pending to this process */
	sigset_t	p_sigmask;		/* current signal mask */
	sigset_t	p_sigignore;		/* signals being ignored */
	sigset_t	p_sigcatch;		/* signals being caught by user */

	caddr_t p_wchan;		/* event process is awaiting */


/* 1.4 - descriptor management (for shared library version) */
	struct	file *u_ofile[NOFILE];	/* file structures for open files */
	char	u_pofile[NOFILE];	/* per-process flags of open files */
	int	u_lastfile;		/* high-water mark of u_ofile */
#define	UF_EXCLOSE 	0x1		/* auto-close on exec */
	short	u_cmask;		/* mask for file creation */

/* 1.5 - timing and statistics */
	struct	rusage u_ru;		/* stats for this proc */
	struct	rusage u_cru;		/* sum of stats for reaped children */
	struct	itimerval u_timer[3];
	struct	timeval u_start;
	short	u_acflag;

	struct uprof {			/* profile arguments */
		short	*pr_base;	/* buffer base */
		unsigned pr_size;	/* buffer size */
		unsigned pr_off;	/* pc offset */
		unsigned pr_scale;	/* pc scaling */
	} u_prof;

/* 1.6 - resource controls */
	struct	rlimit u_rlimit[RLIM_NLIMITS];

/* amiga specific stuff */
	struct malloc_data	u_md;
	
	struct MsgPort		*u_sync_mp;	/* PA_SIGNAL message port */
	struct timerequest 	*u_time_req;
	int			*u_errno;
	BPTR			u_startup_cd;
	
	int			u_ringring;	/* used in sleep.c and usleep.c */

	char			***u_environ;

	/* used to handle amigados signals. see SIGMSG  */
        u_int			u_lastrcvsig;
        char			u_sleep_sig;
        
        /* c-startup stuff */
        jmp_buf			u_jmp_buf;
        char 			*u_argline;
        u_int			u_arglinelen;
        int			u_expand_cmd_line;

	struct atexit		*u_atexit;
	
	char			u_getenv_buf[255];
	
	UBYTE			u_otask_flags;
	void			(*u_olaunch)();
	APTR			u_otrap_code;
	APTR			u_otrap_data;
	struct Interrupt	u_itimerint;	/* 1 interrupt / task */

	int			p_pgrp;		/* process group */

	char			*u_strtok_last;	/* moved with 37.8 */
	
	/* vfork() support */
	struct MinList		p_zombies;	/* list of death messages */
	int			p_zombie_sig;	/* signal to set when a child died */
	struct Process		*p_pptr;	/* parent */
	struct Process		*p_cptr;	/* last recently created child */
	struct Process		*p_osptr;	/* older sybling */
	struct Process		*p_ysptr;	/* younger sybling */
	struct vfork_msg	*p_vfork_msg;

#if 0
	/* moved to global space (ix_async_mp) */
	struct MsgPort		*u_async_mp;	/* PA_SOFTINT message port */
#else
	long			u_rese0;
#endif
	void			(*u_oswitch)();
	
	/* stdio support comes here */
	char			u_tmpnam_buf[MAXPATHLEN]; /* quite large.. */
#include <glue.h>
	struct glue		u_sglue;
	/* the 3 `standard' FILE pointers (!) are here */
	void			*u_sF[3];

	/* vfork() support #2 */
	void			*u_save_sp;	/* when vfork'd, this is the `real' sp */
	jmp_buf			u_vfork_frame;	/* for the parent in vfork () */
	u_int			u_mini_stack[1000]; /* 4K stack while in vfork () */

	/* stack watcher. When usp < u_red_zone && ix.ix_watch_stack -> SIGSEGV */
	void			*u_red_zone;

	/* base relative support. This even works for pure programs ! */
	u_int			u_a4;
	
	/* currently there's just 1, meaning don't trace me */
	u_int			u_trace_flags;
	
	/* this is for getmntinfo() */
	struct statfs		*u_mntbuf;
	int			u_mntsize;
	long			u_bufsize;
	
	/* this is for SIGWINCH support. */
	struct IOStdReq		*u_idev_req;
	struct Window		*u_window;	/* the watched window */
	struct Interrupt	u_idev_int;

	/* for `ps' (or dump as it's called for now.. ) */
	char			*p_wmesg;
	
	/* new support for `real' process groups, control ttys etc.. */
	struct user		*p_pgrpnxt;
	struct pgrp		*p_pgrpptr;
	struct Process		*p_exec_proc;	/* to get back to struct Process */
	
	/* to be able to switch memory lists on the fly, as required when vfork'd
	   processes are supposed to allocate memory from their parents pool until
	   they detach. */
	struct malloc_data	*u_mdp;
	
	/* data needed for network support */
	int			u_sigurg;
	int			u_sigio;
	void			*u_InetBase;
	
};

/* flag codes */
#define	SLOAD	0x0000001	/* in core */
#define	SSYS	0x0000002	/* swapper or pager process */
#define	SLOCK	0x0000004	/* process being swapped out */
#define	SSWAP	0x0000008	/* save area flag */
#define	STRC	0x0000010	/* process is being traced */
#define	SWTED	0x0000020	/* parent has been told that this process stopped */
#define	SULOCK	0x0000040	/* user settable lock in core */
#define	SNOCLDSTOP	0x0000080	/* tc_Launch has to take a signal next time */
#define	SFREEA4	0x0000100	/* we allocated memory for a4, free it */
#define	SOMASK	0x0000200	/* restore old mask after taking signal */
#define	SWEXIT	0x0000400	/* working on exiting */
#define	SPHYSIO	0x0000800	/* doing physical i/o (bio.c) */
#define	SVFORK	0x0001000	/* process resulted from vfork() */
#define	SVFDONE	0x0002000	/* another vfork flag */
#define	SNOVM	0x0004000	/* no vm, parent in a vfork() */
#define	SPAGI	0x0008000	/* init data space on demand, from inode */
#define	SSEQL	0x0010000	/* user warned of sequential vm behavior */
#define	SUANOM	0x0020000	/* user warned of random vm behavior */
#define	STIMO	0x0040000	/* timing out during sleep */
#define	SORPHAN	0x0080000	/* process is orphaned (can't be ^Z'ed) */
#define	STRACNG	0x0100000	/* process is tracing another process */
#define	SOWEUPC	0x0200000	/* owe process an addupc() call at next ast */
#define	SSEL	0x0400000	/* selecting; wakeup/waiting danger */
#define	SLOGIN	0x0800000	/* a login process (legit child of init) */

/* stat codes */
#define	SSLEEP	1		/* awaiting an event */
#define	SWAIT	2		/* (abandoned state) */
#define	SRUN	3		/* running */
#define	SIDL	4		/* intermediate state in process creation */
#define	SZOMB	5		/* has exited, waiting for parent to pick up status */
#define	SSTOP	6		/* stopped */
