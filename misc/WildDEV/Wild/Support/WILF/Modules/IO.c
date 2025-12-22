
#include <inline/dos.h>

extern struct Library *DOSBase;

ULONG LineInput(ULONG *fh,char *line,int max)
{
 return(FGets(fh,line,max)); 
}