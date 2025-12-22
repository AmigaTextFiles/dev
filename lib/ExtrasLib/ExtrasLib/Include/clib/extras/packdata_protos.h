#ifndef CLIB_EXTRAS_PACKDATA_PROTOS_H
#define CLIB_EXTRAS_PACKDATA_PROTOS_H

#ifndef EXTRAS_PACKDATA_H
#include <extras/packdata.h>
#endif

struct PackedData *pd_AllocPackedData(ULONG Size);
void pd_FreePackedData(struct PackedData *PD);

struct PackedData *pd_PackData(Tag Tags, ...);
LONG pd_UnpackData(struct PackedData *PD, Tag Tags, ...);

#define PD_AllocPackedData pd_AllocPackedData
#define PD_FreePackedData  pd_FreePackedData
#define PD_PackData   pd_PackData
#define PD_UnpackData pd_UnpackData


#endif /* CLIB_EXTRAS_PACKDATA_PROTOS_H */
