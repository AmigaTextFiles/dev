#ifndef CLIB_EXTRAS_BOOPSI_PROTOS_H
#define CLIB_EXTRAS_BOOPSI_PROTOS_H

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#ifndef  INTUITION_CGHOOKS_H
#include <intuition/cghooks.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

struct GadgetInfo *boopsi_GetGInfo(Msg Message);

#define GetGInfo boopsi_GetGInfo // alias, some of my old code uses GetGInfo()

#endif /* CLIB_EXTRAS_BOOPSI_PROTOS_H */
