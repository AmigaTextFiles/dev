#include <clib/extras/packdata_protos.h>
#include <clib/extras/string_protos.h>

#include <proto/exec.h>
#include <proto/utility.h>

#include <extras/packdata.h>
#include <math.h>
#include <exec/memory.h>
#include <string.h>
#include <tagitemmacros.h>

#define ALIGN(I)  (((I)+1)&(~1))

#define YANKBYTE(PDATA,INDEX,STORAGE,TYPE)   \
{\
  TYPE *store;\
\
  store=((TYPE *)STORAGE);\
  if(store)\
  {\
    *store=*((TYPE *)(&((PDATA)->pd_Data[INDEX])));\
  }\
  (INDEX)+=sizeof(TYPE);\
}\

#define YANKDATA(PDATA,INDEX,STORAGE,TYPE)   \
{\
  TYPE *store;\
\
  store=((TYPE *)STORAGE);\
  INDEX=ALIGN(INDEX);\
  if(store)\
  {\
    *store=*((TYPE *)(&((PDATA)->pd_Data[INDEX])));\
  }\
  (INDEX)+=sizeof(TYPE);\
}\

extern ULONG PDO;

LONG pd_UnpackData(struct PackedData *PD, Tag Tags, ...)
{
  struct TagItem *tag,*tstate;
  LONG i=0,data,aptrsize,structsize,memflags,version,freestrptr=0;
  BYTE **dptr;

  ULONG pdo;
  struct TagItem mytags[]=
  {
    PD_StructSize, 0,
    PD_Struct,     0,
    TAG_MORE,      0
  };
  
  mytags[0].ti_Data=sizeof(pdo),
  mytags[1].ti_Data=&pdo,
  mytags[2].ti_Data=(ULONG)&Tags;


  memflags=0;
  version=0;

  if(PD)
  {
    if(PD->pd_Data)
    {
      ProcessTagList((struct TagItem *)&mytags,tag,tstate)
      {
        data=tag->ti_Data;
        dptr=(BYTE **)data;
        switch(tag->ti_Tag)
        {
          case PD_FreeSTRPTR:
            freestrptr=data;
            break;
            
          case PD_Version: // It's a ULONG
            YANKDATA(PD,i,&version,ULONG);
            if(dptr)
            {
              *((ULONG *)dptr)=version;
            }
            break;
    
          case PD_BYTE:
            YANKBYTE(PD,i,data,BYTE);
            break;
    
          case PD_UBYTE:
            YANKBYTE(PD,i,data,UBYTE);
            break; 
    
          case PD_WORD:
            YANKDATA(PD,i,data,WORD);
            break;
    
          case PD_UWORD:
            YANKDATA(PD,i,data,UWORD);
            break;
    
          case PD_LONG:
            YANKDATA(PD,i,data,LONG);
            break;
    
          case PD_ULONG:
            YANKDATA(PD,i,data,ULONG);
            break;
    
          case PD_STRPTR:
            {
              LONG sl;
              
              i=ALIGN(i);
              sl=strlen((STRPTR)&PD->pd_Data[i])+1;
              if(dptr)
              {
                if(*dptr && freestrptr) 
                  FreeVec(*dptr);
                
                *dptr=CopyString(&PD->pd_Data[i],memflags); // WARNING no error code!
              }
              i+=sl;
            }
            break;

          case PD_APTRSize:
            YANKDATA(PD,i,&aptrsize,LONG); 
            i-=4; // Backup 4 bytes
            YANKDATA(PD,i,data,ULONG);
            break;

          case PD_APTR:
            i=ALIGN(i);
            
            if(dptr)
            {  
              if(*dptr=AllocVec(aptrsize,memflags)) // WARNING no error code!
              {
                CopyMem((&PD->pd_Data[i]),*dptr,aptrsize); 
              }
            }
            i+=aptrsize;
            break;

          case PD_BufferSize:
            structsize=data;
            break;

          case PD_Buffer:
            i=ALIGN(i);
            {
              ULONG datasize;
            
              YANKDATA(PD,i,&datasize,LONG);
              
              if(dptr)
              { 
                CopyMem((&PD->pd_Data[i]),dptr,min(datasize,structsize)); 
              }
              i+=datasize;
            }
            break;
            
            
          case PD_MemoryFlags:
            memflags=data;
            break;
            
          case PD_IfVersion:
            if(version<data)
              return(0);
            break;
              
          default:
            /* ERROR */
            return(-1);
        }
      }
    }
  }
  return(0);
}
