#ifndef __INC_COCKTEL_CLIB_COCKTEL_PROTOS_H
#define __INC_COCKTEL_CLIB_COCKTEL_PROTOS_H
/*******************************************************************
 $CRT 30 Jul 1996 : hb

 $AUT Holger Burkarth
 $DAT >>cocktel_protos.h<<   30 Jul 1996    10:00:33 - (C) ProDAD
*******************************************************************/
#include <exec/types.h>

struct COCKTEL_AudioTransHeader;
struct COCKTEL_VideoTransHeader;
struct TagItem;


/*\
*** VIDEO-Library
\*/

APTR  VIPK_CreateA(const struct TagItem*);
VOID  VIPK_Delete(APTR);
ULONG VIPK_Pack(APTR,const struct COCKTEL_VideoTransHeader* ath,
                 UBYTE* buffer,ULONG bufSize,ULONG frameMode,ULONG packMode);
ULONG VIPK_Unpack(APTR,const struct COCKTEL_VideoTransHeader* ath,
                 const UBYTE* buffer,ULONG bufSize);



/*\
*** AUDIO-Library
\*/

APTR  AUPK_CreateA(ULONG);
VOID  AUPK_Delete(APTR);
ULONG AUPK_Pack(APTR,struct COCKTEL_AudioTransHeader* ath,
                  const BYTE* src,size_t srcSize,UBYTE* buffer,size_t bufSize);
ULONG AUPK_Unpack(APTR,const struct COCKTEL_AudioTransHeader* ath,
                  const UBYTE* src,BYTE* buffer);


#endif
