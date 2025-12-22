/*
                  S3DC test

  This a simple demo showing how to compile MUI apps
  with GCC. It just draw a cube, which can be moved
                with arrow keys.

            (C) Olivier Croquette

  For any question or comment, please write to :

            ocroquette@nordnet.fr



*/



#include <stdio.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/muimaster.h>


#include <libraries/mui.h>

#include "S3DC.h"

struct GfxBase *GfxBase;
struct IntuitionBase *IntuitionBase;
struct Library  *MUIMasterBase;


#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))

BOOL Open_Libs(void )
{
  if ( !(IntuitionBase=(struct IntuitionBase *) OpenLibrary("intuition.library",39)) )
    return(0);

  if ( !(GfxBase=(struct GfxBase *) OpenLibrary("graphics.library",0)) )
  {
    CloseLibrary((struct Library *)IntuitionBase);
    return(0);
  }

  if ( !(MUIMasterBase=OpenLibrary(MUIMASTER_NAME,19)) )
  {
    CloseLibrary((struct Library *)GfxBase);
    CloseLibrary((struct Library *)IntuitionBase);
    return(0);
  }

  return(1);
}

void Close_Libs(void )
{
  if ( IntuitionBase )
    CloseLibrary((struct Library *)IntuitionBase);

  if ( GfxBase )
    CloseLibrary((struct Library *)GfxBase);

  if ( MUIMasterBase )
    CloseLibrary(MUIMasterBase);
}


int main(int argc,char *argv[])
{
  APTR app,window,MyObj;
  struct MUI_CustomClass *mcc;

  if ( ! Open_Libs() )
  {
    printf("Cannot open libs\n");
    return(0);
  }

  if (!(mcc = MUI_CreateCustomClass(NULL,MUIC_Area,NULL,sizeof(struct S3DC_Data),S3DC_Dispatcher)))
  {
    printf("Cannot create custom class.\n");
    return(0);
  }

  app = ApplicationObject,
    MUIA_Application_Title  , "S3DC",
    MUIA_Application_Version , "$VER: S3DC 1.0 (20.09.99)",
    MUIA_Application_Copyright , "©1999, Olivier Croquette",
    MUIA_Application_Author  , "Olivier Croquette",
    MUIA_Application_Description, "Just a useless software showing a cube.",
    MUIA_Application_Base  , "S3DC",

    SubWindow, window = WindowObject,
      MUIA_Window_Title, "Simple 3D Cube",
      MUIA_Window_ID , MAKE_ID('S','3','D','C'),
      WindowContents, VGroup,

        Child, TextObject,
          TextFrame,
          MUIA_Background, MUII_TextBack,
          MUIA_Text_Contents, "\33cSimple 3D Cube\nby O.Croquette.\n(ocroquette@nordnet.fr)",
          End,

        Child, MyObj = NewObject(mcc->mcc_Class,NULL,
          TextFrame,
          TAG_DONE),

        End,

      End,
    End;

  if (!app)
  {
    printf("Cannot create application.\n");
    return(0);
  }

  set(window,MUIA_Window_DefaultObject, MyObj);

  DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);


  set(window,MUIA_Window_Open,TRUE);

  {
    ULONG sigs = 0;

    while (DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit)
    {
      if (sigs)
      {
        sigs = Wait(sigs | SIGBREAKF_CTRL_C);
        if (sigs & SIGBREAKF_CTRL_C) break;
      }
    }
  }

  set(window,MUIA_Window_Open,FALSE);


  MUI_DisposeObject(app);
  MUI_DeleteCustomClass(mcc);
  Close_Libs();
}
