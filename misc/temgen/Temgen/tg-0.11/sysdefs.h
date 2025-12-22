#ifndef __sysdefs_h_
#define __sysdefs_h_

#include "config.h"

#include <errno.h>

#if STDC_HEADERS
#  include <stdarg.h>
#  include <stdlib.h>
#  include <string.h>
#else
#  error System has no ANSI header files
#endif

#include <stdio.h>

#include <sys/types.h>
#if HAVE_SYS_WAIT_H
#  include <sys/wait.h>
#else
#  ifndef WEXITSTATUS
#     define WEXITSTATUS(v) ((unsigned)(v) >> 8) 
#  endif
#  ifndef WIFEXITED
#     define WIFEXITED(v) (((v) & 255) == 0)
#  endif
#endif

#endif
