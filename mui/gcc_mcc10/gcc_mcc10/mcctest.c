

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <dos/dos.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/io.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <libraries/gadtools.h>
#include <libraries/asl.h>
#include <libraries/mui.h>
#include <devices/clipboard.h>
#include <workbench/workbench.h>
#include <intuition/intuition.h>
#include <intuition/classusr.h>
#include <clib/muimaster_protos.h>

#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/gadtools.h>
#include <proto/asl.h>

#include <proto/muimaster.h>

#include "Simple_mcc.h"
#include "Simple_mcp.h"

static VOID fail(APTR APP_Main,char *str);
static VOID init(VOID);
int main(int argc,char *argv[]);

/* MUI STUFF */

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#ifndef SAVEDS
#define SAVEDS
#endif

struct Library *MUIMasterBase = NULL;

/*LONG __stack = 30000;*/


APTR  APP_Main,
      WIN_Main,
      img;

#define USE_PSI_SCREENON_BODY
#define USE_PSI_SCREENON_COLORS
#include "psi_screenon.bh"

static char *Pages[]   = { "MCC Object","MCP Object",NULL };

/* MUI ERROR? */
static VOID fail(APTR APP_Main,char *str)
{
  if (APP_Main)
    MUI_DisposeObject(APP_Main);

  if (MUIMasterBase)
    CloseLibrary(MUIMasterBase);
  if (str)
  {
    puts(str);
    exit(20);
  }
  exit(0);
}

/* STANDARD INIT FUNCTION FOR MUI */
static VOID init(VOID)
{
  if (!(MUIMasterBase = (struct Library *) OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN-1)))
    fail(NULL,"Failed to open "MUIMASTER_NAME".");
}

/* MAIN PROGRAM */
int main(int argc,char *argv[])
{
  int     numarg;

  init();

  img = BodychunkObject,
    MUIA_FixWidth             , PSI_SCREENON_WIDTH ,
    MUIA_FixHeight            , PSI_SCREENON_HEIGHT,
    MUIA_Bitmap_Width         , PSI_SCREENON_WIDTH ,
    MUIA_Bitmap_Height        , PSI_SCREENON_HEIGHT,
    MUIA_Bodychunk_Depth      , PSI_SCREENON_DEPTH ,
    MUIA_Bodychunk_Body       , (UBYTE *) psi_screenon_body,
    MUIA_Bodychunk_Compression, PSI_SCREENON_COMPRESSION,
    MUIA_Bodychunk_Masking    , PSI_SCREENON_MASKING,
    MUIA_Bitmap_SourceColors  , (ULONG *) psi_screenon_colors,
    MUIA_Bitmap_Transparent   , 0,
  End;

  APP_Main = ApplicationObject,
    MUIA_Application_Title      , "mcctest",
    MUIA_Application_Version    , "$VER: mcctest ["__DATE__"]",
    MUIA_Application_Copyright  , "Written by Gilles MASSON, 1996",
    MUIA_Application_Author     , "Gilles MASSON",
    MUIA_Application_Description, "mcctest",
    MUIA_Application_Base       , "mcctest",

    SubWindow, WIN_Main = WindowObject,
      MUIA_Window_Title, "mcctest 1996",
      MUIA_Window_Width, MUIV_Window_Width_Visible(80),
      MUIA_Window_Height, MUIV_Window_Height_Visible(80),
      WindowContents, VGroup,
        Child, HGroup,
          MUIA_Group_SameWidth, TRUE,
          Child, SimpleButton("Button1"),
          Child, img,
          Child, SimpleButton("Button2"),
        End,
        Child, RegisterGroup(Pages),
          MUIA_Register_Frame, TRUE,
          Child, SimpleObject,
          End,
          Child, SimpleMcpObject,
          End,
        End,
      End,
    End,
  End;

  if(!APP_Main) fail(APP_Main,"Failed to create Application.");

  DoMethod(WIN_Main,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    APP_Main,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

  set(WIN_Main,MUIA_Window_Open,TRUE);

  {
    ULONG sigs = 0;

    while (DoMethod(APP_Main,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit){

      if (sigs){
        sigs = Wait(sigs | SIGBREAKF_CTRL_C);
        if (sigs & SIGBREAKF_CTRL_C) break;
      }
    }
  }

  set(WIN_Main,MUIA_Window_Open,FALSE);
  fail(APP_Main,NULL);
}


