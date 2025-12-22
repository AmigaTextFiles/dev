//
//                     CITFileRequest include
//
//                             StormC
//
//                       version 2003.02.20
//


#ifndef CITFILEREQUEST_H
#define CITFILEREQUEST_H TRUE

#include <citra/CITPopUpWindow.h>
#include <citra/CITListBrowser.h>
#include <citra/CITString.h>

//
// File Request Flags
//
#define CITFR_PATTERN         (1<<0)
#define CITFR_SAVEFILE        (1<<1)
#define CITFR_DIRS            (1<<2)


typedef enum
{
  UPDATE_FILES,
  UPDATE_VOLUMES
}
UpdateType;



class CITFileRequest:public CITPopUpWindow
{
  public:
    CITFileRequest();

    void acceptText(char* t) {acceptLabel=t;}
    void cancelText(char* t) {cancelLabel=t;}
    void volumeText(char* t) {volumeLabel=t;}
    void parentText(char* t) {parentLabel=t;}

    void  SaveRequest(BOOL b = TRUE) {if(b) fr_Flags|=CITFR_SAVEFILE; else fr_Flags &=~CITFR_SAVEFILE;}
    void  DirRequest(BOOL b=TRUE) {if(b) fr_Flags|=CITFR_DIRS; else fr_Flags &=~CITFR_DIRS;}

    virtual void  Pattern(char* p);
    virtual void  FullPath(char* p);
    virtual void  Drawer(char* d);
    virtual void  File(char* f);
    virtual char* Drawer();
    virtual char* File();

  protected:
    virtual BOOL Create(CITScreen* CITScr);
    virtual void Delete(); 

    virtual void listBrowserEvent(ULONG Id,ULONG eventFlag);
    virtual void patternInpEvent(ULONG Id,ULONG eventFlag);
    virtual void drawerInpEvent(ULONG Id,ULONG eventFlag);
    virtual void fileInpEvent(ULONG Id,ULONG eventFlag);
    virtual void volumeEvent(ULONG Id,ULONG eventFlag);
    virtual void parentEvent(ULONG Id,ULONG eventFlag);

    virtual void updateView(UpdateType ut=UPDATE_FILES );
    virtual void readFiles(CITList* fileList);
    virtual void readVolumes(CITList* fileList);

    CITHGroup      userGroup;
    CITListBrowser fileLB;

    CITString      patternInput;
    CITString      drawerInput;
    CITString      fileInput;
    CITButton      volumeButton;
    CITButton      parentButton;
    CITList        lbList;

    ColumnInfo ci[5];    
    
    char* acceptLabel;
    char* cancelLabel;
    char* volumeLabel;
    char* parentLabel;

    char file[110];
    char drawer[256];
    char pattern[128];

  private:
    BOOL displayName(char* name,char* pattern,UWORD type);
    
    static void listBrowserEventStub(void* obj,ULONG Id,ULONG eventFlag);
    static void patternInpEventStub(void* obj,ULONG Id,ULONG eventFlag);
    static void drawerInpEventStub(void* obj,ULONG Id,ULONG eventFlag);
    static void fileInpEventStub(void* obj,ULONG Id,ULONG eventFlag);
    static void volumeEventStub(void* obj,ULONG Id,ULONG eventFlag);
    static void parentEventStub(void* obj,ULONG Id,ULONG eventFlag);

    ULONG fr_Flags;
};


//
// File Node Types (also used as node priority)
//
#define TYPE_FILE       0
#define TYPE_DIR        1
#define TYPE_ASSIGN     2
#define TYPE_VOLUME     3

enum
{
  FILEREQUESTCLASS_FLAGBITUSED = POPUPWINDOWCLASS_FLAGBITUSED
};

#endif // CITFILEREQUEST_H
