int regnum(int c);
void normglue(void);
void reverseglue(void);

#define ERROR(s) (fprintf(stderr,"%s: %s in line %d\n",progname,s,linecount),exit(20))

extern int baserel,basepar,preserve,liboffset,iflag;
extern char *precede,*precedevec,*progname;
extern char namebuf[],libbasevar[];
extern int regbuf[];
extern int regbufcnt,linecount,libbasereg;
