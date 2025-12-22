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
#ifndef CEFFECT_H
#define CEFFECT_H

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#include <time.h>
#ifdef _AMIGAOS
#include <exec/exec.h>
#include <intuition/intuition.h>
#include <stdio.h>
#include <stdlib.h>
#include <proto/all.h>
#include "amigaType.h"
#endif

//---------------------------------------------------------------------------
class CBaseEffect
{
public:

  //Public API

  CBaseEffect(int width = 320,int height = 200);
  virtual ~CBaseEffect();
  void Update(BYTE *pBitmap);

  //Pour recuperer la palette de l'effet
  void GetPalette(PALETTEENTRY *pPalette, int nOffset=0, int nLength=256);

  //Position et taille de l'effet
  void SetPosition(int x, int y);
  void SetSize(int w,int h);

  //Calcul du temps et des FPS
  void ResetTime();
  long GetTime();
  float GetFPS();

protected:
  int m_x,m_y, m_width, m_height;
  BYTE *m_pBitmapBuffer;
  long m_nFrameDisplayed;
  clock_t m_TimeStart, m_TimeEnd;
};

#endif