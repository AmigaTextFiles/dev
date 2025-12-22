//
//                    CITRootClass include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITROOTCLASS_H
#define CITROOTCLASS_H TRUE

#include <citra/CITWindow.h>

class CITRootClass:public CITWindowClass
{
  public:
    CITRootClass();
    ~CITRootClass();

    void Inverted(BOOL b = TRUE);
    void Font(char *Name, int Height, int Width = 0);
    
    Object* objectPtr() { return object; }

    virtual BOOL Attach(Object* object,TagItem* tag,WORD first=FALSE);
    virtual void Detach(Object* object);
    
  protected:
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    virtual void Delete();
    virtual Object* NewObjectA(TagItem* tags);

    struct IClass* classPtr;
    STRPTR className;

    ULONG   objectID;
    Object* object;

    TTextAttr objectTextAttr;
    TextFont* objectTextFont;
    
    CITContainer* container;
};

enum
{
  DISPOSE_OBJECT_BIT = WINCLASS_FLAGBITUSED,
  INSERT_INVERTED_BIT,
  ATTACH_OBJECT_BIT,
  ROOTCLASS_FLAGBITUSED
};

#define DISPOSE_OBJECT  (1<<DISPOSE_OBJECT_BIT)
#define INSERT_INVERTED (1<<INSERT_INVERTED_BIT)
#define ATTACH_OBJECT   (1<<ATTACH_OBJECT_BIT)

#endif
