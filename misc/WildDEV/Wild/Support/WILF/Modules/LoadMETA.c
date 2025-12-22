#include <exec/types.h>
#include <inline/dos.h>
#include <IO.h>
#include <Strings.h>
#include <meta.h>
#include <exec/exec.h>
extern struct Library *DOSBase;
extern struct ExecBase *SysBase;

#define MAXIN	256

ULONG *LoadMETA(char *file)
{
 ULONG *fh;
 if (fh=Open(file,MODE_OLDFILE))
  {
   int chk=NULL;
   char linein[MAXIN];
   char use[32];
   struct Meta *meta;				// current meta
   struct Group *group;				// current group
   struct Entity *enty;				// current entity
   struct Common *com;				// current object to define attrs
   meta=NewMeta(0L);
   com=meta;
   while (LineInput(fh,linein,MAXIN))
    {
     switch (linein[0])
      {
       case META_STARTER:
        {
         chk++;
         if (ChkIn(&linein[1],"Group"))
          {
           CopyWord(use,NextWord(&linein[1]));
           group=NewGroup(meta,use);           
           com=group;
           break;
          }
         if (ChkIn(&linein[1],"Entity"))
          {
           int ID;
           CopyWord(use,NextWord(&linein[1]));
           StrToLong(use,&ID);
	   enty=NewEntity(group,meta,ID);
	   com=enty;
	   break;
          }
        break;				// GCC BUG WAR
        }
       case META_FINISHER:
        {
         chk--;
         if (ChkIn(&linein[1],"Group"))
          {
           com=meta;
           break;
          }
         if (ChkIn(&linein[1],"Entity"))
          {
	   com=group;
	   break;
          }
        break;				// GCC BUG WAR
        }        
       case META_ATTR:
        {
         NewAttr(com,meta,&linein[1],NextWord(&linein[1]));
         break;
        }
       case META_FLAG:
        {
         NewFlag(meta,&linein[1],NextWord(&linein[1]));
         break;
        }       
      }      
    }
   return(meta);
  } 
 return(FALSE);
}

void	FreeMETA(struct Meta *meta)
{
 DeletePool(meta->meta_Pool);
}