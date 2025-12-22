#ifndef EXTRAS_IFFX_H
#define EXTRAS_IFFX_H

#include <exec/types.h>
#include <utility/tagitem.h>

#define DC_DUMMY     TAG_USER

/* Note these are not pointers */
#define DC_BYTE      (0 + DC_DUMMY)
#define DC_UBYTE     (1 + DC_DUMMY)
#define DC_WORD      (2 + DC_DUMMY)
#define DC_UWORD     (3 + DC_DUMMY)
#define DC_LONG      (4 + DC_DUMMY) 
#define DC_ULONG     (5 + DC_DUMMY)

#define DC_STRPTR    (7 + DC_DUMMY) /* NULL termited string pointer */

#define DC_SizeofAPTR (8 + DC_DUMMY) /* Length in bytes */ 
#define DC_APTR      (9 + DC_DUMMY) /* (*)) */ 

#define DC_Chunk     DC_APTR        /* an alias */

#define DC_ArrayIndex
#define DC_ArrayCount     // 
/* These two are mutually exclusive */
#define DC_ArrayItemSize  // Size of an item in bytes
#define DC_ArrayOf        // See DCA_?



#define DCA_BYTE     1
#define DCA_WORD     2
#define DCA_LONG     3
#define DCA_STRPTR   4

struct iffx_APTRDesc
{
  APTR  ad_Data;
  ULONG ad_Size;
};

#endif
