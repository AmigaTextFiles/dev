//
//                  CITDoubleSlider include
//
//                          StormC
//
//                     version 2003.92.12
//

#ifndef CITDOUBLESLIDER_H
#define CITDOUBLESLIDER_H TRUE

#include <citra/CITNumberSlider.h>

class CITDoubleSlider:public CITNumberSlider
{
  public:
    CITDoubleSlider();

    void   Limits(double min, double max, double step=1.0);
    void   Level(double level);

    double Level();

  protected:
    virtual void printValue(WORD level);

  private:
    double _min,_step,_level;
};

enum
{
  DOUBLESLIDERCLASS_FLAGBITUSED = MUMBERSLIDERCLASS_FLAGBITUSED
};

#endif
