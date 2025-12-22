
/*
 *  OPENLIBS.C
 *
 */

#include <local/typedefs.h>
#include <local/xmisc.h>
#ifdef LATTICE
#include <string.h>
#endif

static long OpenMask = 0;

struct GfxBase *GfxBase 	    = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Library *ExpansionBase	    = NULL;
struct Library *DiskfontBase	    = NULL;
struct Library *TranslatorBase	    = NULL;
struct Library *IconBase	    = NULL;
struct Library *MathBase	    = NULL;
struct Library *MathTransBase	    = NULL;
struct Library *MathIeeeDoubBasBase = NULL;
struct Library *MathIeeeSingBasBase = NULL;
struct LayersBase *LayersBase	    = NULL;
struct Library *ClistBase	    = NULL;
struct Library *PotgoBase	    = NULL;
struct Library *TimerBase	    = NULL;
struct Library *DResBase	    = NULL;
long xfiller15			    = NULL;

struct OLI {
    char *name;
    long *var;
};

struct OLI strvar[] = {
  "graphics",           (long *)&GfxBase,
  "intuition",          (long *)&IntuitionBase,
  "expansion",          (long *)&ExpansionBase,
  "diskfont",           (long *)&DiskfontBase,
  "translator",         (long *)&TranslatorBase,
  "icon",               (long *)&IconBase,
  "mathffp",            (long *)&MathBase,
  "mathtrans",          (long *)&MathTransBase,
  "mathieeedoubbas",    (long *)&MathIeeeDoubBasBase,
  "mathieeesingbas",    (long *)&MathIeeeSingBasBase,
  "layers",             (long *)&LayersBase,
  "clist",              (long *)&ClistBase,
  "potgo",              (long *)&PotgoBase,
  "timer",              (long *)&TimerBase,
  "dres",               (long *)&DResBase,
  "x15",                (long *)&xfiller15
};

int
openlibs(mask)
uword mask;
{
    register struct OLI *sv;
    register short i;
    char buf[64];

    for (i = 0; i < sizeof(strvar)/sizeof(strvar[0]); ++i) {
	sv = strvar + i;

	if (*sv->var == 0 && (mask & (1 << i))) {
	    strcpy(buf, sv->name);
	    strcat(buf, ".library");
	    if (*sv->var == 0 && (*sv->var = (long)OpenLibrary(buf, 0)) == 0) {
		closelibs(mask);
		return(0);
	    }
	    OpenMask |= 1 << i;
	}
    }
    return(1);
}

/*
 * CLOSELIBS(mask)
 *
 *	Close the indicated libraries.	Does not close libraries which
 *	have not been openned with OPENLIBS()
 */

void
closelibs(mask)
uword mask;
{
    register struct OLI *sv;
    register short i;

    for (i = 0; i < sizeof(strvar)/sizeof(strvar[0]); ++i) {
	sv = strvar + i;
	if ((mask & (1 << i)) && *sv->var && (OpenMask & (1 << i))) {
	    CloseLibrary((struct Library *)*sv->var);
	    *sv->var = 0L;
	    OpenMask &= ~(1 << i);
	}
    }
}

