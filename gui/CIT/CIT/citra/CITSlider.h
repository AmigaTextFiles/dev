//
//                    CITSlider include
//
//                          StormC
//
//                     version 2003.02.20
//

#ifndef CITSLIDER_H
#define CITSLIDER_H TRUE

#include <gadgets/slider.h>

#include <citra/CITGadget.h>

//
// This enum for internal use only
//
enum
{
  CITSLIDER_MIN,
  CITSLIDER_MAX,
  CITSLIDER_LEVEL,
  CITSLIDER_ORIENTATION,
  CITSLIDER_DISPHOOK,
  CITSLIDER_TICKS,
  CITSLIDER_SHORTTICKS,
  CITSLIDER_TICKSIZE,
  CITSLIDER_KNOBIMAGE,
  CITSLIDER_BODYFILL,
  CITSLIDER_BODYIMAGE,
  CITSLIDER_GRADIENT,
  CITSLIDER_PENARRAY,
  CITSLIDER_INVERT,
  CITSLIDER_KNOBDELTA,
  CITSLIDER_LAST
};

class CITSlider:public CITGadget
{
  public:
    CITSlider();
    ~CITSlider();

    void Min(WORD min)
      {setTag(CITSLIDER_MIN,SLIDER_Min,min);}
    void Max(WORD max)
      {setTag(CITSLIDER_MAX,SLIDER_Max,max);}
    void Level(WORD level)
      {setTag(CITSLIDER_LEVEL,SLIDER_Level,level);}
    void Orientation(WORD orien)
      {setTag(CITSLIDER_ORIENTATION,SLIDER_Orientation,orien);}
    void Ticks(LONG ticks)
      {setTag(CITSLIDER_TICKS,SLIDER_Ticks,ticks);}
    void ShortTicks(BOOL b = TRUE)
      {setTag(CITSLIDER_SHORTTICKS,SLIDER_ShortTicks,b);}
    void TickSize(WORD tSize)
      {setTag(CITSLIDER_TICKSIZE,SLIDER_TickSize,tSize);}
    void KnobImage(struct Image* im)
      {setTag(CITSLIDER_KNOBIMAGE,SLIDER_KnobImage,ULONG(im));}
    void BodyFill(WORD bFill)
      {setTag(CITSLIDER_BODYFILL,SLIDER_BodyFill,bFill);}
    void BodyImage(struct Image* im)
      {setTag(CITSLIDER_BODYIMAGE,SLIDER_BodyImage,ULONG(im));}
    void Gradient(BOOL b = TRUE)
      {setTag(CITSLIDER_GRADIENT,SLIDER_Gradient,b);}
    void PenArray(UWORD pen)
      {setTag(CITSLIDER_PENARRAY,SLIDER_PenArray,pen);}
    void Invert(BOOL b = TRUE)
      {setTag(CITSLIDER_INVERT,SLIDER_Invert,b);}
    void KnobDelta(WORD kDelta)
      {setTag(CITSLIDER_KNOBDELTA,SLIDER_KnobDelta,kDelta);}

    WORD Level();

    virtual void EventHandler(void (*p)(ULONG Id,ULONG eventType),ULONG eventMask=IDCMP_GADGETUP);
    virtual void EventHandler(void* obj,void (*)(void*,ULONG,ULONG),ULONG eventMask=IDCMP_GADGETUP);

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);

    virtual void  HandleEvent(UWORD id,ULONG eventType,UWORD code);
    virtual void  HandleIDCMPHook(IntuiMessage* intuiMsg);
    virtual void  hookSetup(ULONG userData);
    virtual ULONG hookEntry(struct Hook* inputHook,APTR object,APTR msg);

  private:
    void setTag(int index,ULONG attr,ULONG val);

    TagItem* sliderTag;
    BOOL     active;
};

enum
{
   SLIDERCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
