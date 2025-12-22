
/*
 *  BREAK.C
 */

#include <local/typedefs.h>

extern int Enable_Abort;

void
disablebreak()
{
    Enable_Abort = 0;
}

void
enablebreak()
{
    Enable_Abort = 1;
}


