
#include <clib/extras/packdata_protos.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>
#include <proto/dos.h>
#include <stdio.h>
#include <exec/memory.h>
#include <stdlib.h>

#include <extras/packdata.h>

void main(void)
{
  struct PackedData *pd;
  struct IBox box={0,0,50,50};
  
  LONG l,l1,l2,l3;
  WORD w1;
  BYTE b1,b2;
  STRPTR s1,s2;
  
  l1=l2=l3=0;
  w1=0;
  b1=b2=0;
  s1=s2=0;
  
  if(pd=PD_PackData(PD_Version, 1,
                    PD_BYTE,    1,
                    PD_BYTE,    0x0f,
                    PD_BYTE,    0xaa,
                    PD_WORD,    0x1234,
                    /* begin of version 1 */
                    PD_STRPTR,  "needspad",
                    PD_ULONG,   0x89abcdef,
                    PD_STRPTR,  "nopad",
                    PD_ULONG,   0x76543210,
                    PD_STRUCT(box),
                    0,0))
  {
    for(l=0;l<pd->pd_DataSize;l++)
      printf("%02x ",pd->pd_Data[l]);
    printf("\n");
    
    PD_UnpackData(pd,
                PD_Version,   0,
                PD_BYTE,      &b1,
                PD_BYTE,      &b2,
                PD_BYTE,      0,   // set it to 0, to skip an item w/o storing it.
                PD_WORD,      &w1,
                
                PD_IfVersion, 1,   // Only proceed if PD_Version above is atleast 1  
                PD_STRPTR,    &s1,
                PD_ULONG,     &l1,
                PD_STRPTR,    &s2,
                PD_ULONG,     &l2,
                PD_STRUCT(box),
                
                0,0);
    
    printf("b1=%2x b2=%2x   w1=%4x   l1=%8x l2=%8x l3=%8x   s1=%20s s2=%20s\n",b1,b2,w1,l1,l2,l3,s1,s2);
    printf("ibox %d %d %d %d\n",box.Left, box.Top, box.Width, box.Height);
    
    FreeVec(s1);
    FreeVec(s2);
    
    PD_FreePackedData(pd);
  }
}
