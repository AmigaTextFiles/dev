#ifdef DEBUG
#include <clib/debug_protos.h>
//#define DB(x) KPrintf("NewImage.mcc: "); x;
#define DB(x) KPrintf("NewImage.mcc ($%08.lx): ",d->this); x;
#else
#define DB(x)
#endif
