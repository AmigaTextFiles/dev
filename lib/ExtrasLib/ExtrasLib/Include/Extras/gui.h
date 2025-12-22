#ifndef EXTRAS_GUI_H
#define EXTRAS_GUI_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

struct GUI_String
{
  WORD NormalSize;
  STRPTR String;
};

struct BevelBox
{
  WORD X,Y,Width,Height,Scale;
};

#define BBSCALE_WIDTH   (1<<0)
#define BBSCALE_HEIGHT  (1<<1)


/* A better use for ng_VisualInfo */
#define ng_LayoutFlags  ng_VisualInfo

/* custom ng_Flags value */ 
/* ng_VisualInfo */
#define NG_FITLABEL         0x8000000
#define NG_JUST_LABEL       0x4000000
#define NG_JUST_RIGHT       0x2000000
#define NG_JUST_HORIZCENTER 0x1000000
#define NG_JUST_BOTTOM      0x0800000
#define NG_JUST_VERTCENTER  0x0400000   
#define NG_JUST_LEFT        0  /* For no other reason than consistency */ 
#define NG_JUST_TOP         0  /* For no other reason than consistency */ 

#define NG_REAL_GT_FLAGS    0x03fffff

/*
struct MakeGadgets Context
{
  struct Gadget *GadList;
  struct 
};
*/
#endif /* EXTRAS_GUI_H */
