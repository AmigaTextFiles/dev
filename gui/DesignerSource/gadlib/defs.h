
/*
 *  DEFS.H
 */

#define abs
#include <exec/types.h>
#include <exec/ports.h>
#include <exec/semaphores.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <string.h>

#define LibCall __geta4 __regargs
#define Prototype extern

typedef struct Message Message;
typedef struct Library Library;
typedef struct Node    Node;
typedef struct List    List;
typedef struct SignalSemaphore SignalSemaphore;

/*
 *  include lib-protos.h AFTER our typedefs (though it doesn't matter in
 *  this particular test case)
 */

#include <lib-protos.h>

extern const char LibName[];
extern const char LibId[];

