
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/asl.h>

#include <exec/exec.h>
#include <devices/trackdisk.h>

#include "work:libs/lhlib/lhlib.h"

typedef struct Offsetpair { LONG offset,length; } OPAIR;

