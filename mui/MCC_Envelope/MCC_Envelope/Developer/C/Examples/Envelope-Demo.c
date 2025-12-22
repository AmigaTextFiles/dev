/*
 *
 * Envelope.mcc (c) Copyright 1999 by Jon Rocatis
 *
 * Example for Envelope.mcc
 *
 * Envelope-demo.c
 *
 */

/* SMAKE */

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/muimaster_protos.h>
#include <pragmas/muimaster_pragmas.h>
#include <libraries/mui.h>
#include <stdio.h>
#include <proto/all.h>

#include <mui/envelope_mcc.h>
#include "Envelope-Demo.rev"

#define DB / ## /
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))

static char *vers_string  = __VSTRING;
static char *vers_tag = __VERSTAG;

/*** externals ***/
extern struct Library *SysBase;

/*** main ***/
int main(int argc,char *argv[])
{
  Object *aptText[4];
  Object *aptEnvelope[3];
  EnvelopeUpdateData_t tEnvData;
  struct Library *IntuitionBase;
  int ret = RETURN_ERROR;

    if (IntuitionBase = OpenLibrary("intuition.library", 36))
    {
      struct Library *MUIMasterBase;

      if (MUIMasterBase = OpenLibrary(MUIMASTER_NAME, 13))
      {
        APTR app;
        APTR ptWindow;
                        
        ULONG signals;
        BOOL running = TRUE;

        app = ApplicationObject,
                MUIA_Application_Title      , "Envelope-Demo",
                MUIA_Application_Version    , vers_string,
                MUIA_Application_Copyright  , __VERSCR,
                MUIA_Application_Author     , "Jon Rocatis",
                MUIA_Application_Description, "Demonstrates the Envelope class.",
                MUIA_Application_Base       , "ENVELOPEDEMO",

                SubWindow, ptWindow = WindowObject,
                  MUIA_Window_Title, "EnvelopeClass",
                  MUIA_Window_ID   , MAKE_ID('E','N','V','E'),
                  WindowContents, VGroup,

                  /*** create an Envelope gadget ***/
                  // TVA
                  Child, TextObject, MUIA_Text_Contents, "Typical TVA Envelope:", End,
                  Child, aptEnvelope[0] = EnvelopeObject, ButtonFrame, MUIA_Envelope_NoL4, TRUE, MUIA_Envelope_StartAtBottom, TRUE, End,
                  Child, MUI_MakeObject(MUIO_HBar, 0),
                                                
                  // TVF
                  Child, TextObject, MUIA_Text_Contents, "Typical TVF Envelope:", End,
                  Child, aptEnvelope[1] = EnvelopeObject, ButtonFrame, MUIA_Envelope_EndLine, TRUE, MUIA_Envelope_StartAtBottom, TRUE, End,
                  Child, MUI_MakeObject(MUIO_HBar, 0),
                                                
                  // Pitch
                  Child, TextObject, MUIA_Text_Contents, "Typical Pitch Envelope:", End,
                  Child, aptEnvelope[2] = EnvelopeObject, ButtonFrame, MUIA_Envelope_EndLine, TRUE, MUIA_Envelope_ZeroLine, TRUE, MUIA_Envelope_DisplayLevelAdjust, 64, MUIA_Envelope_MinLevel, 1, End,
                  Child, HGroup,
                    Child, aptText[0] = TextObject, TextFrame, End,
                    Child, aptText[1] = TextObject, TextFrame, End,
                    Child, aptText[2] = TextObject, TextFrame, End,
                    Child, aptText[3] = TextObject, TextFrame, End,
                  End,
                End,
              End,
            End;

        if (app)
        {
          /*** generate notifies ***/
          DoMethod(ptWindow, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
                   app, 2,
                   MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

          // Attach some text gadgets to the pitch envelope so we can see the knob readouts
          set(aptEnvelope[2], MUIA_Envelope_Text, aptText);

          // Set the knob data for one of the gadgets
          tEnvData.atKnobs[0].nTime  = 10;
          tEnvData.atKnobs[0].nLevel = 10;
          tEnvData.atKnobs[1].nTime  = 30;
          tEnvData.atKnobs[1].nLevel = 70;
          tEnvData.atKnobs[2].nTime  = 90;
          tEnvData.atKnobs[2].nLevel = 0;
          tEnvData.atKnobs[3].nTime  = 50;
          tEnvData.atKnobs[3].nLevel = 40;
          DoMethod(aptEnvelope[1], MUIM_Envelope_SetKnobs, &tEnvData);

          /*** ready to open the ptWindow ... ***/
          set(ptWindow, MUIA_Window_Open, TRUE);

          while (running)
          {
            switch (DoMethod(app,MUIM_Application_Input,&signals))
            {
              case MUIV_Application_ReturnID_Quit:
                running = FALSE;
                break;
            }

            if (running && signals)
              Wait(signals);
          }

          set(ptWindow, MUIA_Window_Open, FALSE);

          /*** shutdown ***/
          MUI_DisposeObject(app);      /* dispose all objects. */

          ret = RETURN_OK;
        }
        else
        {
          puts("Could not open application!");
          ret = RETURN_FAIL;
        }

        CloseLibrary(MUIMasterBase);
      }
      else
      {
        puts("Could not open muimaster.library v13!");
        ret = RETURN_FAIL;
      }

      CloseLibrary(IntuitionBase);
    }
    else
    {
      puts("Could not open intuition.library v36!");
      ret = RETURN_FAIL;
    }
    
    return ret;
}

