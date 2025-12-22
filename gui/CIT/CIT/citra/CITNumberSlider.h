//
//                    CITNumberSlider include
//
//                          StormC
//
//                     version 2003.02.20
//

#ifndef CITNUMBERSLIDER_H
#define CITNUMBERSLIDER_H TRUE

#include <citra/CITGroup.h>
#include <citra/CITText.h>
#include <citra/CITSlider.h>

// Text position values
#define NSP_LEFT   0
#define NSP_RIGHT  1
#define NSP_ABOVE  2
#define NSP_BELOW  3

//
// CITNumSlider for internal use only
//
class CITNumSlider:public CITSlider
{
  protected:
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
};

class CITNumberSlider:public CITHGroup
{
  public:
    CITNumberSlider();
    ~CITNumberSlider();

    void Text(char* text,UWORD textLen=0);

    // Redirection of CITGadget methods
    void TextPosition(UWORD pos) { textPos = pos;}
    void Disabled(BOOL b = TRUE) { numSlider.Disabled(b); }
    void Selected(BOOL b = TRUE) { numSlider.Selected(b); }
    void Activate() { numSlider.Activate(); }
    void RelVerify(BOOL b = TRUE) { numSlider.RelVerify(b); }
    void FollowMouse(BOOL b = TRUE) { numSlider.FollowMouse(b); }
    void TabCycle(BOOL b = TRUE) { numSlider.TabCycle(b); }
    void GadgetHelp(BOOL b = TRUE) { numSlider.GadgetHelp(b); }
    void ReadOnly(BOOL b = TRUE) { numSlider.ReadOnly(b); }
    void Underscore(char c) { numSlider.Underscore(c); }

    void LabelFont(struct TextAttr* attr) { numSlider.LabelFont(attr); }
    void LabelForegroundPen(LONG pen) { numSlider.LabelForegroundPen(pen); }
    void LabelBackgroundPen(LONG pen) { numSlider.LabelBackgroundPen(pen); }
    void LabelMode(UBYTE mode) { numSlider.LabelMode(mode); }
    void LabelSoftStyle(UBYTE style) { numSlider.LabelSoftStyle(style); }
    void LabelJustification(UWORD pos) { numSlider.LabelJustification(pos); }
    void LabelText(char* text) { numSlider.LabelText(text); }
    void Id(ULONG GadgetID) { numSlider.Id(GadgetID); }
    
    // Redirection of CITSlider methods
    void Orientation(WORD orien) { numSlider.Orientation(orien); }
    void Ticks(LONG ticks) { numSlider.Ticks(ticks); }
    void ShortTicks(BOOL b = TRUE) { numSlider.ShortTicks(b); }
    void TickSize(WORD tSize) { numSlider.TickSize(tSize); }
    void KnobImage(struct Image* im) { numSlider.KnobImage(im); }
    void BodyFill(WORD bFill) { numSlider.BodyFill(bFill); }
    void BodyImage(struct Image* im) { numSlider.BodyImage(im); }
    void Gradient(BOOL b = TRUE) { numSlider.Gradient(b); }
    void PenArray(UWORD pen) { numSlider.PenArray(pen); }
    void Invert(BOOL b = TRUE) { numSlider.Invert(b); }
    void KnobDelta(WORD kDelta) { numSlider.KnobDelta(kDelta); }

    void EventHandler(void (*p)(ULONG Id,ULONG eventFlag),ULONG eventMask=IDCMP_GADGETUP)
      { numSlider.EventHandler(p,eventMask); }
    void EventHandler(void* obj,void (*p)(void*,ULONG,ULONG),ULONG eventMask=IDCMP_GADGETUP)
      { numSlider.EventHandler(obj,p,eventMask); }
    void CallbackHook(ULONG (*p)(void*,void*,ULONG),ULONG userData)
      { numSlider.CallbackHook(p,userData); }
    void CallbackHook(void *obj,ULONG (*p)(void*,void*,void*,ULONG),ULONG userData)
      { numSlider.CallbackHook(obj,p,userData); }
   
  protected:
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    virtual void Delete();
    virtual void HandleEvent(UWORD id,ULONG eventType,UWORD code);
    virtual void HandleIDCMPHook(IntuiMessage* intuiMsg);

    virtual void printValue(WORD level);
    
    CITNumSlider numSlider;
    CITText      numText;
    UWORD        textPos;
    
    char formatStr[128];
    char outputStr[128];

};

enum
{
  MUMBERSLIDERCLASS_FLAGBITUSED = SLIDERCLASS_FLAGBITUSED
};

#endif
