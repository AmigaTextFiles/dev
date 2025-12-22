#ifndef EXTRAS_LIBS_H
#define EXTRAS_LIBS_H

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif


struct Libs
{
  APTR  *LibBase;
  STRPTR LibName;
  ULONG  Version,
         Flags;
};

#define OLF_OPTIONAL (1<<0) 

/****  OBSOLETE ****

#ifdef EXTRAS_LIBS_DEF_ERROR_STRINGS
#ifndef EXTRAS_LIBS_ERRORS
#define EXTRAS_LIBS_ERRORS
extern STRPTR LibErrorString = "Couldn't open the following libraries:";
extern STRPTR LibNameVerFmt  = "\n  %s version %d";
extern STRPTR LibOk          = "Ok";
#endif
#endif

struct Libs
{
  APTR  *LibBase;
  STRPTR LibName;
  ULONG  Version;
};

*/



#endif /* EXTRAS_LIBS_H */
