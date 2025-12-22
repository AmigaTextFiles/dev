//
//                CITTimer include
//
//                     StormC
//
//                version 2003.02.22
//

#ifndef CIT_CITTIMER_H
#define CIT_CITTIMER_H TRUE

#include <citra/CITApp.h>

extern void SysTime(ULONG &t);
extern void SysTime(double &t);
extern ULONG EClock(struct EClockVal &ev);

class CITTimer:public CITAppClass
{
  public:
    void AddEvent(double t,void (*p)(),BYTE prior=0);
    void AddEvent(double t,void *obj, void (*p)(void* obj),BYTE prior=0);
    void Abort(void (*p)());
    void Abort(void *obj,void (*p)(void* obj));
    CITTimer();
    ~CITTimer();

  protected:
    virtual BOOL Create(class CITApp* CITApp);
    virtual void Delete(); 
    virtual void HandleExcept(ULONG Sigs);
    virtual void HandleEvent(ULONG Sigs);

  private:
    CITList trList0;
    CITList trList1;
    struct timerequest *tr0;
    struct MsgPort *ReplyPort0;
    struct timerequest *tr1;
    struct MsgPort *ReplyPort1;
    
    void CleanUp();
    void AddRequest(double t,class TimerReqNode* tn,BYTE prior);
};

#endif
