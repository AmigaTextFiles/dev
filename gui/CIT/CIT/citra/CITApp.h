#ifndef CIT_CITAPP_H
#define CIT_CITAPP_H TRUE

//
//                       CIT_App include
//
//                            StormC
//
//                        version 2002.02.02
//

#include <citra/CITLists.h>

class CITApp;

class CITAppClass:public CITNode
{
  public:
    class CITApp *CITApp;

    CITAppClass();
    ~CITAppClass();

  protected:
    friend class CITApp;
    
    ULONG ExceptSignals;
    ULONG EventSignals;

    virtual BOOL Create(class CITApp* app);
    virtual void Delete();
    virtual void HandleExcept(ULONG Sigs);
    virtual void HandleEvent(ULONG Sigs);
};


#define MAIN_STOPMASK  (1<<0)

class CITApp
{
  public:
    CITApp();
    ~CITApp();

    void  InsObject(CITAppClass &Object,BOOL &Err);
    void  RemObject(CITAppClass &Object);
    ULONG Run(ULONG stopMask=MAIN_STOPMASK);
    void  Stop(ULONG mask=MAIN_STOPMASK);
    void  Disable();
    void  Enable();
    
    void AddExcept(ULONG Sigs);
    void RemExcept(ULONG Sigs);
    void AddEvent(ULONG Sigs) { WaitSignal |= Sigs; }
    void RemEvent(ULONG Sigs) { WaitSignal &= ~Sigs; }

  protected:
    virtual void HandleExcept(ULONG Sigs);
    virtual void HandleEvent(ULONG Sigs);
    
  private:
    friend void HandleExceptEntry(CITApp* app,ULONG Sigs);

    class CITList* ObjectList;
    ULONG ExceptSignal;
    ULONG WaitSignal;
    ULONG stopReq;
    UWORD disableCount;
    BYTE  sleepSignal;
};

#endif
