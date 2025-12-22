//
//                    CITInput include
//
//                          StormC
//
//                     version 2003.02.20
//

#ifndef CITINPUT_H
#define CITINPUT_H TRUE

#include <citra/CITGadget.h>

class CITInput:public CITGadget
{
  public:
    CITInput();
    ~CITInput();

    void MinVisible(WORD min);
    void MaxChars(WORD max);
    void BufferPos(WORD pos);
    void DispPos(WORD pos);
    void Pens(ULONG pen);
    void ActivePens(ULONG pen);
    void EditModes(ULONG mode);
    void ReplaceMode(BOOL b = TRUE);
    void FixedFieldMode(BOOL b = TRUE);
    void NoFilterMode(BOOL b = TRUE);
    void Justification(UWORD pos);

    void EditHook(ULONG (*p)(struct SGWork *sgw,ULONG *msg,ULONG myData),ULONG userData)
            {CITGadget::CallbackHook(CALLBACKHOOK(p),userData);}
    void EditHook(void* obj,ULONG (*p)(void*,struct SGWork *sgw,ULONG *msg,ULONG myData),ULONG userData)
            {CITGadget::CallbackHook(obj,MEMBERCALLBACKHOOK(p),userData);}

  protected:
    virtual Object* NewObjectA(TagItem* tags);
    virtual void    hookSetup(ULONG userData);

  private:
    void  setTag(int index,ULONG attr,ULONG val);
  
    TagItem* inputTag;
};

enum
{
   INPUTCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
