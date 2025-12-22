#ifndef SPRT_H
#define SPRT_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

/************************************************************************/

struct SPRT
{
  UWORD Original;
  UWORD Flags;
};

/************************************************************************/

#define SPRTF_VERTICAL		(1<<0)
#define SPRTF_HORIZONTAL	(1<<1)
#define SPRTF_COPY		(1<<2)
#define SPRTF_NOMASK		(1<<3)
#define SPRTF_NOIMAGE		(1<<4)

#define SPRTF_ORIGINAL		(1<<15)

/************************************************************************/

#endif  /* SPRT_H */
