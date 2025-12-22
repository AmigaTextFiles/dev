#include <proto/exec.h>
#include <dos/dos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <string.h>

#define REG(x)     register __##x
#define LibCall    __saveds
#define Prototype  extern

#include "golded:developer/include/editor.h"

#include "golded:developer/api/include/apilib.h"

#include "lib-protos.h"

#ifndef RC_OK
#define RC_OK   0L
#endif

#ifndef RC_WARN
#define RC_WARN 5L
#endif

extern const char LibName[];
extern const char LibId[];
