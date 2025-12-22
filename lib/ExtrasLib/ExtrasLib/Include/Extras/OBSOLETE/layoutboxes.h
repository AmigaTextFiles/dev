#ifndef EXTRAS_LAYOUTBOXES_H
#define EXTRAS_LAYOUTBOXES_H

#include <exec/types.h>
#include <intuition/intuition.h>

#define NEWGADGETBOX(ngad)  ((struct IBox *)ngad)

struct LBox
{
  struct Node Node;
  ULONG   lb_ID;
  struct  IBox lb_SrcBounds;
  ULONG   lb_GroupFlags;          
  ULONG   lb_RelFlags;   /* Rel to parent LBox */
  struct  IBox lb_DstBounds;
};

struct Group
{
  struct Node Node;
  struct List Boxes; /* Boxes in this group */
  ULONG  GroupFlags;
};




#define LB_GF_BEGIN    (1<<1)
#define LB_GF_END      (1<<2)
#define LB_GF_SPREAD_X (1<<3)
#define LB_GF_SPREAD_Y (1<<4)
#define LB_GF_WRAP     (1<<5)

/*
#define LB_GRP_SPREADX  (LB_GRP_BEGIN | 1<<2)
#define LB_GRP_SPREADY  (LB_GRP_BEGIN | 1<<3)
#define LB_GRP_WRAP     (1<<4)
*/
#define LB_REL_RIGHT   (1<<0)
#define LB_REL_BOTTOM  (1<<1)
#define LB_REL_WIDTH   (1<<2)
#define LB_REL_HEIGHT  (1<<3)

#define LB_REL_SCALE_LEFT   (1<<4)
#define LB_REL_SCALE_WIDTH  (1<<5)
#define LB_REL_SCALE_TOP     (1<<6)
#define LB_REL_SCALE_HEIGHT  (1<<7)

#define LB_REL_SCALE_HORIZ   (LB_REL_SCALE_LEFT | LB_REL_SCALE_WIDTH)
#define LB_REL_SCALE_VERT   (LB_REL_SCALE_TOP | LB_REL_SCALE_HEIGHT)

#define LBS(x) (x * 32767)

/* Example :
struct LBox
{
  {WIN_BOX, 0,  0,100,100,                             0,             0 },
    {GAD1_BOX,   0,  0,100,-10, LB_GF_BEGIN                 , LB_REL_HEIGHT },
    {GAD_BOX, 0,  0,  0, 12, LB_GF_END                  0, LB_REL_HEIGHT }, 
  {END_LBOX}
};

*/

/*

LGRP_SpreadX
LGRP_SpreadY
LGRP_Wrap    /* Space amount */

LBOX_RelWidth
LBOX_RelHeight
LBOX_RelRight
LBOX_RelBottom
LBOX_Justified
LBOX_SpreadWeight
LBOX_Above
LBOX_Below
LBOX_Right
LBOX_Left


*/



#endif /* EXTRAS_LAYOUTBOXES_H */


