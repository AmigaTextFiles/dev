#ifndef ALLOCDATABUFFER_H
#define ALLOCDATABUFFER_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef API_AMIGA_API_H
#include <api/amiga_api.h>
#endif

VOID freeDataBuffer(struct DataBuffer * DB);
BOOL doAllocDataBuffer(struct DataBuffer * DB, int size);

BOOL allocDataBuffer(struct DataBuffer * DB, int size);

#endif /* ALLOCDATABUFFER_H */


