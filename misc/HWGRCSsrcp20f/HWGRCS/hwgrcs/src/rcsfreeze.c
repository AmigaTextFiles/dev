/*------------------------------------------------------------------------*/
/*                                                                        *
 *  $Id: rcsfreeze.c 1.2 1996/03/25 06:23:48 heinz Exp $
 *                                                                        */
/*------------------------------------------------------------------------*/

/*------------------------------------------------------------------------*/
/*
    This is a SAS/C 6.x replacement for my AmigaOS shell script rcsfreeze.

    It should work a lot better for branches. Hopefully it won't freeze the
    branch number anymore, but the highest revision number on that branch
    as it should have done in the first place.

    It is a hack and duplicates the shell script functionality just about
    1:1. I needed it in C to make parsing of the revision number
    possible! This program uses the fact that "rlog -b" gives us the
    revision entry we want. To be sure that we don't read a fake revision
    line in the file description that just happens to be suitable, we check
    for the "----[...]" line first, that comes before every revision entry.

    There is one thing though, that is pretty nasty. We need to make a list
    of all the filenames first, because if we process the files while
    reading through the directory, the MatchXX() routines will loose track
    of the current position.

    One new addition. You may specify a date as second argument.
    This date will be passed to rlog via "-d" and makes it possible
    to correctly freeze a certain set of files later as long as
    the freeze date is known. This is intended for easier reviving
    of totally messed up sources.

    No startup code!

    sc $* nostkchk optimize link nostartup strmerge


*/

/*------------------------------------------------------------------------*/
#ifndef USE_BUILTIN_MATH
#define USE_BUILTIN_MATH
#endif

#ifndef __USE_SYSBASE
#define __USE_SYSBASE
#endif

/*------------------------------------------------------------------------*/
/*------------------------------------------------------------------------*/
#include "conf.h"
#undef VOID
#define VOID void

#include <dos.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <proto/dos.h>
#include <proto/exec.h>

/*------------------------------------------------------------------------*/
#define VERSIONFILE ".rcsfreeze.ver"
#define LOGFILE     ".rcsfreeze.log"

struct FileList
{
    struct FileList *Next;
    UBYTE           Name[0];
    /* Here follows the name! */
};

/*------------------------------------------------------------------------*/
static void SPrintf(struct Library *SysBase, STRPTR buf, STRPTR format, ...);
static LONG freeze_revs(struct Library *SysBase,
                        struct Library *DOSBase,
                        STRPTR symrevname,
                        STRPTR freezedate,
                        BPTR rcsdir);

/*------------------------------------------------------------------------*/
#define PRGVER "\0$" "VER: "PRGPREFIX "rcsfreeze " PRGVERSION "." PRGREVISION " (" PRGDATE ")" PRGVERTEXT

/*------------------------------------------------------------------------*/
#define TEMPLATE    "SYMREV,DATE" PRGVER

/*------------------------------------------------------------------------*/
int main(int argc, char **argv)
{
    struct Library *SysBase = *((struct Library **)4);
    struct Library *DOSBase = OpenLibrary("dos.library", 37);

    if(DOSBase)
    {
        BPTR olddir = CurrentDir(NULL);
        BPTR rcsdir, fh;
        UBYTE buf[BUFSIZ], symrevbuf[BUFSIZ];
        STRPTR symrevname;
        STRPTR freezedate;
        LONG versionnumber;
        struct RDArgs *rd;
        UBYTE datebuf[3][20];
        LONG error = 0;
        STRPTR args[2];

        /* Just to get the version string into the code segment ... */
        strcpy(buf, PRGVER);

        /* First we duplicate the currentdir. So we can restore it later */
        CurrentDir(DupLock(olddir));

        /* "No strings" is default */
        args[0] = NULL;
        args[1] = NULL;

        if(rd = ReadArgs(TEMPLATE, (LONG *)args, NULL))
        {
            BPTR curdir;

            /* Do we have an RCS_link around? */
            buf[0] = 0;
            fh = Open("RCS_link", MODE_OLDFILE);
            if(fh)
            {
                LONG len;

                /* What's in the link? */
                if(!FGets(fh, buf, BUFSIZ - 1))
                {
                    buf[0] = 0;
                } /* if */

                len = strlen(buf);
                if(len && buf[len - 1] == '\n')
                {
                    buf[--len] = 0;
                } /* if */

                Close(fh);
            } /* if */

            if(!buf[0])
            {
                strcpy(buf, "RCS");
            } /* if */

            /* Too lazy to check for a dirname. We just try it. */
            rcsdir = Lock(buf, ACCESS_READ);

            if(rcsdir)
            {
                curdir = CurrentDir(rcsdir);
            } /* if */

            /* Create the version and revision files if necessary */
            fh = Open(VERSIONFILE, MODE_OLDFILE);
            if(!fh)
            {
                fh = Open(VERSIONFILE, MODE_NEWFILE);
                if(fh)
                {
                    FPuts(fh, "0\n");
                    Close(fh);
                } /* if */

                fh = Open(LOGFILE, MODE_NEWFILE);
                if(fh)
                {
                    Close(fh);
                } /* if */

                fh = Open(VERSIONFILE, MODE_OLDFILE);
            } /* if */

            /* Lets advance the version number! */
            versionnumber = 1;
            if(fh)
            {
                if(!FGets(fh, buf, BUFSIZ - 1))
                {
                    buf[0] = 0;
                } /* if */

                StrToLong(buf, &versionnumber);
                versionnumber++;

                Close(fh);

                fh = Open(VERSIONFILE, MODE_NEWFILE);
                if(fh)
                {
                    FPrintf(fh, "%ld\n", versionnumber);

                    Close(fh);
                }
                else
                {
                    error = IoErr();
                } /* if */
            }
            else
            {
                error = IoErr();
            } /* if */

            if(!error)
            {
                SPrintf(SysBase, symrevbuf, "C_%ld", versionnumber);
                symrevname = (args[0]) ? args[0] : symrevbuf;
                freezedate = args[1];

                Printf("rcsfreeze: symbolic revision number computed: '%s'\n", symrevbuf);
                Printf("           symbolic revision number used:     '%s'\n", symrevname);
                if(args[1])
                {
                    Printf("\nFreezing each revision at or before date '%s'\n", args[1]);
                } /* if */

                PutStr("\n  The two differ only when rcsfreeze was invoked with an argument.\n\n");
                PutStr("Give a log message, summarizing changes (end with EOF, CTRL-\\, or single '.')\n");

                /* We need the date for the freeze */
                {
                    struct DateTime dt;

                    DateStamp(&dt.dat_Stamp);
                    dt.dat_Format  = FORMAT_DOS; /* Compatibility to the old script */
                    dt.dat_Flags   = 0;
                    dt.dat_StrDay  = datebuf[0];
                    dt.dat_StrDate = datebuf[1];
                    dt.dat_StrTime = datebuf[2];

                    DateToStr(&dt);
                }

                /* Let us append the revision freeze text */
                fh = Open(LOGFILE, MODE_OLDFILE);
                if(fh)
                {
                    Seek(fh, 0, OFFSET_END);

                    FPrintf(fh, "\nVersion: %s(%s), Date: %s %s %s\n\n",
                            symrevname, symrevbuf,
                            datebuf[0],
                            datebuf[1],
                            datebuf[2]);

                    while(FGets(Input(), buf, BUFSIZ - 1))
                    {
                        if(buf[0] == '.' && (!buf[1] || buf[1] == '\n'))
                        {
                            break;
                        } /* if */

                        FPuts(fh, buf);
                    } /* while */

                    Close(fh);
                }
                else
                {
                    error = IoErr();
                } /* if */

            } /* if */

            if(rcsdir)
            {
                CurrentDir(curdir);
            } /* if */

            if(!error)
            {
                error = freeze_revs(SysBase, DOSBase, symrevname, freezedate, rcsdir);
            } /* if */

            UnLock(rcsdir);

            FreeArgs(rd);
        }
        else
        {
            error = IoErr();
        } /* if */

        UnLock(CurrentDir(olddir));

        if(error)
        {
            PrintFault(error, NULL);
        } /* if */

        CloseLibrary(DOSBase);
    } /* if */

    return(0);


} /* main */

/*------------------------------------------------------------------------*/
static void SPutC(void)
{
    __emit(0x16c0);     /* MOVE.B d0,(a3)+ */

} /* SPutC */

/*------------------------------------------------------------------------*/
static void SPrintf(struct Library *SysBase, STRPTR buf, STRPTR format, ...)
{
    RawDoFmt(format, (APTR) ((&format)+1), SPutC, buf);

} /* SPrintf */

/*------------------------------------------------------------------------*/
static STRPTR MYmktemp(struct Library *SysBase, struct Library *DOSBase, STRPTR template)
{
    STRPTR cp;
    ULONG val;
    BPTR lock;

    cp = template;
    cp += strlen(cp);
    for (val = (ULONG) FindTask(NULL) ; ; )
    {
        if (*--cp == 'X')
        {
            *cp = (val & 0x0f) + '0';
            if(*cp > '9')
            {
                *cp += 7;
            } /* if */
            val >>= 4;
        }
        else if (*cp != '.')
        {
            break;
        } /* if */
    } /* for */

    if (*++cp != 0)
    {
        *cp = 'A';
        while (lock = Lock(template, ACCESS_READ))
        {
            UnLock(lock);

            if (*cp == 'Z')
            {
                *template = 0;
                break;
            } /* if */
            ++*cp;
        } /* while */
    }
    else
    {
        if (lock = Lock(template, ACCESS_READ))
        {
            UnLock(lock);
            *template = 0;
        } /* if */
    } /* if */

    return template;

} /* MYmktemp */

/*------------------------------------------------------------------------*/
static struct FileList *GetFileList(struct Library *SysBase,
                                    struct Library *DOSBase,
                                    LONG *errorp)
{
    struct AnchorPath __aligned ap;
    LONG error;
    struct FileList *head = NULL;

    memset(&ap, 0, sizeof(ap));

    ap.ap_BreakBits = SIGBREAKF_CTRL_C;

    error = MatchFirst("#?", &ap);
    if(!error)
    {
        for(; !error; error = MatchNext(&ap))
        {
            LONG len;
            struct FileList *fl;

            /* We ignore directories or the log files for rcsfreeze */
            if(ap.ap_Info.fib_DirEntryType >= 0 ||
               stricmp(ap.ap_Info.fib_FileName, VERSIONFILE) == 0 ||
               stricmp(ap.ap_Info.fib_FileName, LOGFILE) == 0)
            {
                continue;
            } /* if */

            len = strlen(ap.ap_Info.fib_FileName);
            fl  = AllocVec(sizeof(*fl) + len + 1, MEMF_ANY);

            if(fl)
            {
                fl->Next = head;
                strcpy(fl->Name, ap.ap_Info.fib_FileName);

                head = fl;
            }
            else
            {
                error = ERROR_NO_FREE_STORE;
                break;
            } /* if */
        } /* for */
        MatchEnd(&ap);
    } /* if */

    if(error == ERROR_NO_MORE_ENTRIES)
    {
        error = 0;
    } /* if */

    *errorp = error;

    return(head);

} /* GetFileList */

/*------------------------------------------------------------------------*/
static void FreeFileList(struct Library *SysBase, struct FileList *fl)
{
    struct FileList *flnext;

    for(; fl; fl = flnext)
    {
        flnext = fl->Next;

        FreeVec(fl);
    } /* for */

} /* FreeFileList */

/*------------------------------------------------------------------------*/
static LONG freeze_revs(struct Library *SysBase,
                        struct Library *DOSBase,
                        STRPTR symrevname,
                        STRPTR freezedate,
                        BPTR rcsdir)
{
    LONG error;
    UBYTE buf[BUFSIZ];
    struct FileList *head, *fl;
    BPTR olddir;

    if(rcsdir)
    {
        olddir = CurrentDir(rcsdir);
    } /* if */
    head = GetFileList(SysBase, DOSBase, &error);
    if(rcsdir)
    {
        CurrentDir(olddir);
    } /* if */

    if(!error)
    {
        for(fl = head; !error && fl; fl = fl->Next)
        {
            BPTR fh;
            char tmpbuf[40],cmdbuf[BUFSIZ];

            strcpy(tmpbuf, "PIPE:rcsfreezeXXXXXXXX");
            if(MYmktemp(SysBase, DOSBase, tmpbuf))
            {
#ifdef ASYNC
                BPTR nilfh1, nilfh2;
#endif /* ASYNC */

                strcat(tmpbuf, "//0");
                SPrintf(SysBase, cmdbuf, "rlog >%s -b %s%s%s \"%s\"\n",
                        tmpbuf,
                        (freezedate) ? "\"-d" : "",
                        (freezedate) ? freezedate : (STRPTR)"",
                        (freezedate) ? "\"" : "",
                        fl->Name);

#ifdef ASYNC
                nilfh1 = Open("NIL:", MODE_OLDFILE);
                nilfh2 = Open("NIL:", MODE_NEWFILE);
#endif /* ASYNC */

                if(!(error = SystemTags(cmdbuf,
                                        SYS_UserShell, TRUE,
#ifdef ASYNC
                                        SYS_Asynch,  TRUE,
                                        SYS_Input,  nilfh1,
                                        SYS_Output, nilfh2,
#endif /* ASYNC */
                                        TAG_END)))
                {
                    fh = Open(tmpbuf, MODE_OLDFILE);
                    if(fh)
                    {
                        while(FGets(fh, buf, BUFSIZ - 1) && !error)
                        {
                            if(strlen(buf) > 10 && !memcmp(buf, "----------", 10))
                            {
                                if(FGets(fh, buf, BUFSIZ - 1))
                                {
                                    if(strlen(buf) > 10 &&
                                       !memcmp(buf, "revision ", 9))
                                    {
                                        /* This is the version number we are
                                           looking for!! */
                                        STRPTR version = &buf[9];
                                        ULONG len = strlen(version);

                                        if(version[len - 1] == '\n')
                                        {
                                            version[--len] = 0;

                                        } /* if */

                                        if(len > 2)
                                        {
                                            Printf("rcsfreeze: '%s' %s\n",
                                                   version, fl->Name);

                                            SPrintf(SysBase, cmdbuf, "rcs -q \"-n%s:%s\" \"%s\"\n",
                                                    symrevname,
                                                    version,
                                                    fl->Name);
                                            error = SystemTags(cmdbuf,
                                                               SYS_UserShell, TRUE,
                                                               TAG_END);
                                        } /* if */
                                        break;
                                    } /* if */
                                } /* if */
                            } /* if */
                        } /* while */

                        Close(fh);
                    }
                    else
                    {
                        error = ERROR_OBJECT_NOT_FOUND;
                    } /* if */
                }
                else
                {
                    /* We ignore log errors */
                    Printf("rcsfreeze: rlog failed on %s, file ignored.\n", fl->Name);
                    error = 0;
                } /* if */
            }
            else
            {
                error = ERROR_BAD_TEMPLATE;
            } /* if */

            if(error)
            {
                break;
            } /* if */
        } /* for */
    } /* if */

    FreeFileList(SysBase, head);

    return(error);

} /* freeze_revs */

/*------------------------------------------------------------------------*/

/* Ende des Quelltextes */

