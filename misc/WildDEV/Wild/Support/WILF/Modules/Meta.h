#ifndef	META_DEFS
#define META_DEFS

#include <inline/dos.h>
#include <inline/exec.h>

struct Common
{
 struct	MinNode		com_Node;
 struct MinList		com_Attrs;
 struct MinList		com_Childs;
};

struct Meta
{
 struct MinNode		meta_Node;
 struct MinList		meta_Attrs;			// attributes
 struct MinList		meta_Groups;
 struct MinList		meta_Flags;			// flags (% char)
 ULONG			*meta_Pool;
};

struct Group
{
 struct MinNode		group_Node;
 struct MinList		group_Attrs;			// attributes
 struct MinList		group_Entities;
 char			group_Type[32];			// entity type
};

struct Entity
{
 struct MinNode		entity_Node;
 struct MinList		entity_Attrs;			// attributes
 struct MinList		entity_Childs;			// None, now
 int			entity_ID;
};

struct Attr						// is also for FLAG!
{
 struct MinNode		attr_Node;
 char			attr_Name[32];
 char			attr_Value[512];
};

#define AllocMetaMem(meta,siz) AllocPooled((struct Meta *)meta->meta_Pool,siz)
#define FreeMetaMem(meta,siz) FreePooled((struct Meta *)meta->meta_Pool,siz)

extern struct Meta *NewMeta(struct Common *parent);
extern struct Group *NewGroup(struct Meta *meta,char *type);
extern struct Entity *NewEntity(struct Group *group,struct Meta *meta,int ID);
extern struct Attr *NewAttr(struct Common *com,struct Meta *meta,char *name,char *value);
extern struct Attr *NewFlag(struct Meta *meta,char *name,char *value);
extern char *HaveAttrValue(struct Common *com,char *name);

#define META_STARTER '#'
#define META_FINISHER '-'
#define META_ATTR '$'
#define META_FLAG '%'

#endif

