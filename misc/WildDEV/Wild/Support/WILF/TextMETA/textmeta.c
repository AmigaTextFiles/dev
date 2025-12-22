
#include <exec/types.h>
#include <meta.h>
#include <io.h>
#include <inline/dos.h>
#include <exec/libraries.h>
#include <inline/exec.h>

extern struct Library *DOSBase;
extern struct ExecBase *ExecBase;

#define ARG_FILE	0
#define TXT_Attrs	"Attributes:\n"
#define TXT_Childs	"Childs:\n"

ULONG outfh=NULL;

void ShowAttr(struct Attr *att)
{
 Write(outfh,&att->attr_Name,StrLen(&att->attr_Name));
 Write(outfh,"     ",5);
 Write(outfh,&att->attr_Value,StrLen(&att->attr_Value));
 Write(outfh,'\n',1);
}

void ShowChilds(struct Common *com);

void ShowObj(struct Common *com)
{
 struct Attr *catt,*natt;
 Write(outfh,TXT_Attrs,sizeof(TXT_Attrs));
 catt=com->com_Attrs.mlh_Head;
 while (natt=catt->attr_Node.mln_Succ)
  {
   ShowAttr(catt);
   catt=natt;
  }
 Write(outfh,TXT_Childs,sizeof(TXT_Childs)); 
 ShowChilds(com);
}

void ShowChilds(struct Common *com)
{
 struct Common *ccom,*ncom;
 ccom=com->com_Childs.mlh_Head;
 while (ncom=ccom->com_Node.mln_Succ)
  {
   ShowObj(ccom);
   ccom=ncom;
  }
}

int main()
{
 ULONG *rda,arg[1];
 if (rda=ReadArgs("FILE/A",arg,NULL))
  {
  struct Meta *meta;
  if (meta=LoadMETA(arg[0]))
   {
    outfh=Output();
    
    ShowObj(meta);   
      
    FreeMETA(meta);
   }
  }
}