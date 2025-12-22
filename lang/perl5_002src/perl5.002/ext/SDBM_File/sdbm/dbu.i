# 1 "dbu.c"
# 1 "/gnu/include/stdio.h" 1 3
 








































# 1 "/gnu/include/sys/cdefs.h" 1 3
 













































 











# 76 "/gnu/include/sys/cdefs.h" 3



# 42 "/gnu/include/stdio.h" 2 3


# 1 "/gnu/include/machine/ansi.h" 1 3
 





































 


















# 44 "/gnu/include/stdio.h" 2 3


typedef	unsigned long 	size_t;







typedef long fpos_t;		 



 





 
struct __sbuf {
	unsigned char *_base;
	int	_size;
};

 























typedef	struct __sFILE {
	unsigned char *_p;	 
	int	_r;		 
	int	_w;		 
	short	_flags;		 
	short	_file;		 
	struct	__sbuf _bf;	 
	int	_lbfsize;	 

	 
	void	*_cookie;	 
	int	(*_close)  (void *)  ;
	int	(*_read)   (void *, char *, int)  ;
	fpos_t	(*_seek)   (void *, fpos_t, int)  ;
	int	(*_write)  (void *, const char *, int)  ;

	 
	struct	__sbuf _ub;	 
	unsigned char *_up;	 
	int	_ur;		 

	 
	unsigned char _ubuf[3];	 
	unsigned char _nbuf[1];	 

	 
	struct	__sbuf _lb;	 

	 
	int	_blksize;	 
	int	_offset;	 
} FILE;







 
extern FILE **__sF;
 









	 











 















 







 


























 


 
void	 clearerr  (FILE *)  ;
int	 fclose  (FILE *)  ;
int	 feof  (FILE *)  ;
int	 ferror  (FILE *)  ;
int	 fflush  (FILE *)  ;
int	 fgetc  (FILE *)  ;
int	 fgetpos  (FILE *, fpos_t *)  ;
char	*fgets  (char *, size_t, FILE *)  ;
FILE	*fopen  (const char *, const char *)  ;
int	 fprintf  (FILE *, const char *, ...)  ;
int	 fputc  (int, FILE *)  ;
int	 fputs  (const char *, FILE *)  ;
int	 fread  (void *, size_t, size_t, FILE *)  ;
FILE	*freopen  (const char *, const char *, FILE *)  ;
int	 fscanf  (FILE *, const char *, ...)  ;
int	 fseek  (FILE *, long, int)  ;
int	 fsetpos  (FILE *, const fpos_t *)  ;
long	 ftell  (const FILE *)  ;
size_t	 fwrite  (const void *, size_t, size_t, FILE *)  ;
int	 getc  (FILE *)  ;
int	 getchar  (void)  ;
char	*gets  (char *)  ;

extern int sys_nerr;			 







void	 perror  (const char *)  ;
int	 printf  (const char *, ...)  ;
int	 putc  (int, FILE *)  ;
int	 putchar  (int)  ;
int	 puts  (const char *)  ;
int	 remove  (const char *)  ;
int	 rename   (const char *, const char *)  ;
void	 rewind  (FILE *)  ;
int	 scanf  (const char *, ...)  ;
void	 setbuf  (FILE *, char *)  ;
int	 setvbuf  (FILE *, char *, int, size_t)  ;
int	 sprintf  (char *, const char *, ...)  ;
int	 sscanf  (const char *, const char *, ...)  ;
FILE	*tmpfile  (void)  ;
char	*tmpnam  (char *)  ;
int	 ungetc  (int, FILE *)  ;
int	 vfprintf  (FILE *, const char *, char * )  ;
int	 vprintf  (const char *, char * )  ;
int	 vsprintf  (char *, const char *, char * )  ;
 

 






 
char	*ctermid  (char *)  ;
FILE	*fdopen  (int, const char *)  ;
int	 fileno  (FILE *)  ;
 


 



 
char	*fgetline  (FILE *, size_t *)  ;
int	 fpurge  (FILE *)  ;
int	 getw  (FILE *)  ;
int	 pclose  (FILE *)  ;
FILE	*popen  (const char *, const char *)  ;
int	 putw  (int, FILE *)  ;
void	 setbuffer  (FILE *, char *, int)  ;
int	 setlinebuf  (FILE *)  ;
char	*tempnam  (const char *, const char *)  ;
int	 snprintf  (char *, size_t, const char *, ...)  ;
int	 vsnprintf  (char *, size_t, const char *, char * )  ;
int	 vscanf  (const char *, char * )  ;
int	 vsscanf  (const char *, const char *, char * )  ;
 

 






 


 
FILE	*funopen  (const void *,
		int (*)(void *, char *, int),
		int (*)(void *, const char *, int),
		fpos_t (*)(void *, fpos_t, int),
		int (*)(void *))  ;
 




 


 
int	__srget  (FILE *)  ;
int	__svfscanf  (FILE *, const char *, char * )  ;
int	__swbuf  (int, FILE *)  ;
 

 





static __inline int __sputc(int _c, FILE *_p) {
	if (--_p->_w >= 0 || (_p->_w >= _p->_lbfsize && (char)_c != '\n'))
		return (*_p->_p++ = _c);
	else
		return (__swbuf(_c, _p));
}
# 352 "/gnu/include/stdio.h" 3























# 1 "dbu.c" 2

# 1 "/gnu/include/sys/file.h" 1 3
 





















# 1 "/gnu/include/sys/types.h" 1 3
 





































typedef	unsigned char	u_char;
typedef	unsigned short	u_short;
typedef	unsigned int	u_int;
typedef	unsigned long	u_long;
typedef	unsigned short	ushort;		 

typedef	char *	caddr_t;		 
typedef	long	daddr_t;		 
typedef	short	dev_t;			 
typedef	u_long	ino_t;			 
typedef	long	off_t;			 
typedef	u_short	nlink_t;		 
typedef	long	swblk_t;		 
typedef	long	segsz_t;		 
typedef	u_short	uid_t;			 
typedef	u_short	gid_t;			 
typedef	int	pid_t;			 
typedef	u_short	mode_t;			 
typedef u_long	fixpt_t;		 


typedef	struct	_uquad	{ u_long val[2]; } u_quad;
typedef	struct	_quad	{   long val[2]; } quad;
typedef	long *	qaddr_t;	 








# 1 "/gnu/include/machine/types.h" 1 3
 





































typedef struct _physadr {
	short r[1];
} *physadr;

typedef struct label_t {		 
	int val[15];
} label_t;

typedef	u_long	vm_offset_t;
typedef	u_long	vm_size_t;


# 71 "/gnu/include/sys/types.h" 2 3




typedef	unsigned long 	clock_t;









typedef	long 	time_t;






 









typedef long	fd_mask;






typedef	struct fd_set {
	fd_mask	fds_bits[((( 256  )+((  (sizeof(fd_mask) * 8 )  )-1))/(  (sizeof(fd_mask) * 8 )  )) ];
} fd_set;






# 132 "/gnu/include/sys/types.h" 3




# 23 "/gnu/include/sys/file.h" 2 3

# 1 "/gnu/include/sys/fcntl.h" 1 3
 





































 









 






 
































 


 














# 117 "/gnu/include/sys/fcntl.h" 3



 



 















 



 


 












 



struct flock {
	short	l_type;		 
	short	l_whence;	 
	off_t	l_start;	 
	off_t	l_len;		 
	pid_t	l_pid;		 
};



 










 
int	open  (const char *, int, ...)  ;
int	creat  (const char *, mode_t)  ;
int	fcntl  (int, int, ...)  ;

int	flock  (int, int)  ;

 



# 24 "/gnu/include/sys/file.h" 2 3

# 1 "/gnu/include/sys/unistd.h" 1 3
 





































 








 


				 


 





 





 





 










 










# 25 "/gnu/include/sys/file.h" 2 3


# 99 "/gnu/include/sys/file.h" 3










 


# 2 "dbu.c" 2


# 1 "sdbm.h" 1
 









					 



typedef struct {
	int dirf;		        
	int pagf;		        
	int flags;		        
	long maxbno;		        
	long curbit;		        
	long hmask;		        
	long blkptr;		        
	int keyptr;		        
	long blkno;		        
	long pagbno;		        
	char pagbuf[1024 ];	        
	long dirbno;		        
	char dirbuf[4096 ];	        
} DBM;




 










typedef struct {
	char *dptr;
	int dsize;
} datum;

extern datum nullitem;







 





 


extern DBM *sdbm_open  (char *, int, int)  ;
extern void sdbm_close  (DBM *)  ;
extern datum sdbm_fetch  (DBM *, datum)  ;
extern int sdbm_delete  (DBM *, datum)  ;
extern int sdbm_store  (DBM *, datum, datum, int)  ;
extern datum sdbm_firstkey  (DBM *)  ;
extern datum sdbm_nextkey  (DBM *)  ;

 


extern DBM *sdbm_prep  (char *, char *, int, int)  ;
extern long sdbm_hash  (char *, int)  ;













 


 







# 1 "/gnu/lib/gcc-lib/m68000-unknown-amigaos/2.7.2/include/errno.h" 1 3
 






































extern int errno;			 













					 


























 



 






 













 

















 






 





 




















extern int errno;

# 104 "sdbm.h" 2







# 120 "sdbm.h"







# 1 "/gnu/include/ctype.h" 1 3
 




















	 

	 

	 

	 

	 

	 

	 

	 










extern const char *_ctype_;






















# 127 "sdbm.h" 2

# 1 "/gnu/include/setjmp.h" 1 3
 







































typedef int sigjmp_buf[17  + 1];

typedef int jmp_buf[17 ];



 
int	setjmp  (jmp_buf)  ;
 
void	longjmp  (jmp_buf, int)  ;

int	sigsetjmp  (sigjmp_buf, int)  ;
void	volatile siglongjmp  (sigjmp_buf, int)  ;


int	_setjmp  (jmp_buf)  ;
void	volatile _longjmp  (jmp_buf, int)  ;
void	longjmperror  (void)  ;

 


# 128 "sdbm.h" 2










# 1 "/gnu/include/sys/param.h" 1 3
 



















































 


 


 






# 1 "/gnu/include/sys/syslimits.h" 1 3
 





















































# 66 "/gnu/include/sys/param.h" 2 3












 









 
# 1 "/gnu/include/sys/signal.h" 1 3


# 1 "/gnu/include/signal.h" 1 3
 





























# 1 "/gnu/include/sys/signal.h" 1 3
# 10 "/gnu/include/sys/signal.h" 3

# 31 "/gnu/include/signal.h" 2 3




















































typedef	void (*sig_t)();








typedef unsigned int sigset_t;

 
int	sigaddset  (sigset_t *, int)  ;
int	sigdelset  (sigset_t *, int)  ;
int	sigemptyset  (sigset_t *)  ;
int	sigfillset  (sigset_t *)  ;
int	sigismember  (const sigset_t *, int)  ;
 







 


struct	sigaction {
	void	(*sa_handler)();	 
	sigset_t sa_mask;		 
	int	sa_flags;		 
};






 







 



struct	sigvec {
	void	(*sv_handler)();	 
	int	sv_mask;		 
	int	sv_flags;		 
};




 


struct	sigaltstack {
	char	*ss_base;		 
	int	ss_len;			 
	int	ss_onstack;		 
};

 


struct	sigstack {
	char	*ss_sp;			 
	int	ss_onstack;		 
};

 






struct	sigcontext {
	int	sc_onstack;		 
	int	sc_mask;		 
	int	sc_sp;			 
	int	sc_fp;			 
	int	sc_ap;			 
	int	sc_pc;			 
	int	sc_ps;			 
};

 








# 210 "/gnu/include/signal.h" 3










 
void	(*signal  (int, void (*)  (int)  )  )  (int)  ;
int	raise  (int)  ;

int	kill  (pid_t, int)  ;
int	sigaction  (int, const struct sigaction *, struct sigaction *)  ;
int	sigpending  (sigset_t *)  ;
int	sigprocmask  (int, const sigset_t *, sigset_t *)  ;
int	sigsuspend  (const sigset_t *)  ;


int	killpg  (pid_t, int)  ;
void	psignal  (unsigned, const char *)  ;
int	sigblock  (int)  ;
int	siginterrupt  (int, int)  ;
int	sigpause  (int)  ;
int	sigreturn  (struct sigcontext *)  ;
int	sigsetmask  (int)  ;
int	sigstack  (const struct sigstack *, struct sigstack *)  ;
int	sigvec  (int, struct sigvec *, struct sigvec *)  ;

 




# 3 "/gnu/include/sys/signal.h" 2 3


 





# 89 "/gnu/include/sys/param.h" 2 3


 
# 1 "/gnu/include/machine/param.h" 1 3
 









































 




 


























 





 


















 

 




 




 


 







 







 











# 156 "/gnu/include/machine/param.h" 3


# 168 "/gnu/include/machine/param.h" 3



# 92 "/gnu/include/sys/param.h" 2 3

# 1 "/gnu/include/machine/endian.h" 1 3
 


































 













 
unsigned long	htonl  (unsigned long)  ;
unsigned short	htons  (unsigned short)  ;
unsigned long	ntohl  (unsigned long)  ;
unsigned short	ntohs  (unsigned short)  ;
 

 




















# 93 "/gnu/include/sys/param.h" 2 3

# 1 "/gnu/include/machine/limits.h" 1 3
 




























































 






























# 94 "/gnu/include/sys/param.h" 2 3


 


























 






















				 



 











 











 





 






 








 

















 














# 138 "sdbm.h" 2









# 1 "/gnu/include/sys/stat.h" 1 3
 







































# 63 "/gnu/include/sys/stat.h" 3

struct	stat
{
	dev_t	st_dev;
	ino_t	st_ino;
	unsigned short st_mode;
	short	st_nlink;
	short	st_uid;
	short	st_gid;
	dev_t	st_rdev;
	off_t	st_size;
	time_t	st_atime;
	int	st_spare1;
	time_t	st_mtime;
	int	st_spare2;
	time_t	st_ctime;
	int	st_spare3;
	long	st_blksize;
	long	st_blocks;
	long	st_spare4[2];
};

















































					 


















 
mode_t	umask  (mode_t)  ;
int	chmod  (const char *, mode_t)  ;
int	fstat  (int, struct stat *)  ;
int	mkdir  (const char *, mode_t)  ;
int	mkfifo  (const char *, mode_t)  ;
int	stat  (const char *, struct stat *)  ;

int	fchmod  (int, mode_t)  ;
int	lstat  (const char *, struct stat *)  ;

 



# 147 "sdbm.h" 2










 









# 1 "/gnu/include/strings.h" 1 3
 


































# 1 "/gnu/include/string.h" 1 3
 

















































 
void	*memchr  (const void *, int, size_t)  ;
int	 memcmp  (const void *, const void *, size_t)  ;
void	*memcpy  (void *, const void *, size_t)  ;
void	*memmove  (void *, const void *, size_t)  ;
void	*memset  (void *, int, size_t)  ;
char	*strcat  (char *, const char *)  ;
char	*strchr  (const char *, int)  ;
int	 strcmp  (const char *, const char *)  ;
int	 strcoll  (const char *, const char *)  ;
char	*strcpy  (char *, const char *)  ;
size_t	 strcspn  (const char *, const char *)  ;
char	*strerror  (int)  ;
size_t	 strlen  (const char *)  ;
char	*strncat  (char *, const char *, size_t)  ;
int	 strncmp  (const char *, const char *, size_t)  ;
char	*strncpy  (char *, const char *, size_t)  ;
char	*strpbrk  (const char *, const char *)  ;
char	*strrchr  (const char *, int)  ;
size_t	 strspn  (const char *, const char *)  ;
char	*strstr  (const char *, const char *)  ;
char	*strtok  (char *, const char *)  ;
size_t	 strxfrm  (char *, const char *, size_t)  ;

 

int	 bcmp  (const void *, const void *, size_t)  ;
void	 bcopy  (const void *, void *, size_t)  ;
void	 bzero  (void *, size_t)  ;
int	 ffs  (int)  ;
char	*index  (const char *, int)  ;
void	*memccpy  (void *, const void *, int, size_t)  ;
char	*rindex  (const char *, int)  ;
int	 strcasecmp  (const char *, const char *)  ;
char	*strdup  (const char *)  ;
void	 strmode  (int, char *)  ;
int	 strncasecmp  (const char *, const char *, size_t)  ;
char	*strsep  (char **, const char *)  ;
void	 swab  (const void *, void *, size_t)  ;
int	 stricmp  (const char *, const char *)  ;
int	 strnicmp  (const char *, const char *, size_t)  ;

 


# 36 "/gnu/include/strings.h" 2 3

# 167 "sdbm.h" 2
























































 











# 4 "dbu.c" 2










extern int	getopt();
extern char	*strchr();
extern void	oops();

char *progname;

static int rflag;
static char *usage = "%s [-R] cat | look |... dbmname";












typedef struct {
	char *sname;
	int scode;
	int flags;
} cmd;

static cmd cmds[] = {

	"fetch", 1 , 	0x0000 ,
	"get", 1 ,		0x0000 ,
	"look", 1 ,		0x0000 ,
	"add", 2 ,		0x0002 ,
	"insert", 2 ,	0x0002 ,
	"store", 2 ,	0x0002 ,
	"delete", 3 ,	0x0002 ,
	"remove", 3 ,	0x0002 ,
	"dump", 4 ,		0x0000 ,
	"list", 4 , 		0x0000 ,
	"cat", 4 ,		0x0000 ,
	"creat", 7 ,	0x0002  | 0x0200  | 0x0400 ,
	"new", 7 ,		0x0002  | 0x0200  | 0x0400 ,
	"build", 5 ,	0x0002  | 0x0200 ,
	"squash", 6 ,	0x0002 ,
	"compact", 6 ,	0x0002 ,
	"compress", 6 ,	0x0002 
};



static cmd *parse();
static void badk(), doit(), prdatum();

int
main(argc, argv)
int	argc;
char *argv[];
{
	int c;
	register cmd *act;
	extern int optind;
	extern char *optarg;

	progname = argv[0];

	while ((c = getopt(argc, argv, "R")) != (-1) )
		switch (c) {
		case 'R':	        
			rflag++;
			break;

		default:
			oops("usage: %s", usage);
			break;
		}

	if ((argc -= optind) < 2)
		oops("usage: %s", usage);

	if ((act = parse(argv[optind])) == 0 )
		badk(argv[optind]);
	optind++;
	doit(act, argv[optind]);
	return 0;
}

static void
doit(act, file)
register cmd *act;
char *file;
{
	datum key;
	datum val;
	register DBM *db;
	register char *op;
	register int n;
	char *line;





	if ((db = sdbm_open; (file, act->flags, 0644)) == 0 )
		oops("cannot open: %s", file);

	if ((line = (char *) malloc(8192 )) == 0 )
		oops("%s: cannot get memory", "line alloc");

	switch (act->scode) {

	case 1 :
		while (fgets(line, 8192 , (__sF[0]) ) != 0 ) {
			n = strlen(line) - 1;
			line[n] = 0;
			key.dptr = line;
			key.dsize = n;
			val = sdbm_fetch; (db, key);
			if (val.dptr != 0 ) {
				prdatum((__sF[1]) , val);
				__sputc(  '\n'  ,   (__sF[1])  )  ;
				continue;
			}
			prdatum((__sF[2]) , key);
			fprintf((__sF[2]) , ": not found.\n");
		}
		break;
	case 2 :
		break;
	case 3 :
		while (fgets(line, 8192 , (__sF[0]) ) != 0 ) {
			n = strlen(line) - 1;
			line[n] = 0;
			key.dptr = line;
			key.dsize = n;
			if (sdbm_delete; (db, key) == -1) {
				prdatum((__sF[2]) , key);
				fprintf((__sF[2]) , ": not found.\n");
			}
		}
		break;
	case 4 :
		for (key = sdbm_firstkey; (db); key.dptr != 0; 
		     key = sdbm_nextkey; (db)) {
			prdatum((__sF[1]) , key);
			__sputc(  '\t'  ,   (__sF[1])  )  ;
			prdatum((__sF[1]) , sdbm_fetch; (db, key));
			__sputc(  '\n'  ,   (__sF[1])  )  ;
		}
		break;
	case 5 :



		while (fgets(line, 8192 , (__sF[0]) ) != 0 ) {
			n = strlen(line) - 1;
			line[n] = 0;
			key.dptr = line;
			if ((op = strchr(line, '\t')) != 0) {
				key.dsize = op - line;
				*op++ = 0;
				val.dptr = op;
				val.dsize = line + n - op;
			}
			else
				oops("bad input; %s", line);
	
			if (sdbm_store; (db, key, val, 1 ) < 0) {
				prdatum((__sF[2]) , key);
				fprintf((__sF[2]) , ": ");
				oops("store: %s", "failed");
			}
		}



		break;
	case 6 :
		break;
	case 7 :
		break;
	}

	sdbm_close; (db);
}

static void
badk(word)
char *word;
{
	register int i;

	if (progname)
		fprintf((__sF[2]) , "%s: ", progname);
	fprintf((__sF[2]) , "bad keywd %s. use one of\n", word);
	for (i = 0; i < (int)(sizeof (cmds)/sizeof (cmd)) ; i++)
		fprintf((__sF[2]) , "%-8s%c", cmds[i].sname,
			((i + 1) % 6 == 0) ? '\n' : ' ');
	fprintf((__sF[2]) , "\n");
	exit(1);
	 
}

static cmd *
parse(str)
register char *str;
{
	register int i = (sizeof (cmds)/sizeof (cmd)) ;
	register cmd *p;
	
	for (p = cmds; i--; p++)
		if (strcmp(p->sname, str) == 0)
			return p;
	return 0 ;
}

static void
prdatum(stream, d)
FILE *stream;
datum d;
{
	register int c;
	register char *p = d.dptr;
	register int n = d.dsize;

	while (n--) {
		c = *p++ & 0377;
		if (c & 0200) {
			fprintf(stream, "M-");
			c &= 0177;
		}
		if (c == 0177 || c < ' ') 
			fprintf(stream, "^%c", (c == 0177) ? '?' : c + '@');
		else
			__sputc( c ,   stream ) ;
	}
}


