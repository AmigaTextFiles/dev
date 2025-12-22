//===========================================================================
//
// Amiga Demo Tutorial - Alain Bocherens [alain@devils.ch]
//
// Nom: BaseEffect.h
//
// Classes: CBaseEffect
//
// Fonction: Classe de base de tous les effets graphiques
//
//===========================================================================

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#ifdef _WINDOWS 
#include <windows.h>
#endif   
#include "BaseEffect.h"
#include <string.h>


//---------------------------------------------------------------------------
CBaseEffect::CBaseEffect(int width, int height)
{
  m_width = width;
  m_height = height;
  m_x = 0;
  m_y = 0;
  m_pBitmapBuffer = NULL;
  ResetTime();
}

//---------------------------------------------------------------------------
CBaseEffect::~CBaseEffect()
{
}

//---------------------------------------------------------------------------
void CBaseEffect::GetPalette(PALETTEENTRY *pPalette, int nOffset, int nLength)
{
}

//---------------------------------------------------------------------------
void CBaseEffect::Update(BYTE *pBitmap)
{
  m_pBitmapBuffer = pBitmap;

#ifdef _FPS
  m_nFrameDisplayed++;
  m_TimeEnd = clock();
#endif
}

//---------------------------------------------------------------------------
// Methode pour gerer la taille et la position de l'effet
//---------------------------------------------------------------------------
void CBaseEffect::SetPosition(int x, int y)
{
  m_x = x;
  m_y = y;
}

//---------------------------------------------------------------------------
void CBaseEffect::SetSize(int w,int h)
{
  m_height = h;
  m_width = w;
}

//---------------------------------------------------------------------------
// methodes pour le calcul du temps et des FPS
//---------------------------------------------------------------------------
void CBaseEffect::ResetTime()
{
  m_nFrameDisplayed = 0;
  m_TimeStart = clock();
}

//---------------------------------------------------------------------------
long CBaseEffect::GetTime()
{
  return (m_TimeEnd - m_TimeStart)*1000/CLOCKS_PER_SEC;
}

//---------------------------------------------------------------------------
float CBaseEffect::GetFPS()
{
  return (float)m_nFrameDisplayed*1000/GetTime();
}
//---------------------------------------------------------------------------