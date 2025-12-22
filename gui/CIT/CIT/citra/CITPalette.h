//
//                    CITPalette include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITPALETTE_H
#define CITPALETTE_H TRUE

#include <citra/CITGadget.h>

#include <gadgets/palette.h>

//
// This enum is for internal use only
//
enum
{
  CITPALETTE_COLOUR = 0,
  CITPALETTE_COLOUROFFSET,
  CITPALETTE_COLOURTABLE,
  CITPALETTE_NUMCOLOURS,
  CITPALETTE_LAST
};

class CITPalette:public CITGadget
{
  public:
    CITPalette();
    ~CITPalette();


    void Colour(UBYTE col)
             {setTag(CITPALETTE_COLOUR,PALETTE_Colour,col);}
    void ColourOffset(UBYTE off)
             {setTag(CITPALETTE_COLOUROFFSET,PALETTE_ColourOffset,off);}
    void ColourTable(UBYTE* tab)
             {setTag(CITPALETTE_COLOURTABLE,PALETTE_ColourTable,ULONG(tab));}
    void NumColours(UWORD numCol)
             {setTag(CITPALETTE_NUMCOLOURS,PALETTE_NumColours,numCol);}

    UBYTE  Colour()
             { return getTag(PALETTE_Colour); }
    UBYTE  ColourOffset()
             { return getTag(PALETTE_ColourOffset); }
    UBYTE* ColourTable()
             { return (UBYTE*)(getTag(PALETTE_ColourTable)); }
    UWORD  NumColours()
             { return getTag(PALETTE_NumColours); }

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void  setTag(int index,ULONG attr,ULONG val);
    ULONG getTag(ULONG attr);

    TagItem* paletteTag;
};

enum
{
  PALETTECLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
