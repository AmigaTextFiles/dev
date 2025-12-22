/*******************************************************************************

 LayGroup.mcc - An automatic object arranger layout MUI Custom Class
 Copyright (C) 1997-1999 by Alessandro Zummo
 Copyright (C) 2008      by LayGroup.mcc Open Source Team

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 LayGroup class Support Site: http://sourceforge.net/projects/laygroup-mcc

 $Id:$

*******************************************************************************/

#include <libraries/mui.h>
#include <datatypes/pictureclass.h>
#include <libraries/iffparse.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/muimaster.h>
#include <proto/alib.h>

#include <stdio.h>

#include "SDI_compiler.h"

#include "mui/LayGroup_mcc.h"
#include "mui/LayGroup_revision.h"

#include "LayGroup_image_smiley.h"

struct Library * MUIMasterBase;

int main(UNUSED int argc, UNUSED char * argv[])
{
   ULONG ret;

   if ((MUIMasterBase = OpenLibrary(MUIMASTER_NAME, MUIMASTER_VLATEST)))
   {
      APTR app;
      APTR window;
      APTR lg;

      ULONG sigs;

      app = ApplicationObject,
         MUIA_Application_Title,       "LayGroup-Demo",
         MUIA_Application_Version,     "$VER: LayGroup-Demo " LIB_REV_STRING "(" LIB_DATE ")",
         MUIA_Application_Copyright,   LIB_COPYRIGHT,
         MUIA_Application_Author,      "LayGroup.mcc Open Source Team",
         MUIA_Application_Description, "LayGroup class demonstration program",
         MUIA_Application_Base       , "LAYGROUPDEMO",
         SubWindow, window = WindowObject,
            MUIA_Window_Title, "LayGroupClass",
            MUIA_Window_ID   , MAKE_ID('L','A','Y','G'),
            WindowContents, VGroup,
               Child, lg = LayGroupObject,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  Child, LAYGROUP_IMAGE_SMILEY,
                  End,
               End,
            End,
         End;
      if (app)
      {
         /*** generate notifies ***/
         DoMethod(window, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
            app, 2,
            MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

         /*** ready to open the window ... ***/
         set(window,MUIA_Window_Open,TRUE);

         while ((DoMethod(app, MUIM_Application_NewInput, &sigs) != (ULONG) MUIV_Application_ReturnID_Quit))
         {
            if (sigs)
            {
               sigs = Wait(sigs | SIGBREAKF_CTRL_C);
               if (sigs & SIGBREAKF_CTRL_C) break;
            }
         }

         set(window, MUIA_Window_Open, FALSE);

         /*** dispose all objects ***/
         MUI_DisposeObject(app);

         ret = RETURN_OK;
      }
      else
      {
         printf("Error, could not open application !\n");

         ret = RETURN_FAIL;
      }

      CloseLibrary(MUIMasterBase);
   }
   else
   {
      printf("Error, could not open muimaster.library V%d+ !\n", MUIMASTER_VLATEST);

      ret = RETURN_FAIL;
   }

   return ret;
}

