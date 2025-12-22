/*
** ObjectiveAmiga: Interface to Kit objam
** See GNU:lib/libobjam/ReadMe for details
*/

#ifndef __OBJAM__
#define __OBJAM__

#define OA_FREE(o) { if(o) [o free]; }
#define OA_PURGE(o) { if(o) { [o free]; o=nil; } }

#endif
