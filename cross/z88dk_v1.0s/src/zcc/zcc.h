/* 
 * Some standard defines which are the same for all machines - hopefully!
 *
 * $Id: zcc.h 1.6 1999/03/22 23:32:18 djm8 Exp $
 */


/* Some machine specific definitions (paths etc!) */

#ifdef AMIGA

char *amiver="$VER: zcc v2.33 (22.3.99)";
#endif

/* Insert your machines definitions in here... */

#ifdef MSDOS

#endif

#ifdef UNIX

#endif


/* 
 *      Now some fun stuff - all this moved out of zcc.c to clean
 *      things up a little bit!
 */

#define CFILE   1
#define PFILE   2
#define AFILE   3
#define OFILE   4

#define NO      0
#define YES     1

#define Z88MATH 1
#define GENMATH 2

#define LINEMAX 80      /* Max number of chars to read from config file*/

/*
 *      Sorry, this is hard coded, hopefully won't cause too many
 *      problems - needed to ensure math libs are linked in correctly!
 */

#define DEFFILE "zcc_opt.def"

struct args {
        char *name;
        char more;
        void (*setfunc)(char *);
};

struct confs {
        char *name;
        void (*setfunc)(char *,int);
        char *def;
};

enum iostyle { outimplied, outspecified, filter };

enum conf { OPTIONS, Z80EXE, CPP, LINKER, COMPILER, COPTEXE, COPYCMD, INCPATH, COPTRULES1, COPTRULES2, CRT0, LIBPATH, LINKOPTS, Z88MATHLIB, STARTUPLIB, GENMATHLIB };

