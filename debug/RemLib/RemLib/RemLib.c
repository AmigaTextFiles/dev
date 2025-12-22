
#include <exec/types.h>
#include <exec/libraries.h>
#include <exec/execbase.h>
#include <dos/dosasl.h>
#include <functions.h>
#include <macros/macros.h>

char *VERSION="$VER: RemLib 1.20 (2.8.92) written by H.P.G 1992";

char *Template = "LibName/M/A";
char **array = NULL;
struct RDArgs *CArgs;
void _main(void);
char *HelpText="Usage: RemLib LibName/M/A\n";

extern struct ExecBase *SysBase;

void _main(void)
    {
    struct Library *found=0L;
    LONG index=0L;

    if (!(CArgs=(struct RDArgs *)ReadArgs(Template,(LONG *)&array,NULL) ))
        {
        PUTS(HelpText);
        exit(10);
        }

    LoopStart:

    while (array[index])
        {
        Forbid();
        if (found = (struct Library *)
        FindName((struct List *)&SysBase->LibList , array[index] )) RemLibrary(found);

        if (!found)
            {
            Permit();
            PUTS("Library \033[32m");
            PUTS(array[index]);
            PUTS(" \033[31mnot found\n");
            index++;
            goto LoopStart;
            }

        if (found = (struct Library *)FindName((struct List *)&SysBase->LibList , array[index] ))
            {
            PUTS("Library \033[32m");
            PUTS(array[index]);
            PUTS(" \033[31mcould not be removed\n");
            }
        else{
            PUTS("Library \033[32m");
            PUTS(array[index]);
            PUTS(" \033[31mremoved\n");
            }

        Permit();
        index++;
        } /* while array[index] */

        if (CArgs) FreeArgs(CArgs);
        exit(0);
    }

