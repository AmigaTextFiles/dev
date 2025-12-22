//
//                    CITScroller include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITSCROLLER_H
#define CITSCROLLER_H TRUE

#include <gadgets/scroller.h>

#include <citra/CITGadget.h>

//
// This enum for internal use only
//
enum
{
  CITSCROLLER_TOP = 0,
  CITSCROLLER_VISIBLE,
  CITSCROLLER_TOTAL,
  CITSCROLLER_ORIENTATION,
  CITSCROLLER_ARROWS,
  CITSCROLLER_STRETCH,
  CITSCROLLER_ARROWDELTA,
  CITSCROLLER_SIGNALTASK,
  CITSCROLLER_SIGNALBIT,
  CITSCROLLER_LAST
};

class CITScroller:public CITGadget
{
  public:
    CITScroller();
    ~CITScroller();

    void Top(WORD top)
      {setTag(CITSCROLLER_TOP,SCROLLER_Top,top);}
    void Visible(WORD visible)
      {setTag(CITSCROLLER_VISIBLE,SCROLLER_Visible,visible);}
    void Total(WORD total)
      {setTag(CITSCROLLER_TOTAL,SCROLLER_Total,total);}
    void Orientation(WORD orien)
      {setTag(CITSCROLLER_ORIENTATION,SCROLLER_Orientation,orien);}
    void Arrows(BOOL b = TRUE)
      {setTag(CITSCROLLER_ARROWS,SCROLLER_Arrows,b);}
    void Stretch(BOOL b = TRUE)
      {setTag(CITSCROLLER_STRETCH,SCROLLER_Stretch,b);}
    void ArrowDelta(WORD aDelta)
      {setTag(CITSCROLLER_ARROWDELTA,SCROLLER_ArrowDelta,aDelta);}
    void SignalTask(struct Task* task,ULONG sigMask);

    WORD Top();

  protected:
    virtual Object* NewObjectA(TagItem* tags);
    
  private:
    void setTag(int index,ULONG attr,ULONG val);

    TagItem* scrollerTag;
};

enum
{
   SCROLLERCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
