//
//                     CITPopUpWindow include
//
//                             StormC
//
//                       version 2003.02.20
//


#ifndef CITPOPUPWINDOW_H
#define CITPOPUPWINDOW_H TRUE


#include <citra/CITGroup.h>
#include <citra/CITButton.h>

class CITPopUpWindow:public CITWindow
{
  public:
    CITPopUpWindow();

    void CloseGadget(BOOL b =TRUE);
    
    void InsObject(CITWindowClass &winClass,BOOL &Err)
      {infoGroup.InsObject(winClass,Err);}
      
    void InsAcceptButton(BOOL& Err);
    void InsAcceptButton(char* t,BOOL& Err);
    void InsCancelButton(BOOL& Err);
    void InsCancelButton(char* t,BOOL& Err);

    void AcceptText(char* t) {acceptButton.Text(t);}
    void AcceptMaxWidth(int w) {acceptButton.MaxWidth(w);}
    void AcceptMinWidth(int w) {acceptButton.MinWidth(w);}
    void AcceptMaxHeight(int h) {acceptButton.MaxHeight(h);}
    void AcceptMinHeight(int h) {acceptButton.MinHeight(h);}
    void AcceptWeightedWidth(int w) {acceptButton.WeightedWidth(w);}
    void AcceptWeightedHeight(int h) {acceptButton.WeightedHeight(h);}

    void CancelText(char* t) {cancelButton.Text(t);}
    void CancelMaxWidth(int w) {cancelButton.MaxWidth(w);}
    void CancelMinWidth(int w) {cancelButton.MinWidth(w);}
    void CancelMaxHeight(int h) {cancelButton.MaxHeight(h);}
    void CancelMinHeight(int h) {cancelButton.MinHeight(h);}
    void CancelWeightedWidth(int w) {cancelButton.WeightedWidth(w);}
    void CancelWeightedHeight(int h) {cancelButton.WeightedHeight(h);}

  protected:
    virtual void closeEvent();
    virtual void acceptEvent(ULONG Id,ULONG eventFlag);
    virtual void cancelEvent(ULONG Id,ULONG eventFlag);

    CITVGroup  mainGroup;
    CITGroup   infoGroup;
    CITHGroup  buttonGroup;
    CITButton  acceptButton;
    CITButton  cancelButton;

  private:
    static void closeEventStub(void* obj);
    static void acceptEventStub(void* obj,ULONG Id,ULONG eventFlag);
    static void cancelEventStub(void* obj,ULONG Id,ULONG eventFlag);

    ULONG Flags;
};

//
// Flags
//
#define INCLUDEACCEPT (1<<0)
#define INCLUDECANCEL (1<<1)

//
// Stop codes
//
#define POPUP_CLOSE  (1<<1)
#define POPUP_ACCEPT (1<<2)
#define POPUP_CANCEL (1<<3)

enum
{
  POPUPWINDOWCLASS_FLAGBITUSED = WINCLASS_FLAGBITUSED
};

#endif // CITPOPUPWINDOW_H
