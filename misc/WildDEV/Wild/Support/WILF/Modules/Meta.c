#include <meta.h>
#include <inline/exec.h>
#include <exec/exec.h>
#include <exec/lists.h>

extern struct ExecBase *SysBase;

void CommonInit(struct Common *com,struct Common *par)
{
 NewList(com->com_Attrs); 
 NewList(com->com_Childs); 
 if (par) 
  {AddTail(&par->com_Childs,&com->com_Node);}
}

struct Meta *NewMeta(struct Common *parent) 			// parent may be 0
{ULONG *pool; 
 struct Meta *meta;
 pool=CreatePool(MEMF_CLEAR+MEMF_ANY,32768,16384); 
 meta=AllocPooled(pool,sizeof(struct Meta)); 
 CommonInit(meta,parent); 
 meta->meta_Pool=pool;
 NewList(meta->meta_Flags); 
 return(meta);
}

struct Group *NewGroup(struct Meta *meta,char *type)
{
 struct Group *group;
 group=AllocMetaMem(meta,sizeof(struct Group)); 
 CommonInit(group,meta); 
 CopyWord((struct Group *)&group->group_Type,type); 
 return(group);
}

struct Entity *NewEntity(struct Group *group,struct Meta *meta,int ID) 
{
 struct Entity *enty;
 enty=AllocMetaMem(meta,sizeof(struct Entity)); 
 CommonInit(enty,group); 
 enty->entity_ID=ID; 
 return(enty);
}

struct Attr *GenAttr(struct Meta *meta,char *name,char *value)
{
 struct Attr *attr;
 attr=AllocMetaMem(meta,sizeof(struct Attr)); 
 CopyWord(&attr->attr_Name,name); 
 CopyStr(&attr->attr_Value,value); 
 return(attr);
}

struct Attr *NewAttr(struct Common *com,struct Meta *meta,char *name,char *value)
{
 struct Attr *attr;
 attr=GenAttr(meta,name,value);
 AddTail(&com->com_Attrs,&attr->attr_Node); 
 return(attr);
}

struct Attr *NewFlag(struct Meta *meta,char *name,char *value)
{
 struct Attr *attr;
 attr=GenAttr(meta,name,value);
 AddTail(&meta->meta_Flags,&attr->attr_Node);
 return(attr);
}

char *HaveAttrValue(struct Common *com,char *name)
{
 struct Attr *catt,*natt;
 catt=com->com_Attrs.mlh_Head;
 while (natt=catt->attr_Node.mln_Succ)
  {
   if (StrCmp(catt->attr_Name,name))
    {return(catt->attr_Value);}
   catt=natt;
  }
 return(FALSE);
}

