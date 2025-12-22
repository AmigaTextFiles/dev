//===========================================================================
//
// Amiga Demo Tutorial - Alain Bocherens [alain@devils.ch]
//
// Nom: demo.cpp
//
// Classes: CMyGfxSupport (fichier principal)
//
// Fonction: Fichier principal d'une demo affichant un champs d'etoiles ave 
//           musique.
//
//===========================================================================

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#include "GfxSupport.h"
#include "Stars.h"
#include "ModulePlayer.h"
#include <stdio.h>

//---------------------------------------------------------------------------
// derivation de la classe CGfxSupport pour la demo
//---------------------------------------------------------------------------
class CMyGfxSupport : public CGfxSupport
{
public:
  //Methodes virtuelles pour etre au courant des changements
  virtual void OnDisplayFrame(BYTE *pBitmapBuffer);
  virtual void OnInit();
  virtual void OnEnd();
 
  //L'effet Stars
  CStars m_Stars;
  
  //La musique
  CModulePlayer m_ModPlayer;

  //Pour stocker la palette
  PALETTEENTRY m_aPalette[256];

  //variable pour le changement de la palette 
  BOOL m_bFirstTime;
};

//---------------------------------------------------------------------------
void CMyGfxSupport::OnDisplayFrame(BYTE *pBitmapBuffer)
{
  m_ModPlayer.FillBuffer();
  // si premiere fois, on set la palette
  if(m_bFirstTime )
  {
    m_Stars.GetPalette(m_aPalette);
    SetPalette( m_aPalette );
    m_bFirstTime = FALSE;
    m_Stars.ResetTime();
  }

  //on efface l'ecran
  memset(pBitmapBuffer,0,64000);

  //On affiche les etoiles
  m_Stars.Update(pBitmapBuffer);
}

//---------------------------------------------------------------------------
void CMyGfxSupport::OnInit()
{
  //on initialise la variable
  m_bFirstTime = TRUE;
  
  //On prepare la musique
#ifdef _WINDOWS
  m_ModPlayer.Init((DWORD)m_hWnd);
#endif

  m_ModPlayer.Load("dre.mod");
  
  //On la joue
  m_ModPlayer.Play();
}

//---------------------------------------------------------------------------
void CMyGfxSupport::OnEnd()
{
  //On arrete la musique
  m_ModPlayer.Stop();
  
#ifdef _FPS
  //on affiche le nombre (approximatif) de FPS
  char str[256];
  sprintf(str,"FPS: %f",m_Stars.GetFPS());
  DemoMessageBox(str);
#endif
}

//---------------------------------------------------------------------------
// main de la demo
//---------------------------------------------------------------------------
DEMOMAIN
{
  //On initialise
  CMyGfxSupport m_Gfx;
  m_Gfx.SetResolution(320,200,8);
  m_Gfx.InitDisplay();
  return 0;
}
//---------------------------------------------------------------------------
