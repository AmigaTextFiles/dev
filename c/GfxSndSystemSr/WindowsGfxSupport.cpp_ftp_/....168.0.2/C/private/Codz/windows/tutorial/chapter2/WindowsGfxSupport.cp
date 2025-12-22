//===========================================================================
//
// Amiga Demo Tutorial - Alain Bocherens [alain@devils.ch]
//
// Nom: WindowsGfxSupport.cpp
//
// Classes: CGfxSupport
//
// Fonction: Implementation de la couche d'abstraction graphique
//           pour Windows (DirectDraw).
//
//===========================================================================

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#include "GfxSupport.h"

//---------------------------------------------------------------------------
CGfxSupport::CGfxSupport()
{
  //init des variables
  m_nWidth = 320;
  m_nHeight = 200;
  m_nBBPlane = 8;
  m_pDD = NULL;
  m_pDDSPrimary = NULL;
  m_pDDSBack = NULL;
  m_pDDSBitmap = NULL;
  m_hWnd = NULL;
  m_hAccel = NULL;
  m_bSetPalette = false;
}

//---------------------------------------------------------------------------
CGfxSupport::~CGfxSupport()
{
}

//---------------------------------------------------------------------------
void CGfxSupport::SetResolution(int nWidth, int nHeight, int nBBplane)
{
  //set les variables de resolutions/nombre de couleurs
  m_nWidth = nWidth;
  m_nHeight = nHeight;
  m_nBBPlane = nBBplane;
}

//---------------------------------------------------------------------------
void CGfxSupport::SetPalette(PALETTEENTRY *aPalette)
{
  //stocke la nouvelle palette,et change le flag a true pour qu'a la prochaine
  //image la palette soit modifiee
  m_bSetPalette = true;
  m_paPalette = aPalette;
}

//---------------------------------------------------------------------------
int CGfxSupport::InitDisplay()
{
  //Crée une fenetre
  if(false == CreateDemoWindow(0, 0))
  {
    return -1;
  }

  //Appelle la fonction OnInit qui permet d'initialiser les effets de la demo
  OnInit();
  
  //Initialise DirectDraw, et change la resolution de l'ecran
  if( false == InitDirectDraw())
  {
    return -1;
  }

  //Lance la boucle de message
  int returnvalue = MsgLoop();

  //Appelle la fonction OnEnd pour desinitialiser les effets de la demo.
  OnEnd();

  //On rend la main
  return returnvalue;
}

//---------------------------------------------------------------------------
bool CGfxSupport::CreateDemoWindow(HINSTANCE hInstance, int nCmdShow)
{
  WNDCLASS wc;

  //definition de la classe
  wc.style = CS_HREDRAW || CS_VREDRAW;
  wc.cbClsExtra = 0;
  wc.cbWndExtra = 0;
  wc.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
  wc.hCursor = LoadCursor( (HINSTANCE)NULL, IDC_ARROW);
  wc.hIcon = LoadIcon( (HINSTANCE)NULL, IDI_APPLICATION);
  wc.hInstance = hInstance;
  wc.lpfnWndProc = WndProc;
  wc.lpszClassName = "MainWndClass";
  wc.lpszMenuName = NULL;

  //Enregistrement
  if(0 == RegisterClass(&wc))
  {
    return false;
  }

  // Chargement des accelerators (pour la touche ESC)
  m_hAccel = LoadAccelerators( hInstance, MAKEINTRESOURCE(IDR_MAIN_ACCEL) );
  
  //Creation de la fenetre
  m_hWnd = CreateWindow(wc.lpszClassName,
                        "Demo window",
                        WS_POPUPWINDOW,
                        CW_USEDEFAULT,
                        CW_USEDEFAULT,
                        CW_USEDEFAULT,
                        CW_USEDEFAULT,
                        (HWND)NULL,
                        (HMENU)NULL,
                        hInstance,
                        (LPVOID)NULL);

  //Si la fenetre n'est pas cree, on retourne false.
  if( m_hWnd == NULL)
  {
     return false;
  }

  //On affiche la fenetre
  ShowWindow(m_hWnd, nCmdShow);

  //Et on l'update une premiere fois
  UpdateWindow(m_hWnd);

  //tout s'est bien passé.
  return true;
}

//---------------------------------------------------------------------------
bool CGfxSupport::InitDirectDraw()
{
  
  //Surfaces
  DDSCAPS2 ddsc;
  DDSURFACEDESC2 sd;

  //Creation d'un objet DirectDraw
  if( FAILED(DirectDrawCreateEx(NULL,(VOID**)&m_pDD, IID_IDirectDraw7,NULL)))
  {
    return false;
  }

  //Changement du niveau de coopération de la carte gfx. (plein ecran/Exclusif)
  if( FAILED(m_pDD->SetCooperativeLevel(m_hWnd,DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN) ))
  {
    return false;
  }

  //On change la resolution
  if( FAILED(m_pDD->SetDisplayMode(m_nWidth,m_nHeight,m_nBBPlane,0,0) ))
  {
    return false;
  }

  //On cree la structure Double Buffer
  ZeroMemory( &sd, sizeof( sd ) );
  sd.dwSize            = sizeof( sd );
  sd.dwFlags           = DDSD_CAPS | DDSD_BACKBUFFERCOUNT;
  sd.ddsCaps.dwCaps    = DDSCAPS_PRIMARYSURFACE | DDSCAPS_FLIP |
                             DDSCAPS_COMPLEX | DDSCAPS_3DDEVICE;
  sd.dwBackBufferCount = 1;

  if( FAILED(m_pDD->CreateSurface(&sd,&m_pDDSPrimary,NULL)))
  {
    return false;
  }

  //On retrouve un pointeur sur la back surface
  ZeroMemory(&ddsc,sizeof(ddsc));
  ddsc.dwCaps = DDSCAPS_BACKBUFFER;

  if( FAILED(m_pDDSPrimary->GetAttachedSurface(&ddsc, &m_pDDSBack)))
  {
    return false;
  }

  //On ajoute une reference sur la back surface (pour les smart pointers)
  m_pDDSBack->AddRef();

  //On cree une surface pour dessiner dessus
  DDSURFACEDESC2 ddsd;
  ZeroMemory( &ddsd, sizeof( ddsd ) );
  ddsd.dwSize         = sizeof( ddsd );
  ddsd.dwFlags        = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT; 
  ddsd.ddsCaps.dwCaps = DDSCAPS_OFFSCREENPLAIN;
  ddsd.dwWidth        = m_nWidth;
  ddsd.dwHeight       = m_nHeight;

  if( FAILED(m_pDD->CreateSurface(&ddsd, &m_pDDSBitmap,NULL)))
  {
	  return false;
  }

  //tout est OK
  return true;
}

//---------------------------------------------------------------------------
int CGfxSupport::MsgLoop()
{
  MSG msg;
  DDSURFACEDESC2 ddsd;
  ZeroMemory( &ddsd,sizeof(ddsd) );
  ddsd.dwSize = sizeof(ddsd);

  //Boucle infinie
  while( TRUE )
  {
    // Ici on checke les messages. 
    if( PeekMessage( &msg, NULL, 0, 0, PM_NOREMOVE ) )
    {
      if( 0 == GetMessage(&msg, NULL, 0, 0 ) )
      {
        // on a reçu le message WM_QUIT donc on sort
        return (int)msg.wParam;
      }
      
      // On s'occupe de l'accelerateur
      if( 0 == TranslateAccelerator( m_hWnd, m_hAccel, &msg ) )
      {
        TranslateMessage( &msg ); 
        DispatchMessage( &msg );
      }
    }
    else
    {
      //Si on a pas de messages on update l'affichage
      //On lock l'image avant de dessiner dessus
      m_pDDSBitmap->Lock( NULL, &ddsd, DDLOCK_WAIT, NULL );
      
      //On appelle OnDisplayFrame pour que la demo ecrive la nouvelle image
      OnDisplayFrame((BYTE*) ddsd.lpSurface);

      //on Unlock la surface
      m_pDDSBitmap->Unlock(NULL);

      //On la dessine sur la back surface
  	  m_pDDSBack->BltFast( 0, 0, m_pDDSBitmap, NULL, 0L );

      //Et on flip les images
      Present();
      
      //Si un changement de palette est a faire
      if(m_bSetPalette)
      {
        //On change la palette
        m_bSetPalette = false;
        LPDIRECTDRAWPALETTE pPalette = NULL;
        m_pDD->CreatePalette( DDPCAPS_8BIT, m_paPalette, &pPalette, NULL );
        m_pDDSPrimary->SetPalette( pPalette );
      }
    }
  }
}

//---------------------------------------------------------------------------
HRESULT CGfxSupport::Present()
{
  HRESULT hr;
  
  //On checke si les pointeurs sont valides
  if( NULL == m_pDDSPrimary && NULL == m_pDDSBack )
    return E_POINTER;
  
  //boucle infinie
  while( 1 )
  {
    //On flip les images
    hr = m_pDDSPrimary->Flip( NULL, 0 );
    
    //Si on a perdu la surface
    if( hr == DDERR_SURFACELOST )
    {
      m_pDDSPrimary->Restore();
      m_pDDSBack->Restore();
    }
    
    //Attend la fin du redraw
    if( hr != DDERR_WASSTILLDRAWING )
      return hr;
  }
}

//---------------------------------------------------------------------------
void CGfxSupport::DemoMessageBox(char* strMessage)
{
  //Affiche un simple message box avec le message strMessage dedant.
  MessageBox(NULL,strMessage,"Demo message", MB_OK);
}

//---------------------------------------------------------------------------
// Méthodes virtuelles
//---------------------------------------------------------------------------
void CGfxSupport::OnDisplayFrame(BYTE *pBitmapBuffer)
{
}

//---------------------------------------------------------------------------
void CGfxSupport::OnInit()
{
}

//---------------------------------------------------------------------------
void CGfxSupport::OnEnd()
{
}

//---------------------------------------------------------------------------
// Procédure principale de traitement des messages
//---------------------------------------------------------------------------
LRESULT CALLBACK WndProc(HWND hWnd,UINT Msg, WPARAM wParam,LPARAM lParam )
{
  switch( Msg )
  {
    //Si on a recu un message destroy, on post un message QUIT
  case WM_DESTROY:
    PostQuitMessage(0);
    return 0;

    //On met le curseur invisible
  case WM_SETCURSOR:
    SetCursor(NULL);
    return 0;

    //Exit
  case WM_COMMAND:
    switch( LOWORD(wParam) )
    {
    case IDM_EXIT:
      PostMessage( hWnd, WM_CLOSE, 0, 0 );
      return 0L;
    }
    break; 
  }

  // Appel des procedures par defaut
  return DefWindowProc( hWnd, Msg, wParam, lParam);
}
//---------------------------------------------------------------------------