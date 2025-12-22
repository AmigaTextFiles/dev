#include "global.h"

UINT sgets(UCHAR *String, UINT Size, UCHAR *Buffer)
{
register UINT t;
for(t=0; t<Size && Buffer[t] && (Buffer[t]!='\x0D'); t++) String[t]=Buffer[t];
String[t]='\0';
if(Buffer[t]=='\x0D') t++;
if(Buffer[t]=='\x0A') t++;
DelNBin(Buffer, RESPONSE_SIZE, 0, t);
return t;
}
