//===========================================================================
//
// Amiga Demo Tutorial - Alain Bocherens [alain@devils.ch]
//
// Nom: AmigaGfxSupport.cpp
//
// Classes: CGfxSupport
//
// Fonction: Implementation de la couche d'abstraction graphique
//           pour Amiga (AGA/CyberGraphX).
//
//===========================================================================

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#include <exec/exec.h>
#include <intuition/intuition.h>
#include <stdio.h>
#include <stdlib.h>
#include <proto/all.h>
#include <graphics/gfx.h>
#include <pragmas/graphics_pragmas.h>  
#include "GfxSupport.h"
#include "c2p.h"


//---------------------------------------------------------------------------
// variables globales
//---------------------------------------------------------------------------
UWORD PointerGfx[]={0,0,0,0,0,0};

//---------------------------------------------------------------------------
CGfxSupport::CGfxSupport()
{
  //Init des variables
  m_bCyberGraphX = FALSE;
  m_nWidth = 320;
  m_nHeight = 200;
  m_nBBPlane = 8;

  m_pScreenBase = NULL;
  m_pWindowBase = NULL;
  m_pChunkyScreenBase1 = NULL;
  m_pChunkyScreenBase2 = NULL;
  m_pScreenBufferBase1 = NULL;
  m_pScreenBufferBase2  = NULL;
}

//---------------------------------------------------------------------------
CGfxSupport::~CGfxSupport()
{
}

//---------------------------------------------------------------------------
void CGfxSupport::SetResolution(int nWidth, int nHeight, int nBBplane)
{
  //Set les variables de resolution
  m_nWidth = nWidth;
  m_nHeight = nHeight;
  m_nBBPlane = nBBplane;
}

//---------------------------------------------------------------------------
void CGfxSupport::SetPalette(PALETTEENTRY *aPalette)
{
  //Set une nouvelle palette
  int i;
  for( i = 0; i < 256; i++ )
    SetColor(i, aPalette[i].peRed, aPalette[i].peGreen , aPalette[i].peBlue );
}

//---------------------------------------------------------------------------
int CGfxSupport::InitDisplay()
{
  //adresse du bouton gauche de la souris
  char *pMouseButton = (char*) 0xbfe001;

  //On ouvre les librairies
  OpenLibraries();

  //On ouvre l'ecran
  OpenDemoScreen();

  //On appelle la methode OnInit pour permettre d'initialiser 
  //les effets de la demo
  OnInit();

  //Tant que bouton de la souris pas appuyé
  while((*pMouseButton & 0x40) == 0x40)
  {
    //On appelle la methode OnDisplayFrame qui permet a la demo de dessiner
    //l'image
    OnDisplayFrame(m_pChunkyScreenBase1);

    //On affiche (soit en AGA, soit en CGX)
    if( m_bCyberGraphX == FALSE)
      DisplayChunkyScreen();
    else
      DisplayCGXChunkyScreen();
  }

  //On ferme l'ecran
  CloseDemoScreen();

  //On appelle la methode OnEnd qui permet de desinitialiser les effets de la demo
  OnEnd();

  //On ferme les librairies
  CloseLibraries();

  //Tout est OK.
  return 0;
}

//---------------------------------------------------------------------------
// methodes virtuelles
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
// Ouverture d'un écran AGA 8 bitplanes, de la fenêtre associée et du
// double buffer.
//---------------------------------------------------------------------------
void CGfxSupport::OpenDemoScreen()
{
  ULONG DisplayID = PAL_MONITOR_ID|LORES_KEY;

#ifdef _CYBERGRAPHX
  
  //Demande a CyberGraphX si un mode d'ecran correspond a nos besoins
  DisplayID = BestModeID(BIDTAG_NominalWidth,m_nWidth,BIDTAG_NominalHeight,m_nHeight,
              BIDTAG_Depth,8,TAG_DONE);

  //Si non on ouvre un ecran AGA
  if(( DisplayID == INVALID_ID) || (DisplayID == PAL_MONITOR_ID|LORES_KEY))
  {
    DisplayID = PAL_MONITOR_ID|LORES_KEY;
    m_bCyberGraphX = FALSE;
  }
  else
  {
    m_bCyberGraphX = TRUE;
  }
#endif

  //On ouvre l'ecran
  if( m_bCyberGraphX == TRUE )
  {
    OpenCGXScreen( DisplayID );
  }
  else
  {
    OpenAGAScreen( DisplayID );
  }
      

      
  // On efface le pointeur souris 
  SetPointer(m_pWindowBase,PointerGfx,0,0,0,0);
  
  //Allocation de l'espace chunky 
  m_pChunkyScreenBase1=(UBYTE*)AllocVec(m_nWidth*m_nHeight, MEMF_ANY|MEMF_CLEAR);
 
  if( m_pChunkyScreenBase1 == NULL)
  {
    //Erreur
    CloseDemoScreen();
    return;
  }

  //Allocation de l'espace chunky 
  m_pChunkyScreenBase2=(UBYTE*)AllocVec(m_nWidth*m_nHeight, MEMF_ANY|MEMF_CLEAR);

  if( m_pChunkyScreenBase2 == NULL)
  {
    //Erreur
    CloseDemoScreen();
    return;
  }
}
//-------------------------------------------------------------------------
void CGfxSupport::OpenCGXScreen(ULONG DisplayID)
{
  //On ouvre l'ecran
  m_pScreenBase=OpenScreenTags(NULL,SA_Left,0,
    SA_Top,0,
    SA_Width,m_nWidth,
    SA_Height,m_nHeight,
    SA_Depth,8,
    SA_DisplayID,DisplayID,
    SA_ShowTitle,FALSE,
    TAG_DONE);
  
  //Si l'ecran n'a pas ete ouvert
  if( m_pScreenBase == NULL)
  {
    //erreur, on ferme
    CloseDemoScreen();
    return;
  }
  
  //Ouverture d'une window sur l'écran pour intercepter
  //tous les messages
  m_pWindowBase=OpenWindowTags(NULL,WA_PubScreen,m_pScreenBase,
    WA_RMBTrap,TRUE,
    WA_SimpleRefresh,TRUE,
    WA_BackFill,LAYERS_NOBACKFILL,
    WA_Flags,WFLG_BACKDROP|WFLG_BORDERLESS,
    WA_IDCMP,IDCMP_VANILLAKEY,
    WA_Activate, TRUE,
    TAG_DONE);
  if( m_pWindowBase == NULL)
  {
    //erreur
    CloseDemoScreen();
    return;
  }
    
}
//---------------------------------------------------------------------------
void CGfxSupport::OpenAGAScreen(ULONG DisplayID)
{
  //On ouvre l'ecran
  m_pScreenBase=OpenScreenTags(NULL,SA_Left,0,
    SA_Top,0,
    SA_Width,m_nWidth,
    SA_Height,m_nHeight,
    SA_Depth,8,
    SA_FullPalette,TRUE,
    SA_Interleaved,TRUE,
    SA_Overscan,OSCAN_TEXT,
    SA_Type,CUSTOMSCREEN,
    SA_DisplayID,DisplayID,
    SA_ShowTitle,FALSE,
    TAG_DONE);
  
  //Si l'ecran n'a pas ete ouvert
  if( m_pScreenBase == NULL)
  {
    //erreur, on ferme
    CloseDemoScreen();
    return;
  }
  
  //Ouverture d'une window sur l'écran pour intercepter
  //tous les messages
  m_pWindowBase=OpenWindowTags(NULL,WA_PubScreen,m_pScreenBase,
    WA_RMBTrap,TRUE,
    WA_SimpleRefresh,TRUE,
    WA_BackFill,LAYERS_NOBACKFILL,
    WA_Flags,WFLG_BACKDROP|WFLG_BORDERLESS,
    WA_IDCMP,IDCMP_VANILLAKEY,
    WA_Activate, TRUE,
    TAG_DONE);
  if( m_pWindowBase == NULL)
  {
    //erreur
    CloseDemoScreen();
    return;
  }
  // Vérification du format de la bitmap. D'après les autodocs,
  // le Tag SA_Interleaved peut sauter si la mémoire chip n'est pas
  // suffisante pour allouer un espace video continue.
  // On en profite pour savoir si on a bien alloué un écran AGA.
  if((GetBitMapAttr(m_pScreenBase->RastPort.BitMap,BMA_FLAGS)
    & (BMF_INTERLEAVED|BMF_STANDARD))==(BMF_INTERLEAVED|BMF_STANDARD))
      
  {
    //Allocation d'une structure ScreenBuffer et d'une bitmap identique
    //à l'originale (ScreenBase)
    m_pScreenBufferBase1=AllocScreenBuffer(m_pScreenBase,NULL,SB_SCREEN_BITMAP);
    if( m_pScreenBufferBase1 == NULL)
    {
      //erreur
      CloseDemoScreen();
      return;
    }
      
    //Allocation d'une structure ScreenBuffer avec une structure
    //bitmap qui pointe directement la bitmap du ScreenBase
    m_pScreenBufferBase2=AllocScreenBuffer(m_pScreenBase,NULL,SB_COPY_BITMAP);
    if( m_pScreenBufferBase2 == NULL)
    {
      //erreur
      CloseDemoScreen();
      return;
    }
  }
  
}
//---------------------------------------------------------------------------
void CGfxSupport::OpenLibraries()
{
  //on ouvre les librairies ...
  DosBase = (struct DosBase*)OpenLibrary("dos.library",0L);
  GfxBase = (struct GfxBase*)OpenLibrary("graphics.library",0L);
  IntuitionBase = (struct IntuitionBase*)OpenLibrary("intuition.library",0L);
   
  //On verifie...
  if((DosBase == NULL) || (GfxBase == NULL) || (IntuitionBase == NULL))
    CloseLibraries();
}

//---------------------------------------------------------------------------
void CGfxSupport::CloseLibraries()
{
  //Fermeture de toutes les librairies ouvertes
  if (DosBase != NULL) 
    CloseLibrary((struct Library*)DosBase);
  if (IntuitionBase != NULL) 
    CloseLibrary((struct Library*)IntuitionBase);
  if (GfxBase != NULL) 
    CloseLibrary((struct Library*)GfxBase);

}

//---------------------------------------------------------------------------
// Fermeture de l'écran et libération de la structure Video
//---------------------------------------------------------------------------
void CGfxSupport::CloseDemoScreen()
{
  //Liberation du chunky
  FreeVec(m_pChunkyScreenBase1);
  FreeVec(m_pChunkyScreenBase2);
   
  //On ferme la fenetre
  if(m_pWindowBase != NULL) 
  {
    CloseWindow(m_pWindowBase);
  }
   
  //On ferme l'ecran
  if(m_pScreenBase)
  {
  	 if( m_pScreenBufferBase1)
      FreeScreenBuffer(m_pScreenBase,m_pScreenBufferBase1);
    if( m_pScreenBufferBase2)
      FreeScreenBuffer(m_pScreenBase,m_pScreenBufferBase2);

    CloseScreen(m_pScreenBase);
  }
}

//---------------------------------------------------------------------------
// Cette fonction execute une c2p sur la bitmap non visible et swap celle-ci
// au premier plan.
//---------------------------------------------------------------------------
void CGfxSupport::DisplayChunkyScreen()
{
    struct ScreenBuffer *t;
    struct BitMap *bm=m_pScreenBufferBase2->sb_BitMap;

    // c2p sur la bitmap arrière (non visible) 
    WriteChunkyPixel256_Fast_v12(bm,m_pChunkyScreenBase1,0,0,m_nWidth,m_nHeight);

    // swaping des buffers 
    t=m_pScreenBufferBase2;
    m_pScreenBufferBase2=m_pScreenBufferBase1;
    m_pScreenBufferBase1=t;

    // passage de la bitmap arrière vers l'avant 
    ChangeScreenBuffer(m_pScreenBase,t);
}

//---------------------------------------------------------------------------
void CGfxSupport::DisplayCGXChunkyScreen()
{
  UBYTE *p = m_pChunkyScreenBase1;
  m_pChunkyScreenBase1 = m_pChunkyScreenBase2;
  m_pChunkyScreenBase2 = p;

//  WaitTOF();  
  WriteChunkyPixels(&m_pScreenBase->RastPort,0,0,320,199,p,320);

}

//---------------------------------------------------------------------------
// Initialisation des palettes de la video, au format LONG.
// 1<=NColors<=256
//---------------------------------------------------------------------------
void CGfxSupport::SetColor(int Number, BYTE r, BYTE g, BYTE b)
{
	ULONG ur,ug,ub; 
	ur = ((ULONG)r) * 0x1010101;
	ug = ((ULONG)g) * 0x1010101;
	ub = ((ULONG)b) * 0x1010101;
    
  SetRGB32(&m_pScreenBase->ViewPort, (ULONG)Number, ur,ug,ub );
}

//---------------------------------------------------------------------------
void CGfxSupport::DemoMessageBox(char* strMessage)
{
  //On declare un requester EasyStruct
  struct EasyStruct text = {
    sizeof( struct EasyStruct ),
    0,
    "Demo Message",
    "%s%s",
    "OK"
  };

  if(m_bCyberGraphX)
  {
    //On l'affiche
    EasyRequest( NULL, &text,NULL, strMessage, " (CGX)");
  }
  else
  {
    //On l'affiche
    EasyRequest( NULL, &text,NULL, strMessage," (AGA)");
  }
}
//---------------------------------------------------------------------------  
