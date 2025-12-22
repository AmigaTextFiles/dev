//
//               CITWindow include
//
//							 StormC
//
//               version 2003.02.19
//

#ifndef CITCITWINDOW_H
#define CITCITWINDOW_H TRUE

#include <classes/window.h>
#include <intuition/classusr.h>

#include <citra/CITScreen.h>

//
// These enums only for internal use
//
enum
{
  CITWD_POSITION = 0,
  CITWD_POSITION_Y,
  CITWD_WIDTH,
  CITWD_HEIGHT,
  CITWD_LOCKWIDTH,
  CITWD_LOCKHEIGHT,
  CITWD_SHAREDPORT,
  CITWD_APPWINDOW,
  CITWD_APPPORT,
  CITWD_ICONIFYGADGET,
  CITWD_BACKFILLNAME,
  CITWD_MENUSTRIP,
  CITWD_ICONTITLE,
  CITWD_ICON,
  CITWD_GADGETHELP,
  CITWD_REFWINDOW,
  CITWD_ACTIVATE,
  CITWD_CLOSEGADGET,
  CITWD_DEPTHGADGET,
  CITWD_SIZEGADGET,
  CITWD_DRAGBAR,
  CITWD_BORDERLESS,
  CITWD_BACKDROP,
  CITWD_CAPTION,
  CITWD_SCREENTITLE,
  CITWD_LAST
};

class CITWindowClass;
class CITContainer;
class CITGroup;

class CITWindow:public CITScreenClass
{
  public:
    Window*    window;
    Object*    windowObject;
    TTextAttr* defTextAttr;
    TextFont*  defTextFont;
    int        LeftEdge, TopEdge;
    int        Width, Height;

    CITWindow();
    ~CITWindow();

    void Close() { closeWindow(); }
    void Open()  {  openWindow(); }

    void InsObject(CITWindowClass& winClass,BOOL& Err);
    void InsObject(CITWindowClass& winClass,CITContainer* parent,BOOL& Err);
    void RemObject(CITWindowClass& winClass);

    void Align(CITGroup& group1,CITGroup& group2);
    
    void Size(int w, int h);
    void Position(int x, int y);
    void Position(UWORD pos);
    void LockWidth(ULONG w)
      {setTag(CITWD_LOCKWIDTH,WINDOW_LockWidth,w);}
    void LockHeigh(ULONG h)
      {setTag(CITWD_LOCKHEIGHT,WINDOW_LockHeight,h);}
    void AppPort(BOOL b = TRUE)
      {setTag(CITWD_APPPORT,WINDOW_AppPort,b,0);}
    void AppWindow(BOOL b = TRUE)
      {setTag(CITWD_APPWINDOW,WINDOW_AppWindow,b,0);}
    void IconifyGadget(BOOL b = TRUE);
    void BackFillName(char* name)
      {setTag(CITWD_BACKFILLNAME,WINDOW_BackFillName,ULONG(name));}
    void BusyPointer(BOOL b);
    void Zoom(BOOL b);
    void MenuStrip(struct Menu* menu)
      {setTag(CITWD_MENUSTRIP,WINDOW_MenuStrip,ULONG(menu));}
    void IconTitle(char* title)
      {setTag(CITWD_ICONTITLE,WINDOW_IconTitle,ULONG(title));}
    void Icon (struct DiskObject* diskObject)
      {setTag(CITWD_ICON,WINDOW_Icon,ULONG(diskObject));}
    void GadgetHelp(BOOL b = TRUE)
      {setTag(CITWD_GADGETHELP,WINDOW_GadgetHelp,b);}
    void RefWindow(CITWindow* wd)
      {setTag(CITWD_REFWINDOW,WINDOW_RefWindow,ULONG(wd->window));}
    void Activate(BOOL b = TRUE)
      {setTag(CITWD_ACTIVATE,WA_Activate,b);}
    void CloseGadget(BOOL b =TRUE)
      {setTag(CITWD_CLOSEGADGET,WA_CloseGadget,b);}
    void DepthGadget(BOOL b = TRUE)
      {setTag(CITWD_DEPTHGADGET,WA_DepthGadget,b);}
    void SizeGadget(BOOL b  = TRUE)
      {setTag(CITWD_SIZEGADGET,WA_SizeGadget,b);}
    void DragBar(BOOL b = TRUE)
      {setTag(CITWD_DRAGBAR,WA_DragBar,b);}
    void Borderless(BOOL b = TRUE)
      {setTag(CITWD_BORDERLESS,WA_Borderless,b);}
    void Backdrop(BOOL b = TRUE)
      {setTag(CITWD_BACKDROP,WA_Backdrop,b);}
    void ToFront();
    void ToBack();
    void MouseMoveOn(BOOL On);
    void ScreenTitle(char* title)
      {setTag(CITWD_SCREENTITLE,WA_ScreenTitle,ULONG(title));}
    void Caption(char* title)
      {setTag(CITWD_CAPTION,WA_Title,ULONG(title));}
    void DefaultFont(char* name, short Height, short Width = 0);

    UWORD EventCode() {return eventCode;}
    BOOL  ClosePressed();
    int   TextLen(char* t);

    // Set user event handlers
    void CloseEventHandler(void (*p)());
    void CloseEventHandler(void* obj,void (*p)(void* obj));

    // Return inner size of window
    virtual int InnerWidth();
    virtual int InnerHeight();

  protected:
    friend ULONG idcmpHookEntry(struct CITWindowHook* hook,APTR object,APTR msg);
  
    virtual void CloseEvent();
    virtual BOOL Create(CITScreen* CITScr);
    virtual void Delete();
    virtual void Notify(ULONG event);
    virtual void HandleEvent(ULONG Sigs);
    virtual void HandleIDCMPHook(IntuiMessage* intuiMsg);
    virtual void HandleWindowEvent(ULONG result,UWORD code);

    void updateIDCMPMasks();
    void openWindow();
    void closeWindow(BOOL iconify=FALSE);

    UWORD eventCode;
    UWORD closeCount;

  private:
    MsgPort*  wdIDCMP;
    MsgPort*  appPort;
    TTextAttr wdTextAttr;
    TextFont* wdTextFont;
    CITList   eventList;
    CITList   childList;
    CITList*  alignList;
    TagItem*  windowTag;
    ULONG     mouseMoveRequest;
    ULONG     flags;
    ULONG     idcmpEventMask;
    ULONG     idcmpHookMask;

    struct Hook* hook;

    void *closeEventObj;
    union
    {
      void (*Proc0)();
      void (*Proc1)(void* obj);
    } closeEvent;
    
    struct Hook* createHook(ULONG userData);
    
    void notifyObjects(UWORD id,ULONG eventType,UWORD code);
    void setTag(int index,ULONG attr,ULONG val,BOOL set = TRUE);
    void SetUp();
};

class CITWindowClass:public CITNode
{
  public:
    CITWindow* CITWd;

    CITWindowClass();
    ~CITWindowClass();

    virtual void Refresh();
    
    void  setFlags(ULONG mask,ULONG value);
    ULONG getFlags() { return flags; }

    void    Page(Object* page) { cPage = page;}
    Object* Page() { return cPage; }
    
  protected:
    friend class CITWindow;

    UWORD   classID;
    ULONG   IDCMPHookMask;
    ULONG   eventMask;
    ULONG   flags;
    Object* cPage;
    
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    virtual void Delete();
    virtual void HandleIDCMPHook(IntuiMessage* intuiMsg);
    virtual void HandleEvent(UWORD id,ULONG eventType,UWORD code);
};

enum
{
  WINCLASS_FLAGBITUSED = 0
};

//
// Event Types (most of them equal to corresponding IDCMP Flag)
//
#define EVENT_NEWSIZE           0x00000002L
#define EVENT_MOUSEBUTTONS      0x00000008L
#define EVENT_MOUSEMOVE         0x00000010L
#define EVENT_GADGETDOWN        0x00000020L // Not implemented yet  
#define EVENT_GADGETUP          0x00000040L
#define EVENT_MENUPICK          0x00000100L
#define EVENT_RAWKEY            0x00000400L
#define EVENT_ACTIVEWINDOW      0x00040000L
#define EVENT_INACTIVEWINDOW    0x00080000L
#define EVENT_VANILLAKEY        0x00200000L
#define EVENT_UPDATE            0x00800000L
#define EVENT_MENUHELP          0x01000000L
#define EVENT_CHANGEWINDOW      0x02000000L
#define EVENT_GADGETHELP        0x04000000L
#define EVENT_OPENWINDOW        0x20000000L // CIT private
#define EVENT_CLOSEWINDOW       0x40000000L // CIT private

// Mask for Event Type common to IDCMP Flags
#define EVENT_IDCMP             0x0F7FFFFFL

#endif
