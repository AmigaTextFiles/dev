//
//                    CITIntSlider include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITINTSLIDER_H
#define CITINTSLIDER_H TRUE

#include <citra/CITNumberSlider.h>

class CITIntSlider:public CITNumberSlider
{
  public:
    CITIntSlider();

    void Limits(int min, int max, int step=1);
    void Level(int level);

    int  Level();

  protected:
    virtual void printValue(WORD level);

  private:
    int _min,_step,_level;
};

enum
{
  INTSLIDERCLASS_FLAGBITUSED = MUMBERSLIDERCLASS_FLAGBITUSED
};

#endif
