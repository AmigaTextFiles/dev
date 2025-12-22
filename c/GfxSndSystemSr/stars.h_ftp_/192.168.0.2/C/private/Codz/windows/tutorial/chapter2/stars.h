//===========================================================================
//
// Amiga Demo Tutorial - Alain Bocherens [alain@devils.ch]
//
// Nom: stars.h
//
// Classes: CStars
//
// Fonction: Effet de champ d'etoiles (starfield)
//
//===========================================================================
#ifndef CSTARS_H
#define CSTARS_H

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#include "BaseEffect.h"

// structure pour une etoile
struct TStar
{
  float x, y;             // position
  unsigned char plane;    // plan
};

//---------------------------------------------------------------------------
class CStars : public CBaseEffect
{
public:
  CStars(int width = 320, int height = 200, int nNumberStar = 256);
  virtual ~CStars();
  void Update(BYTE *pBitmap);
  void GetPalette(PALETTEENTRY *pPalette);
  
protected:

  // nombre d'etoiles
  int m_nNumberStar;

  // les etoiles
  TStar *m_pStars;
private:
};
//---------------------------------------------------------------------------
#endif