#include <clib/extras/packdata_protos.h>
#include <proto/exec.h>
#include <proto/utility.h>
#include <extras/packdata.h>

#include <exec/memory.h>
#include <string.h>
#include <tagitemmacros.h>

//#define DEBUG
#include <debug.h>

#define ALIGN(I)  (((I)+1)&(~1))
//#define PACKBYTE(PD,DATA) {BYTE data; data=DATA; 


#define STOREDATA(PDATA,INDEX,VALUE,TYPE)   \
{\
  TYPE *store;\
  INDEX=ALIGN(INDEX);\
  if(PDATA->pd_Data)\
  {\
    store=(TYPE *)(&(PDATA->pd_Data[INDEX]));\
    *store=VALUE;\
  }\
  (INDEX)+=sizeof(TYPE);\
}\



#define STOREBYTE(PDATA,INDEX,VALUE,TYPE)   \
{\
  TYPE *store;\
  if(PDATA->pd_Data)\
  {\
    store=(TYPE *)(&(PDATA->pd_Data[INDEX]));\
    *store=VALUE;\
  }\
  (INDEX)+=sizeof(TYPE);\
}\

LONG pd_subPackData(struct PackedData *PD,struct TagItem *TagList);



struct PackedData *pd_PackData(Tag Tags, ...)
{
  struct PackedData pd,*npd;
  ULONG pdo;
  struct TagItem mytags[]=
  {
    PD_StructSize, 0,
    PD_Struct,     0,
    TAG_MORE,      0
  };
  LONG size;
  
  mytags[0].ti_Data=sizeof(pdo),
  mytags[1].ti_Data=&pdo,
  mytags[2].ti_Data=(ULONG)&Tags;
  
  pd.pd_Data=0;
  size=pd_subPackData(&pd,(struct TagItem *)mytags);
  if(size>0)
  {
    if(npd=PD_AllocPackedData(size))
    {
      if(size==pd_subPackData(npd,(struct TagItem *)mytags))
      {
        return(npd);
      }
      else
      PD_FreePackedData(npd);
    }
  }
  return(0);
}

LONG pd_subPackData(struct PackedData *PD,struct TagItem *TagList)
{
  LONG i=0,data,aptrsize=0,structsize=0;
  struct TagItem *tag,*tstate;
  
  aptrsize=0;
  
  ProcessTagList(TagList,tag,tstate)
  {
    data=tag->ti_Data;
    
//    DKP("i=%ld\n",i);
    
    switch(tag->ti_Tag)
    {
      case PD_Version: // It's a ULONG
        STOREDATA(PD,i,data,ULONG);
        break;

      case PD_BYTE:
        STOREBYTE(PD,i,data,BYTE);
        break;

      case PD_UBYTE:
        STOREBYTE(PD,i,data,UBYTE);
        break; 

      case PD_WORD:
        STOREDATA(PD,i,data,WORD);
        break;

      case PD_UWORD:
        STOREDATA(PD,i,data,UWORD);
        break;

      case PD_LONG:
        STOREDATA(PD,i,data,LONG);
        break;

      case PD_ULONG:
        STOREDATA(PD,i,data,ULONG);
        break;

      case PD_STRPTR:
        if(!data) 
          data=(ULONG)"";
        
        {
          LONG sl;
          
          i=ALIGN(i);
          sl=strlen((STRPTR)data)+1;
          if(PD->pd_Data)
          {
            CopyMem((APTR)data,(APTR)(&PD->pd_Data[i]),sl);
          }
          i+=sl;
        }
        break;
        
      case PD_APTRSize:
        aptrsize=data;
        STOREDATA(PD,i,data,LONG);
        break;
        
      case PD_APTR:
        i=ALIGN(i);
        
        if(PD->pd_Data && data)
        {
          CopyMem((APTR)data,(&PD->pd_Data[i]),aptrsize);
        }
        i+=aptrsize;
        break;
        
      case PD_BufferSize:
        structsize=data;
        break;
        
      case PD_Buffer:
        i=ALIGN(i);
        
        STOREDATA(PD,i,structsize,LONG);
        if(PD->pd_Data && data)
        {
          CopyMem((APTR)data,(&PD->pd_Data[i]),structsize);
        }
        i+=structsize;
        break;  
        
      default:
//        DKP("Unknow Tag %ld, %ld (%08lx, %08lx)\n",tag[0],tag[0]);
        /* ERROR */
        return(-1);
    }
  }
  return(i);
}  

struct PackedData *pd_AllocPackedData(ULONG Size)
{
  struct PackedData *pd;
  if(pd=AllocVec(sizeof(*pd),MEMF_CLEAR|MEMF_PUBLIC))
  {
    pd->pd_DataSize=Size;
    if(pd->pd_Data=AllocVec(Size,MEMF_CLEAR|MEMF_PUBLIC))
    {
      return(pd);
    }
    FreeVec(pd);
  }
  return(0);
}

void pd_FreePackedData(struct PackedData *PD)
{
  if(PD)
  {
    FreeVec(PD->pd_Data);
    FreeVec(PD);
  }
}
