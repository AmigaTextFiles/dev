//
//                    CITGetFile include
//
//                          StormC
//
//                     version 2002.03.20
//

#ifndef CITGETFILE_H
#define CITGETFILE_H TRUE

#include <citra/CITGadget.h>

#include <gadgets/getfile.h>

//
// This enum is for internal use only
//
enum
{
  CITGETFILE_TITLETEXT = 0,
  CITGETFILE_LEFTEDGE,
  CITGETFILE_TOPEDGE,
  CITGETFILE_WIDTH,
  CITGETFILE_HEIGHT,
  CITGETFILE_FILE,
  CITGETFILE_DRAWER,
  CITGETFILE_FULLFILE,
  CITGETFILE_FULLFILEEXPAND,
  CITGETFILE_PATTERN,
  CITGETFILE_DOSAVEMODE,
  CITGETFILE_DOMULTISELECT,
  CITGETFILE_DOPATTERNS,
  CITGETFILE_DRAWERSONLY,
  CITGETFILE_FILTERFUNC,
  CITGETFILE_REJECTICONS,
  CITGETFILE_REJECTPATTERN,
  CITGETFILE_ACCEPTPATTERN,
  CITGETFILE_FILTERDRAWERS,
  CITGETFILE_FILELIST,
  CITGETFILE_LBNODESTRUCTS,
  CITGETFILE_READONLY,
  CITGETFILE_FILEPARTONLY,
  CITGETFILE_LAST
};

class CITGetFile:public CITGadget
{
  public:
    CITGetFile();
    ~CITGetFile();

    void RequesterLeftEdge(WORD x)
           {setTag(CITGETFILE_LEFTEDGE,GETFILE_LeftEdge,x);}
    void RequesterTopEdge(WORD y)
           {setTag(CITGETFILE_TOPEDGE,GETFILE_TopEdge,y);}
    void RequesterWidth(WORD w)
           {setTag(CITGETFILE_WIDTH,GETFILE_Width,w);}
    void RequesterHeight(WORD h)
           {setTag(CITGETFILE_HEIGHT,GETFILE_Height,h);}
    void RequesterTitleText(char* text)
           {setTag(CITGETFILE_TITLETEXT,GETFILE_TitleText,ULONG(text));}
    void File(char* file)
           {setTag(CITGETFILE_FILE,GETFILE_File,ULONG(file));}
    void Drawer(char* drawer)
           {setTag(CITGETFILE_DRAWER,GETFILE_Drawer,ULONG(drawer));}
    void FullFile(char* file)
           {setTag(CITGETFILE_FULLFILE,GETFILE_FullFile,ULONG(file));}
    void FullFileExpand(BOOL b = TRUE)
           {setTag(CITGETFILE_FULLFILEEXPAND,GETFILE_FullFileExpand,b);}
    void Pattern(char* pat)
           {setTag(CITGETFILE_PATTERN,GETFILE_Pattern,ULONG(pat));}
    void DoSaveMode(BOOL b = TRUE)
           {setTag(CITGETFILE_DOSAVEMODE,GETFILE_DoSaveMode,b);}
    void DoMultiSelect(BOOL b = TRUE)
           {setTag(CITGETFILE_DOMULTISELECT,GETFILE_DoMultiSelect,b);}
    void DoPatterns(BOOL b = TRUE)
           {setTag(CITGETFILE_DOPATTERNS,GETFILE_DoPatterns,b);}
    void DrawersOnly(BOOL b = TRUE)
           {setTag(CITGETFILE_DRAWERSONLY,GETFILE_DrawersOnly,b);}
    void RejectIcons(BOOL b = TRUE)
           {setTag(CITGETFILE_REJECTICONS,GETFILE_RejectIcons,b);}
    void RejectPattern(UBYTE* rejPat)
           {setTag(CITGETFILE_REJECTPATTERN,GETFILE_RejectPattern,ULONG(rejPat));}
    void AcceptPattern(UBYTE* accPat)
           {setTag(CITGETFILE_ACCEPTPATTERN,GETFILE_AcceptPattern,ULONG(accPat));}
    void FilterDrawers(BOOL b = TRUE)
           {setTag(CITGETFILE_FILTERDRAWERS,GETFILE_FilterDrawers,b);}
    void LBNodeStructs(BOOL b = TRUE)
           {setTag(CITGETFILE_LBNODESTRUCTS,GETFILE_LBNodeStructs,b);}
    void ReadOnly(BOOL b = TRUE)
           {setTag(CITGETFILE_READONLY,GETFILE_ReadOnly,b);}
    void FilePartOnly(BOOL b = TRUE)
           {setTag(CITGETFILE_FILEPARTONLY,GETFILE_FilePartOnly,b);}

    WORD  RequesterLeftEdge()
           { return getTag(GETFILE_LeftEdge); }
    WORD  RequesterTopEdge()
           { return getTag(GETFILE_TopEdge); }
    WORD  RequesterWidth()
           { return getTag(GETFILE_Width); }
    WORD  RequesterHeight()
           { return getTag(GETFILE_Height); }
    char* File()
           { return (char*)getTag(GETFILE_File); }
    char* Drawer()
           { return (char*)getTag(GETFILE_Drawer); }
    char* FullFile()
           { return (char*)getTag(GETFILE_FullFile); }
    char* Pattern()
           { return (char*)getTag(GETFILE_Pattern); }
    List* Filelist()
           { return (List*)getTag(GETFILE_Filelist); }

    void RequestFile();
    void FreeFilelist(List* list);

    void FilterFunc(ULONG (*p)(struct FileRequest* fReq,struct AnchorPath* anch,ULONG myData),ULONG userData)
          {CITGadget::CallbackHook(CALLBACKHOOK(p),userData);}
    void FilterFunc(void* obj,ULONG (*p)(void*,struct FileRequest* fReq,struct AnchorPath* anch,ULONG myData),ULONG userData)
          {CITGadget::CallbackHook(obj,MEMBERCALLBACKHOOK(p),userData);}

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);
    virtual void    hookSetup(ULONG userData);

  private:
    void  setTag(int index,ULONG attr,ULONG val);
    ULONG getTag(ULONG attr);

    TagItem* getFileTag;
};

enum
{
  GETFILECLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
