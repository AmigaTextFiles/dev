//
//                    CITLabel include
//
//                        StormC
//
//                   version 2003.02.12
//

#ifndef CITLABEL_H
#define CITLABEL_H TRUE

#include <citra/CITImage.h>

class CITLabel:public CITImage
{
  public:
    CITLabel();
    ~CITLabel();

    void Text(char* text);
    void Font(char *Name, int Height, int Width = 0);
    void FGPen(LONG pen);
    void BGPen(LONG pen);
    void Mode(UBYTE mode);
    void SoftStyle(UBYTE style);
    void Image(struct Image* im);
    void DisposeImage(BOOL b = TRUE);
    void Mapping(UWORD* map,DrawInfo* drInfo = NULL);
    void Justification(UWORD pos);

  protected:  
    virtual Object* NewObjectA(TagItem* tags);
    
  private:
    void setTag(int index,ULONG attr,ULONG val);

    CITList  labTagList;
    TagItem* labelTag;
};
    
enum
{
  LABELCLASS_FLAGBITUSED = IMAGECLASS_FLAGBITUSED
};

#endif
