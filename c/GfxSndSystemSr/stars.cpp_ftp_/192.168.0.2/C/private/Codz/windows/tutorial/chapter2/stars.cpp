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

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#include <iostream.h>
#include <stdlib.h>  

#ifdef _WINDOWS
#include <windows.h>
#endif

#ifdef _AMIGAOS
#include "AmigaType.h"
#endif   

#include "stars.h"
//---------------------------------------------------------------------------
CStars::CStars(int width, int height, int nNumberStar ) : CBaseEffect(width, height)
{
  //on stocke le nombre d'etoile
  m_nNumberStar = nNumberStar;

  //on alloue la memoire pour les etoiles
  m_pStars = new TStar[m_nNumberStar];

  //on genere au hasard des etoiles
  for (int i=0; i<m_nNumberStar; i++)
  {
    m_pStars[i].x = (float)(rand() % m_width);
    m_pStars[i].y = (float)(rand() % m_height);
    m_pStars[i].plane = rand() % 3;     // couleur de l'etoile entre 0 et 2
  }
}

//---------------------------------------------------------------------------
CStars::~CStars()
{
  // on libere la memoire
  delete [] (m_pStars);
}

//---------------------------------------------------------------------------
void CStars::GetPalette(PALETTEENTRY *pPalette)
{
  //on genere la palette (tout noir, sauf les couleurs 248 - 250 )
  int i;
  for(i=0;i<256;i++)
    pPalette[i].peRed = pPalette[i].peGreen = pPalette[i].peBlue = 0;

  pPalette[248].peRed = pPalette[248].peGreen = pPalette[248].peBlue = 100;
  pPalette[249].peRed = pPalette[249].peGreen = pPalette[249].peBlue = 190;
  pPalette[250].peRed = pPalette[250].peGreen = pPalette[250].peBlue = 255;
}

//---------------------------------------------------------------------------
void CStars::Update(BYTE *pBitmap)
{
  //On appelle la classe de base
  CBaseEffect::Update( pBitmap );

  //on update chaque etoile
  for (int i=0; i<m_nNumberStar; i++)
  {
    // on bouge l'etoile a droite, la vitesse dependant du plan de l'etoile..
    m_pStars[i].x += (float)((1+(float)m_pStars[i].plane)*0.15);

    // on checke si l'etoile est sortie de l'ecran
    if (m_pStars[i].x>m_width)
    {
    // si elle est sortie on la remet a 0
      m_pStars[i].x = 0;
    // et on genere sa position verticale au hasard
      m_pStars[i].y = (float)(rand() % m_height);
    }
    // on dessine l'etoile avec une couleur dependant du plan
    m_pBitmapBuffer[(int)m_pStars[i].x + m_x + (int)(m_pStars[i].y + m_y)* 320] = 248+m_pStars[i].plane;
  }
  
}
//---------------------------------------------------------------------------
