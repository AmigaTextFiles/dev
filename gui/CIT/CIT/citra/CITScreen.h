//
//               CITScreen include
//
//							  StormC
//
//               version 2003.01.18
//

#ifndef CIT_CITSCREEN_H
#define CIT_CITSCREEN_H TRUE

#include <citra/CITApp.h>

#include <graphics/text.h>
#include <intuition/screens.h>

#define DEF_MONITOR    ~0x00000000    // INVALID_D forces WB-type
#define PAL_HIRES       0x00029000
#define PAL_HIRESLACE   0x00029004
#define NTSC_HIRES      0x00019000
#define NTSC_HIRESLACE  0x00019004

class CITScreenClass;

class CITScreen:public CITAppClass
{
  public:
    TTextAttr defTextAttr;
    TextFont* defTextFont;
    Screen*   screen;

    CITScreen();
    CITScreen(char *Name);
    ~CITScreen();

    void InsObject(CITScreenClass &Object,BOOL &Err);
    void RemObject(CITScreenClass &Object);
    void Depth(UWORD d);
    void Display(ULONG ID);
    void Display(char *Name);
    void Display(Screen *sc);
    void ScreenFont(char *name, short Height, short Width = 0);
    void DefaultFont(char *name, short Height, short Width = 0);
    void Caption(char *title);
    void AutoScroll();
    void Interleaved();
    void ToFront();
    void ToBack();

    UWORD Depth();
    ULONG Display() { return displayMode;}
    
  protected:
    friend class CITApp;

    virtual BOOL Create(class CITApp* CITApp);
    virtual void Delete();
    virtual void HandleEvent(ULONG Sigs);

    void openScreen();
    void closeScreen();
    
    struct DrawInfo* drawinfo;

  private:
    CITList   objectList;
    Screen*   useScr;
    ULONG     displayMode;
    TTextAttr scrTextAttr;
    TextFont* scrTextFont;
    char*     screenName;
    char*     defaultTitle;
    UWORD     Pens_3D;
    UWORD     depth;
    UWORD     flags;

    void SetUp(UWORD Depth);
};

class CITWorkbench:public CITScreen
{
  public:
    CITWorkbench() { Display("Workbench");}
};

class CITScreenClass:public CITNode
{
  public:
    CITScreen* CITScr;
    
    CITScreenClass();
    ~CITScreenClass();

    DrawInfo* drawinfo;

  protected:
    friend class CITScreen;
    
    virtual BOOL Create(class CITScreen* scr);
    virtual void Delete(); 
    virtual void Notify(ULONG event);
    virtual void HandleEvent(ULONG Sigs);

    ULONG  eventSigMask;
};

// Notification events
//
#define SCREENCLOSE 0
#define SCREENOPEN  1

#endif
