/*
 *      Front End for The Small C+ Compiler
 *
 *      Based on the frontend from zcc096 but substantially
 *      reworked
 *
 *      Each file is now processed in turn (all the way through)
 *      And then everything is linked at the end, this makes it
 *      quite a bit nicer, and a bit more standard - saves having
 *      to preprocess all files and then find out there's an error
 *      at the start of the first one!
 *
 *      3/12/98 djm
 *
 *      16/2/99 djm 
 *      Reworking so that we read a config file which tells us all we
 *      need to know about paths etc - removes the variable things
 *      from the executable - and makes it more portable - thanks
 *      to Dennis for suggesting this one!
 *
 *      28/2/99 djm
 *      Added an extra option CRT0 - this allows us to do wildcard
 *      compiles such that main() doesn't have to be in the first
 *      file. We also have the parameter COPYCMD which is whatever
 *      the commmand is for copy files (COPYCMD [source] [dest]),
 *      this is needed because the output file gets dumped in
 *      {zcc}/lib/{CRT0}.bin because Z80 doesn't like being 
 *      specified an output filename.
 *
 *      Also added the cleanup routines, these are a bit nasty, so
 *      perhaps we could create temporary files (using tmpnam) -
 *      but we'll leave that for the moment (till a later release!)
 *
 *      An unwanted side effect of the cleanup routines is that if
 *      you supply a filename which isn't .c and you compile all
 *      the way through then the file will be zapped - for safety
 *      don't use -cleanup if you have non .c files!
 *
 *      $Id: zcc.c 1.17 1999/03/22 23:32:18 djm8 Exp $
 */


#include        <stdio.h>
#include        <string.h>
#include        <stdlib.h>
#include        <ctype.h>
#include        "zcc.h"



/* All our function prototypes */

void ParseArgs(char *);
void AddComp(char *);
void AddPreProc(char *);
void AddLink(char *);
void DispInfo(char *);
void SetVerbose(char *);
void SetCompileOnly(char *);
void SetAssembleOnly(char *);
void SetOutputMap(char *);
void SetOutputSym(char *);
void SetPeepHole(char *);
void DispInfo(char *);
void AddToFileList(char *);
void SetPeepHole(char *);
void SetZ80Verb(char *);
void SetOutputFile(char *);
void SetCleanUp(char *);
void UnSetCleanUp(char *);
void SetPreProcessOnly(char *);
void SetShowErrs(char *);
void SetLibMake(char *);

void *mustmalloc(int);
int  hassuffix(char *, char *);
char *changesuffix(char *, char *);
int  process(char *, char *, char *, char *, enum iostyle, int, int);
int  linkthem(char *);
int  main(int, char **);
int  FindSuffix(char *);
void BuildAsmLine(char *, char *);
void ParseArgs(char *);

void ParseOpts(char *);
void SetNormal(char *,int);
void SetOptions(char *,int);
void SetConfig(char *, int);

void CleanUpFiles(void);
void CleanFile(char *, char *);



/* Mode Options, used for parsing arguments */


struct args myargs[]= {
        {"math-z88",NO,AddComp},
        {"unsigned",NO,AddComp},
        {"//",NO,AddComp},
        {"make-app",NO,AddComp},
        {"do-inline",NO,AddComp},
        {"stop-error",NO,AddComp},
        {"far-pointers",NO,AddComp},
        {"no-header",NO,AddComp},
        {"Wnone",NO,AddComp},
        {"z80-verb",NO,SetZ80Verb},
        {"cleanup",NO,SetCleanUp},
        {"no-cleanup",NO,UnSetCleanUp},
        {"show-errs",NO,SetShowErrs},
        {"make-lib",NO,SetLibMake},
        {"E",NO,SetPreProcessOnly},
        {"D",YES,AddPreProc},
        {"U",YES,AddPreProc},
        {"I",YES,AddPreProc},
        {"l",YES,AddLink},
        {"O",YES,SetPeepHole},
        {"h",NO,DispInfo},
        {"v",YES,SetVerbose},
        {"c",NO,SetCompileOnly},
        {"a",NO,SetAssembleOnly},
        {"m",NO,SetOutputMap},
        {"s",NO,SetOutputSym},
        {"o",YES,SetOutputFile},
        {"",0,0}
};


struct confs myconf[]={
        {"OPTIONS",SetOptions,0},
        {"Z80EXE",SetNormal,0},
        {"CPP",SetNormal,0},
        {"LINKER",SetNormal,0},
        {"COMPILER",SetNormal,0},
        {"COPTEXE",SetNormal,0},
        {"COPYCMD",SetNormal,0},
        {"INCPATH",SetNormal,0},
        {"COPTRULES1",SetNormal,0},
        {"COPTRULES2",SetNormal,0},
        {"CRT0",SetNormal,0},
        {"LIBPATH",SetNormal,0},
        {"LINKOPTS",SetNormal,0},
        {"Z88MATHLIB",SetNormal,0},
        {"STARTUPLIB",SetNormal,0},
        {"GENMATHLIB",SetNormal,0},
        {"",0,0}
};

/*
 * Oh, I know these could be chars, but I'm lazy!
 */


int     mathlibreq      = 0;
int     z80verbose      = 0;
int     cleanup         = 0;
int     assembleonly    = 0;
int     compileonly     = 0;
int     verbose         = 0;
int     peepholeopt     = 0;
int     symbolson       = 0;
int     mapon           = 0;
int     ncppargs        = 0;
int     preprocessonly  = 0;
int     showerrors      = 0;
int     gotfiles        = 0;    /* We've got a file list */
char    **cpparglist=0;
int     nfiles          = 0;
char    **filelist=0;
int     nparms          = 0;
char    **parmlist=0;
int     ncompargs       = 0;
char    **comparglist=0;
char    *outputfile;
char    *cpparg;
char    *comparg;

char    outfilename[FILENAME_MAX+1];

/*
 * Default output binary filename - why mess with genius?!?!
 */

char    *defaultout="a.out";

/* Okay! Off we Go! */

void *mustmalloc(n)
        int     n;
{
        void    *p;

        if ((p = malloc(n)) == 0)
        {
                fprintf(stderr, "malloc failed\n");
                exit(1);
        }
        return (p);
}

int hassuffix(name, suffix)
        char    *name, *suffix;
{
        int     nlen, slen;

        nlen = strlen(name);
        slen = strlen(suffix);

        if (slen > nlen)
                return (0);
        return (strcmp(&name[nlen-slen], suffix) == 0);
}

char *changesuffix(name, suffix)
        char    *name, *suffix;
{
        char    *p, *r;

        if ((p = strrchr(name, '.')) == 0)
        {
                r = mustmalloc(strlen(name) + strlen(suffix) + 1);
                sprintf(r, "%s%s", name, suffix);
        }
        else
        {
                r = mustmalloc(p - name + strlen(suffix) + 1);
                r[0] = '\0';
                strncat(r, name, p - name);
                strcat(r, suffix);
        }
        return (r);
}

int process(suffix, nextsuffix, processor, extraargs, ios,number,needsuffix)
        char    *suffix, *nextsuffix, *processor, *extraargs;
        enum iostyle    ios;
        int     number;
        int     needsuffix;     /* Should dump suffix (z80) oi! */
{
        int     status, errs;
        int     tstore;
        char    *buffer, *outname;

        errs = 0;
         if (!hassuffix(filelist[number], suffix)) return(0);

         switch (ios) {
                case outimplied:
                        buffer = mustmalloc(strlen(processor) + strlen(extraargs)+ strlen(filelist[number]) + 3);

/* Dropping the suffix for Z80..cheating! */
                        tstore=strlen(filelist[number])-strlen(suffix);

                        if (!needsuffix)
                                filelist[number][tstore]=0;

                        sprintf(buffer, "%s %s %s", processor, extraargs,
                                filelist[number]);
                        filelist[number][tstore]='.';
                        break;
                case outspecified:
                        outname = changesuffix(filelist[number], nextsuffix);
                        buffer = mustmalloc(strlen(processor) + strlen(extraargs)
                                + strlen(filelist[number]) + strlen(outname) + 4);
                        sprintf(buffer, "%s %s %s %s", processor, extraargs,
                                filelist[number], outname);
                        free(outname);
                        break;
                case filter:
                        outname = changesuffix(filelist[number], nextsuffix);
                        buffer = mustmalloc(strlen(processor) + strlen(extraargs)
                                + strlen(filelist[number]) + strlen(outname) + 8);
                        sprintf(buffer, "%s %s < %s > %s", processor, extraargs,
                                filelist[number], outname);
                        free(outname);
           }
           if (verbose)         puts(buffer);
                status = system(buffer);
                if (status  != 0)
                        errs = 1;
                else {
/*
 * djm mod 9/3/99 dumb win95 cleanup thing
 */
                   outname = changesuffix(filelist[number], nextsuffix);
                   free(filelist[number]);
                   filelist[number]=outname;
                }
                free(buffer);
        return (errs);
}

int linkthem(linker)
        char    *linker;
{
        int     i, n, status;
        char    *p;

        n = strlen(myconf[LINKER].def) + 1;
        n += strlen("-a -nm -nv");
        for (i = 0; i < nparms; ++i)
                n += (strlen(parmlist[i]) + 1);
        n += strlen(myconf[STARTUPLIB].def);
        n += 10*strlen(myconf[LIBPATH].def); /* To cover for lib - enuff libs? */
        n += (strlen(myconf[CRT0].def)+2 );
        if (mathlibreq) n+= strlen(myconf[Z88MATHLIB].def);
        for (i = 0; i < nfiles; ++i)
        {
                if (hassuffix(filelist[i], ".obj"))
                        n += strlen(filelist[i]) + 1 -3; /* ignore .obj*/
        }
        p = mustmalloc(n);
        sprintf(p, "%s %s", linker,myconf[LINKOPTS].def);
        if      (!mapon)
                strcat(p," -nm");
        if      (!z80verbose)
                strcat(p," -nv");
/* Put the startup lib in first (speeds things up!) */
        strcat(p, " ");
        strcat(p, myconf[LIBPATH].def);
        strcat(p, myconf[STARTUPLIB].def);
        strcat(p, " ");
/* Now, do the maths libraries */
        switch (mathlibreq) {
                case Z88MATH:
                        strcat(p,myconf[LIBPATH].def);
                        strcat(p,myconf[Z88MATHLIB].def);
                        break;
                case GENMATH:
                        strcat(p,myconf[LIBPATH].def);
                        strcat(p,myconf[GENMATHLIB].def);
        }
        for (i = 0; i < nparms; ++i)
        {
                strcat(p, " ");
                strcat(p, parmlist[i]);
        }
/* Now insert the 0crt file (so main doesn't have to be the first file */
        strcat(p," ");
        strcat(p,myconf[CRT0].def);

        for (i = 0; i < nfiles; ++i)
        {
                if (hassuffix(filelist[i], ".obj"))
                {
                        strcat(p, " ");
                        filelist[i][strlen(filelist[i])-4]='\0';
                        strcat(p, filelist[i]);
                }
        }
        if (verbose)
                printf("%s\n", p);
        status = system(p);
        free(p);
        return (status);
}

int main(argc, argv)
        int     argc;
        char    **argv;
{
        int     i, n, gc;
        char    *temp,*temp2,*cfgfile;
        char    asmarg[20];     /* Must hold "-eopt -ns" */
        char    buffer[LINEMAX+1]; /* For reading in option file */
        FILE    *fp;

/*
 * Okay, the fun begins now, first of all, lets use atexit so we can
 * cleanup after ourselves..
 */

        atexit(CleanUpFiles);

        comparg=cpparg=0;

        /* allocate enough pointers for all files, slight overestimate */
        filelist = (char **)mustmalloc(sizeof(char *) * argc);
        /* ditto for -Ddef=val, -Udef, -I, huge overestimate */
        cpparglist = (char **)mustmalloc(sizeof(char *) * argc);
        /* ditto for -l..., huge overestimate */
        parmlist = (char **)mustmalloc(sizeof(char *) * argc);
        /* And again for compile flags...*/
        comparglist=(char **)mustmalloc(sizeof(char *) * argc);



/* Now, find the environmental variable ZCCFILE which contains the
 * filename of our config file..
 */
        gc=1;           /* Set for the first argument to scan for */

/*
 * If we only have one parameter, we don't want to go any further..
 * (Linux quite rightly baulks..)
 */
        if (argc == 1 ) { DispInfo(buffer); exit(1); }

/*
 * Scan for an option file on the command line
 */
        if ( argv[gc][0]=='+' ) {
/*
 *      Trapped the +
 */
                strcpy(outfilename,argv[gc]+1);
                gc++;   /* Increment first arg to search from */
        } else {
/*
 *      Use the default - find the ZCCFILE variable
 */
                cfgfile=getenv("ZCCFILE");
                if (cfgfile == NULL ) 
                {
                        fprintf(stderr,"Env variable ZCCFILE not found, exiting!\n");
                        exit(1);
                }
                if (strlen(cfgfile) > FILENAME_MAX) {
                        fprintf(stderr,"Possibly corrupt env variable ZCCFILE\n");
                        exit(1);
                }
                strcpy(outfilename,cfgfile);
        }



/*
 * Okay, so now we read in the options file and get some info for us
 */

        if ( (fp=fopen(outfilename,"r") ) == NULL )  
        {
                fprintf(stderr,"Can't open config file %s\n",outfilename);
                exit(1);
        }

        while (fgets(buffer,LINEMAX,fp) != NULL) 
        {
                if (!isupper(buffer[0])) continue;
                ParseOpts(buffer);
        }
        fclose(fp);

/*
 *      Check to see if we are missing any definitions, if we are
 *      exit..
 */

        for (i= Z80EXE ; i<= GENMATHLIB ; i++ ) {
                if ( myconf[i].def == 0 ) {
                        fprintf(stderr,"Missing definition for %s\n",myconf[i].name);
                        exit(1);
                }
        }



/*
 *      Set the default output file
 */

        outputfile=defaultout;



/*
 * That's dealt with the options, so onto real stuff now!
 */

/* Now, parse the default options list */
        if ( myconf[OPTIONS].def != 0 ) {
/* Now, pain up the arse time, we have to go round, chasing up every space
 * in myconf[OPTIONS].def to turn it into a \0 so that ParseArgs 
 * understands what we're on about...hmmmm
 *
 * First of all, scan forward to first non space character.
 */
                temp2=myconf[OPTIONS].def;
                while ( isspace(*temp2) ) temp2++;

                while ( (temp=strchr(temp2,' ')) != NULL ) {
                        *temp='\0';      /* Truncate string */
                        if (temp2[0]=='-') ParseArgs(&temp2[1]);
                        else AddToFileList(temp2);
                        temp2=temp+1;
                }
/* If we're here, we have at least one option left...so do it! first of
 * all, get rid of that pesky line feed character
 */
                temp2[strlen(temp2)-1]='\0';
                if (temp2[0]=='-') ParseArgs(&temp2[1]);
                else AddToFileList(temp2);
        }

/* Parse the argument list */

        for (n=gc;n<argc;n++) {
                if (argv[n][0]=='-') ParseArgs(1+argv[n]);
                else AddToFileList(argv[n]);
        }

/*
 *      First thing we do is to remove the zcc_opt.def file
 *      This is written to by sccz80
 *
 *      Done in this this dotty way to ensure we can write and
 *      also to avoid usage of access() - maybe it's not present
 *      on all systems..
 *
 */
        if ( (fp=fopen(DEFFILE,"w")) != NULL ) {
                fclose(fp);
                if (remove(DEFFILE) < 0 ) {
                        fprintf(stderr,"Cannot remove %s: File in use?\n",DEFFILE);
                        exit(1);
                }
/*
 *      It's the merry go round, here we try to open it again, so that
 *      if we specify non .c files compiling doesn't barf, ah, if only
 *      we could do a touch [filename]!
 */

                if ( ( fp=fopen(DEFFILE,"w")) != NULL) fclose(fp);
                else { fprintf(stderr,"Could not create %s: File in use?\n",DEFFILE); exit(1); }


        } else {
                fprintf(stderr,"Cannot open %s: File in use?\n",DEFFILE);
                exit(1);
        }


        n = 1+strlen(myconf[INCPATH].def);
        for (i = 0; i < ncppargs; ++i)
                n += strlen(cpparglist[i]) + 1;
        cpparg = mustmalloc(n);
        cpparg[0] = '\0';
        strcpy(cpparg,myconf[INCPATH].def);
        for (i = 0; i < ncppargs; ++i)
        {
                strcat(cpparg, cpparglist[i]);
                if (i < ncppargs - 1)
                        strcat(cpparg, " ");
        }
/* Now, do the same for the compiler! */

        n=1;
        for (i=0; i<ncompargs; ++i)
                n+= strlen(comparglist[i])+1;
        comparg=mustmalloc(n);
        comparg[0]='\0';
        for (i = 0; i < ncompargs; ++i)
        {
                strcat(comparg, comparglist[i]);
                if (i < ncompargs - 1)
                        strcat(comparg, " ");
        }

        if (nfiles <= 0) {
                DispInfo(temp);
                exit(0);
        }

        gotfiles=1;
/*
 * Okay, the fun begins now, first of all, lets use atexit so we can
 * cleanup after ourselves..
 */




/*
 * Parse through the files, handling each one in turn
 */

        for     (i=0;i<nfiles;i++) {
                 switch (FindSuffix(filelist[i])) {
                        case CFILE:
                        if (process(".c", ".i", myconf[CPP].def, cpparg, outspecified,i,YES))  exit(1);
                        if (preprocessonly) exit(0);

                        case PFILE:
                        if (process(".i", ".asm", myconf[COMPILER].def, comparg, outimplied,i,YES))  exit(1);

                        case AFILE:
                        if (peepholeopt) {
                                if (peepholeopt==YES) {
                                        if (process(".asm", ".opt", myconf[COPTEXE].def, myconf[COPTRULES1].def, filter,i,YES))  exit(1);
                                } else {
/* Double optimization! */
                                        if (process(".asm", ".op1", myconf[COPTEXE].def, myconf[COPTRULES2].def, filter,i,YES))  exit(1);

                                        if (process(".op1", ".opt", myconf[COPTEXE].def, myconf[COPTRULES1].def, filter,i,YES))  exit(1);
                                }
                        } else {
                                BuildAsmLine(asmarg,"-easm");
                                if (!assembleonly)
                                        if (process(".asm", ".obj", myconf[Z80EXE].def, asmarg , outimplied,i,NO)) exit(1);
                        }
                        case OFILE:
                        BuildAsmLine(asmarg,"-eopt");
                        if (!assembleonly)
                                if (process(".opt", ".obj", myconf[Z80EXE].def, asmarg , outimplied,i,NO)) exit(1);
                        break;
                }
        }
        if (compileonly || assembleonly)
                exit(0);

/*
 *      Now, build the option line to compile the header file..
 */

        sprintf(buffer,"%s -nv -ns %s",myconf[Z80EXE].def, myconf[CRT0].def);
        if (verbose) printf("%s\n",buffer);
        if (system(buffer) ){
                fprintf(stderr,"Compiling startup code failed\n");
                exit(1);
        }


        if (linkthem(myconf[LINKER].def)) {
                if (showerrors) {
/*
 * Here, we could open the error file and dump all the errors
 */
                        temp=changesuffix(myconf[CRT0].def,".err");
                        if ( (fp=fopen(temp,"r") ) != 0 ) {
                                fprintf(stderr,"\nCompilation errors are:\n\n");
                                while (fgets(buffer,LINEMAX,fp) != NULL ){
                                        fprintf(stderr,"%s\n",buffer);
                                }
                                fclose(fp);
                        }
                }
                exit(1);
        }
/*
 *      Here we've had success, so copy the file over to either
 *      a.out or to an output filename if specified
 */
        temp2=changesuffix(myconf[CRT0].def,".bin");
        sprintf(buffer,"%s %s %s",myconf[COPYCMD].def,temp2 ,outputfile);
        if (verbose) printf("%s\n",buffer);

        if (system(buffer)) {
                fprintf(stderr,"Copy of output file failed\n");
                exit(1);
        }
        if (remove(temp2) ) {
                fprintf(stderr,"Cannot remove initial output file %s\n",temp2);
                exit(1);
        }
        exit(0);


}


/* New djm Functions start here! */


int FindSuffix(char *name)
{
        int     j;
        j=strlen(name);
        while(j && name[j]!='.') j--;

        if      (!j) return 0;

        j++;
        if (strcmp(&name[j],".c")) return CFILE;
        if (strcmp(&name[j],".i")) return PFILE;
        if (strcmp(&name[j],".asm")) return AFILE;
        if (strcmp(&name[j],".opt")) return OFILE;
        return 0;
}


void BuildAsmLine(char *dest, char *prefix)
{
        strcpy(dest,prefix);
        if (!z80verbose)
                strcat(dest," -nv");   
        if      (!symbolson)
                strcat(dest," -ns");
}

/*
 *      Compile library files
 */

void SetLibMake(char *arg)
{
        char *nline="-no-header";
        compileonly=YES;        /* Get to object file */
        peepholeopt=2*YES;
        AddComp(nline+1);
}
        

void SetCompileOnly(char *arg)
{
        compileonly=YES;
}

void SetAssembleOnly(char *arg)
{
        assembleonly=YES;
}

void SetOutputMap(char *arg)
{
        mapon=YES;
}

void SetOutputSym(char *arg)
{
        symbolson=YES;
}

void SetOutputFile(char *arg)
{
        sscanf(&arg[1],"%s",outfilename);
        outputfile=outfilename;
        if (!strlen(outputfile) ) {
/* Invalid filename specified (null) */
                outputfile=defaultout;
        }
}

void SetPeepHole(char *arg)
{
        if ((arg[1]) == '2') peepholeopt=2*YES;
        else if ((arg[1]) == '0' ) peepholeopt=NO;
        else peepholeopt=YES;
}

void SetPreProcessOnly(char *arg)
{
        preprocessonly=YES;
}

void SetShowErrs(char *arg)
{
        showerrors=YES;
}

void SetZ80Verb(char *arg)
{
        z80verbose=YES;
}

void AddPreProc(char *arg)
{
        cpparglist[ncppargs++]=arg-1;
}

void SetCleanUp(char *arg)
{
        cleanup=YES;
}

void UnSetCleanUp(char *arg)
{
        cleanup=NO;
}

void AddLink(char *arg)
{
        char *mathlib="-math-z88";

        if (strcmp(arg,"ls")==0) arg[1]='\0';
        if (strcmp(arg,"lm")==0) { mathlibreq=GENMATH; return; }
        if (strcmp(arg,"lmz")==0) { mathlibreq=Z88MATH; AddComp(mathlib+1); return; }
        arg[0]='i';     /* Change it to an i for library */
        parmlist[nparms++]=arg-1;
}

/* Add flag to compiler list, if argument is math-z88 then include
 * the Z88 maths library automatically
 */

void AddComp(char *arg)
{
        if (strcmp(arg,"math-z88")==0) mathlibreq=Z88MATH;
        comparglist[ncompargs++]=arg-1;
}

void AddToFileList(char *arg)
{
        char *ptr;
        if (isspace(arg[0]) || arg[0] == 0 ) return;
/*
 *      Sassen frassen Winblows..
 */
        ptr=mustmalloc(strlen(arg)+1);
        strcpy(ptr,arg);
        filelist[nfiles++] = ptr;
}

void SetVerbose(char *arg)
{
        if (arg[1] == 'n') verbose = NO;
        else verbose=YES;
}

void DispInfo(char *arg)
{
        printf("Zcc Frontend for the Small C+ Compiler\n");
        printf("v2.31 15.3.99 D.J.Morris\n");
        exit(0);
}


void ParseArgs(char *arg)
{
        struct args *pargs;
        int     flag;
        pargs=myargs;
        flag=0;
        while(pargs->setfunc)
        {
                switch(pargs->more) {

/* More info follows the initial thing.. */
                case YES:
                        if (strncmp(arg,pargs->name,strlen(pargs->name))==0) {
                                (*pargs->setfunc)(arg);
                                flag=1;
                        }
                        break;
                case NO:

                        if (strcmp(arg,pargs->name)==0) {
                                (*pargs->setfunc)(arg);
                                flag=1;
                        }
                }
                if (flag) return;
                pargs++;
        }
        printf("Unrecognised argument: -%s\n",arg);
}

void ParseOpts(char *arg)
{
        struct confs *pargs;
        int     num=0;
        pargs=myconf;

        while(pargs->setfunc)
        {
                if (strncmp(arg,pargs->name,strlen(pargs->name))==0) {
                        (*pargs->setfunc)(arg,num);
                        return;
                }
                num++;
                pargs++;
        }
        printf("Unrecognised option: -%s\n",arg);
        return;
}

/* 
 * Set the pointer in the myconf structure to be for out inputted thing
 * malloc the space for it, and then flunk if die..
 */

void SetConfig(char *arg, int num)
{
        if (myconf[num].def == NULL ) {
                myconf[num].def=(char *) mustmalloc(strlen(arg)+1);
                strcpy(myconf[num].def,arg);
        } else {
                fprintf(stderr,"%s already defined as %s",myconf[num].name,myconf[num].def);
        }
}
        


void SetNormal(char *arg,int num)
{
        char name[LINEMAX+1];
        sscanf(arg,"%s%s",name,name);
        if (strncmp(name,myconf[num].name,strlen(myconf[num].name)) != 0 ) {
                SetConfig(name,num);
        }
}

void SetOptions(char *arg, int num)
{
        char name[LINEMAX+1];
        sscanf(arg,"%s%s",name,name);
        if (strncmp(name,myconf[num].name,strlen(myconf[num].name)) != 0 ) {
                SetConfig(&arg[strlen(myconf[num].name)+1],num);
        }
}


/*
 *      Functions to clean up after the compiler - these are called
 *      courtesy of atexit()
 *
 *      Cleanup mem now in here as well - to avoid crashes!
 */


void CleanUpFiles()
{
        int j;

        if ( gotfiles && cleanup) {
                for (j=0; j<nfiles; j++ ) {
                        if (!preprocessonly)
                                CleanFile(filelist[j],".i");
                        if (!assembleonly) {
                                CleanFile(filelist[j],".asm");
                                CleanFile(filelist[j],".hdr");
                                CleanFile(filelist[j],".op1");
                                CleanFile(filelist[j],".opt");
                        }
                        if (!compileonly)
                                CleanFile(filelist[j],".obj");
                }
        }

        for (j = OPTIONS ; j<= GENMATHLIB; j++ ) {
                if (myconf[j].def) { free(myconf[j].def); myconf[j].def=0;}
        }
        for (j=0; j<nfiles; j++ ) {
                free(filelist[j]);
        }
        if (filelist) { free(filelist); filelist=0; }
        if (cpparglist) { free(cpparglist); cpparglist=0; }
        if (parmlist) { free(parmlist) ; parmlist=0; }
        if (comparglist) { free(comparglist) ; comparglist=0; }
        if (comparg) { free(comparg) ; comparg=0; }
        if (cpparg) { free(cpparg) ; cpparg=0; }


}


void CleanFile(char *file,char *ext)
{
        char *temp;
        if (hassuffix(file,ext)) return;
        
        temp=changesuffix(file,ext);
        remove(temp);
        free(temp);     /* Being nice for once! */
}
