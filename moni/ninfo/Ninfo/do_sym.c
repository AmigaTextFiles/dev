/* Symbol Processing and I/O routines */
#include "hunk.h"
extern Flgs[26];
unsigned char OneChar(file)  /* read one character from file */
  BPTR file;
  {
  unsigned char c;
  if( Read(file,&c,1) == 1)
    {
    return (c);
    };
  return (0); /* errors and eof */
  }

int GrabThree(file) /* get a three byte value */
  BPTR file;
  {
  unsigned char out[4];
  int  i,j;
  char *cp;
  i = 0;
  if( Read(file,&out[1],3) == 3 )
    {
    out[0] = 0;
    cp = (char *)&i;
    for(j=0; j<4; j++)*cp++=out[j];
    return ( i );
    } ;
  return (0);
  }

int GrabLong(file)
  BPTR file;
  {
  int data;
  if( Read(file,(UBYTE *)&data,4L) == 4)
    {
    return ( data );
    }  ;
  return(0);
  }

void DoSymbolData(file)
  BPTR file;
  {
  register   int type,i,length,t0;
  char *Data;
  while (1)
    {
    type   = OneChar(file);
    length = GrabThree(file);
    if( length > 32 )
      {
      printf(" Error in symbol length=%d\n",length);
      length = 32;
      };
    if ( type == 0 && length == 0 ) break;
    if( ! Flgs[18] )
      {
    switch (type)
      {
      case Ext_symbol: printf("Ext_symbol"); break;
      case Ext_def   : printf("Ext_def   "); break;
      case Ext_abs   : printf("Ext_abs   "); break;
      case Ext_res   : printf("Ext_res   "); break;
      case Ext_ref32 : printf("Ext_ref32 "); break;
      case Ext_common: printf("Ext_common"); break;
      case Ext_ref16 : printf("Ext_ref16 "); break;
      case Ext_ref8  : printf("Ext_ref8  "); break;
      case Ext_dref32: printf("Ext_dref32"); break;
      case Ext_dref16: printf("Ext_dref16"); break;
      case Ext_dref8 : printf("Ext_dref8 "); break;
      default:
      printf(" Unknown Symbol Reference %x (%d)",type,type);
      type = Ext_ref32; /* try to recover! */
      };
    printf("(%x, %x):",type,length);
    };
    Data = malloc(length*4);
    (void)Read(file,Data,length*4);
    length = GrabLong(file);  /* get either the count or value */
    switch (type)
      {
      case Ext_symbol:
      case Ext_def   :
      case Ext_abs   :
      case Ext_res   :
      if( ! Flgs[18] )
        {
        printf(" Value = %08.08X(%d)",length,length);
        printf(" %s\n",Data);
        }
      break;
      case Ext_common:
      if( ! Flgs[18] )printf(" Size of Common = %d 32 bit words",length);
      length = GrabLong(file);  /* get number of references */
      case Ext_ref16 :
      case Ext_ref32 :
      case Ext_ref8  :
      case Ext_dref32:
      case Ext_dref16:
      case Ext_dref8 :
      if( ! Flgs[18] )
        {
        printf(" %s",Data);
        printf("(%d references)\n",length);
        (void)Dump_Raw(file,Hunk_Data,length);
        }
      else
        {
        t0 = Flgs[3];
        Flgs[3] = TRUE;
        (void)Dump_Raw(file,Hunk_Data,length);
        Flgs[3] = t0;
        };
      free(Data);
      };
    };
  }
