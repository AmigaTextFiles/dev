/*        S3DC v1.0
      ( Simple 3D Cube )

   (C) 1999 Olivier Croquette
      ocroquette@nordnet.fr

*/



#define S3DC_NB_POINTS 4 /* number of points, 4 for a cube */
#define S3DC_HEIGHT (1/sqrt(2.0))

#include <stdio.h>

#include "S3DC.h"

extern struct GfxBase *GfxBase;
extern struct IntuitionBase *IntuitionBase;
extern struct Library  *MUIMasterBase;


#include <math.h>


int S3DC_Convert_Coord(double data, double max, int direction, Object *obj);


/* Convert coord. to window coord. */
#define S3DC_DIR_X 1
#define S3DC_DIR_Y 2
int S3DC_Convert_Coord(double data, double max, int direction, Object *obj)
{
  switch ( direction )
  {
    case S3DC_DIR_X:
      return((int)( (data/max)*_width(obj)/2 + (_mleft(obj)+_mright(obj))/2 ) );
    case S3DC_DIR_Y:
      return((int)( (data/max)*_height(obj)/2 + (_mbottom(obj)+_mtop(obj))/2 ) );
    default :
      return(-1);
  }
}



ULONG S3DC_AskMinMax(struct IClass *cl,Object *obj,struct MUIP_AskMinMax *msg)
{
  DoSuperMethodA(cl,obj,(Msg)msg);

  msg->MinMaxInfo->MinWidth += MIN_WIDTH;
  msg->MinMaxInfo->DefWidth += DEFAULT_WIDTH;
  msg->MinMaxInfo->MaxWidth += MAX_WIDTH;

  msg->MinMaxInfo->MinHeight += MIN_HEIGHT;
  msg->MinMaxInfo->DefHeight += DEFAULT_HEIGHT;
  msg->MinMaxInfo->MaxHeight += MAX_HEIGHT;

  return(0);
}


ULONG S3DC_Draw(struct IClass *cl,Object *obj,struct MUIP_Draw *msg)
{
  struct S3DC_Data *data = INST_DATA(cl,obj);
  float x,y;
  int xcenter, ycenter;

  S3DC_Coord bottom[S3DC_NB_POINTS];
  S3DC_Coord top[S3DC_NB_POINTS];

  int i;

  DoSuperMethodA(cl,obj,(Msg)msg);

  if (msg->flags & MADF_DRAWOBJECT || msg->flags & MADF_DRAWUPDATE)
  {
    SetAPen(_rp(obj),data->BlackPen);
    RectFill(_rp(obj),_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj));

    xcenter=(_mright(obj)+_mleft(obj))/2;
    ycenter=(_mtop(obj)+_mbottom(obj))/2;

    for ( i=0; i< S3DC_NB_POINTS; i++)
    {
      x = cos(data->theta+i*2*M_PI/S3DC_NB_POINTS);
      y = sin(data->phi)*sin(data->theta+i*2*M_PI/S3DC_NB_POINTS)-cos(data->phi)*S3DC_HEIGHT;

      bottom[i].x=S3DC_Convert_Coord(x,2.0,S3DC_DIR_X,obj);
      bottom[i].y=S3DC_Convert_Coord(y,2.0,S3DC_DIR_Y,obj);

      x = cos(data->theta+2*i*M_PI/S3DC_NB_POINTS);
      y = sin(data->phi)*sin(data->theta+i*2*M_PI/S3DC_NB_POINTS)+cos(data->phi)*S3DC_HEIGHT;

      top[i].x=S3DC_Convert_Coord(x,2.0,S3DC_DIR_X,obj);
      top[i].y=S3DC_Convert_Coord(y,2.0,S3DC_DIR_Y,obj);
    }

    SetAPen(_rp(obj),data->WhitePen);

    for ( i=0; i<S3DC_NB_POINTS; i++ )
    {
      Move(_rp(obj),bottom[i].x, bottom[i].y);
      if ( i != S3DC_NB_POINTS-1 )
        Draw(_rp(obj),bottom[i+1].x, bottom[i+1].y);
      else
        Draw(_rp(obj),bottom[0].x, bottom[0].y);

      Move(_rp(obj),top[i].x, top[i].y);
      if ( i != S3DC_NB_POINTS-1 )
        Draw(_rp(obj),top[i+1].x, top[i+1].y);
      else
        Draw(_rp(obj),top[0].x, top[0].y);
    }

    for ( i=0; i< S3DC_NB_POINTS; i++ )
    {
      Move(_rp(obj),bottom[i].x, bottom[i].y);
      Draw(_rp(obj),top[i].x, top[i].y);
    }

  }

  return(0);

}


/* init data & allocate pens */
ULONG S3DC_Setup(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
  struct S3DC_Data *data = INST_DATA(cl,obj);

  if (!(DoSuperMethodA(cl,obj,(Msg)msg)))
    return(FALSE);

  MUI_RequestIDCMP(obj,IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY);

  data->BlackPen = ObtainBestPen(_screen(obj)->ViewPort.ColorMap, 0,0,0,TAG_DONE);
  data->WhitePen = ObtainBestPen(_screen(obj)->ViewPort.ColorMap, 0xFFFFFFFF
                , 0xFFFFFFFF
                , 0xFFFFFFFF,TAG_DONE);
  data->phi   =0.101;
  data->theta =0.101;

 return(TRUE);
}


ULONG S3DC_Cleanup(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
 struct S3DC_Data *data = INST_DATA(cl,obj);
 struct MUIP_Setup *smsg;
 struct Screen *scr;
 struct ColorMap *cmap;

 smsg = (struct MUIP_Setup *)msg;
 scr = smsg->RenderInfo->mri_Screen;
 cmap = scr->ViewPort.ColorMap;

 ReleasePen(_screen(obj)->ViewPort.ColorMap,data->BlackPen);
 ReleasePen(_screen(obj)->ViewPort.ColorMap,data->WhitePen);

 MUI_RejectIDCMP(obj,IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY);


 return(DoSuperMethodA(cl,obj,(Msg)msg));
}


ULONG S3DC_HandleInput(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
  #define _between(a,x,b) ((x)>=(a) && (x)<=(b))
  #define _isinobject(x,y) (_between(_mleft(obj),(x),_mright(obj)) && _between(_mtop(obj),(y),_mbottom(obj)))

  struct S3DC_Data *data = INST_DATA(cl,obj);

  if (msg->muikey!=MUIKEY_NONE)
  {
    switch (msg->muikey)
    {
      case MUIKEY_UP : data->phi+=0.05; MUI_Redraw(obj,MADF_DRAWUPDATE); break;
      case MUIKEY_DOWN : data->phi-=0.05; MUI_Redraw(obj,MADF_DRAWUPDATE); break;
      case MUIKEY_RIGHT : data->theta+=0.05; MUI_Redraw(obj,MADF_DRAWUPDATE); break;
      case MUIKEY_LEFT : data->theta-=0.05; MUI_Redraw(obj,MADF_DRAWUPDATE); break;

    }
  }
  return(DoSuperMethodA(cl,obj,(Msg)msg));
}


ULONG S3DC_Dispatcher(struct IClass *cl __asm("a0"),Object *obj __asm("a2"),Msg msg __asm("a1"))
{
  switch (msg->MethodID)
  {
    case MUIM_AskMinMax : return(S3DC_AskMinMax (cl,obj,(APTR)msg));
    case MUIM_Draw  : return(S3DC_Draw  (cl,obj,(APTR)msg));
    case MUIM_HandleInput: return(S3DC_HandleInput(cl,obj,(APTR)msg));
    case MUIM_Setup  : return(S3DC_Setup  (cl,obj,(APTR)msg));
    case MUIM_Cleanup : return(S3DC_Cleanup (cl,obj,(APTR)msg));
  }

  return(DoSuperMethodA(cl,obj,(Msg)msg));
}

