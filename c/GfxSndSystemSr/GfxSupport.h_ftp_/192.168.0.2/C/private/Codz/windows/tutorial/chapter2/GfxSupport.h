//===========================================================================
//
// Amiga Demo Tutorial - Alain Bocherens [alain@devils.ch]
//
// Nom: GfxSupport.h
//
// Classes: CGfxSupport
//
// Fonction: Header de la couche d'abstraction graphique pour 
//           AmigaOS (AGA/CGX) et Windows (DirectDraw)
//
//===========================================================================
#ifndef GFXSUPPORT_H
#define GFXSUPPORT_H

//---------------------------------------------------------------------------
// Definition de la macro DEMOMAIN qui est la fonction main sous Amiga et
// WinMain sous Windows.
//---------------------------------------------------------------------------
#ifdef _WINDOWS
#define DEMOMAIN int APIENTRY WinMain( HINSTANCE hInst, HINSTANCE hPrevInst, LPSTR pCmdLine, int nCmdShow )
#endif

#ifdef _AMIGAOS
#define DEMOMAIN int main(int argc, char **argv)
#endif

//---------------------------------------------------------------------------
//Includes et variables/fonctions globales
//---------------------------------------------------------------------------
#ifdef _WINDOWS
#include <cmath>
#include <windows.h>
#include <ddraw.h>                   
#include <mmsystem.h>
#include "resource.h"

//callback function pour windows
LRESULT CALLBACK WndProc(HWND hWnd,UINT Msg, WPARAM wParam,LPARAM lParam );
#endif

#ifdef _AMIGAOS
#include "AmigaType.h"

//adresses des librairies
struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct DosBase *DosBase;
#endif

//---------------------------------------------------------------------------
//class CGfxSupport
//---------------------------------------------------------------------------
class CGfxSupport
{

// Public API
public:
  CGfxSupport();
  virtual ~CGfxSupport();

  int InitDisplay();
  virtual void OnDisplayFrame(BYTE *pBitmapBuffer);
  virtual void OnInit();
  virtual void OnEnd();
  
  void DemoMessageBox(char* strMessage);

  void SetResolution(int nWidth, int nHeight, int nBBplane);
  void SetPalette(PALETTEENTRY *aPalette);
  

// Variables protegées
protected:

  int m_nWidth;
  int m_nHeight;
  int m_nBBPlane;

// Membres spécifiques Windows
#ifdef _WINDOWS
public:
  HWND     m_hWnd;
private:

  bool CreateDemoWindow(HINSTANCE hInstance, int nCmdShow);
  bool InitDirectDraw();
  int MsgLoop();

  bool m_bSetPalette;
  PALETTEENTRY *m_paPalette;


  
  HRESULT Present();

  LPDIRECTDRAW7 m_pDD;
  LPDIRECTDRAWSURFACE7 m_pDDSPrimary,m_pDDSBack;
  LPDIRECTDRAWSURFACE7 m_pDDSBitmap;

  HACCEL m_hAccel;
#endif  

// Membres spécifiques Amiga
#ifdef _AMIGAOS
private:
  void OpenDemoScreen();
  void CloseDemoScreen();
  
  void OpenAGAScreen(ULONG DisplayID);
  void OpenCGXScreen(ULONG DisplayID);
  
  void DisplayChunkyScreen();
  void DisplayCGXChunkyScreen();
  
  void SetColor(int Number, BYTE r, BYTE g, BYTE b);

  void CloseLibraries();
  void OpenLibraries();
  struct Screen *m_pScreenBase;
  struct Window *m_pWindowBase;
  UBYTE *m_pChunkyScreenBase1;
  UBYTE *m_pChunkyScreenBase2;
  struct ScreenBuffer *m_pScreenBufferBase1;
  struct ScreenBuffer *m_pScreenBufferBase2;

   
  BOOL m_bCyberGraphX, m_bFlip;
#endif
};
#endif