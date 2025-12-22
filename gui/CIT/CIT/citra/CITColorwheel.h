//
//                    CITColorwheel include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITCOLORWHEEL_H
#define CITCOLORWHEEL_H TRUE

#include <citra/CITScroller.h>
#include <citra/CITGadget.h>

#include <gadgets/colorwheel.h>

//
// This enum is for internal use only
//
enum
{
  CITCOLORWHEEL_HUE = 0,
  CITCOLORWHEEL_SATURATION,
  CITCOLORWHEEL_BRIGHTNESS,
  CITCOLORWHEEL_RED,
  CITCOLORWHEEL_GREEN,
  CITCOLORWHEEL_BLUE,
  CITCOLORWHEEL_ABBRV,
  CITCOLORWHEEL_DONATION,
  CITCOLORWHEEL_BEVELBOX,
  CITCOLORWHEEL_MAXPENS,
  CITCOLORWHEEL_GRADIENTSLIDER,
  CITCOLORWHEEL_SCREEN,
  CITCOLORWHEEL_LAST
};

class CITColorwheel:public CITGadget
{
  public:
    CITColorwheel();
    ~CITColorwheel();

    void Hue(ULONG hue)
           {setTag(CITCOLORWHEEL_HUE,WHEEL_Hue,hue);}
    void Saturation(ULONG sat)
           {setTag(CITCOLORWHEEL_SATURATION,WHEEL_Saturation,sat);}
    void Brightness(ULONG bright)
           {setTag(CITCOLORWHEEL_BRIGHTNESS,WHEEL_Brightness,bright);}
    void Red(ULONG red)
           {setTag(CITCOLORWHEEL_RED,WHEEL_Red,red);}
    void Green(ULONG green)
           {setTag(CITCOLORWHEEL_GREEN,WHEEL_Green,green);}
    void Blue(ULONG blue)
           {setTag(CITCOLORWHEEL_BLUE,WHEEL_Blue,blue);}
    void Abbrv(char* abb)
           {setTag(CITCOLORWHEEL_ABBRV,WHEEL_Abbrv,ULONG(abb));}
    void Donation(UWORD* don)
           {setTag(CITCOLORWHEEL_DONATION,WHEEL_Donation,ULONG(don));}
    void BevelBox(BOOL b = TRUE)
           {setTag(CITCOLORWHEEL_BEVELBOX,WHEEL_BevelBox,b);}
    void MaxPens(ULONG max)
           {setTag(CITCOLORWHEEL_MAXPENS,WHEEL_MaxPens,max);}
    void GradientSlider(class CITScroller* scrl)
           {setTag(CITCOLORWHEEL_GRADIENTSLIDER,WHEEL_GradientSlider,ULONG(scrl->objectPtr()));}

    ULONG Hue() { return getTag(WHEEL_Hue); }
    ULONG Saturation() { return getTag(WHEEL_Saturation); }
    ULONG Brightness() { return getTag(WHEEL_Brightness); }
    ULONG Red() { return getTag(WHEEL_Red); }
    ULONG Green() { return getTag(WHEEL_Green); }
    ULONG Blue() { return getTag(WHEEL_Blue); }

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void   setTag(int index,ULONG attr,ULONG val);
    ULONG  getTag(ULONG attr);

    TagItem* colorwheelTag;
};

enum
{
  COLORWHEELCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
