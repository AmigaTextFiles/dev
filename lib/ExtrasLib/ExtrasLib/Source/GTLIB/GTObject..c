#include <extras/gtobject.h>

#define GTNT_CONTEXT  1
#define GTNT_GRPDATA  2
#define GTNT_GADDATA  3

struct gto_Object
{
  struct Node o_Node;
  struct Node *o_MemberOf;
  struct Gadget *o_Gadget;
  struct TagList *o_GTA_Tags
  struct Point o_Dimensions[3];
};

struct gto_Context
{
  struct gto_Object c_Object;
  struct List c_Members; 
};

struct gto_GrpData
{
  struct gto_Object gd_Object;
  ULONG  gd_Class;
  struct List gd_Members; 
};
  
struct gto_GadData
{
  struct gto_Object gd_Object;
  struct NewGadget  gd_NewGadget;  // NewGadget struct for Layout
  struct Gadget     *gd_Gadget;    // Created gadget
  struct TagItem    *gd_TagList;
  ULONG  gd_Flags;
};

void GTO_NewObject(struct TagItem *TagList)
{
  
  
}

#define GTM_LAYOUT
#define GTM_ADDGROUP
#define GTM_REMOVEGROUP

