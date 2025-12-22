/*
 * $Id$
 *
 * :ts=4
 *
 * AmigaOS wrapper routines for GNU CVS, using the RoadShow TCP/IP API
 *
 * Written and adapted by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 *                        Jens Langner <Jens.Langner@light-speed.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include "SDI_compiler.h"

#include <exec/memory.h>

#include <pwd.h>
#include <grp.h>

#include <proto/bsdsocket.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/locale.h>
#include <proto/utility.h>

#include <dos/dostags.h>

#include <libraries/locale.h>
#include <workbench/startup.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/ioctl.h>

/* includes only for SASC or which SASC don`t like */
#if defined(__SASC)
  #include <ios1.h>
#else
  #include <sys/fcntl.h>
#endif

#include <utime.h>
#include <stdio.h>
#include <errno.h>
#include <dirent.h>
#include <netdb.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <stdarg.h>

/****************************************************************************/

//#define DEBUG
#include "_assert.h"

/****************************************************************************/

#define const
#define NO_NAME_REPLACEMENT
#include "amiga.h"
#undef const

#include "error.h"

/****************************************************************************/

#include "ssh_protocol.h"

/****************************************************************************/

#define UNIX_TIME_OFFSET 252460800

/****************************************************************************/

#define ZERO	((BPTR)NULL)
#define SAME	(0)
#define OK		(0)
#define CANNOT	!
#define NOT		!

/****************************************************************************/

/* This macro lets us long-align structures on the stack */
#define D_S(type,name) \
	char a_##name[sizeof(type)+3]; \
	type *name = (type *)((LONG)(a_##name+3) & ~3)

/****************************************************************************/

#define NUM_ENTRIES(t)		(sizeof(t) / sizeof(t[0]))

/****************************************************************************/

#define FIB_IS_FILE(fib)	((fib)->fib_DirEntryType < 0)
#define FIB_IS_DRAWER(fib)	((fib)->fib_DirEntryType >= 0 && \
							 (fib)->fib_DirEntryType != ST_SOFTLINK && \
							 (fib)->fib_DirEntryType != ST_LINKDIR)

/****************************************************************************/

#define FLAG_IS_SET(v,f)	  (((v) & (f)) == (f))
#define FLAG_IS_CLEAR(v,f)	(((v) & (f)) == 0)
#define SET_FLAG(v,f)		    ((v) |= (f))

/****************************************************************************/

extern void		error(int,int,const char *,...);
extern void *	xmalloc(size_t size);
extern char *	xstrdup(const char * const str);
extern char *	scramble(char *str);
extern char *	descramble(char *str);
extern char *	get_homedir(void);
extern int		getline(char **lineptr,size_t *n,FILE *stream);

/****************************************************************************/

struct Library * SocketBase;

/****************************************************************************/

#if defined(__SASC) || defined(__GNUC__)
  /* GCC (libnix) supports the same as SAS/C! */
  long __stack = 8192;
  long __buffsize = 8192;
  unsigned long _MSTEP = 16384;
#endif

/****************************************************************************/

/* add some features GNUC doesn`t provide by default
   and take care that the libnix of morphOS supports some of those per default
*/
#if defined(__GNUC__)
  #if !defined(__MORPHOS__)
    STRPTR _ProgramName;
  #endif

  /* libnix catches the WB startup code for us, so we don`t need to worry */
  extern struct WBStartup *_WBenchMsg;
  #define WBenchMsg _WBenchMsg

  /* prototype for the chkabort() function (libnix supports it) */
  #define chkabort() __chkabort()
  extern void chkabort();
#endif

/****************************************************************************/

#if defined(__PPC__)
  #if defined(__MORPHOS__)
    #define CPU " [MOS/PPC]"
  #else
    #define CPU " [OS4/PPC]"
  #endif
#elif defined(_M68060) || defined(__M68060) || defined(__mc68060)
	#define CPU " [060]"
#elif defined(_M68040) || defined(__M68040) || defined(__mc68040)
	#define CPU " [040]"
#elif defined(_M68030) || defined(__M68030) || defined(__mc68030)
	#define CPU " [030]"
#elif defined(_M68020) || defined(__M68020) || defined(__mc68020)
	#define CPU " [020]"
#else
	#define CPU ""
#endif

/****************************************************************************/

const char VersTag[] = "$VER: cvs 1.11.4" CPU " (19.11.2004) ported by Olaf Barthel and Jens Langner";

/****************************************************************************/

static void map_ioerr_to_errno(void);
static void get_next_buffer(char **buffer_ptr);
static void correct_name(char **name_ptr);
static void close_libs(void);
static void initialize_libraries(void);
static int recursive_unlink_file_dir(char *f, BOOL remove_this_entry);
static int compare(char **a,char **b);
static void convert_fileinfo_to_stat(struct FileInfoBlock *fib,struct stat *st);
static int amiga_rcmd(char **remote_hostname,int remote_port,char *local_user,char *remote_user,char *command);

/****************************************************************************/

static void map_ioerr_to_errno(void)
{
	/* This routine maps AmigaDOS error codes to
	 * Unix error codes, as far as this is possible.
	 * This table contains AmigaDOS error codes
	 * the emulated routines won't generate. I have
	 * included them for the sake of completeness.
	 */
	struct { LONG IoErr; int errno; } map_table[] =
	{
		{ ERROR_NO_FREE_STORE,				ENOMEM },
		{ ERROR_TASK_TABLE_FULL,			ENOMEM },
		{ ERROR_BAD_TEMPLATE,				EINVAL },
		{ ERROR_BAD_NUMBER,					EINVAL },
		{ ERROR_REQUIRED_ARG_MISSING,		EINVAL },
		{ ERROR_KEY_NEEDS_ARG,				EINVAL },
		{ ERROR_TOO_MANY_ARGS,				EINVAL },
		{ ERROR_UNMATCHED_QUOTES,			EINVAL },
		{ ERROR_LINE_TOO_LONG,				ENAMETOOLONG },
		{ ERROR_FILE_NOT_OBJECT,			ENOEXEC },
		{ ERROR_INVALID_RESIDENT_LIBRARY,	EIO },
		{ ERROR_NO_DEFAULT_DIR,				EIO },
		{ ERROR_OBJECT_IN_USE,				EBUSY },
		{ ERROR_OBJECT_EXISTS,				EEXIST },
		{ ERROR_DIR_NOT_FOUND,				ENOENT },
		{ ERROR_OBJECT_NOT_FOUND,			ENOENT },
		{ ERROR_BAD_STREAM_NAME,			EINVAL },
		{ ERROR_OBJECT_TOO_LARGE,			EFBIG },
		{ ERROR_ACTION_NOT_KNOWN,			ENOSYS },
		{ ERROR_INVALID_COMPONENT_NAME,		EINVAL },
		{ ERROR_INVALID_LOCK,				EBADF },
		{ ERROR_OBJECT_WRONG_TYPE,			EFTYPE },
		{ ERROR_DISK_NOT_VALIDATED,			EROFS },
		{ ERROR_DISK_WRITE_PROTECTED,		EROFS },
		{ ERROR_RENAME_ACROSS_DEVICES,		EXDEV },
		{ ERROR_DIRECTORY_NOT_EMPTY,		ENOTEMPTY },
		{ ERROR_TOO_MANY_LEVELS,			ENAMETOOLONG },
		{ ERROR_DEVICE_NOT_MOUNTED,			ENXIO },
		{ ERROR_SEEK_ERROR,					EIO },
		{ ERROR_COMMENT_TOO_BIG,			ENAMETOOLONG },
		{ ERROR_DISK_FULL,					ENOSPC },
		{ ERROR_DELETE_PROTECTED,			EACCES },
		{ ERROR_WRITE_PROTECTED,			EACCES },
		{ ERROR_READ_PROTECTED,				EACCES },
		{ ERROR_NOT_A_DOS_DISK,				EFTYPE },
		{ ERROR_NO_DISK,					EACCES },
		{ ERROR_NO_MORE_ENTRIES,			EIO },
		{ ERROR_IS_SOFT_LINK,				EFTYPE },
		{ ERROR_OBJECT_LINKED,				EIO },
		{ ERROR_BAD_HUNK,					ENOEXEC },
		{ ERROR_NOT_IMPLEMENTED,			ENOSYS },
		{ ERROR_RECORD_NOT_LOCKED,			EIO },
		{ ERROR_LOCK_COLLISION,				EACCES },
		{ ERROR_LOCK_TIMEOUT,				EIO },
		{ ERROR_UNLOCK_ERROR,				EIO },
		{ ERROR_BUFFER_OVERFLOW,			EIO },
		{ ERROR_BREAK,						EINTR },
		{ ERROR_NOT_EXECUTABLE,				ENOEXEC }
	};

	LONG Error = IoErr();

	if(Error != OK)
	{
		int i;

		/* If nothing else matches, we can always
		 * flag it as an I/O error.
		 */
		errno = EIO;

		for(i = 0 ; i < NUM_ENTRIES(map_table) ; i++)
		{
			if(map_table[i].IoErr == Error)
			{
				errno = map_table[i].errno;
				break;
			}
		}
	}
}

/****************************************************************************/

int REGARGS amiga_get_minutes_west(void)
{
	int minutes_west;

	if(LocaleBase == NULL)
	{
	#if defined(__MORPHOS__)
		LocaleBase = OpenLibrary("locale.library", 38);
	#else
		LocaleBase = (struct LocaleBase *)OpenLibrary("locale.library", 38);
	#endif

		if(LocaleBase != NULL)
			atexit(close_libs);
	}

	if(LocaleBase != NULL)
	{
		struct Locale * loc;

		loc = OpenLocale(NULL);

		minutes_west = loc->loc_GMTOffset;

		CloseLocale(loc);
	}
	else
	{
		minutes_west = 0;
	}

	return(minutes_west);
}

/****************************************************************************/

#define MAX_FILENAME_LEN 1024

/****************************************************************************/

static void get_next_buffer(char ** buffer_ptr)
{
	static char buffer_slots[8][MAX_FILENAME_LEN];
	static int buffer_index;

	(*buffer_ptr)	= buffer_slots[buffer_index];
	buffer_index	= (buffer_index + 1) % 8;
}

/****************************************************************************/

static void correct_name(char ** name_ptr)
{
	char * buffer;
	int len,i;
	char * name;

	ENTER();

	name = (*name_ptr);

	if(name[0] == '/')
	{
		BOOL done;

		SHOWSTRING(name);

		get_next_buffer(&buffer);

		done = FALSE;

		len = strlen(name);
		for(i = 1 ; i <= len ; i++)
		{
			if(name[i] == '/' || name[i] == '\0')
			{
				memcpy(buffer, name+1, i);
				buffer[i-1] = ':';

				if(name[i] != '\0')
					strcpy(&buffer[i],&name[i+1]);
				else
					buffer[i] = '\0';

				done = TRUE;
				break;
			}
		}

		if(NOT done)
			strcpy(buffer,name);

		SHOWSTRING(buffer);

		name = buffer;
	}
	else
	{
		len = strlen(name);

		SHOWSTRING(name);

		for(i = 0 ; i < len-1 ; i++)
		{
			if(name[i] == ':' && name[i+1] == '/')
			{
				get_next_buffer(&buffer);

				memcpy(buffer,name,i+1);
				strcpy(&buffer[i+1],&name[i+2]);

				SHOWSTRING(buffer);

				name = buffer;
				break;
			}
		}
	}

	if(strncmp(name,"./",2) == SAME)
	{
		get_next_buffer(&buffer);

		strcpy(buffer,name+2);
		name = buffer;
	}
	else if (strncmp(name,"../",3) == SAME)
	{
		get_next_buffer(&buffer);

		strcpy(buffer,name+3);
		name = buffer;
	}
	else if (strcmp(name,".") == SAME)
	{
		get_next_buffer(&buffer);

		strcpy(buffer,"");
		name = buffer;
	}
	else if (strcmp(name,"..") == SAME)
	{
		get_next_buffer(&buffer);

		strcpy(buffer,"/");
		name = buffer;
	}

	len = strlen(name);
	if(len > 1)
	{
		if(name[len-1] == '/')
			name[--len] = '\0';

		if(name[len-1] == '.' && name[len-2] == '/')
			name[--len] = '\0';
	}

	/* The following has been commented out since it is not for
	 * everyday use. Some CVS servers hosted on systems that default
	 * to the PC850 code page for international characters will return
	 * file and directory names which the Amiga file system will reject.
	 * This is because the Amiga default file system enforces the use
	 * of the ISO8559-1 character set. To make a checkout work even with
	 * the server supplying PC850 style file names, the following
	 * translation may be helpful. Note that there is no counterpart to
	 * this in the code that mangles names for transmission to the
	 * server. This here is purely for checking out projects which
	 * would otherwise be unusable for the Amiga CVS port.
	 */
	#ifdef undefined
	{
		static const UBYTE pc850_to_iso8859_1_tab[256] =
		{
			0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,
			0x10,0x11,0x12,0x13,0xB6,0xA7,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F,
			0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,
			0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,
			0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,
			0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x5B,0x5C,0x5D,0x5E,0x5F,
			0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,
			0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D,0x7E,0x7F,
			0xC7,0xFC,0xE9,0xE2,0xE4,0xE0,0xE5,0xE7,0xEA,0xEB,0xE8,0xEF,0xEE,0xEC,0xC4,0xC5,
			0xC9,0xE6,0xC6,0xF4,0xF6,0xF2,0xFB,0xF9,0xFF,0xD6,0xDC,0xA2,0xA3,0xA5,0x5F,0x66,
			0xE1,0xED,0xF3,0xFA,0xF1,0xD1,0xAA,0xBA,0xBF,0x5F,0xAC,0xBD,0xBC,0xA1,0xAB,0xBB,
			0x5F,0x7F,0x5F,0x7C,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,
			0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,
			0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,
			0x61,0xDF,0x67,0x50,0x53,0x73,0xB5,0x74,0x70,0x54,0x4F,0x64,0x5F,0x66,0x65,0x5F,
			0x5F,0xB1,0x5F,0x5F,0x5F,0x5F,0xF7,0x5F,0xB0,0xB7,0xB7,0x5F,0x6E,0xB2,0x5F,0x20
		};

		int c;

		get_next_buffer(&buffer);

		for(i = 0 ; i < len ; i++)
		{
			c = ((unsigned char *)name)[i];

			buffer[i] = (char)pc850_to_iso8859_1_tab[c];
		}

		buffer[i] = '\0';

		name = buffer;
	}
	#endif

	(*name_ptr) = name;

	LEAVE();
}

/****************************************************************************/

void * amiga_valloc(size_t bytes)
{
	void * result;

	ENTER();
	SHOWVALUE(bytes);

	result = malloc(bytes);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_symlink(char *to, char *from)
{
	int result;

	ENTER();

	SHOWSTRING(to);
	SHOWSTRING(from);

	result = -1;
	errno = EINVAL;

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_readlink(char *path, char *buf, int buf_size)
{
	int result;

	ENTER();

	SHOWSTRING(path);

	result = -1;
	errno = EINVAL;

	RETURN(result);
	return(result);
}

/****************************************************************************/

unsigned amiga_sleep(unsigned seconds)
{
	Delay(TICKS_PER_SECOND * seconds);

	return(0);
}

/****************************************************************************/

unsigned long amiga_umask(unsigned long mask)
{
	return(0);
}

/****************************************************************************/

unsigned long amiga_waitpid(unsigned long pid,int *stat_loc,int options)
{
	return(0);
}

/****************************************************************************/

int amiga_utime(char *name,struct utimbuf *time)
{
	struct DateStamp ds;
	int result = -1;

	ENTER();

	correct_name(&name);

	SHOWSTRING(name);

	/* Use the current time? */
	if(time == NULL)
	{
		DateStamp(&ds);
	}
	else
	{
		int minutes_west = amiga_get_minutes_west();
		ULONG seconds;

		/* Convert the time given. */
		if(time->modtime < (UNIX_TIME_OFFSET + 60 * minutes_west))
			seconds = 0;
		else
			seconds = time->modtime - (UNIX_TIME_OFFSET + 60 * minutes_west); /* translate from UTC to local time */

		ds.ds_Days		= (seconds / (24*60*60));
		ds.ds_Minute	= (seconds % (24*60*60)) / 60;
		ds.ds_Tick		= (seconds % 60) * TICKS_PER_SECOND;
	}

	if(SetFileDate((STRPTR)name,&ds))
		result = 0;

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_geteuid(void)
{
	return(0);
}

/****************************************************************************/

int amiga_getuid(void)
{
	return(0);
}

/****************************************************************************/

int amiga_getgid(void)
{
	return(0);
}

/****************************************************************************/

long amiga_getpid(void)
{
	static long old_pid = -1;
	long result;

	ENTER();

	if(old_pid == -1)
	{
		struct Process * this_process;
		LONG max_cli;
		LONG which;
		LONG i;

		this_process = (struct Process *)FindTask(NULL);

		Forbid();

		which = max_cli = MaxCli();

		for(i = 1 ; i <= max_cli ; i++)
		{
			if(FindCliProc(i) == this_process)
			{
				which = i;
				break;
			}
		}

		Permit();

		old_pid = which;
	}

	result = old_pid;

	RETURN(result);
	return(result);
}

/****************************************************************************/

char *amiga_getlogin(void)
{
	static char name[256];
	int i;

	ENTER();

	if(GetVar("USER",name,sizeof(name),0) <= 0)
	{
		if(GetVar("LOGUSER",name,sizeof(name),0) <= 0)
		{
			if(GetVar("USERNAME",name,sizeof(name),0) <= 0)
				strcpy(name,"anonymous");
		}
	}

	for(i = strlen(name)-1 ; i >= 0 ; i--)
	{
		if(name[i] == ' ' || name[i] == '\t' || name[i] == '\r' || name[i] == '\n')
			name[i] = '\0';
		else
			break;
	}

	SHOWSTRING(name);

	RETURN(name);
	return(name);
}

/****************************************************************************/

struct passwd *amiga_getpwuid(int uid)
{
	static struct passwd pw;

	ENTER();

	SHOWVALUE(uid);

	memset(&pw,0,sizeof(pw));

	pw.pw_dir	= "CVSHOME:";		/* pseudo-home directory */
	pw.pw_gid	= 1;				/* ZZZ wrong */
	pw.pw_name	= amiga_getlogin();
	pw.pw_uid	= uid;				/* ZZZ wrong */

	RETURN(&pw);
	return(&pw);
}

/****************************************************************************/

struct passwd *amiga_getpwnam(char *name)
{
	struct passwd * result;

	ENTER();

	SHOWSTRING(name);

	result = amiga_getpwuid(1);

	RETURN(result);
	return(result);
}

/****************************************************************************/

struct group *amiga_getgrnam(char *name)
{
	struct group * result;

	ENTER();

	result = NULL;

	RETURN(result);
	return(result);
}

/****************************************************************************/

char *amiga_getpass(char *prompt)
{
	void (*old_sig_handler)(int);
	char * result = NULL;
	BPTR input_stream;

	ENTER();

	SHOWSTRING(prompt);

	/* Let's hope that this really refers to the current input
	 * stream...
	 */
	input_stream = Input();

	old_sig_handler = signal(SIGINT,SIG_IGN);

	if(SetMode(input_stream,DOSTRUE))
	{
		static char pwd_buf[128];
		int len,c;

		fputs(prompt,stderr);
		fflush(stderr);

		len = 0;
		while(TRUE)
		{
			c = -1;

			while(TRUE)
			{
				if(CheckSignal(SIGBREAKF_CTRL_C))
				{
					SetMode(input_stream,DOSFALSE);
					signal(SIGINT,old_sig_handler);

					raise(SIGINT);

					signal(SIGINT,SIG_IGN);
					SetMode(input_stream,DOSTRUE);
				}

				if(WaitForChar(input_stream,TICKS_PER_SECOND / 2))
				{
					c = fgetc(stdin);
					if(c == '\003')
					{
						SetMode(input_stream,DOSFALSE);
						signal(SIGINT,old_sig_handler);

						raise(SIGINT);

						signal(SIGINT,SIG_IGN);
						SetMode(input_stream,DOSTRUE);
					}
					else
					{
						break;
					}
				}
			}

			if(c == '\r' || c == '\n')
				break;

			if(((c >= ' ' && c < 127) || (c >= 160)) && len < sizeof(pwd_buf)-1)
			{
				pwd_buf[len++] = c;
				pwd_buf[len] = '\0';
			}
		}

		SetMode(input_stream,DOSFALSE);

		fputs("\n",stderr);

		SHOWSTRING(pwd_buf);

		result = pwd_buf;
	}

	signal(SIGINT,old_sig_handler);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_gethostname(char * name,int namelen)
{
	static char hostname[256];
	int i,len;

	ENTER();

	if(GetVar("HOST",hostname,sizeof(hostname),0) <= 0)
	{
		if(GetVar("HOSTNAME",hostname,sizeof(hostname),0) <= 0)
			strcpy(hostname,"anonymous");
	}

	for(i = strlen(hostname)-1 ; i >= 0 ; i--)
	{
		if(hostname[i] == ' ' || hostname[i] == '\t' || hostname[i] == '\r' || hostname[i] == '\n')
			hostname[i] = '\0';
		else
			break;
	}

	len = strlen(hostname);
	if(len > namelen)
		len = namelen;

	memcpy(name,hostname,len);
	name[len] = '\0';

	SHOWSTRING(name);

	RETURN(0);
	return(0);
}

/****************************************************************************/

int amiga_pclose(FILE * pipe)
{
	ENTER();

	fclose(pipe);

	RETURN(0);
	return(0);
}

/****************************************************************************/

FILE *amiga_popen(char *command, char *mode)
{
	FILE * result = NULL;
	char temp_name[40];
	BPTR output;

	ENTER();

	correct_name(&command);

	SHOWSTRING(command);
	SHOWSTRING(mode);

	sprintf(temp_name, "PIPE:%08x.%08lx", (int)FindTask(NULL), time(NULL));

	output = Open(temp_name,MODE_NEWFILE);
	if(output != ZERO)
	{
		LONG res;

		res = SystemTags(command,
			SYS_Input,		Input(),
			SYS_Output,		output,
			SYS_Asynch,		TRUE,
			SYS_UserShell,	TRUE,
			NP_CloseInput,	FALSE,
		TAG_END);

		switch(res)
		{
			case 0:
				result = fopen(temp_name,mode);
				break;

			case -1:
				errno = ENOMEM;
				Close(output);
				break;

			default:
				errno = EIO;
				break;
		}
	}
	else
	{
		errno = EIO;
	}

	RETURN(result);
	return(result);
}

/****************************************************************************/

struct socket_context
{
	int								sc_Socket;	/* The socket involved, or -1 if not used. */
	struct ssh_protocol_context *	sc_SSH;		/* The secure shell data structures involved, * or NULL if not used. */
};

/****************************************************************************/

static struct socket_context **	socket_table;
static int						socket_table_size;

/****************************************************************************/

static struct socket_context *get_registered_socket(int fd)
{
	struct socket_context * result;

	if(socket_table != NULL && 0 <= fd && fd < socket_table_size && socket_table[fd] != NULL)
		result = socket_table[fd];
	else
		result = NULL;

	return(result);
}

static void unregister_socket(int fd)
{
	if(socket_table != NULL && 0 <= fd && fd < socket_table_size && socket_table[fd] != NULL)
	{
		free(socket_table[fd]);
		socket_table[fd] = NULL;
	}
}

static struct socket_context *register_socket(int fd)
{
	struct socket_context * result = NULL;

	if(socket_table_size <= fd)
	{
		struct socket_context ** new_table;
		int new_table_size;

		new_table_size = (fd + 10);

		new_table = malloc(sizeof(*new_table) * new_table_size);
		if(new_table == NULL)
			goto out;

		if(socket_table != NULL)
			memcpy(new_table,socket_table,sizeof(*socket_table) * socket_table_size);

		memset(&new_table[socket_table_size],0,sizeof(*socket_table) * (new_table_size - socket_table_size));

		free(socket_table);

		socket_table = new_table;
		socket_table_size = new_table_size;
	}

	socket_table[fd] = malloc(sizeof(*socket_table[fd]));
	if(socket_table[fd] == NULL)
		goto out;

	memset(socket_table[fd],0,sizeof(*socket_table[fd]));

	result = socket_table[fd];

 out:

	return(result);
}

/****************************************************************************/

static void close_libs(void)
{
	ENTER();

	if(LocaleBase != NULL)
	{
	#if defined(__MORPHOS__)
		CloseLibrary(LocaleBase);
	#else
		CloseLibrary((struct Library *)LocaleBase);
	#endif

		LocaleBase = NULL;
	}

	if(SocketBase != NULL)
	{
		CloseLibrary(SocketBase);
		SocketBase = NULL;
	}

	LEAVE();
}

/****************************************************************************/

static void initialize_libraries(void)
{
	ENTER();

	if(SocketBase == NULL)
	{
		SHOWMSG("opening bsdsocket.library V3");

		SocketBase = OpenLibrary("bsdsocket.library",3);
		if(SocketBase != NULL)
		{
			extern STRPTR _ProgramName;

			if(SocketBaseTags(
				SBTM_SETVAL(SBTC_ERRNOPTR(sizeof(errno))),	&errno,
				SBTM_SETVAL(SBTC_LOGTAGPTR),				_ProgramName,
			TAG_END) != 0)
			{
				CloseLibrary(SocketBase);
				SocketBase = NULL;
			}
		}

		if(SocketBase == NULL)
		{
			fprintf(stderr,"Could not open 'bsdsocket.library' V3; TCP/IP stack not running?\n");
			exit(RETURN_FAIL);
		}

		/* Make sure that the library will eventually be closed. */
		atexit(close_libs);
	}
	else
	{
		SHOWMSG("bsdsocket.library already open");
	}

	LEAVE();
}

/****************************************************************************/

/* This routine is required because the original abort() may not invoke
 * the cleanup routines installed by atexit(). Down below we also 'overload'
 * the runtime library abort() routine to call the following code.
 */
void amiga_abort(void)
{
	extern STRPTR _ProgramName;

	ENTER();

	/* Flush the standard output streams so that
	 * any following output will be printed after
	 * any buffered stdio output.
	 */
	if(WBenchMsg == NULL)
	{
		/* Don't let anybody stop us. */
		signal(SIGINT,SIG_IGN);
		signal(SIGTERM,SIG_IGN);

		fflush(stdout);
		fflush(stderr);
	}

	/* This routine is called when the program is interrupted. */
	if(((struct Library *)DOSBase)->lib_Version >= 37)
	{
		PrintFault(ERROR_BREAK,_ProgramName);
	}
	else
	{
		const char *famousLastWords = ": *** Break";
		BPTR output = Output();

		Write(output,(APTR)famousLastWords,strlen(famousLastWords));
		Write(output,_ProgramName,strlen(_ProgramName));
		Write(output,"\n",1);
	}

	exit(RETURN_WARN);
}

/****************************************************************************/

void abort(void)
{
	amiga_abort();
}

/****************************************************************************/

/* The following routines are really SAS/C specific. */

#if defined(__SASC)

void REGARGS __chkabort(void)
{
	if(SetSignal(0,0) & SIGBREAKF_CTRL_C)
		raise(SIGINT);
}

void REGARGS _CXBRK(void)
{
	abort();
}

#endif

/****************************************************************************/

char *amiga_strerror(int code)
{
	char *result = NULL;

	ENTER();

	if(SocketBase != NULL)
	{
		struct TagItem tags[2];

		tags[0].ti_Tag	= SBTM_GETVAL(SBTC_ERRNOSTRPTR);
		tags[0].ti_Data	= code;
		tags[1].ti_Tag	= TAG_DONE;

		if(SocketBaseTagList(tags) == 0)
			result = (char *)tags[0].ti_Data;
	}

	if(result == NULL)
		result = strerror(code);

	SHOWSTRING(result);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_mkdir(char *name,int mode)
{
	int result = OK;
	BPTR lock;

	ENTER();

	correct_name(&name);

	SHOWSTRING(name);

	lock = CreateDir(name);
	if(lock != ZERO)
	{
		UnLock(lock);

		amiga_chmod(name,mode);
	}
	else
	{
		LONG error = IoErr();

		if(error != ERROR_OBJECT_IN_USE)
		{
			SetIoErr(error);

			map_ioerr_to_errno();

			result = -1;
		}
	}

	RETURN(result);
	return(result);
}

/****************************************************************************/

struct hostent *amiga_gethostbyname(char *name)
{
	struct hostent *result;

	ENTER();
	SHOWSTRING(name);

	initialize_libraries();

	result = gethostbyname(name);

	RETURN(result);
	return(result);
}

struct servent *amiga_getservbyname(char *name,char *proto)
{
	struct servent *result;

	ENTER();

	SHOWSTRING(name);
	SHOWSTRING(proto);

	initialize_libraries();

	result = getservbyname(name,proto);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_bind(int fd,struct sockaddr *name,int namelen)
{
	struct socket_context * sc;
	int result = -1;

	ENTER();

	initialize_libraries();

	sc = get_registered_socket(fd);
	if(sc == NULL)
	{
		errno = EIO;
		goto out;
	}

	if(sc->sc_Socket == -1)
	{
		SHOWMSG("not a socket");
		errno = EBADF;
		goto out;
	}

	result = bind(sc->sc_Socket,name,namelen);

 out:

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_close(int fd)
{
	struct socket_context * sc;
	int result = -1;

	ENTER();

	sc = get_registered_socket(fd);
	if(sc != NULL)
	{
		if(sc->sc_Socket != -1)
			CloseSocket(sc->sc_Socket);
		else
			ssh_disconnect(sc->sc_SSH);

		unregister_socket(fd);
	}

	result = close(fd);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_connect(int fd,struct sockaddr *name,int namelen)
{
	struct socket_context * sc;
	int result = -1;

	ENTER();

	initialize_libraries();

	sc = get_registered_socket(fd);
	if(sc == NULL)
	{
		errno = EIO;
		goto out;
	}

	if(sc->sc_Socket == -1)
	{
		SHOWMSG("not a socket");
		errno = EBADF;
		goto out;
	}

	result = connect(sc->sc_Socket,name,namelen);

 out:

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_recv(int fd,void *buff,int nbytes,int flags)
{
	struct socket_context * sc;
	int result = -1;

	ENTER();

	initialize_libraries();

	sc = get_registered_socket(fd);
	if(sc == NULL)
	{
		errno = EIO;
		goto out;
	}

	if(sc->sc_Socket != -1)
		result = recv(sc->sc_Socket,buff,nbytes,flags);
	else if (sc->sc_SSH != NULL)
		result = ssh_read(sc->sc_SSH,buff,nbytes);
	else
		errno = EIO;

 out:

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_send(int fd,void *buff,int nbytes,int flags)
{
	struct socket_context * sc;
	int result = -1;

	ENTER();

	initialize_libraries();

	sc = get_registered_socket(fd);
	if(sc == NULL)
	{
		errno = EIO;
		goto out;
	}

	if(sc->sc_Socket != -1)
		result = send(sc->sc_Socket,buff,nbytes,flags);
	else if (sc->sc_SSH != NULL)
		result = ssh_write(sc->sc_SSH,buff,nbytes);
	else
		errno = EIO;

 out:

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_shutdown(int fd,int how)
{
	struct socket_context * sc;
	int result = -1;

	ENTER();

	initialize_libraries();

	sc = get_registered_socket(fd);
	if(sc == NULL)
	{
		errno = EIO;
		goto out;
	}

	if(sc->sc_Socket != -1)
	{
		result = shutdown(sc->sc_Socket,how);
	}
	else if (sc->sc_SSH != NULL && sc->sc_SSH->spc_Socket != -1)
	{
		result = shutdown(sc->sc_SSH->spc_Socket, how);
	}
	else
	{
		SHOWMSG("not a socket");
		errno = EBADF;
	}

 out:

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_socket(int domain,int type,int protocol)
{
	struct socket_context * sc;
	int fd;

	ENTER();

	initialize_libraries();

	fd = open("NIL:",O_RDWR,0777);
	if(fd < 0)
		goto out;

	sc = register_socket(fd);
	if(sc == NULL)
	{
		close(fd);
		fd = -1;

		errno = ENOMEM;
		goto out;
	}

	sc->sc_Socket = socket(domain,type,protocol);
	if(sc->sc_Socket < 0)
	{
		int error;

		error = errno;

		unregister_socket(fd);

		close(fd);
		fd = -1;

		errno = error;

		goto out;
	}

 out:

	RETURN(fd);
	return(fd);
}

/****************************************************************************/

int amiga_connect_ssh(char *host_name,char *user_name,char *password,int cipher,int port)
{
	struct socket_context * sc;
	int fd;

	ENTER();

	initialize_libraries();

	fd = open("NIL:",O_RDWR,0777);
	if(fd < 0)
		goto out;

	sc = register_socket(fd);
	if(sc == NULL)
	{
		close(fd);
		fd = -1;

		errno = ENOMEM;
		goto out;
	}

	sc->sc_SSH = ssh_connect(host_name,port,user_name,password,cipher);
	if(sc->sc_SSH == NULL)
	{
		unregister_socket(fd);

		close(fd);
		fd = -1;

		errno = EACCES;
		goto out;
	}

	sc->sc_Socket = -1;

 out:

	RETURN(fd);
	return(fd);
}

/****************************************************************************/

int amiga_piped_child(char ** argv,int * to_fd_ptr,int * from_fd_ptr)
{
	int len,total_len,quotes,escape,argc,i,j;
	char * s;
	char * arg;
	char * command;

	BPTR input = ZERO;
	BPTR output = ZERO;
	char in_name[40];
	char out_name[40];
	int result = -1;

	ENTER();

	argc = 0;
	total_len = 0;
	for(i = 0 ; argv[i] != NULL ; i++)
	{
		argc++;
		arg = argv[i];
		len = strlen(arg);
		quotes = 0;

		for(j = 0 ; j < len ; j++)
		{
			if(arg[j] == ' ' && quotes == 0)
				quotes = 2;
			else if (arg[j] == '\"')
				total_len++;
		}

		total_len += len + quotes + 1;
	}

	command = malloc(total_len+1);
	if(command == NULL)
	{
		errno = ENOMEM;
		return(-1);
	}

	s = command;

	for(i = 0 ; i < argc ; i++)
	{
		arg = argv[i];
		len = strlen(arg);
		quotes = escape = 0;

		for(j = 0 ; j < len ; j++)
		{
			if(arg[j] == ' ')
				quotes = 1;
			else if (arg[j] == '\"')
				escape = 1;

			if(quotes && escape)
				break;
		}

		if(quotes)
			(*s++) = '\"';

		for(j = 0 ; j < len ; j++)
		{
			if(arg[j] == '\"')
				(*s++) = '*';

			(*s++) = arg[j];
		}

		if(quotes)
			(*s++) = '\"';

		if(i < argc-1)
			(*s++) = ' ';
	}

	(*s) = '\0';

	SHOWSTRING(command);

	sprintf(in_name, "PIPE:in_%08x.%08lx", (int)FindTask(NULL), time(NULL));
	sprintf(out_name, "PIPE:out_%08x.%08lx", (int)FindTask(NULL), time(NULL));

	input = Open(in_name,MODE_OLDFILE);
	output = Open(out_name,MODE_NEWFILE);
	if(input != ZERO && output != ZERO)
	{
		LONG res;

		res = SystemTags(command,
			SYS_Input,		input,
			SYS_Output,		output,
			SYS_Asynch,		TRUE,
			SYS_UserShell,	TRUE,
		TAG_END);

		switch(res)
		{
			case 0:
				(*to_fd_ptr) = open(in_name,O_WRONLY,0777);
				if((*to_fd_ptr) == -1)
					break;

				(*from_fd_ptr) = open(out_name,O_RDONLY,0777);
				if((*from_fd_ptr) == -1)
					break;

				result = 0;
				break;

			case -1:
				errno = ENOMEM;
				Close(input);
				Close(output);
				break;

			default:
				errno = EIO;
				break;
		}
	}
	else
	{
		if(input != ZERO)
			Close(input);

		if(output != ZERO)
			Close(output);

		errno = EIO;
	}

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_isabsolute(char *filename)
{
	int result = 0;
	int i;

	ENTER();

	SHOWSTRING(filename);

	for(i = 0 ; i < strlen(filename) ; i++)
	{
		if(filename[i] == ':')
		{
			result = 1;
			break;
		}
	}

	RETURN(result);
	return(result);
}

/****************************************************************************/

char *amiga_last_component(char *path)
{
	char * result;

	ENTER();

	SHOWSTRING(path);

	result = FilePart(path);

	RETURN(result);
	return(result);
}

/****************************************************************************/

static int recursive_unlink_file_dir(char *f, BOOL remove_this_entry)
{
	D_S(struct FileInfoBlock,fib);
	BOOL directory_changed = FALSE;
	BPTR old_dir = ZERO;
	BPTR lock;
	int res = -1;

	ENTER();

	SHOWSTRING(f);
	SHOWVALUE(remove_this_entry);

	/* Try to get a lock on the object; if it's a directory, then
	   we will want to remove its contents (recursively). */
	lock = Lock(f,SHARED_LOCK);
	if(lock == ZERO)
		goto out;

	/* Figure out what kind of object we are dealing with. */
	if(CANNOT Examine(lock,fib))
		goto out;

	/* Is it a plain drawer? */
	if(FIB_IS_DRAWER(fib))
	{
		char name[sizeof(fib->fib_FileName)];

		/* Name of the file/drawer to be deleted. This is
		   filled in later. */
		name[0] = '\0';

		/* Make this directory being scanned the new current
		   directory. We'll need this to remove its contents. */
		old_dir = CurrentDir(lock);
		directory_changed = TRUE;

		while(TRUE)
		{
			/* Check if the user wants to abort the process. */
			if(SetSignal(0,0) & SIGBREAKF_CTRL_C)
			{
				SHOWMSG("stopped");
				goto out;
			}

			/* Try to examine the next directory entry. */
			if(CANNOT ExNext(lock,fib))
			{
				/* Is this a real error or did we hit the end
				   of the directory list? */
				if(IoErr() != ERROR_NO_MORE_ENTRIES)
					goto out;

				/* We reached the end of the directory list. Is there
				   still one last entry waiting to be deleted? */
				if(name[0] != '\0')
				{
					/* Check if the user wants to abort the process. */
					if(SetSignal(0,0) & SIGBREAKF_CTRL_C)
					{
						SHOWMSG("aborted");
						goto out;
					}

					if(CANNOT DeleteFile(name) && IoErr() != ERROR_OBJECT_NOT_FOUND)
					{
						D(("that didn't work; error=%ld",IoErr()));
						goto out;
					}
				}

				break;
			}

			/* Check if there is an entry waiting to be removed. */
			if(name[0] != '\0')
			{
				/* Check if the user wants to abort the process. */
				if(SetSignal(0,0) & SIGBREAKF_CTRL_C)
				{
					SHOWMSG("aborted");
					goto out;
				}

				/* Try to delete that entry. Don't complain if it's already gone. */
				if(CANNOT DeleteFile(name) && IoErr() != ERROR_OBJECT_NOT_FOUND)
				{
					D(("that didn't work; error=%ld",IoErr()));
					goto out;
				}

				/* That entry has been taken care of. */
				name[0] = '\0';
			}

			/* Did we find another directory? */
			if(FIB_IS_DRAWER(fib))
			{
				D(("'%s' (dir)",fib->fib_FileName));

				/* Enter it and proceed to remove its contents.
				   Careful: do not delete the directory itself.
				   This will be done later after the next
				   call to ExNext(). */
				res = recursive_unlink_file_dir(fib->fib_FileName,FALSE);
				if(res != 0)
					goto out;
			}

			/* Remember this name. The entry will be removed after
			   the next call to ExNext(). */
			strcpy(name,fib->fib_FileName);
		}
	}

	/* Should we remove the entry we just obtained a lock on? */
	if(remove_this_entry)
	{
		/* Return to the previously valid directory. We will want
		   to delete the object by the name of 'f' from it. */
		if(directory_changed)
		{
			CurrentDir(old_dir);
			directory_changed = FALSE;
		}

		/* Release the lock on the object in question. */
		UnLock(lock);
		lock = ZERO;

		/* Check if the user wants to abort the process. */
		if(SetSignal(0,0) & SIGBREAKF_CTRL_C)
		{
			SHOWMSG("aborted");
			goto out;
		}

		/* Now try to delete it. Don't complain if it's already gone. */
		if(CANNOT DeleteFile(f) && IoErr() != ERROR_OBJECT_NOT_FOUND)
		{
			D(("that didn't work; error=%ld",IoErr()));
			goto out;
		}
	}

	res = 0;

 out:

	/* Clean up... */
	if(directory_changed)
		CurrentDir(old_dir);

	UnLock(lock);

	RETURN(res);
	return(res);
}

int amiga_unlink_file_dir(char * f)
{
	int res;

	ENTER();

	correct_name(&f);

	SHOWSTRING(f);

	res = recursive_unlink_file_dir(f, TRUE);

	RETURN(res);
	return(res);
}

/****************************************************************************/

int amiga_fncmp(char *n1,char *n2)
{
	int result;

	ENTER();

	SHOWSTRING(n1);
	SHOWSTRING(n2);

	result = stricmp(n1, n2);

	RETURN(result);
	return(result);
}

/****************************************************************************/

void amiga_fnfold(char *name)
{
	int c;

	while((c = (*(unsigned char *)name)) != '\0')
		(*name++) = ToLower(c);
}

/****************************************************************************/

int amiga_fold_fn_char(int c)
{
	int result;

	result = ToLower(c);

	return(result);
}

/****************************************************************************/

typedef struct name_node
{
	struct name_node *	nn_next;
	char *				nn_name;
	BOOL				nn_wild;
} name_node_t;

/****************************************************************************/

static int compare(char **a,char **b)
{
	return(stricmp(*a,*b));
}

/****************************************************************************/

void amiga_expand_wild(int argc,char ** argv,int * _argc,char *** _argv)
{
	struct AnchorPath * anchor;
	name_node_t * root;
	name_node_t * node;
	name_node_t * next;
	LONG name_plus;
	LONG name_total;
	LONG i;

	ENTER();

	anchor		= (struct AnchorPath *)xmalloc(sizeof(*anchor) + 2 * MAX_FILENAME_LEN);
	root		= NULL;
	node		= NULL;
	next		= NULL;
	name_plus	= 0;
	name_total	= 0;

	memset(anchor,0,sizeof(*anchor));

	anchor->ap_Strlen		= MAX_FILENAME_LEN;
	anchor->ap_BreakBits	= SIGBREAKF_CTRL_C;

	for(i = 0 ; i < argc ; i++)
	{
		/* Jens: we only check from the start of the real arguments and only expand
		 * wildcards if the previous argument isn`t a option which is identified by a "-"
		 * followed by one character which results in a argv[i-1] of strlen() 2 !!
		 * this will prevent expanding of wildcards in options like "-m" completly.
		 */
		if(i > 0 && !(*(argv[i-1]) == '-' && strlen(argv[i-1]) == 2) && ParsePatternNoCase(argv[i],anchor->ap_Buf,2 * MAX_FILENAME_LEN) > 0)
		{
			LONG result;

			result = MatchFirst(argv[i],anchor);

			while(result == 0)
			{
				node = (name_node_t *)malloc(sizeof(*node) + strlen(anchor->ap_Buf) + 1);
				if(node == NULL)
				{
					char buf[80];

					MatchEnd(anchor);

					sprintf(buf,"out of memory; could not allocate %lu bytes",
						(unsigned long)(sizeof(*node) + strlen(anchor->ap_Buf) + 1));

					error(1,0,buf);
				}

				node->nn_name = (char *)(node + 1);
				node->nn_next = root;
				node->nn_wild = TRUE;

				strcpy(node->nn_name,anchor->ap_Buf);

				root = node;

				name_plus++;
				name_total++;

				result = MatchNext(anchor);
			}

			MatchEnd(anchor);
		}
		else
		{
			node = (name_node_t *)xmalloc(sizeof(*node));

			node->nn_name = argv[i];
			node->nn_next = root;
			node->nn_wild = FALSE;

			root = node;

			name_total++;
		}
	}

	if(name_plus > 0)
	{
		char ** last_wild;
		char ** index;

		index = (char **)xmalloc(sizeof(char *) * (name_total + 1));

		(*_argc) = name_total;
		(*_argv) = index;

		index = &(index[name_total]);

		(*index--) = NULL;

		node			= root;
		last_wild	= NULL;

		while(node != NULL)
		{
			if(node->nn_wild)
			{
				if(last_wild == NULL)
					last_wild = index;
			}
			else
			{
				if(last_wild)
				{
					if((ULONG)last_wild - (ULONG)index > sizeof(char **))
						qsort(index + 1,((ULONG)last_wild - (ULONG)index) / sizeof(char **),sizeof(char *), compare);

					last_wild = NULL;
				}
			}

			/* Here we have to call xstrdup() because free_names() will free
			 * that strings later.
			 */
			(*index--) = xstrdup(node->nn_name);

			node = node->nn_next;
		}
	}
	else
	{
		int i;

		/* Now we just have to allocate new memory and copy the whole argv[] to this mem
		 * because free_names() is going to free this mem later.
		 */
		(*_argc) = argc;
		(*_argv) = (char **) xmalloc(argc * sizeof (char *));

		for(i = 0; i < argc; ++i)
			(*_argv)[i] = xstrdup(argv[i]);
	}

	/* Now we free that whole list. */
	node = root;

	while(node != NULL)
	{
		next = node->nn_next;
		free(node);

		node = next;
	}

	free(anchor);

	LEAVE();
}

/****************************************************************************/

static void convert_fileinfo_to_stat(struct FileInfoBlock *fib, struct stat *st)
{
	ULONG flags;
	int mode;
	long time;

	ENTER();

	/* This routine converts the contents of a FileInfoBlock
	 * into information to fill a Unix-like stat data structure
	 * with.
	 */
	flags = fib->fib_Protection ^ (FIBF_READ|FIBF_WRITE|FIBF_EXECUTE|FIBF_DELETE);

	if(FIB_IS_DRAWER(fib))
	{
		/* We always tag directories as available for reading, writing
		 * and searching by the owner.
		 */
		fib->fib_Protection |= FIBF_READ|FIBF_WRITE|FIBF_EXECUTE|FIBF_DELETE;

		mode = S_IFDIR;
	}
	else
	{
		/* Files are always reported as readable by the owner. */
		fib->fib_Protection |= FIBF_READ;

		mode = S_IFREG;
	}

	if(FLAG_IS_SET(flags,FIBF_READ))
	{
		SET_FLAG(mode,S_IRUSR);
	}

	if(FLAG_IS_SET(flags,FIBF_WRITE))
	{
		SET_FLAG(mode,S_IWUSR);
	}

	if(FLAG_IS_SET(flags,FIBF_EXECUTE))
	{
		SET_FLAG(mode,S_IXUSR);
	}

	if(FLAG_IS_SET(flags,FIBF_GRP_READ))
	{
		SET_FLAG(mode,S_IRGRP);
	}

	if(FLAG_IS_SET(flags,FIBF_GRP_WRITE))
	{
		SET_FLAG(mode,S_IWGRP);
	}

	if(FLAG_IS_SET(flags,FIBF_GRP_EXECUTE))
	{
		SET_FLAG(mode,S_IXGRP);
	}

	if(FLAG_IS_SET(flags,FIBF_OTR_READ))
	{
		SET_FLAG(mode,S_IROTH);
	}

	if(FLAG_IS_SET(flags,FIBF_OTR_WRITE))
	{
		SET_FLAG(mode,S_IWOTH);
	}

	if(FLAG_IS_SET(flags,FIBF_OTR_EXECUTE))
	{
		SET_FLAG(mode,S_IXOTH);
	}

	time = fib->fib_Date.ds_Days * 24*60*60 +
		   fib->fib_Date.ds_Minute * 60 +
		   (fib->fib_Date.ds_Tick / TICKS_PER_SECOND);

	memset(st, 0, sizeof(struct stat));

	if(FIB_IS_FILE(fib))
	{
		st->st_nlink	= 1;
		st->st_size		= fib->fib_Size;
	}
	else
	{
		st->st_nlink = 2;
	}

	/* first we fill the struct stat with data we know immediatly */
	st->st_ino		= fib->fib_DiskKey;
	st->st_uid		= fib->fib_OwnerUID;
	st->st_gid		= fib->fib_OwnerGID;
	#if !defined(__SASC)
	st->st_blksize	= S_BLKSIZE;
	st->st_blocks	= (st->st_size + st->st_blksize-1) / st->st_blksize;
	#endif
	st->st_mode		= mode;
	st->st_mtime	= UNIX_TIME_OFFSET + time + 60 * amiga_get_minutes_west(); /* translate from local time to UTC */
	st->st_atime	= st->st_mtime;
	st->st_ctime	= st->st_mtime;

	LEAVE();
}

/****************************************************************************/

int amiga_stat(char *name,struct stat *st)
{
	int result = -1;
	BPTR fileLock;

	ENTER();

	chkabort();

	correct_name(&name);

	fileLock = Lock((STRPTR)name,SHARED_LOCK);
	if(fileLock != ZERO)
	{
		D_S(struct FileInfoBlock,fib);

		if(Examine(fileLock,fib))
		{
			BPTR parentDir;

			/* Check if this is a root directory. */
			parentDir = ParentDir(fileLock);
			if(parentDir != ZERO)
			{
				/* This is not the root directory. */
				UnLock(parentDir);
			}
			else
			{
				/* So this is a root directory. Make sure
				 * that we return proper protection bits for
				 * it, i.e. that the directory is always
				 * readable, writable, etc. This may be
				 * necessary since on the Amiga, root
				 * directories cannot have any protection
				 * bits set. Note that the "deletable"
				 * bits don't make much sense, but then
				 * these bits work together with the
				 * writable bits. The lowest four bits
				 * remain zero, which enables them all.
				 */
				fib->fib_Protection = FIBF_OTR_READ |
									  FIBF_OTR_WRITE |
									  FIBF_OTR_EXECUTE |
									  FIBF_OTR_DELETE |
									  FIBF_GRP_READ |
									  FIBF_GRP_WRITE |
									  FIBF_GRP_EXECUTE |
									  FIBF_GRP_DELETE;
			}

			convert_fileinfo_to_stat(fib,st);

			result = OK;
		}
		else
		{
			map_ioerr_to_errno();
		}

		UnLock(fileLock);
	}
	else
	{
		map_ioerr_to_errno();
	}

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_lstat(char *name,struct stat *statstruct)
{
	int result;

	result = amiga_stat(name,statstruct);

	return(result);
}

/****************************************************************************/

int amiga_fstat(int fd,struct stat * st)
{
	int result = -1;

	/* NOTE: SAS/C 6.5x has no fstat() routine in its runtime
	 *       library (this is not required by the ANSI standard).
	 *       So for SAS/C we cook up a version which depends
	 *       upon compiler specific features and assume that for
	 *       everything else, a different solution will be found.
	 */
	#ifdef __SASC
	{
		struct UFB * ufb;

		chkabort();

		ufb = chkufb(fd);
		if(ufb != NULL)
		{
			D_S(struct FileInfoBlock,fib);

			if(ExamineFH(ufb->ufbfh,fib))
			{
				convert_fileinfo_to_stat(fib,st);

				result = OK;
			}
			else
			{
				map_ioerr_to_errno();
			}
		}
	}
	#else
	{
		result = fstat(fd,st);
	}
	#endif /* __SASC */

	return(result);
}

/******************************************************************************/

int amiga_chmod(char *name,int mode)
{
	int result = OK;
	ULONG flags = 0;

	ENTER();

	chkabort();

	/* Convert the file access modes into
	 * Amiga typical protection bits.
	 */
	if(FLAG_IS_SET(mode,S_IRUSR))
	{
		SET_FLAG(flags,FIBF_READ);
	}

	if(FLAG_IS_SET(mode,S_IWUSR))
	{
		SET_FLAG(flags,FIBF_WRITE);
		SET_FLAG(flags,FIBF_DELETE);
	}

	if(FLAG_IS_SET(mode,S_IXUSR))
	{
		SET_FLAG(flags,FIBF_EXECUTE);
	}

	if(FLAG_IS_SET(mode,S_IRGRP))
	{
		SET_FLAG(flags,FIBF_GRP_READ);
	}

	if(FLAG_IS_SET(mode,S_IWGRP))
	{
		SET_FLAG(flags,FIBF_GRP_WRITE);
		SET_FLAG(flags,FIBF_GRP_DELETE);
	}

	if(FLAG_IS_SET(mode,S_IXGRP))
	{
		SET_FLAG(flags,FIBF_GRP_EXECUTE);
	}

	if(FLAG_IS_SET(mode,S_IROTH))
	{
		SET_FLAG(flags,FIBF_OTR_READ);
	}

	if(FLAG_IS_SET(mode,S_IWOTH))
	{
		SET_FLAG(flags,FIBF_OTR_WRITE);
		SET_FLAG(flags,FIBF_OTR_DELETE);
	}

	if(FLAG_IS_SET(mode,S_IXOTH))
	{
		SET_FLAG(flags,FIBF_OTR_EXECUTE);
	}

	/* AmigaOS handles the RWED bits different 0 == allowed */
	flags ^= (FIBF_READ|FIBF_WRITE|FIBF_EXECUTE|FIBF_DELETE);

	correct_name(&name);

	if(CANNOT SetProtection(name,flags))
	{
		LONG error;

		error = IoErr();
		if(error != ERROR_OBJECT_IN_USE)
		{
			SetIoErr(error);

			map_ioerr_to_errno();

			result = -1;
		}
	}

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_access(char *name,int modes)
{
	int result;

	ENTER();

	correct_name(&name);

	SHOWSTRING(name);
	SHOWVALUE(modes);

	/* We ignore the 'x' bit since it doesn't matter
	 * on the Amiga.
	 */
	result = access(name,modes & ~X_OK);

	RETURN(result);
	return(result);
}

/****************************************************************************/

#if defined(__SASC)
static BPTR home_dir;

static void restore_home_dir(void)
{
	if(home_dir != ZERO)
	{
		UnLock(CurrentDir(home_dir));
		home_dir = ZERO;
	}
}
#endif

/****************************************************************************/

int amiga_chdir(char *path)
{
	int result;

	ENTER();

#if defined(__SASC)
	if(home_dir == ZERO)
	{
		BPTR old_dir;

		/* This is tricky at best. chdir() will change the
		 * current directory of this process and unlock the
		 * previously active current directory lock. However,
		 * the current directory lock with which this program
		 * was launched *must not* be unlocked; the same lock
		 * the program was launched with must be the one the
		 * program exits with. This is what we are trying to
		 * achieve here. Note that this strange procedure is
		 * required only because the SAS/C chdir() implementation
		 * will UnLock() the current directory before changing
		 * to the new one.
		 */
		old_dir = Lock("",SHARED_LOCK);
		if(old_dir == ZERO)
		{
			errno = EIO;
			result = -1;

			RETURN(result);
			return(result);
		}

		home_dir = CurrentDir(old_dir);

		atexit(restore_home_dir);
	}
#endif

	correct_name(&path);

	SHOWSTRING(path);

	result = chdir(path);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_creat(char *name,int prot)
{
	int result;

	ENTER();

	correct_name(&name);

	SHOWSTRING(name);
	SHOWVALUE(prot);

	result = creat(name, prot);
	if(result > -1)
		amiga_chmod(name, prot);

	RETURN(result);
	return(result);
}

/****************************************************************************/

FILE *amiga_fopen(char *name, char *modes)
{
	FILE * result;

	ENTER();

	correct_name(&name);

	SHOWSTRING(name);
	SHOWSTRING(modes);

	result = fopen(name,modes);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_open(char *name, int flags, ...)
{
	int result;
	int mode;
	va_list args;

	ENTER();

	// lets get the mode if exists
	va_start(args, flags);
	mode = va_arg(args, int);

	correct_name(&name);

	SHOWSTRING(name);
	SHOWVALUE(mode);

	result = open(name, flags);
	if(result > -1 && FLAG_IS_SET(flags, O_CREAT) && mode)
		amiga_chmod(name, mode|S_IWUSR);

	va_end(args);

	RETURN(result);
	return(result);
}

/****************************************************************************/

void *amiga_opendir(char *dir_name)
{
	void * result;

	ENTER();

	correct_name(&dir_name);

	SHOWSTRING(dir_name);

	result = opendir(dir_name);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_rename(char *old,char *new)
{
	int result;

	ENTER();

	correct_name(&old);
	correct_name(&new);

	SHOWSTRING(old);
	SHOWSTRING(new);

	/* NOTE: Unix-style rename, which will cause a file of the same
	 *       name to be removed first.
	 */

	result = rename(old,new);
	if(result == -1 && errno == EEXIST)
	{
		if(CANNOT DeleteFile(new))
		{
			LONG error = IoErr();

			if(error == ERROR_DELETE_PROTECTED)
			{
				SetProtection(new,0);
				DeleteFile(new);
			}
		}

		result = rename(old,new);
	}

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_rmdir(char *name)
{
	int result;

	ENTER();

	correct_name(&name);

	SHOWSTRING(name);

	result = rmdir(name);

	RETURN(result);
	return(result);
}

/****************************************************************************/

int amiga_unlink(char *name)
{
	int result = 0;

	ENTER();

	correct_name(&name);

	SHOWSTRING(name);

	if(CANNOT DeleteFile(name))
	{
		LONG error;

		/* This is tricky; CVS can be run either by the administrator
		 * or by a humble user. Trouble is, there is no such distinction
		 * on the Amiga, which effectively means that the user is also
		 * the administrator. In this particular case it means that the
		 * file to be removed must be removed even if it is protected
		 * from deletion. Why is this important? If we don't do this,
		 * then checking out CVSROOT files and modifying them (such as
		 * the modules file) will not work.
		 */
		error = IoErr();
		if(error == ERROR_DELETE_PROTECTED)
		{
			if(SetProtection(name,0) && DeleteFile(name))
				error = 0;
			else
				error = IoErr();
		}

		if(error != 0)
		{
			SetIoErr(error);

			map_ioerr_to_errno();

			result = -1;
		}
	}

	RETURN(result);
	return(result);
}

/****************************************************************************/

unsigned char *amiga_inet_ntoa(struct in_addr iaddr)
{
	return(Inet_NtoA(iaddr.s_addr));
}

/****************************************************************************/

FILE *amiga_cvs_temp_file(char **filename)
{
	FILE *fp = NULL;
	char *fn;

	fn = amiga_cvs_temp_name();
	if(fn != NULL)
	{
		fp = amiga_fopen(fn,"w+");
		if(fp != NULL);
			amiga_chmod(fn,0600);
	}

	(*filename) = fn;

	return(fp);
}

/****************************************************************************/

char *amiga_cvs_temp_name(void)
{
	extern char *Tmpdir;
	char *value;
	char *retval;
	int max_len;
	int len;

	ENTER();

	max_len = strlen(Tmpdir) + 40;

	value = xmalloc(max_len);

	strcpy(value,Tmpdir);
	len = strlen(value);
	while(len > 0 && value[len-1] == '/')
		value[--len] = '\0';

	AddPart(value,"cvsXXXXXX",max_len);

	correct_name(&value);

	retval = mktemp(value);

	if(retval == NULL)
		error(1,errno,"could not generate temporary filename");

	SHOWSTRING(value);

	RETURN(value);
	return(value);
}

/****************************************************************************/

static int amiga_rcmd(char **remote_hostname,int remote_port,char *local_user,char *remote_user,char *command)
{
	struct hostent *remote_hp;
	struct hostent *local_hp;
	struct sockaddr_in remote_isa;
	struct sockaddr_in local_isa;
	char local_hostname[80];
	char ch;
	int s;
	int local_port;
	int rs;

	remote_hp = amiga_gethostbyname(*remote_hostname);
	if(remote_hp == NULL)
	{
		fprintf(stderr,"Could not obtain address of remote host '%s' (%d, %s).\n",(*remote_hostname),errno,amiga_strerror(errno));
		exit(1);
	}

	/* Copy remote IP address into socket address structure */
	memset(&remote_isa,0,sizeof(remote_isa));
	remote_isa.sin_family = AF_INET;
	remote_isa.sin_port = htons(remote_port);
	memcpy(&remote_isa.sin_addr,remote_hp->h_addr,sizeof(remote_isa.sin_addr));

	amiga_gethostname(local_hostname,sizeof(local_hostname));
	local_hp = amiga_gethostbyname(local_hostname);
	if(local_hp == NULL)
	{
		fprintf(stderr,"Could not obtain local host address (%d, %s).\n",errno,amiga_strerror(errno));
		exit(1);
	}

	/* Copy local IP address into socket address structure */
	memset(&local_isa,0,sizeof(local_isa));
	local_isa.sin_family = AF_INET;
	memcpy(&local_isa.sin_addr,local_hp->h_addr,sizeof(local_isa.sin_addr));

	/* Create the local socket */
	s = amiga_socket(AF_INET,SOCK_STREAM,0);
	if(s < 0)
	{
		fprintf(stderr,"Socket creation failed (%d, %s).\n",errno,amiga_strerror(errno));
		exit(1);
	}

	/* Bind local socket with a port from IPPORT_RESERVED/2 to IPPORT_RESERVED - 1
	 * this requires the OPER privilege under VMS -- to allow communication with
	 * a stock rshd under UNIX
	 */
	rs = 0;
	for(local_port = IPPORT_RESERVED - 1; local_port >= IPPORT_RESERVED/2; local_port--)
	{
		local_isa.sin_port = htons(local_port);
		rs = amiga_bind(s,(struct sockaddr *)&local_isa,sizeof(local_isa));
		if(rs == 0)
			break;
	}

	/* Bind local socket to an unprivileged port.  A normal rshd will drop the
	 * connection; you must be running a patched rshd invoked through inetd for
	 * this connection method to work
	 */

	if(rs != 0)
	{
		for(local_port = IPPORT_USERRESERVED - 1;
		    local_port > IPPORT_RESERVED;
		    local_port--)
		{
			local_isa.sin_port = htons(local_port);
			rs = amiga_bind(s,(struct sockaddr *)&local_isa,sizeof(local_isa));
			if(rs == 0)
				break;
		}
	}

	rs = amiga_connect(s,(struct sockaddr *) &remote_isa,sizeof(remote_isa));
	if(rs == -1)
	{
		fprintf(stderr,"Could not connect to %s:%d (%d, %s).\n",(*remote_hostname),remote_port,errno,amiga_strerror(errno));
		amiga_close(s);
		exit(2);
	}

	/* Now supply authentication information */

	/* Auxiliary port number for error messages, we don't use it */
	amiga_send(s,"0\0",2,0);

	/* Who are we */
	amiga_send(s,local_user,strlen(local_user) + 1,0);

	/* Who do we want to be */
	amiga_send(s,remote_user,strlen(remote_user) + 1,0);

	/* What do we want to run */
	amiga_send(s,command,strlen(command) + 1,0);

	/* NUL is sent back to us if information is acceptable */
	if(amiga_recv(s,&ch,1,0) != 1)
		return(-1);

	if(ch != '\0')
	{
		errno = EPERM;
		return -1;
	}

	return s;
}

/****************************************************************************/

static char *cvs_server;
static char *command;

extern int trace;

void amiga_start_server(int *tofd,int *fromfd,char *client_user,char *server_user,char *server_host,char *server_cvsroot)
{
	int fd,port;
	char *portenv;
	struct servent *sptr;
	char * shell_name;

	shell_name = amiga_getenv("CVS_RSH");
	if(shell_name == NULL)
		shell_name = "rsh";

	cvs_server = amiga_getenv("CVS_SERVER");
	if(cvs_server == NULL)
		cvs_server = "cvs";

	command = xmalloc(strlen(cvs_server)
	                  + strlen(server_cvsroot)
	                  + 50);
	sprintf(command,"%s server",cvs_server);

	portenv = amiga_getenv("CVS_RCMD_PORT");
	if(portenv != NULL)
	{
		port = atoi(portenv);
	}
	else
	{
		sptr = amiga_getservbyname("shell","tcp");
		if(sptr != NULL)
			port = sptr->s_port;
		else
			port = 514; /* shell/tcp */
	}

	if(trace)
	{
		fprintf(stderr,"amiga_start_server(): connecting to %s:%d\n",
		        server_host,port);

		fprintf(stderr,"local_user = %s, remote_user = %s, CVSROOT = %s\n",
		        client_user,(server_user ? server_user : client_user),
		        server_cvsroot);
	}

	if(strcmp(shell_name,"ssh") == SAME || strcmp(shell_name,"ssh1") == SAME)
	{
		int cipher = SSH_CIPHER_3DES;
		int port = SSH_PORT;

		char *new_user_name = NULL;
		char *password = NULL;
		char *ssh_passfile;
		char *ssh_config_file;
		char *cvsrootstr;
		BOOL password_found_in_file = FALSE;

		/* Allocate local memory for the larger buffers. */
		cvsrootstr = xmalloc(1024);

		/* Load the defaults for this server, if a configuration file is provided. */
		ssh_config_file = amiga_getenv("CVS_SSH_CONFIGFILE");
		if(ssh_config_file != NULL)
		{
			FILE *fh;

			fh = amiga_fopen(ssh_config_file,"r");
			if(fh != NULL)
			{
				char * current_host_name = NULL;
				int line_length;
				char *linebuf = NULL;
				size_t linebuf_len;
				char * token;
				
				while((line_length = getline(&linebuf,&linebuf_len,fh)) >= 0)
				{
					/* Now we remove the finishing line feed. */
					while(line_length > 0 && linebuf[line_length-1] == '\n')
						linebuf[--line_length] = '\0';

					token = strtok(linebuf," \t");
					if(token != NULL)
					{
						if(stricmp(token,"host") == SAME || stricmp(token,"server") == SAME)
						{
							if(current_host_name != NULL)
							{
								free(current_host_name);
								current_host_name = NULL;
							}

							token = strtok(NULL," \t");
							if(token != NULL)
								current_host_name = strdup(token);
						}
						else if (stricmp(token,"port") == SAME)
						{
							if(current_host_name != NULL && stricmp(server_host,current_host_name) == SAME)
							{
								token = strtok(NULL," \t");
								if(token != NULL)
								{
									int n;

									n = atoi(token);
									if(1 <= n && n < 32768)
										port = n;
								}
							}
						}
						else if (stricmp(token,"cipher") == SAME)
						{
							if(current_host_name != NULL && stricmp(server_host,current_host_name) == SAME)
							{
								token = strtok(NULL," \t");
								if(token != NULL && stricmp(token,"blowfish") == SAME)
									cipher = SSH_CIPHER_BLOWFISH;
							}
						}
						else if (stricmp(token,"user") == SAME)
						{
							if(current_host_name != NULL && stricmp(server_host,current_host_name) == SAME)
							{
								if(new_user_name != NULL)
								{
									free(new_user_name);
									new_user_name = NULL;
								}

								token = strtok(NULL," \t");
								if(token != NULL)
									new_user_name = strdup(token);
							}
						}
					}

					free(linebuf);
				}

				if(current_host_name != NULL)
					free(current_host_name);

				if(new_user_name != NULL)
					server_user = new_user_name;

				fclose(fh);
			}
		}

		/* Now we check if the special CVS_SSH_PASSFILE variable is enabled.
		 * Please note that it is ABSOLUTLY INSECURE to use this PASSFILE option.
		 * It was added on user request, but we do not recommend to use it.
		 */
		ssh_passfile = amiga_getenv("CVS_SSH_PASSFILE");
		if(ssh_passfile != NULL)
		{
			FILE *fh;

			sprintf(cvsrootstr,":server:%s@%s:%s ",(server_user ? server_user : client_user),server_host,server_cvsroot);

			/* Now we check if an entry exists in the passfile. */
			fh = amiga_fopen(ssh_passfile,"r");
			if(fh != NULL)
			{
				int line_length;
				char *linebuf = NULL;
				size_t linebuf_len;

				while((line_length = getline(&linebuf,&linebuf_len,fh)) >= 0)
				{
					/* Now we remove the finishing line feed. */
					while(line_length > 0 && linebuf[line_length-1] == '\n')
						linebuf[--line_length] = '\0';

					if(strncmp(linebuf,cvsrootstr,strlen(cvsrootstr)) == SAME)
					{
						char *passphrase = linebuf+strlen(cvsrootstr);

						if(passphrase[0] != 'A')
							error(1,0,"corrupt SSH passfile entry.");

						password = descramble(passphrase);
						password_found_in_file = TRUE;

						break;
					}

					free(linebuf);
					linebuf = NULL;
				}

				fclose(fh);

				if(linebuf != NULL)
					free(linebuf);
			}
		}

		if(password == NULL)
		{
			char *prompt;

			prompt = xmalloc(400);

			sprintf(prompt,"Password for %s@%s: ",(server_user ? server_user : client_user),server_host);

			password = amiga_getpass(prompt);

			free(prompt);
		}

		if(password != NULL)
		{
			char * cipher_name;
			char * port_number;

			cipher_name = amiga_getenv("CVS_SSH_CIPHER");
			if(cipher_name != NULL && stricmp(cipher_name,"blowfish") == SAME)
				cipher = SSH_CIPHER_BLOWFISH;

			port_number = amiga_getenv("CVS_SSH_PORT");
			if(port_number != NULL)
			{
				int n;

				n = atoi(port_number);
				if(1 <= n && n < 32768)
					port = n;
			}

			fd = amiga_connect_ssh(server_host,(server_user != NULL) ? server_user : client_user,password,cipher,port);
			if(fd != -1)
			{
				struct socket_context * sc;

				sc = get_registered_socket(fd);
				if(sc != NULL)
				{
					/* We can now save the password in the passfile
					 * unless it already exists.
					 */
					if(ssh_passfile != NULL && NOT password_found_in_file)
					{
						FILE *fh;

						/* Check if a entry exists in the passfile. */
						fh = amiga_fopen(ssh_passfile,"a");
						if(fh != NULL)
						{
							if(fprintf(fh,"%s%s\n",cvsrootstr,scramble(password)) < 0)
								error(1,errno,"could not write to '%s'",ssh_passfile);

							fclose(fh);
						}
						else
						{
							error(1,errno,"could not open '%s' for writing",ssh_passfile);
						}
					}

					if(ssh_execute_cmd(sc->sc_SSH,command) == -1)
					{
						amiga_close(fd);
						fd = -1;
					}
				}
				else
				{
					amiga_close(fd);
					fd = -1;
				}
			}
		}
		else
		{
			fd = -1;
		}

		if(new_user_name != NULL)
			free(new_user_name);

		free(cvsrootstr);
	}
	else
	{
		fd = amiga_rcmd(&server_host,port,
		                client_user,
		                (server_user ? server_user : client_user),
		                command);
	}

	if(fd < 0)
		error(1,errno,"could not start server via rcmd()");

	(*tofd) = fd;
	(*fromfd) = fd;

	free(command);
}

/****************************************************************************/

void amiga_shutdown_server_input(int fd)
{
	ENTER();

	// make sure write&read channels are shutdown
	if(amiga_shutdown(fd, 2) < 0 && errno != ENOTSOCK)
		error(1,0,"could not shutdown() input server connection");

	// then free this thing
	if(amiga_close(fd) < 0)
		error(1,0,"could not close() server connection");

	LEAVE();
}

/****************************************************************************/

void amiga_shutdown_server_output(int fd)
{
	ENTER();

	// make sure write&read channels are shutdown
	if(amiga_shutdown(fd, 1) < 0 && errno != ENOTSOCK)
		error(1,0,"could not shutdown() output server connection");

	LEAVE();
}

/****************************************************************************/

void amiga_system_initialize(int * _argc, char *** _argv)
{
	/* We have to take care that the 68k libnix doesn`t support
	   some of the stuff SAS/C supports by default and also we have to
	   take care that the morphOS libnix supports it */
#if defined(__GNUC__) && !defined(__MORPHOS__)
	if(WBenchMsg != NULL)
	{
		_ProgramName = (char *)WBenchMsg->sm_ArgList[0].wa_Name;
	}
	else
	{
		_ProgramName = (char *)*_argv[0];
	}
#endif

	amiga_expand_wild((*_argc),(*_argv),_argc,_argv);
}

/****************************************************************************/

char *amiga_getenv(char * name)
{
	static char local_buffer[512];
	char * result = NULL;

	if(GetVar((STRPTR)name,local_buffer,sizeof(local_buffer),0) > 0)
	{
		result = malloc(strlen(local_buffer)+1);
		if(result != NULL)
			strcpy(result,local_buffer);
	}

	return(result);
}

/****************************************************************************/

/* We have to provide our own functions for several things because
   the libnix version of morphos doesn`t provide those functions yet.
   But as soon as it is supported we can remove those functions here.
*/
#if defined(__MORPHOS__)

#include <unistd.h>
#include <proto/exec.h>

char *mktemp(char *buf)
{
	long pid = (long)FindTask(0L);
	char *c = buf;

	while(*c++); --c;

	while(*--c == 'X')
	{
		*c = pid % 10 + '0';
		pid /= 10;
	}

	if (++c,*c)
	{
		for(*c='A'; *c <= 'Z'; (*c)++)
		{
			if (access(buf,0))
			{
				return buf;
			}
		}
		*c = 0;
	}

	return buf;
}

#include <fcntl.h>

int creat(const char *path, mode_t mode)
{
	return open(path, O_CREAT | O_TRUNC | O_WRONLY, mode);
}

#include <unistd.h>

int rmdir(const char *pathname)
{
	return remove(pathname);
}

#endif /* __MORPHOS__ */
