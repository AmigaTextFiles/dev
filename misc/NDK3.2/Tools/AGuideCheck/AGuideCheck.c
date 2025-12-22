;/*
sc AGuideCheck.c LINK NOSTACKCHECK UNSIGNEDCHARS NOICONS DATA=FAR
quit
*/

/*************************************************
 ** AGuideCheck                                 **
 **---------------------------------------------**
 ** Finde alle ungültigen Links in einer        **
 ** AGuide-Datei                                **
 *************************************************/

/// Includes
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/lists.h>
#include <dos/dos.h>
#include <dos/dosasl.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/locale.h>
#include <clib/alib_protos.h>

#include <stdio.h>
#include <string.h>
#include <stdarg.h>

/// Defines
#define TEMPLATE "FROM/A,INDEX,FMTCHECK/S,ALL/S"

#define ARG_FROM        0
#define ARG_INDEX       1
#define ARG_FMTCHECK    2
#define ARG_ALL         3
#define ARG_LEN         4

#define BUFSIZE      8192 // maximum length of each line

/// Strukturen
struct GuideNode {
        struct GuideNode       *gn_succ;
        struct GuideNode       *gn_pred;
        char                   *gn_name;
        char                   *gn_title;
        char                   *gn_file;
        char                   *gn_origin;
        ULONG                   gn_line;
        BOOL                    gn_done;
};
///
/// Statics
char version[]="$VER: AGuideCheck 3.0 (11.5.2020)\0";
struct Library *UtilityBase;
IMPORT struct ExecBase* SysBase;
struct Locale *locale;
ULONG lineno;
int innode;
int isbreak;
int wordwrap;
int incode;
int fmttrouble;
int fmtcheck;
int isguide;
struct List nodelist,reflist,filelist;
char linebuf[BUFSIZE];
char tempbuf[BUFSIZE];
__aligned struct AnchorPath ap;
///
/// Prototypen
int __saveds main(void);
int ParseGuide(char *file, FILE* fh);
void FreeList(struct List *list);
struct GuideNode *AllocGuideNode(char *name,char *title,char *file,char *origin,ULONG line);
void PassError(char *text);
int ParseNode(char *node);
int CheckAttribute(char *attr,char *file);
int CheckCommand(char *file,char *cmd);
int ParseLine(char *in,char *out);
int CheckNodes(void);
int CheckReferences(void);
int AddToList(char *cmd,char *file,struct List *list,BOOL unique);
int WriteIndex(FILE* fh,char *base,struct List *list);
int FPrintF(FILE* fh,char *format,...);
void SortList(struct List *list);
struct GuideNode *MergeSort(struct GuideNode *gn,ULONG count);
BOOL CheckBreak(void);
int ParseFile(char *file);
struct GuideNode *FindNameInFile(struct List *list,char *name,char *file);
int RecursiveParse(void);
int CollectExternals(void);
int CheckFile(BPTR lock,char *name,char *index);
///

/// main
int __saveds main(void)
{
LONG args[ARG_LEN];
struct RDArgs *rd;
int res=25;


        SysBase=*((struct ExecBase **)4L);
        memset(args,0,sizeof(args));

        lineno=0;
        NewList(&nodelist);
        NewList(&reflist);
        NewList(&filelist);

        if (DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",37L)) {
                if (UtilityBase=OpenLibrary("utility.library",37L)) {
                        if (LocaleBase = (struct LocaleBase*) OpenLibrary("locale.library", 38L)) {
                                /* According to autodocs, this is always valid. */
                                locale=OpenLocale(NULL);
                                if (rd=ReadArgs(TEMPLATE,args,NULL)) {
                                        BOOL found;

                                        fmtcheck=args[ARG_FMTCHECK];

                                        found   = FALSE;        /* No file matched yet... */

                                        ap.ap_BreakBits      = SIGBREAKF_CTRL_C;
                                        ap.ap_Strlen         = 0;
                                        ap.ap_Flags          = (UBYTE)APF_FollowHLinks;

                                        /* initialize the pattern matching */

                                        res = MatchFirst((char *)args[ARG_FROM],&ap);

                                        for(;;) {
                                                if (res) break;

                                                if (ap.ap_Flags & APF_DIDDIR) {

                                                        /* leave a directory */
                                                        ap.ap_Flags &= ~APF_DIDDIR;
                                                } else if (ap.ap_Info.fib_DirEntryType >= 0 &&
                                                           ap.ap_Info.fib_DirEntryType != ST_SOFTLINK) {

                                                        /* enter a directory if ALL keyword set.
                                                         * On verbosity, print the directory name
                                                         * and print the indention.
                                                         */

                                                        if (args[ARG_ALL]) {
                                                           ap.ap_Flags |= APF_DODIR;
                                                        }
                                                } else {
                                                        /* Found a file. Hence handle it.
                                                         */

                                                        res = CheckFile(ap.ap_Current->an_Lock,ap.ap_Info.fib_FileName,(char *)args[ARG_INDEX]);
                                                        found = TRUE;
                                                }

                                                if (res) break;

                                                /* and now for the next file... */

                                                res = MatchNext(&ap);
                                        }

                                        if (res == ERROR_NO_MORE_ENTRIES)
                                                res = 0;

                                        /* Not a single file matched? -> generate an error. */

                                        if (found == FALSE)
                                                res = ERROR_OBJECT_NOT_FOUND;

                                        MatchEnd(&ap);


                                        if (res>64) {
                                                PrintFault(IoErr(),"AGuideCheck failed");
                                                res=20;
                                        }

                                        FreeArgs(rd);

                                } else  PrintFault(IoErr(),"AGuideCheck failed");
                                CloseLocale(locale);
                                CloseLibrary((struct Library*) LocaleBase);
                        } else Printf("AGuideCheck: locale.library V38 required.\n");
                        CloseLibrary(UtilityBase);
                } else Printf("AGuideCheck: utility.library required.\n");
                CloseLibrary((struct Library *)DOSBase);
        }

        return res;
}
///
/// CheckFile
int CheckFile(BPTR lock,char *name,char *index)
{
BPTR oldlock;
int res,res2;
struct GuideNode        *gn;

        oldlock = CurrentDir(lock);

        res  = 20;
        res2 = 0;

        if (gn = AllocGuideNode("MAIN",NULL,name,name,0)) {

                AddTail(&filelist,(struct Node *)gn);

                res = RecursiveParse();

                if (!CheckBreak()) {

                        res2=CheckNodes();
                        if (res2>res)
                                res=res2;

                        res2=CheckReferences();
                        if (res2>res)
                                res=res2;

                        if (res==0 && index) {
                                FILE* fh;

                                SortList(&nodelist);

                                if (fh=fopen(index, "wb")) {
                                        res2=WriteIndex(fh,name,&nodelist);
                                        fclose(fh);
                                } else {
                                        res2=10;
                                        PrintFault(IoErr(),"AGuideCheck failed");
                                }

                                if (res2>res)
                                        res=res2;
                        }
                } else res=ERROR_BREAK;

                FreeList(&nodelist);
                FreeList(&reflist);
                FreeList(&filelist);
        }

        CurrentDir(oldlock);

        return res;
}
///
/// FreeList
void FreeList(struct List *list)
{
struct GuideNode *gn;

        while(gn=(struct GuideNode *)RemHead(list)) {
                FreeVec(gn);
        }
}
///
/// AllocGuideNode
struct GuideNode *AllocGuideNode(char *name,char *title,char *file,char *origin,ULONG line)
{
struct GuideNode *gn;
ULONG len;


        len=sizeof(struct GuideNode)+strlen(name)+1;
        if (title)
                len += strlen(title)+1;

        if (file)
                len += strlen(file)+1;

        if (origin)
                len += strlen(origin)+1;

        if (gn=(struct GuideNode *)AllocVec(len,MEMF_PUBLIC)) {
                gn->gn_done=FALSE;
                gn->gn_name=(char *)(gn+1);
                strcpy(gn->gn_name,name);
                name=gn->gn_name;

                while(*name) {
                        *name = ToUpper((ULONG)(*name));
                        name++;
                }

                gn->gn_line=line;

                if (title) {
                        gn->gn_title = name+1;
                        name = stpcpy(gn->gn_title,title);
                } else {
                        gn->gn_title=NULL;
                }

                if (file) {
                        gn->gn_file = ++name;
                        stpcpy(gn->gn_file,file);
                        while(*name) {
                                *name = ToUpper((ULONG)(*name));
                                name++;
                        }
                } else {
                        gn->gn_file = NULL;
                }

                if (origin) {
                        gn->gn_origin = ++name;
                        stpcpy(gn->gn_origin,origin);
                        while(*name) {
                                *name = ToUpper((ULONG)(*name));
                                name++;
                        }
                } else {
                        gn->gn_origin = NULL;
                }


                return gn;
        }

        PrintFault(ERROR_NO_FREE_STORE,"AGuideCheck");
        return NULL;
}
///
/// FindNameInFile
struct GuideNode *FindNameInFile(struct List *list,char *name,char *file)
{
struct GuideNode *node;

        for(node = (struct GuideNode *)list->lh_Head; node->gn_succ ; node = node->gn_succ) {
                if (!strcmp(name,node->gn_name)) {
                        if (file) {
                                if (!strcmp(file,node->gn_file)) {
                                        return node;
                                }
                        } else {
                                return node;
                        }
                }
        }

        return NULL;
}
///

/// RecursiveParse
int RecursiveParse(void)
{
struct GuideNode *gn;
int res,res2;

        res2 = 0;

        for(gn = (struct GuideNode *)filelist.lh_Head;gn->gn_succ;gn = gn->gn_succ) {

                if (!gn->gn_done) {

                        if (CheckBreak())
                                return 0;

                        res = ParseFile(gn->gn_file);


                        if (res>res2)
                                res2=res;

                        gn->gn_done = TRUE;
                }
        }

        return res2;
}
///
/// ParseFile
int ParseFile(char *file)
{
struct GuideNode *gn;
FILE* fh;
int res=10,res2;

        Printf("Now checking %s...\n",file);

        if (fh=fopen(file, "rb")) {
                if (gn=AllocGuideNode("MAIN",NULL,file,file,0)) {
                        AddTail(&reflist,(struct Node *)gn);

                        lineno = 0;
                        innode = 0;
                        wordwrap = 0;
                        incode = 0;
                        isguide = 0;

                        res=ParseGuide(file,fh);

                        fclose(fh);

                        if (!CheckBreak()) {
                                res2 = CollectExternals();

                                if (res2>res)
                                        res=res2;
                        }
                }
        } else  PrintFault(IoErr(),"AGuideCheck");

        return res;
}
///

/// CheckBreak
BOOL CheckBreak(void)
{

        if (isbreak)
                return TRUE;

        if (CheckSignal(SIGBREAKF_CTRL_C)) {
                isbreak=TRUE;
                return TRUE;
        }

        return FALSE;
}
///
/// PassError
void PassError(char *text)
{
        Printf("Problem found at line %ld: %s.\n%s\n\n",
                lineno,text,linebuf);
}
///
/// ParseGuide
int ParseGuide(char *file,FILE* fh)
{
int len=0;
char *ptr;
int res=0,res2;
int behindcmd,inline;
int stringonline;


        for(;;) {
                if (CheckBreak()) {
                        PrintFault(ERROR_BREAK,"AGuideCheck");
                        return 0;
                }
                len = 0;
		for (;;)
		{	if (len == BUFSIZE)
			{	Printf("Line too long; aborting.\n");
				goto DONE;
			}
			if (fread(&linebuf[len], 1, 1, fh) != 1)
			{	linebuf[len] = '\0';
				break;
			}
			if (linebuf[len] == '\n')
				break;
			len++;
                }
		if (!linebuf[0])
			goto DONE;

		lineno++;

		len++;
                linebuf[len]=0;

                if (lineno==1 && Strnicmp(linebuf,"@DATABASE",(long)strlen("@DATABASE"))) {
                        Printf("%s doesn't seem to be an AmigaGuide file, ignored.\n",file);
                        return AddToList("MAIN Main",file,&nodelist,TRUE);
                }

                res2=ParseLine(linebuf,tempbuf);
                if (res2>=10)
                        return res2;
                if (res2!=0)
                        continue;

                if (res2>res)
                        res=res2;

                if (lineno>1 && isguide == FALSE) {
                        Printf("%s doesn't seem to be an AmigaGuide file, ignored.\n",file);
                        return AddToList("MAIN Main",file,&nodelist,TRUE);
                }

                ptr=tempbuf;
                if (fmtcheck && fmttrouble && wordwrap && (!incode)) {
                        if (*ptr!=' ' && *ptr) {
                                PassError("command at end of previous line, expect formatting errors");
                                if (res<2)
                                        res=2;
                        }
                }

                behindcmd=FALSE;
                inline=TRUE;
                fmttrouble=FALSE;
                stringonline=FALSE;
                while(inline) {
                        switch (*ptr) {
                        case 0x80:
                                ptr++;

                                if (*ptr==0x81) {
                                        ptr++;
                                        if (*ptr==0x83) {
                                                stringonline=TRUE;
                                                ptr++;
                                        }
                                        res2=CheckAttribute(ptr,file);
                                        if (res2>=10)
                                                return res2;
                                        if (res2>res)
                                                res=res2;
                                        while((*ptr!=0x82) && (*ptr))
                                                ptr++;
                                        behindcmd=TRUE;
                                } else {
                                        if (ptr!=tempbuf+1) {
                                                PassError("command not at start of line");
                                                res=5;
                                        } else {
                                                res2=CheckCommand(file,ptr);
                                                if (res2>=10)
                                                        return res2;
                                                if (res2>res)
                                                        res=res2;
                                        }
                                }
                                break;
                        case 0x00:
                                inline=FALSE;
                                if (stringonline && behindcmd && wordwrap && (!incode)) {
                                        fmttrouble=TRUE;
                                }
                                break;
                        default:
                                behindcmd=FALSE;
                                /* läuft hier hinein */
                        case 0x20:
                        case 0xa0:
                                stringonline=TRUE;
                                break;
                        }
                        ptr++;
                }
        }

DONE:
        if (len<0) {
                PrintFault(IoErr(),"AGuideCheck");
                res=10;
        }
        return res;
}
///
/// ParseLine
int ParseLine(char *in,char *out)
{
int esc=0;
int quote=0;
int attr=0;
int cmd=0;
int cmdline=0;
int attrhere=0;
int stringin=0;
char me;


        for(;;in++) {

                me=*in;

                if (me==0x00 || me=='\n')
                        break;

                if (me==0x09)
                        me=0x20;

                if (me<0x20 || (me>=0x80 && me<0xa0)) {
                        PassError("found illegal character");
                        return 5;
                }

                if (esc) {
                        if (!quote || ((cmdline || attrhere) && !stringin))
                                *out++=me;
                        esc=FALSE;
                        continue;
                }

                if (me=='\\') {
                        esc=TRUE;
                        continue;
                }


                if (attr) {

                        if (quote) {
                                if (me=='\"') {
                                        quote=FALSE;
                                } else {
                                        if (attrhere) {
                                                if (me==' ')
                                                        *out++=0xa0;
                                                else    *out++=me;
                                        } else {
                                                if (!stringin) {
                                                        *out++=0x83;
                                                        stringin=TRUE;
                                                }
                                        }
                                }
                                continue;
                        }
                        switch (me) {
                                case '}':
                                        *out++=0x82;
                                        attr=FALSE;
                                        attrhere=FALSE;
                                        cmdline=FALSE;
                                        break;
                                case '{':
                                        PassError("found attribute open within attribute");
                                        return 5;
                                        break;
                                case '\"':
                                        quote=TRUE;
                                        break;
                                default:
                                        *out++=me;
                                        attrhere=TRUE;
                                        break;
                        }
                        continue;
                }

                if (cmdline) {
                        if (me=='\"') {
                                quote=!quote;
                                continue;
                        }

                        if (quote) {
                                if (me==' ')
                                        *out++=0xa0;
                                else    *out++=me;
                                continue;
                        }

                }

                if (me=='@') {
                        if (cmd) {
                                PassError("found double @");
                                return 5;
                        }
                        cmd=TRUE;
                        cmdline=TRUE;
                        *out++=0x80;
                        continue;
                }

                if (me=='{' && cmd) {
                        *out++=0x81;
                        cmd=FALSE;
                        attr=TRUE;
                        stringin=FALSE;
                        continue;
                }

                cmd=FALSE;

                *out++=me;
        }

        if (cmd) {
                PassError("command missing after introducer");
                return 5;
        }

        if (esc) {
                PassError("found incomplete escape sequence");
                return 5;
        }

        if (quote) {
                PassError("found unterminated string");
                return 5;
        }

        if (attr) {
                PassError("found unterminated attribute");
                return 5;
        }

        *out=0;

        return 0;
}
///
/// CheckAttribute
int CheckAttribute(char *attr,char *file)
{
static char namebuf[BUFSIZE];
char *nptr;

        if (!innode) {
                PassError("found attribute outside a node");
                return 5;
        }

        nptr=namebuf;
        while(*attr==' ')
                attr++;
        while(*attr!=' ' && *attr!=0x82 && *attr)
                *nptr++=*attr++;
        *nptr=0;
        while(*attr==' ')
                attr++;
        nptr=namebuf;

        if (!Stricmp(nptr,"LINK")) {
                return AddToList(attr,file,&reflist,FALSE);
        }

        if (!Stricmp(nptr,"ALINK")) {
                PassError("found obsolete ALINK command");
                return 5;
        }
        if (!Stricmp(nptr,"CLOSE")) {
                PassError("found obsolete CLOSE command");
                return 5;
        }
        if (!Stricmp(nptr,"QUIT")) {
                PassError("found obsolete QUIT command");
                return 5;
        }

        if (!Stricmp(nptr,"RX")) {
                return 0;
        }
        if (!Stricmp(nptr,"RXS")) {
                return 0;
        }
        if (!Stricmp(nptr,"SYSTEM")) {
                return 0;
        }
        if (!Stricmp(nptr,"AMIGAGUIDE")) {
                return 0;
        }
        if (!Stricmp(nptr,"APEN")) {
                return 0;
        }
        if (!Stricmp(nptr,"B")) {
                return 0;
        }
        if (!Stricmp(nptr,"BG")) {
                return 0;
        }
        if (!Stricmp(nptr,"BODY")) {
                incode=FALSE;
                return 0;
        }
        if (!Stricmp(nptr,"BPEN")) {
                return 0;
        }
        if (!Stricmp(nptr,"CLEARTABS")) {
                return 0;
        }
        if (!Stricmp(nptr,"CODE")) {
                incode=TRUE;
                return 0;
        }
        if (!Stricmp(nptr,"FG")) {
                return 0;
        }
        if (!Stricmp(nptr,"I")) {
                return 0;
        }
        if (!Stricmp(nptr,"JCENTER")) {
                return 0;
        }
        if (!Stricmp(nptr,"JLEFT")) {
                return 0;
        }
        if (!Stricmp(nptr,"JRIGHT")) {
                return 0;
        }
        if (!Stricmp(nptr,"LINDENT")) {
                return 0;
        }
        if (!Stricmp(nptr,"LINE")) {
                return 0;
        }
        if (!Stricmp(nptr,"PAR")) {
                return 0;
        }
        if (!Stricmp(nptr,"PARD")) {
                return 0;
        }
        if (!Stricmp(nptr,"PARI")) {
                return 0;
        }
        if (!Stricmp(nptr,"PLAIN")) {
                return 0;
        }
        if (!Stricmp(nptr,"SETTABS")) {
                return 0;
        }
        if (!Stricmp(nptr,"TAB")) {
                return 0;
        }
        if (!Stricmp(nptr,"U")) {
                return 0;
        }
        if (!Stricmp(nptr,"UB")) {
                return 0;
        }
        if (!Stricmp(nptr,"UI")) {
                return 0;
        }
        if (!Stricmp(nptr,"UU")) {
                return 0;
        }


        PassError("found unknown attribute");
        return 5;
}
///
/// AddToList
int AddToList(char *cmd,char *file,struct List *list,BOOL unique)
{
static char namebuf[BUFSIZE];
static char titlebuf[BUFSIZE];
static char pathbuf[BUFSIZE];
char *nptr;
struct GuideNode *gn;

        nptr=namebuf;
        while(*cmd==' ')
                cmd++;
        while(*cmd!=' ' && *cmd!=0x82 && *cmd!=0)
                *nptr++=*cmd++;
        *nptr=0;

        if (nptr==namebuf) {
                PassError("name parameter missing");
                return 5;
        }

        nptr=titlebuf;
        while(*cmd==' ')
                cmd++;
        while(*cmd!=' ' && *cmd!=0x82 && *cmd!=0)
                *nptr++=*cmd++;
        *nptr=0;

        if (nptr==titlebuf)
                nptr=NULL;
        else    nptr=titlebuf;

        if (unique) {
                if (FindNameInFile(list,namebuf,file)) {
                        PassError("duplicate node found");
                        return 5;
                }
        }

        /*
         * copy the path over
         */

        strcpy(pathbuf,file);

        if (PathPart(namebuf) != namebuf) {

                *PathPart(pathbuf) = 0;         /* remove the file name */

                if (!AddPart(pathbuf,namebuf,511)) {
                        PrintFault(ERROR_LINE_TOO_LONG,"AGuideCheck");
                        return 10;
                }
                *PathPart(pathbuf) = 0;

        }

        if (gn=AllocGuideNode(FilePart(namebuf),nptr,pathbuf,file,lineno)) {
                AddTail(list,(struct Node *)gn);
                return 0;
        }

        return 10;
}
///
/// CheckCommand
int CheckCommand(char *file,char *cmd)
{
static char namebuf[BUFSIZE];
char *nptr;

        nptr=namebuf;
        while(*cmd==' ')
                cmd++;
        while(*cmd!=' ' && *cmd!=0)
                *nptr++=*cmd++;
        *nptr=0;
        while(*cmd==' ')
                cmd++;
        nptr=namebuf;

        if (!Stricmp(nptr,"NODE")) {
                if (innode==0) {
                        innode=TRUE;
                        return AddToList(cmd,file,&nodelist,TRUE);
                } else {
                        PassError("found @NODE inside a node");
                        return 5;
                }
        }
        if (!Stricmp(nptr,"ENDNODE")) {
                if (innode) {
                        innode=FALSE;
                        return 0;
                } else {
                        PassError("found @ENDNODE outside a node");
                        return 5;
                }
        }
        if (!Stricmp(nptr,"$VER:")) {
                if (innode) {
                        PassError("found @$VER inside a node");
                        return 5;
                }
                return 0;
        }
        if (!Stricmp(nptr,"(C)")) {
                if (innode) {
                        PassError("found (C) inside a node");
                        return 5;
                }
                return 0;
        }
        if (!Stricmp(nptr,"AUTHOR")) {
                if (innode) {
                        PassError("found AUTHOR inside a node");
                        return 5;
                }
                return 0;
        }
        if (!Stricmp(nptr,"DATABASE")) {
                if (innode) {
                        PassError("found DATABASE inside a node");
                        return 5;
                }
                if (lineno!=1) {
                        PassError("found DATABASE not at start of file");
                        return 5;
                }
                isguide = TRUE;
                return 0;
        }
        if (!Stricmp(nptr,"DNODE")) {
                if (innode) {
                        PassError("found DNODE inside a node");
                        return 5;
                }
                PassError("found obsolete DNODE command");
                return 2;
        }
        if (!Stricmp(nptr,"HEIGHT")) {
                if (innode) {
                        PassError("found HEIGHT inside a node");
                        return 5;
                }
                return 0;
        }
        if (!Stricmp(nptr,"MASTER")) {
                if (innode) {
                        PassError("found MASTER inside a node");
                        return 5;
                }
                return 0;
        }
        if (!Stricmp(nptr,"TAB")) {
                if (innode) {
                        PassError("found TAB inside a node");
                        return 5;
                }
                return 0;
        }
        if (!Stricmp(nptr,"WIDTH")) {
                if (innode) {
                        PassError("found WIDTH inside a node");
                        return 5;
                }
                return 0;
        }
        if (!Stricmp(nptr,"KEYWORDS")) {
                if (!innode) {
                        PassError("found KEYWORDS outside a node");
                        return 5;
                }
                return 0;
        }
        if (!Stricmp(nptr,"NEXT")) {
                if (!innode) {
                        PassError("found NEXT outside a node");
                        return 5;
                } else  return AddToList(cmd,file,&reflist,FALSE);
                return 0;
        }
        if (!Stricmp(nptr,"PREV")) {
                if (!innode) {
                        PassError("found PREV outside a node");
                        return 5;
                } else  return AddToList(cmd,file,&reflist,FALSE);
        }
        if (!Stricmp(nptr,"TOC")) {
                if (!innode) {
                        PassError("found TOC outside a node");
                        return 5;
                } else  return AddToList(cmd,file,&reflist,FALSE);
        }
        if (!Stricmp(nptr,"TITLE")) {
                if (!innode) {
                        PassError("found TITLE outside a node");
                        return 5;
                }
                return 0;
        }

        if (!Stricmp(nptr,"FONT")) {
                return 0;
        }
        if (!Stricmp(nptr,"HELP")) {
                return AddToList(cmd,file,&reflist,FALSE);
        }
        if (!Stricmp(nptr,"INDEX")) {
                return AddToList(cmd,file,&reflist,FALSE);
        }
        if (!Stricmp(nptr,"MACRO")) {
                return 0;
        }
        if (!Stricmp(nptr,"ONCLOSE")) {
                return 0;
        }
        if (!Stricmp(nptr,"ONOPEN")) {
                return 0;
        }
        if (!Stricmp(nptr,"REM")) {
                return 0;
        }
        if (!Stricmp(nptr,"REMARK")) {
                return 0;
        }
        if (!Stricmp(nptr,"SMARTWRAP")) {
                wordwrap=TRUE;
                return 0;
        }
        if (!Stricmp(nptr,"WORDWRAP")) {
                wordwrap=FALSE;
                return 0;
        }

        PassError("found unknown command");
        return 5;
}
///

/// CheckNodes
int CheckNodes(void)
{
struct GuideNode *gn;
int res=0;


        for(gn=(struct GuideNode *)reflist.lh_Head;gn->gn_succ;gn=gn->gn_succ) {
                if (!FindNameInFile(&nodelist,gn->gn_name,gn->gn_file)) {
                        Printf("Undefined node %s/%s referenced at line %ld of %s.\n",gn->gn_file,gn->gn_name,gn->gn_line,gn->gn_origin);
                        res=7;

                        if (CheckBreak())
                                return res;
                }
        }

        return res;
}
///
/// CheckReferences
int CheckReferences(void)
{
struct GuideNode *gn;
int res=0;


        for(gn=(struct GuideNode *)nodelist.lh_Head;gn->gn_succ;gn=gn->gn_succ) {
                if (!FindNameInFile(&reflist,gn->gn_name,NULL)) {
                        Printf("Node %s defined at line %ld of %s is unreferenced.\n",gn->gn_name,gn->gn_line,gn->gn_origin);
                        res=5;

                        if (CheckBreak())
                                return res;

                }
                if (gn->gn_title==NULL) {
                        Printf("Node %s defined at line %ld of %s has no title.\n",gn->gn_name,gn->gn_line,gn->gn_origin);
                        res=6;

                        if (CheckBreak())
                                return res;
                }
        }

        return res;
}
///
/// CollectExternals
int CollectExternals(void)
{
struct GuideNode *gn,*new;

        for (gn = (struct GuideNode *)reflist.lh_Head;gn->gn_succ;gn = gn->gn_succ) {
                if (!FindNameInFile(&filelist,"MAIN",gn->gn_file)) {
                        /// Printf("Found external reference to %s/%s at line %ld\n",gn->gn_file,gn->gn_name,gn->gn_line);
                        if (new = AllocGuideNode("MAIN",NULL,gn->gn_file,gn->gn_file,0)) {
                                AddTail(&filelist,(struct Node *)new);
                        } else  return 10;
                }
        }

        return 0;
}
///
///FPrintF
int FPrintF(FILE* fh,char *format,...)
{
va_list args;
static char buffer[BUFSIZE];
ULONG len;

        va_start(args,format);
        vsprintf(buffer,format,args);
        va_end(args);
        len=strlen(buffer);
        if (len != fwrite(buffer, (size_t) len, 1, fh))
                return 5;
        else    return 0;
}
///
///WriteIndex
int WriteIndex(FILE* fh,char *base,struct List *list)
{
int res=0;
struct GuideNode *gn;
char this,last=0;
char *cmpchar;

        if (res=FPrintF(fh,"@NODE INDEX \"Index\"\n@{CODE}\n"))
                return res;

        for(gn=(struct GuideNode *)(list->lh_Head);gn->gn_succ;gn=gn->gn_succ) {
                cmpchar=gn->gn_title;
                while(*cmpchar && (!IsPrint(locale,(ULONG)(*cmpchar))))
                        cmpchar++;

                if (!IsAlpha(locale,(ULONG)(*cmpchar)))
                        this=0;
                else    this=ConvToUpper(locale,(ULONG)(*cmpchar));

                if (!Stricmp(base,gn->gn_file)) {

                        if (this!=last) {
                                last=this;
                                if (this) {
                                        if (res=FPrintF(fh,"\n\t%lc...\n\n",last))
                                                break;
                                } else {
                                        if (res=FPrintF(fh,"\n\tOther...\n\n"))
                                                break;
                                }
                        }
                        if (res=FPrintF(fh,"\t@{\"%s\" link %s}\n",gn->gn_title,gn->gn_name))
                                break;
                }
        }

        if (res==0)
                res=FPrintF(fh,"\n\n@{BODY}\n@ENDNODE\n");

        return res;
}
///
///SortList
void SortList(struct List *list)
{
ULONG count;
struct GuideNode *gn;


        for(count=0,gn=(struct GuideNode *)(list->lh_Head);gn->gn_succ;gn=gn->gn_succ)
                count++;

        if (count>0)
                MergeSort((struct GuideNode *)(list->lh_Head),count);
}
///
///MergeSort
struct GuideNode *MergeSort(struct GuideNode *gn,ULONG count)
{
ULONG i,lower,upper;
struct GuideNode *on,*cn,*tn;

        if (count>1) {
                lower=count>>1;
                upper=count-lower;

                for(i=lower,on=gn;i;i--)
                        on=on->gn_succ;

                cn=MergeSort(gn,lower);         /* sort lower part */
                on=MergeSort(on,upper);         /* sort higher part */

                gn=NULL;                        /* not yet removed */
                tn=cn;                          /* compare node. */
                for(;;) {
                        if (gn==NULL) {         /* get next node from upper list? */
                                if (upper) {
                                        gn=on;
                                        on=on->gn_succ;
                                        Remove((struct Node *)gn);      /* remove from top */
                                        upper--;                        /* cound down */
                                } else  break;
                        }

                        /* still nodes left for comparison? */
                        if (lower) {
                                if (StrnCmp(locale,gn->gn_title,tn->gn_title,-1,SC_COLLATE2)<0) {
                                        /* insert gn in front of tn */
                                        gn->gn_succ=tn;
                                        gn->gn_pred=tn->gn_pred;
                                        tn->gn_pred->gn_succ=gn;
                                        tn->gn_pred=gn;
                                        if (tn==cn)
                                                cn=gn;          /* set first node */
                                        gn=NULL;                /* need next node from above */
                                } else {
                                        lower--;                 /* try next one */
                                        if (lower)
                                                tn=tn->gn_succ;
                                }
                        } else {
                                /* insert in front of tn, which is at its end now */
                                gn->gn_pred=tn;
                                gn->gn_succ=tn->gn_succ;
                                tn->gn_succ->gn_pred=gn;
                                tn->gn_succ=gn;
                                tn=gn;
                                gn=NULL;
                        }
                }

                return cn;
        } else  return gn;

}
///

