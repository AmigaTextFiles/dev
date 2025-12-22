//
//                    CITGetScreenMode include
//
//                          StormC
//
//                     version 2003.02.20
//

#ifndef CITGETSCREENMODE_H
#define CITGETSCREENMODE_H TRUE

#include <citra/CITGadget.h>

#include <gadgets/getscreenmode.h>

//
// This enum is for internal use only
//
enum
{
  CITGETSCREENMODE_TITLETEXT = 0,
  CITGETSCREENMODE_HEIGHT,
  CITGETSCREENMODE_WIDTH,
  CITGETSCREENMODE_LEFTEDGE,
  CITGETSCREENMODE_TOPEDGE,
  CITGETSCREENMODE_DISPLAYID,
  CITGETSCREENMODE_DISPLAYWIDTH,
  CITGETSCREENMODE_DISPLAYHEIGHT,
  CITGETSCREENMODE_DISPLAYDEPTH,
  CITGETSCREENMODE_OVERSCANTYPE,
  CITGETSCREENMODE_AUTOSCROLL,
  CITGETSCREENMODE_INFOOPENED,
  CITGETSCREENMODE_INFOLEFTEDGE,
  CITGETSCREENMODE_INFOTOPEDGE,
  CITGETSCREENMODE_DOWIDTH,
  CITGETSCREENMODE_DOHEIGHT,
  CITGETSCREENMODE_DODEPTH,
  CITGETSCREENMODE_DOOVERSCANTYPE,
  CITGETSCREENMODE_DOAUTOSCROLL,
  CITGETSCREENMODE_PROPERTYFLAGS,
  CITGETSCREENMODE_PROPERTYMASK,
  CITGETSCREENMODE_MINWIDTH,
  CITGETSCREENMODE_MAXWIDTH,
  CITGETSCREENMODE_MINHEIGHT,
  CITGETSCREENMODE_MAXHEIGHT,
  CITGETSCREENMODE_MINDEPTH,
  CITGETSCREENMODE_MAXDEPTH,
  CITGETSCREENMODE_CUSTOMSMLIST,
  CITGETSCREENMODE_FILTERFUNC,
  CITGETSCREENMODE_LAST
};

class CITGetScreenMode:public CITGadget
{
  public:
    CITGetScreenMode();
    ~CITGetScreenMode();

    void RequesterTitleText(char* text)
           {setTag(CITGETSCREENMODE_TITLETEXT,GETSCREENMODE_TitleText,ULONG(text));}
    void RequesterLeftEdge(WORD x)
           {setTag(CITGETSCREENMODE_LEFTEDGE,GETSCREENMODE_LeftEdge,x);}
    void RequesterTopEdge(WORD y)
           {setTag(CITGETSCREENMODE_TOPEDGE,GETSCREENMODE_TopEdge,y);}
    void RequesterWidth(WORD w)
           {setTag(CITGETSCREENMODE_WIDTH,GETSCREENMODE_Width,w);}
    void RequesterHeight(WORD h)
           {setTag(CITGETSCREENMODE_HEIGHT,GETSCREENMODE_Height,h);}
    void DisplayID(ULONG id)
           {setTag(CITGETSCREENMODE_DISPLAYID,GETSCREENMODE_DisplayID,id);}
    void DisplayWidth(ULONG w)
           {setTag(CITGETSCREENMODE_DISPLAYWIDTH,GETSCREENMODE_DisplayWidth,w);}
    void DisplayHeight(ULONG h)
           {setTag(CITGETSCREENMODE_DISPLAYHEIGHT,GETSCREENMODE_DisplayHeight,h);}
    void DisplayDepth(UWORD d)
           {setTag(CITGETSCREENMODE_DISPLAYDEPTH,GETSCREENMODE_DisplayDepth,d);}
    void OverscanType(UWORD type)
           {setTag(CITGETSCREENMODE_OVERSCANTYPE,GETSCREENMODE_OverscanType,type);}
    void AutoScroll(BOOL b = TRUE)
           {setTag(CITGETSCREENMODE_AUTOSCROLL,GETSCREENMODE_AutoScroll,b);}
    void InfoOpened(BOOL b = TRUE)
           {setTag(CITGETSCREENMODE_INFOOPENED,GETSCREENMODE_InfoOpened,b);}
    void InfoLeftEdge(WORD left)
           {setTag(CITGETSCREENMODE_INFOLEFTEDGE,GETSCREENMODE_InfoLeftEdge,left);}
    void InfoTopEdge(WORD top)
           {setTag(CITGETSCREENMODE_INFOTOPEDGE,GETSCREENMODE_InfoTopEdge,top);}
    void DoWidth(BOOL b = TRUE)
           {setTag(CITGETSCREENMODE_DOWIDTH,GETSCREENMODE_DoWidth,b);}
    void DoHeight(BOOL b = TRUE)
           {setTag(CITGETSCREENMODE_DOHEIGHT,GETSCREENMODE_DoHeight,b);}
    void DoDepth(BOOL b = TRUE)
           {setTag(CITGETSCREENMODE_DODEPTH,GETSCREENMODE_DoDepth,b);}
    void DoOverscanType(BOOL b = TRUE)
           {setTag(CITGETSCREENMODE_DOOVERSCANTYPE,GETSCREENMODE_DoOverscanType,b);}
    void DoAutoScroll(BOOL b = TRUE)
           {setTag(CITGETSCREENMODE_DOAUTOSCROLL,GETSCREENMODE_DoAutoScroll,b);}
    void PropertyFlags(ULONG flags)
           {setTag(CITGETSCREENMODE_PROPERTYFLAGS,GETSCREENMODE_PropertyFlags,flags);}
    void PropertyMask(ULONG mask)
           {setTag(CITGETSCREENMODE_PROPERTYMASK,GETSCREENMODE_PropertyMask,mask);}
    void DisplayMinWidth(ULONG min)
           {setTag(CITGETSCREENMODE_MINWIDTH,GETSCREENMODE_MinWidth,min);}
    void DisplayMaxWidth(ULONG max)
           {setTag(CITGETSCREENMODE_MAXWIDTH,GETSCREENMODE_MaxWidth,max);}
    void DisplayMinHeight(ULONG min)
           {setTag(CITGETSCREENMODE_MINHEIGHT,GETSCREENMODE_MinHeight,min);}
    void DisplayMaxHeight(ULONG max)
           {setTag(CITGETSCREENMODE_MAXHEIGHT,GETSCREENMODE_MaxHeight,max);}
    void DisplayMinDepth(ULONG min)
           {setTag(CITGETSCREENMODE_MINDEPTH,GETSCREENMODE_MinDepth,min);}
    void DisplayMaxDepth(ULONG max)
           {setTag(CITGETSCREENMODE_MAXDEPTH,GETSCREENMODE_MaxDepth,max);}
    void CustomSMList(struct List* list)
           {setTag(CITGETSCREENMODE_CUSTOMSMLIST,GETSCREENMODE_CustomSMList,ULONG(list));}

    WORD  RequesterLeftEdge()
           { return getTag(GETSCREENMODE_LeftEdge); }
    WORD  RequesterTopEdge()
           { return getTag(GETSCREENMODE_TopEdge); }
    WORD  RequesterWidth()
           { return getTag(GETSCREENMODE_Width); }
    WORD  RequesterHeight()
           { return getTag(GETSCREENMODE_Height); }
    ULONG DisplayID()
           { return getTag(GETSCREENMODE_DisplayID); }
    ULONG DisplayWidth()
           { return getTag(GETSCREENMODE_DisplayWidth); }
    ULONG DisplayHeight()
           { return getTag(GETSCREENMODE_DisplayHeight); }
    ULONG DisplayDepth()
           { return getTag(GETSCREENMODE_DisplayDepth); }
    ULONG OverscanType()
           { return getTag(GETSCREENMODE_OverscanType); }
    WORD  InfoLeftEdge()
           { return getTag(GETSCREENMODE_InfoLeftEdge); }
    WORD  InfoTopEdge()
           { return getTag(GETSCREENMODE_InfoTopEdge); }

    void ReqScreenMode();

    void FilterFunc(ULONG (*p)(struct ScreenModeRequester* smReq,ULONG modeID,ULONG myData),ULONG userData)
          {CITGadget::CallbackHook(CALLBACKHOOK(p),userData);}
    void FilterFunc(void* obj,ULONG (*p)(void*,struct ScreenModeRequester* smReq,ULONG modeID,ULONG myData),ULONG userData)
          {CITGadget::CallbackHook(obj,MEMBERCALLBACKHOOK(p),userData);}

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);
    virtual void    hookSetup(ULONG userData);

  private:
    void  setTag(int index,ULONG attr,ULONG val);
    ULONG getTag(ULONG attr);

    TagItem* getScreenModeTag;
};

enum
{
  GETSCREENMODECLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
