//
//                    CITFuelGauge include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITFUELGAUGE_H
#define CITFUELGAUGE_H TRUE

#include <citra/CITGadget.h>
#include <gadgets/fuelgauge.h>

//
// This enum is for internal use only
//
enum
{
  CITFUELGAUGE_MIN = 0,
  CITFUELGAUGE_MAX,
  CITFUELGAUGE_LEVEL,
  CITFUELGAUGE_ORIENTATION,
  CITFUELGAUGE_PERCENT,
  CITFUELGAUGE_TICKS,
  CITFUELGAUGE_SHORTTICKS,
  CITFUELGAUGE_TICKSIZE,
  CITFUELGAUGE_TICKPEN,
  CITFUELGAUGE_PERCENTPEN,
  CITFUELGAUGE_FILLPEN,
  CITFUELGAUGE_EMPTYPEN,
  CITFUELGAUGE_VARARGS,
  CITFUELGAUGE_JUSTIFICATION,
  CITFUELGAUGE_LAST
};

class CITFuelGauge:public CITGadget
{
  public:
    CITFuelGauge();
    ~CITFuelGauge();

    void Min(LONG min)
           {setTag(CITFUELGAUGE_MIN,FUELGAUGE_Min,min);}
    void Max(LONG max)
           {setTag(CITFUELGAUGE_MAX,FUELGAUGE_Max,max);}
    void Level(LONG level)
           {setTag(CITFUELGAUGE_LEVEL,FUELGAUGE_Level,level);}
    void Orientation(WORD orien)
           {setTag(CITFUELGAUGE_ORIENTATION,FUELGAUGE_Orientation,orien);}
    void Percent(BOOL b = TRUE)
           {setTag(CITFUELGAUGE_PERCENT,FUELGAUGE_Percent,b);}
    void Ticks(WORD ticks)
           {setTag(CITFUELGAUGE_TICKS,FUELGAUGE_Ticks,ticks);}
    void ShortTicks(WORD ticks)
           {setTag(CITFUELGAUGE_SHORTTICKS,FUELGAUGE_ShortTicks,ticks);}
    void TickSize(WORD size)
           {setTag(CITFUELGAUGE_TICKSIZE,FUELGAUGE_TickSize,size);}
    void TickPen(WORD pen)
           {setTag(CITFUELGAUGE_TICKPEN,FUELGAUGE_TickPen,pen);}
    void PercentPen(WORD pen)
           {setTag(CITFUELGAUGE_PERCENTPEN,FUELGAUGE_PercentPen,pen);}
    void FillPen(WORD pen)
           {setTag(CITFUELGAUGE_FILLPEN,FUELGAUGE_FillPen,pen);}
    void EmptyPen(WORD pen)
           {setTag(CITFUELGAUGE_EMPTYPEN,FUELGAUGE_EmptyPen,pen);}
    void VarArgs(APTR arg)
           {setTag(CITFUELGAUGE_VARARGS,FUELGAUGE_VarArgs,ULONG(arg));}
    void Justification(WORD just)
           {setTag(CITFUELGAUGE_JUSTIFICATION,FUELGAUGE_Justification,just);}

    LONG Min()
           { return LONG(getTag(FUELGAUGE_Min)); }
    LONG Max()
           { return LONG(getTag(FUELGAUGE_Max)); }
    LONG Level()
           { return LONG(getTag(FUELGAUGE_Level)); }
    BOOL Percent()
           { return BOOL(getTag(FUELGAUGE_Percent)); }

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void  setTag(int index,ULONG attr,ULONG val);
    ULONG getTag(ULONG attr);

    TagItem* fuelGaugeTag;
};

enum
{
  FUELGAUGECLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
