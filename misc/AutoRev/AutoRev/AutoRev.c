/*-- AutoRev header do NOT edit!
*
*   Program         :   AutoRev.c
*   Copyright       :   © 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   04-Apr-91
*   Current version :   1.1r
*   Translator      :   DICE
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   03-May-91     1.1r            Uses '__regargs' now. 4924 bytes!
*   14-Apr-91     1.1             Added top/bottom choice and args shortcuts
*   04-Apr-91     1.0             Initial version! Requires kickstart 2.0!
*
*-- REV_END --*/

/*
 * COMPILING:   dcc -r -mRR AutoRev.c -o AutoRev
 */
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <dos/dos.h>
#include <dos/stdio.h>
#include <string.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

#define TEMPLATE        "File/a,ASS=ASSEM/s,MOD=MODULA/s,UPD=UPDATE/s,BOT=BOTTOM/s,AUT=AUTHOR/k,COP=COPYRIGHT/k,REV=REVISION/k,COM=COMMENT/k,TRA=TRANSLATOR/k"
#define USAGE           "Usage: AutoRev <filename> [ASSEM] [MODULA] [UPDATE] [BOTTOM]\n"\
                        "                          [AUTHOR <name>] [COPYRIGHT <string>]\n"\
                        "                          [REVISION <string>] [COMMENT <string>]\n"\
                        "                          [TRANSLATOR <string>]\n\n"\
                        "With:  filename    : The name of the header you want to create/update.\n"\
                        "       ASSEM       :\n       MODULA      : The target language of the header.\n"\
                        "       UPDATE      : Update source header.\n"\
                        "       BOTTOM      : History at the bottom.\n"\
                        "       AUTHOR      : Optional author name.\n"\
                        "       COPYRIGHT   : Optional copyright string.\n"\
                        "       REVISION    : Optional revision specifier. (e.g. 1.0 or 1.1a  etc.)\n"\
                        "       COMMENT     : Optional comment string\n"\
                        "       TRANSLATOR  : Optional name and version of your compiler/assembler.\n"
#define COPYR           "\r\033[0;1;33mAutoRev v1.1r\033[0m - © 1991 Jaba Development\n"\
                        "  \033[1mWritten by Jan van den Baard.\033[0m\n"

#define PUT(m)          Write(stdout,m,strlen(m))

struct RDArgs           *RArgs = 0L;
struct RDArgs            IArgs = { 0,0,0,0,0,0,USAGE,0 };

ULONG                    size, Args[10];
BPTR                     infile = 0L, outfile = 0L, stdout;
UBYTE                    Language = 0L;   /* 0=C, 1=Assem, 2=Modula */
UBYTE                   *Name, *Mem = 0L, Revision[9];

char *lines[]  = { "*-- AutoRev header do NOT edit!\n*\n",
                   "*   Program         :   %-52.52ls\n",
                   "*   Copyright       :   %-52.52ls\n",
                   "*   Author          :   %-52.52ls\n",
                   "*   Creation Date   :   ",
                   "*   Current version :   %-7.7ls\n",
                   "*   Translator      :   %-52.52ls\n*\n",
                   "*   REVISION HISTORY\n*\n",
                   "*   Date          Version         Comment\n",
                   "*   ---------     -------         ------------------------------------------\n",
                   "*-- REV_END --*" };

extern struct Library *SysBase;

int _main( void );
__regargs void cleanup( char *, long );
void create( void );
__regargs void writecomm( BOOL );
void endheader( void );
void revline( void );
long getrev( void );
void loadold( void );
void update( void );
extern __stkargs void _exit( int );

__regargs void writecomm(BOOL how)
{
    if(!Language)
        FPutC(outfile,'/');
    else if(Language == 2) {
        if(how)
            FPutC(outfile,'(');
        else
            FPutC(outfile,')');
    }
}

void endheader(void)
{
    VFPrintf(outfile,lines[10],0);
    if(Language != 1)
        writecomm(FALSE);
    VFPrintf(outfile,"\n\n",0);
}

void dodate(void)
{
    struct DateTime  dt;
    char             date[10];

    DateStamp((struct DateStamp *)&dt);
    dt.dat_Format  = FORMAT_DOS;
    dt.dat_StrDate = &date[0];
    dt.dat_Flags   = 0;
    dt.dat_StrDay  = 0;
    dt.dat_StrTime = 0;
    DateToStr(&dt);
    VFPrintf(outfile,&date[0],0);
}

void revline(void)
{
    VFPrintf(outfile,"*   ",0);
    dodate();
    VFPrintf(outfile,"     %-7.7ls",&Args[7]);
    VFPrintf(outfile,"         %-42.42ls\n",&Args[8]);
}

long getrev(void)
{
    UBYTE   *m = Mem, *m2, i = 0;

    m2 = Mem+(size-15);

    while((strncmp(m++,"Current version",15)) && (m <= m2));

    if(m > m2) return(FALSE);
    m += 19;
    while(*m != 0x0a) Revision[i++] = *m++;
    Revision[i++] = 0x0a;
    Revision[i]   = 0;
    return(TRUE);
}

void create(void)
{
    UBYTE   c = 'y';

    if((infile = Open(Name,MODE_OLDFILE))) {
        Close(infile);
        infile = 0L;
        PUT("File already exists! Overwrite ? (y/n) : ");
        c = ReadChar();
    }

    if(c == 'y' || c == 'Y') {
        if((outfile = Open(Name,MODE_NEWFILE))) {
            SetIoErr(0L);
            writecomm(TRUE);
            VFPrintf(outfile,lines[0],0);
            VFPrintf(outfile,lines[1],&Name);
            VFPrintf(outfile,lines[2],&Args[6]);
            VFPrintf(outfile,lines[3],&Args[5]);
            VFPrintf(outfile,lines[4],0);
            dodate();
            FPutC(outfile,0x0a);
            VFPrintf(outfile,lines[5],&Args[7]);
            VFPrintf(outfile,lines[6],&Args[9]);
            VFPrintf(outfile,lines[7],0);
            VFPrintf(outfile,lines[8],0);
            VFPrintf(outfile,lines[9],0);
            revline();
            VFPrintf(outfile,"*\n",0);
            endheader();
            Close(outfile);
            outfile = 0L;
            if(IoErr())
                cleanup("Write error!\n",20L);
        } else
            cleanup("Can't open output file!\n",20L);
    } else
        cleanup("Header not created!\n",5L);
}

void update(void)
{
    char    old_name[32];
    ULONG   curcnt = 0L, hiscnt = 0L;
    UBYTE   *cm,*hm;

    loadold();

    if(!getrev())
        cleanup("No revision header found!\n",20L);

    if(!Args[7])
        Args[7] = &Revision[0];
    else {
        strcpy(&Revision[0],(char *)Args[7]);
        strcat(&Revision[0],"\n");
        Args[7] = &Revision[0];
    }

    strncpy(old_name,Name,27);
    strcat(old_name,".old");
    Rename(Name,(char *)&old_name[0]);

    if(!(outfile = Open(Name,MODE_NEWFILE)))
        cleanup("Can't open output file!\n",20L);

    SetIoErr(0L);

    cm = Mem;

    while(strncmp(cm++,"Current version",15))
        curcnt++;

    cm     += 20;
    curcnt += 20;

    FWrite(outfile,Mem,curcnt,1);
    FWrite(outfile,(char *)Args[7],strlen((char *)Args[7]),1);

    Revision[strlen((char *)Args[7])-1] = 0;

    while(*cm++ != 0x0a) curcnt++;;
    hm = cm;

    if(!Args[4]) {
        while(strncmp(cm++,"REVISION HISTORY",16))
            hiscnt++;

        cm     += 138;
        hiscnt += 138;

        FWrite(outfile,hm,hiscnt,1);
    } else {
        while(strncmp(cm++,"*-- REV_END",11))
            hiscnt++;

        cm     -= 2;
        hiscnt -= 2;

        FWrite(outfile,hm,hiscnt,1);
    }

    revline();
    FWrite(outfile,cm-1,(size-(curcnt+hiscnt)-2),1);
    Close(outfile);
    outfile = 0L;
    if(IoErr())
        cleanup("Write error!\n",20L);
}

void loadold(void)
{
    if((infile = Open(Name,MODE_OLDFILE))) {
               Seek(infile,0,OFFSET_END);
        size = Seek(infile,0,OFFSET_BEGINNING);

        if((Mem = AllocMem(size,MEMF_PUBLIC))) {
            if(Read(infile,Mem,size) < size)
                cleanup("Read error!\n",20L);
            Close(infile);
            infile = 0L;
        } else
            cleanup("Out of memory!\n",20L);
    } else
        cleanup("Can't open input file!\n",20L);
}

__regargs void cleanup(char *msg, long code)
{
    if(infile)      Close(infile);
    if(outfile)     Close(outfile);
    if(Mem)         FreeMem(Mem,size);
    if(RArgs)       FreeArgs(RArgs);
    if(msg)         PUT(msg);
    _exit(code);
}

int _main( void )
{
    stdout = Output();
    if(SysBase->lib_Version < 36)
        cleanup("You need kickstart 2.0!\n",20L);

    setmem(&Args[0],40L,0);

    if((RArgs = ReadArgs(TEMPLATE,&Args[0],&IArgs))) {
        PUT(COPYR);
        Name = (char *)Args[0];

        if(Args[1])      Language = 1;
        else if(Args[2]) Language = 2;
        else             Language = 0;
    } else
        cleanup("Bad args for AutoRev.\n",20L);

    if(!Args[3]) create();
    else         update();

    cleanup(NULL,NULL);
    return(0L);
}
