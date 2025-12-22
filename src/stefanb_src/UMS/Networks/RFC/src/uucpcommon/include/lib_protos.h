
/* MACHINE GENERATED */


/* getpwnam.c           */

Prototype struct passwd *getpwnam(const char *);

/* setstdin.c           */

Prototype int SetStdin(int, char **);

/* sleep.c              */

Prototype void sleep(int);

/* validuser.c          */

Prototype int ValidUser(const char *);

/* lsys.c               */

Prototype int is_in_L_sys_file(const char *);

/* stpchr.c             */

Prototype const char *stpchr(const char *, char);

/* mntreq.c             */

Prototype void mountrequest(int);

/* security.c           */

Prototype int SecurityDisallow(char *, int);
Prototype int SameLock(long, long);

/* log.c                */

Prototype void ulog(int, const char *, ...);
Prototype void OpenLog();
Prototype void CLoseLog();

/* lockfile.c           */

Prototype void LockFile(const char *);
Prototype void UnLockFile(const char *);
Prototype void UnLockFiles(void);
Prototype int FileIsLocked(const char *);

/* tmpfile.c            */

Prototype char *TmpFileName(const char *);

/* seq.c                */

Prototype int GetSequence(int);

/* getenv.c             */

Prototype char *gettmpenv(const char *);
Prototype char *getenv(const char *);

/* waitmsg.c            */

Prototype void WaitMsg(struct Message *);

/* config.c             */

Prototype char *FindLocalVariable(const char *);
Prototype char *FindConfig(const char *);
Prototype char *GetConfig(const char *, char *);
Prototype char *GetConfigDir(char *);
Prototype char *GetConfigProgram(char *);
Prototype char *MakeConfigPath(const char *, const char *);
Prototype char *MakeConfigPathBuf(char *, const char *, const char *);
Prototype FILE *openlib(const char *);
Prototype FILE *openlib_write(const char *);

/* alias.c              */

Prototype void LoadAliases(void);
Prototype int  UserAliasList(const char *, int (*)(const char *, long, int), long, int);
Prototype int  AliasExists(const char *);

/* string.c             */

Prototype int strcmpi(const char *, const char *);
Prototype int strncmpi(const char *, const char *, int);

/* getfiles.c           */

Prototype dir_list *getfiles(const char *, int, int (*)(char *), int (*)(dir_list *, dir_list *));

/* ndir.c               */

Prototype struct DIR *opendir(const char *);
Prototype int rewinddir(struct DIR *);
Prototype struct direct *readdir(struct DIR *);
Prototype int closedir(struct DIR *);

/* list_sort.c          */


/* qsort.c              */


/* strtokp.c            */

Prototype char *strtokp(char **, char *);

/* expand_path.c        */

Prototype char *expand_path(const char *, const char *);

/* isdir.c              */

Prototype int IsDir(const char *);

/* getuser.c            */

Prototype char *GetUserName(void);
Prototype char *GetRealName(void);

/* uncomp.c             */

Prototype int uncompress_to_file(FILE *, char *);
Prototype int uncompress_to_fp(FILE *, FILE *);

/* header.c             */

Prototype int ScanHeader(const char *, const char *);
Prototype char *GetHeader(const char *, const char *);
Prototype char *DupHeader(const char *, const char *);
Prototype char *ScanNext(void);

/* date.c               */

Prototype char *atime(time_t *);

/* comp.c               */

Prototype int compress_from_file(char *, FILE *, short);
Prototype int compress_from_fp(FILE *, FILE *, short);

/* namemunge.c          */

Prototype void mungecase_fiename(char *, char *);

/* seqname.c            */

Prototype char *SeqToName(long);

/* heirarchy.c          */

Prototype char *HandleHeirarchy (const char *, const char *, const int);

/* unix_comp.c          */

Prototype int unix_compress_from_file(char *, FILE *, short);
Prototype int unix_compress_from_fp(FILE *, FILE *, short);
Prototype int unix_uncompress_to_file(FILE *, char *, short *);
Prototype int unix_uncompress_to_fp(FILE *, FILE *, short *);

/* gethead.a            */


/* gettail.a            */


/* getpred.a            */

