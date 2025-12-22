/*
 *      Small C+ Compiler -
 *
 *      Main() part
 *
 *      $Id: main.c 1.6 1999/03/18 01:14:26 djm8 Exp $
 */

#include "ccdefs.h"




/*
 *      Compiler begins execution here
 */
int main(argc, argv)
int argc ;
char **argv ;
{
        int     n;      /* Loop counter */
        gargc = argc ;
        gargv = argv ;
/*
 * Empty our mem ptrs
 */

        litq=dubq=tempq=glbq=0;
        symtab=loctab=0;
        wqueue=0;membptr=0;tagptr=0;swnext=0;stage=0;

        /* allocate space for arrays */
        litq = alloc(FNLITQ) ;         /* literals, these 2 dumped end */
        dubq = alloc(FNLITQ) ;         /* Doubles */
        tempq = alloc(LITABSZ) ;        /* Temp strings... */
        glbq  = alloc(LITABSZ) ;        /* Used for glb lits, dumped now */
        symtab = SYM_CAST alloc(NUMGLBS*sizeof(SYMBOL)) ;
        loctab = SYM_CAST alloc(NUMLOC*sizeof(SYMBOL)) ;
        wqueue = WQ_CAST alloc(NUMWHILE*sizeof(WHILE_TAB)) ;

        tagptr = tagtab = TAG_CAST alloc(NUMTAG*sizeof(TAG_SYMBOL)) ;
        membptr = membtab = SYM_CAST alloc(NUMMEMB*sizeof(SYMBOL)) ;

        swnext = SW_CAST alloc(NUMCASE*sizeof(SW_TAB)) ;
        swend = swnext + (NUMCASE-1) ;

        stage = alloc(STAGESIZE) ;
        stagelast = stage+STAGELIMIT ;

        /* empty symbol table */
        glbptr = STARTGLB;
        while ( glbptr < ENDGLB ) {
                glbptr->name[0] = 0 ;
                ++glbptr ;
        }

        glbcnt = 0 ;                    /* clear global symbols */
        locptr = STARTLOC ;             /* clear local symbols */
        wqptr = wqueue ;                /* clear while queue */
        gltptr=dubptr=litptr = 0 ;                    /* clear literal pool */


        Zsp =                   /* stack ptr (relative) */
        errcnt =                /* no errors */
        errstop =               /* keep going after an error */
        eof =                   /* not eof yet */
        swactive =              /* not in switch */
        skiplevel =             /* #if not encountered */
        iflevel =               /* #if nesting level = 0 */
        ncmp =                  /* no open compound states */
        lastst =                /* not first file to asm */
        fnstart =               /* current "function" started at line 0 */
        lineno =                /* no lines read from file */
        infunc =                /* not in function now */
                        0 ;             /*  ...all set to zero.... */

        stagenext = NULL_CHAR ; /* direct output mode */

        input =                                 /* no input file */
        inpt2 =                                 /* or include file */
        saveout =                               /* no diverted output */
        output = NULL_FD ;              /* no open units */

        currfn = NULL_SYM ;             /* no function yet */
        macptr = cmode = 1 ;    /* clear macro pool and enable preprocessing */
        ncomp=doinline=mathz88 = incfloat= compactcode =0;
        lpointer=cppcom=appz88=0;
        dosigned=NO;
        doheader=YES;
        nxtlab =                        /* start numbers at lowest possible */
        ctext =                         /* don't include the C text as comments */
        errstop =                       /* don't stop after errors */
        verbose = 0;
        dowarnings=YES;                   /* All those annoying warnings */

        /*
         *      compiler body
         */
        setup_sym() ;   /* define some symbols */
/* Parse the command line options */
        atexit(MemCleanup);     /* To free everything */
        clear();
        filenum=0;
        for (n=1;n<argc;n++) {
                if (argv[n][0]=='-') ParseArgs(1+argv[n]);
                else {filenum=n; break;}
        }
        clear();

        if (filenum == 0)
        {
                info();
                exit(1);
        }
        litlab=getlabel();              /* Get labels for function lits*/
        dublab=getlabel();              /* and fn doubles*/
        openout();              /* get the output file */
        openin();               /* and initial input file */
        header();               /* intro code */
        parse();                /* process ALL input */
        /* dump literal queues, with label */
        dumplits(1, YES,litptr,litlab,litq) ;
        dumplits(1, YES,dubptr,dublab,dubq) ;
        dumpvars();
        trailer();              /* follow-up code */
        closeout();             /* close the output (if any) */
        if (doheader) dohdrfi();
        errsummary();   /* summarize errors */
        if (errcnt) exit(1);
        exit(0);
}

#ifndef SMALL_C
void
#endif

iseof()
{
        warning("Unexpected end of file");
        ccabort();
}


/*
 *      Abort compilation
 */

#ifndef SMALL_C
void 
#endif

ccabort()
{
        if ( inpt2 != NULL_FD )
                endinclude();
        if ( input != NULL_FD )
                fclose(input);
        closeout();
        fprintf(stderr,"Compilation aborted\n");
        exit(1);
}

/*
 * Process all input text
 *
 * At this level, only static declarations,
 * defines, includes, and function
 * definitions are legal...
 */

#ifndef SMALL_C
void
#endif

parse()
{
        while ( eof == 0 ) {            /* do until no more input */
                if ( amatch("extern") )
                        dodeclare(EXTERNAL, NULL_TAG, 0) ;
                else if (amatch("static"))
                        dodeclare(STATIK, NULL_TAG, 0) ;
                else if (dodeclare(STATIK, NULL_TAG, 0) )
                        ;
                else if ( ch() == '#' ) {
                        if (match("#asm")) doasm();
                        else if (match("#include")) doinclude() ;
                        else if (match("#define") ) addmac() ;
                        else 
                        {
                                clear();
                                blanks();
                        }
                }
                else newfunc();
                blanks();       /* force eof if pending */
        }
}



/*
 *      Report errors for user
 */

#ifndef SMALL_C
void
#endif

errsummary()
{
        /* see if anything left hanging... */
        if (ncmp) { error("missing closing bracket"); nl(); }
                /* open compound statement ... */
        if (verbose){
                outstr("Symbol table usage: "); outdec(glbcnt); nl();
                outstr("There were "); outdec(errcnt);
                outstr(" errors in compilation.\n");
        }
}


/*
 * places in s the n-th argument (up to "size"
 * bytes). If successful, returns s. Returns 0
 * if the n-th argument doesn't exist.
 */

#ifndef SMALL_C
char *
#endif

nextarg(n, s, size)
int n;
char *s;
int size ;
{
        char *str;
        char *str2;
        int i;

        if ( n < 1 || n >= gargc ) return NULL_CHAR ;
        i = 0 ;
        str = str2 =gargv[n] ;
        while ( ++i < size && (*s++ = *str++) )
                ;
        if (*str2 == '\0' ) return NULL_CHAR;
        return s ;
}


/*
 * make a few preliminary entries in the symbol table
 */

#ifndef SMALL_C
void
#endif

setup_sym()
{
        defmac("Z80") ;
        defmac("SMALL_C") ;
        /* dummy symbols for pointers to char, int, double */
        /* note that the symbol names are not valid C variables */
        dummy_sym[0] = 0 ;
        dummy_sym[CCHAR] = addglb("0ch", POINTER, CCHAR, 0, STATIK, 0,0) ;
        dummy_sym[CINT] = addglb("0int", POINTER, CINT, 0, STATIK, 0,0) ;
        dummy_sym[DOUBLE] = addglb("0dbl", POINTER,DOUBLE,0,STATIK, 0,0) ;
        dummy_sym[LONG] = addglb("0lng", POINTER, LONG, 0, STATIK, 0,0) ;
        dummy_sym[CPTR] = addglb("0cpt", POINTER, CPTR, 0, STATIK, 0,0) ;
        dummy_sym[VOID] = addglb("0vd", POINTER, VOID, 0 , STATIK, 0,0) ;

}

#ifndef SMALL_C
void
#endif

info()
{
        fputs(titlec,stderr);
        fputs("1980-1999 Cain, Van Zandt, Hendrix, Yorston, Morris\n",stderr);
        fprintf(stderr,"Usage: %s [flags] [file]\n",gargv[0]);
        
}


/*
 ***********************************************************************
 *
 *
 *      Routines To Write Out The Header File (.hdr) and to Dump
 *      the static variables, also for dumping the literal pool
 *
 *
 ***********************************************************************
 */


/*
 *      Write out the header file! - djm
 */

void dohdrfi()
{
        char file2[FILENAME_MAX+1];
        if (verbose)
                fputs("Writing header file\n",stderr);
        clear();
        strcpy(file2,Filename);
        changesuffix(file2,".hdr");
        if ((output=fopen(file2,"w")) != NULL )
        {
                dumpfns();
                fclose(output);
                output=0;
        }
        else {
                fprintf(stderr,"Cannot open output file: %s\n",file2);
        }
}



/* djm write out the header file */

#ifndef SMALL_C
void 
#endif

dumpfns()
{
        int ident,type,storage;
        SYMBOL *ptr;
        FILE    *fp;

        outstr(";\tHeader file for file:\t");
        outstr(Filename);
        outstr("\n;\n;\tEven if empty do not delete!!!\n");
        outstr(";\n;\t***START OF HEADER DEFNS***\n\n");
        if (!glbcnt)
                return;

/* Start at the start! */
        glbptr=STARTGLB;

        ptr=STARTGLB;
        while (ptr < ENDGLB)
        {
                if (ptr->name[0] != 0 && ptr->name[0] != '0' )
                {
                        ident=ptr->ident;
                        type =ptr->type;
                        storage=ptr->storage;
                        if (ident == FUNCTION)
                        {
                                if (storage==EXTERNAL)
                                        if (ptr->size)
                                                outstr("\tLIB\t");
                                        else    outstr("\tXREF\t");
                                else
                                        if (ptr->offset.i == FUNCTION)
                                                outstr("\tXDEF\t");
                                        else
                                                outstr("\tXREF\t");
                        outname(ptr->name,dopref(ptr));
                        nl();
                        }
                        else
                                if (storage == EXTERNP) {
                                        outstr("\tdefc\t");
                                        outname(ptr->name,1);
                                        outstr("\t=\t");
                                        outdec(ptr->size);
                                        outstr("\n");
                                }
                                else
                                        
                                if (ident != MACRO && storage != LSTATIC && storage != LSTKEXT )
                                {
                                        if (storage == EXTERNAL)
                                                outstr("\tXREF\t");
                                        else 
                                                outstr("\tXDEF\t");
                                outname(ptr->name,1);
                                nl();
                                }
                }
        ++ptr;
        }
/*
 *      If a module requires floating point then previously we wrote
 *      it out to the header file. However, if the module didn't
 *      contain main() then important routines wouldn't be included.
 *      So, if main didn't need float, but ours did we would never
 *      compile!!
 *
 *      The solution was to separate startup code, and then define
 *      a new file to which all the math type headers would be
 *      appended.
 *
 *      This file is zcc_opt.def in the source code directory.
 *
 */

        if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
                warning("Can't open zcc_opt.def file");
                ccabort();
        }

        if (incfloat) {
                        fprintf(fp,"\nIF !NEED_floatpack\n");
                        fprintf(fp,"\tDEFINE\tNEED_floatpack\n");
                        fprintf(fp,"ENDIF\n\n");
        }
        if (mathz88) {
                        fprintf(fp,"\nIF !NEED_mathz88\n");
                        fprintf(fp,"\tDEFINE\tNEED_mathz88\n");
                        fprintf(fp,"ENDIF\n\n");
        }
        if (lpointer) {
                        fprintf(fp,"\nIF !NEED_farpointer\n");
                        fprintf(fp,"\tDEFINE NEED_farpointer\n");
                        fprintf(fp,"ENDIF\n\n");
        }
        fclose(fp);
 

/*
 * No need to find main to see if we need the startup code
 * z88_crt0.asm is the first module in the file list automatically
 *
 * DO_inline is obsolete, but it may have a use sometime..
 */
/*
        if (ptr=findglb("main"))
                if (ptr->ident == FUNCTION && ptr->storage != EXTERNAL)
                        outstr("\tDEFINE\tNEED_startup\n");
 */
        if (doinline)
                        outstr("\tDEFINE\tDO_inline\n");
        outstr("\n\n;\t***END OF HEADER FILE***\n");
}


/*
 * Dump the DEFVAR statement out - will also be for DEFDATA..eventually!
 */

#ifndef SMALL_C
void
#endif

dumpvars()
{
        int ident,type,storage;
        SYMBOL *ptr;
        char   dname[10];

        if (!glbcnt)
                return;

/* Start at the start! */
        glbptr=STARTGLB;
        outstr("; --- Start of Static Variables ---\n\n");
/* Two different handlings, if an application then use defvars construct
 * if not, then just drop em using defs!
 */

        if (appz88) {
                ot("\n\tDEFVARS ");
                strcpy(dname,"-1\n{\n");
                if ( (ptr=findglb("main")) )
                        if (ptr->ident == FUNCTION && ptr->storage != EXTERNAL)
                                strcpy(dname,"$2000\n{\n");
                outstr(dname);
        }
        ptr=STARTGLB;
        while (ptr < ENDGLB)
        {
                if (ptr->name[0] != 0 && ptr->name[0] != '0' )
                {
                        ident=ptr->ident;
                        type =ptr->type;
                        storage=ptr->storage;
                        if (ident != MACRO && ident != FUNCTION && storage != EXTERNAL && storage != DECLEXTN && storage != EXTERNP && storage != LSTKEXT )
                        {
                        if (!appz88) prefix();
                        outname(ptr->name,1);
                        if (appz88) outstr("\n\tds.b\t");
                        else  defstorage();
                        outdec(ptr->size);
                        nl();
                        }
                }
        ++ptr;
        }

/* Not need ATM - is in startup code..
        if (ptr=findglb("main"))
                if (ptr->ident == FUNCTION && ptr->storage != EXTERNAL && incfloat)
                        {
                                outstr(".extra\tds.b\t6\n");
                                outstr(".fa\tds.b\t6\n");
                                outstr(".fasign\tds.b\t1\n");
                                outstr(".seed\tds.b\t6\n");
                        }
*/
        if (appz88) outstr("}\n");      /* close defvars statement */
}

/*
 *      Dump the literal pool if it's not empty
 *      Modified by djm to be able to input which queue should be
 *      dumped..
 */

#ifndef SMALL_C
void
#endif

dumplits(size, pr_label,queueptr,queuelab,queue)
int size, pr_label ;
int queueptr,queuelab;
char *queue;
{
        int j, k ;

        if ( queueptr ) {
                if ( pr_label ) {
                        prefix(); printlabel(queuelab) ;
                        col() ; nl();
                }
                k = 0 ;
                while ( k < queueptr ) {
                        /* pseudo-op to define byte */
                        if (size == 1) defbyte();
                        else if (size == 4) deflong();
                        else defword();
                        j = 10 ;                /* max bytes per line */
                        while ( j-- ) {
                                outdec(getint(queue+k, size));
                                k += size ;
                                if ( j == 0 || k >= queueptr ) {
                                        nl();           /* need <cr> */
                                        break;
                                }
                                outbyte(',');   /* separate bytes */
                        }
                }
        }
        nl();
}



/*
 * dump zeroes for default initial value
 * (or rather, get loader to do it for us)
 */
int dumpzero(size, count)
int size, count ;
{
        if (count <= 0) return (0);
        defstorage() ;
        outdec(size*count) ;
/*        outstr("dumpzero"); */
        nl();
        return(size*count);
}



/********************************************************************
 *
 *      Routines to open the assembly and C source files
 *
 ********************************************************************
 */


/*
 *      Get output filename
 */
void openout()
{
        char filen2[FILENAME_MAX+1];
        FILE *fp;
        clear() ;               /* erase line */
        output = 0 ;    /* start with none */
        if ( nextarg(filenum, filen2, FILENAME_MAX) == NULL_CHAR ) return ;
/* For weird reasons, output is opened before input, so have to check
 * input exists beforehand..
 */
        if ( ( fp=fopen(filen2,"r")) == NULL )
                {
                fprintf(stderr,"Cannot open source file: %s\n",filen2);
                exit(1);
                }
        fclose(fp);     /* Close it again... */

        /* copy file name to string */
        strcpy(Filename,filen2) ;
        changesuffix(filen2,".asm"); /* Change appendix to .asm */
        if ( (output=fopen(filen2, "w")) == NULL && (!eof) ) {
                fprintf(stderr,"Cannot open output file: %s\n",line);
                exit(1);
        }
        clear() ;                       /* erase line */
}

/*
 *      Get (next) input file
 */
void openin()
{
        input = 0 ;                             /* none to start with */
        while ( input == 0 ) {  /* any above 1 allowed */
                clear() ;                       /* clear line */
                if ( eof ) break ;      /* if user said none */
/* Deleted hopefully irrelevant code */
                if (Filename[0] == '-')
                {
                        if (ncomp==0)
                                info();
                        exit(1);
                }
                if ( (input=fopen(Filename,"r")) == NULL ) {
                        fprintf(stderr,"Can't open: %s\n",Filename);                         exit(1);
                }
                else {
                        if (verbose)
                           fprintf(stderr,"Compiling: %s\n",Filename);
                        ncomp++;
                        newfile() ;
                }
        }
        clear();                /* erase line */
}

/*
 *      Reset line count, etc.
 */
void newfile()
{
        lineno  =                               /* no lines read */
        fnstart =                               /* no fn. start yet. */
        infunc  = 0 ;                   /* therefore not in fn. */
        currfn  = NULL ;                /* no fn. yet */
}

/*
 *      Open an include file
 */
void doinclude()
{
        char name[FILENAME_MAX+1], *cp ;

        blanks();       /* skip over to name */
        if (verbose)
        {
        toconsole();
        outstr(line); nl();
        tofile();
        }

        if ( inpt2 )
                warning("Can't nest include files");
        else {
                /* ignore quotes or angle brackets round file name */
                strcpy(name, line+lptr) ;
                cp = name ;
                if ( *cp == '"' || *cp == '<' ) {
                        name[strlen(name)-1] = '\0' ;
                        ++cp ;
                }
                if ( (inpt2=fopen(cp, "r") ) == NULL ) {
                        error("Can't open include file") ;
                        closeout();
                        exit(1);
                }
                else {
                        saveline = lineno ;
                        savecurr = currfn ;
                        saveinfn = infunc ;
                        savestart = fnstart ;
                        newfile() ;
                }
        }
        clear();                /* clear rest of line */
                                /* so next read will come from */
                                /* new file (if open) */
}

/*
 *      Close an include file
 */
void endinclude()
{
        if (verbose) {
                toconsole();
                outstr("#end include\n");
                tofile();
        }

        inpt2  = 0 ;
        lineno  = saveline ;
        currfn  = savecurr ;
        infunc  = saveinfn ;
        fnstart = savestart ;
}

/*
 *      Close the output file
 */
void closeout()
{
        tofile() ;      /* if diverted, return to file */
        if ( output ) {
                /* if open, close it */
                fclose(output) ;
        }
        output = 0 ;            /* mark as closed */
}

/*      
 *      Deals With parsing of command line options
 *
 *      djm 3/12/98
 *
 */






struct args {
        char *name;
        char more;
        void (*setfunc)(char *);
};


struct args myargs[]= {
        {"math-z88",NO,SetMathZ88},
        {"unsigned",NO,SetUnsigned},
        {"//",NO,SetCppComm},
        {"make-app",NO,SetMakeApp},
        {"do-inline",NO,SetDoInline},
        {"stop-error",NO,SetStopError},
        {"far-pointers",NO,SetFarPtrs},
        {"no-header",NO,SetNoHeader},
        {"Wnone",NO,SetNoWarn},
        {"compact",NO,SetCompactCode},
        {"c-code",NO,SetCCode},
        {"D",YES,SetDefine},
        {"U",YES,SetUndefine},
        {"h",NO,DispInfo},
        {"v",NO,SetVerbose},
/* Compatibility Modes.. */
        {"f",NO,SetUnsigned},
        {"l",NO,SetFarPtrs},
        {"",0}
        };

void SetMathZ88(char *arg)
{
        mathz88=YES;
}

void SetUnsigned(char *arg)
{
        dosigned=YES;
}

void SetNoWarn(char *arg)
{
        dowarnings=NO;
}

void SetCppComm(char *arg)
{
        cppcom=YES;
}

void SetMakeApp(char *arg)
{
        ShowNotFunc(arg);
        appz88=YES;
}

void SetDoInline(char *arg)
{
        doinline=YES;
}

void SetStopError(char *arg)
{
        errstop=YES;
}

void SetFarPtrs(char *arg)
{
        ShowNotFunc(arg);
        lpointer=YES;
}

void SetNoHeader(char *arg)
{
        doheader=NO;
}

void SetCompactCode(char *arg)
{
        compactcode=YES;
}

void SetCCode(char *arg)
{
        ctext=1;
}

void SetDefine(char *arg)
{
        defmac(arg+1);
}

void SetUndefine(char *arg)
{
        strcpy(line,arg+1);
        delmac();
}

void DispInfo(char *arg)
{
        info();
}

void SetVerbose(char *arg)
{
        verbose=YES;
}


void ShowNotFunc(char *arg)
{
        fprintf(stderr,"Flag -%s is currently non-functional\n",arg);
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
        printf("Unrecognised argument: %s\n",arg);
}

/*
 *      This routine called via atexit to clean up memory
 */

void MemCleanup()
{
        if (litq) { free(litq); litq=0; }
        if (dubq) { free(dubq); dubq=0;}
        if (tempq) { free(tempq); tempq=0;}
        if (glbq) { free(glbq); glbq=0; }
        if (symtab) { free(symtab); symtab=0; }
        if (loctab) { free(loctab); loctab=0; }
        if (wqueue) { free(wqueue); wqueue=0; }
        if (tagtab) { free(tagtab); tagtab=0; }
        if (membtab) { free(membtab); membtab=0; }
        if (swnext) { free(swnext); swnext=0; }
        if (stage) { free(stage); stage=0; }
}

