#include <intuition/intuition.h>
#include <graphics/rastport.h>
#include <proto/gadtools.h>
#include <extras/gui.h>

/****** extras.lib/OBSOLETEDrawBevelBoxes ******************************************
*
*   NAME
*       DrawBevelBoxes -- draw a series of scaled bevel boxws.
*
*   SYNOPSIS
*       DrawBevelBoxes(Window, VisualInfo, BBoxes, NumBoxes,
*             XScale, YScale);  
*
*       void DrawBevelBoxes(struct Window *, APTR, 
*             struct BevelBox *, LONG, float, float);
*
*   FUNCTION
*       Draws a series of scaled boxes.
*
*   INPUTS
*       Win - the Window to draw the bevel boxes in.
*       VI - VisualInfo previously obtained by 
*            gadtools.library/GetVisualInfoA()
*       BBoxes - pointer to an array of struct BevelBox.
*       NumBoxes - the number of entries in the array.
*       XScale - 
*       YScale - 
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/

void DrawBevelBoxes(struct Window *Win, APTR VI, struct BevelBox *BBox,
                    LONG NumBoxes, float XScale, float YScale)
{
  struct  RastPort *rp;
  ULONG   l;
  LONG    x,y;
//  LONG    bx1,by1, bx2,by2;
  float   xm,ym;
  struct  TagItem bbtags[]=
  {
    GTBB_Recessed   ,TRUE,
    GT_VisualInfo ,   0,
    TAG_DONE,
  };

  rp  =Win->RPort;
  x   =Win->BorderLeft;
  y   =Win->BorderTop;
  
  bbtags[1].ti_Data=(ULONG)VI;

  for(l=0;l<NumBoxes;l++)
  {
    if(BBox[l].Scale & BBSCALE_WIDTH)
      xm=XScale;
    else
      xm=1.0;
    
    if(BBox[l].Scale & BBSCALE_HEIGHT)
      ym=YScale;
    else
      ym=1.0;
    
    DrawBevelBoxA(rp,x+(LONG)(BBox[l].X     * XScale),y+(LONG)(BBox[l].Y      * YScale), 
                       (LONG)(BBox[l].Width * xm)    ,  (LONG)(BBox[l].Height * ym),
                        bbtags);
  }
}

