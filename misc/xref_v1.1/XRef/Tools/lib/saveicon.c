/*
** $PROJECT: xrefsupport.lib
**
** $VER: saveicon.c 1.2 (03.11.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 03.11.94 : 001.002 :  gadget width and height now correct
** 04.09.94 : 001.001 :  initial
*/

/* ------------------------------- include -------------------------------- */

#include "/source/Def.h"

#include "xrefsupport.h"

/* ------------------------------- function ------------------------------- */

void saveicon(STRPTR file,struct SaveDefIcon *def_icon)
{
   struct SaveDefIcon old;
   struct DiskObject *dobj;
   BOOL oldicon = FALSE;

   if(IconBase = OpenLibrary("icon.library",37))
   {
      if(!(dobj = GetDiskObject(file)))
      {
         if(!(dobj = GetDiskObject(def_icon->sdi_DefaultIcon)))
            if(dobj = GetDefDiskObject(WBPROJECT))
            {
               old.sdi_Image       = dobj->do_Gadget.GadgetRender;
               old.sdi_DefaultTool = dobj->do_DefaultTool;
               old.sdi_ToolTypes   = dobj->do_ToolTypes;

               if(def_icon->sdi_Image)
               {
                  dobj->do_Gadget.GadgetRender = def_icon->sdi_Image;
                  dobj->do_Gadget.Width        = def_icon->sdi_Image->Width;
                  dobj->do_Gadget.Height       = def_icon->sdi_Image->Height;
                  dobj->do_Gadget.Flags        = GFLG_GADGHCOMP | GFLG_GADGIMAGE;
               }

               if(def_icon->sdi_DefaultTool)
                  dobj->do_DefaultTool = def_icon->sdi_DefaultTool;
               if(def_icon->sdi_ToolTypes)
                  dobj->do_ToolTypes   = def_icon->sdi_ToolTypes;
            }

         if(dobj)
         {
            PutDiskObject(file,dobj);

            if(oldicon)
            {
               dobj->do_Gadget.GadgetRender = old.sdi_Image;
               dobj->do_DefaultTool         = old.sdi_DefaultTool;
               dobj->do_ToolTypes           = old.sdi_ToolTypes;
            }
         }
      }

      if(dobj)
         FreeDiskObject(dobj);

      CloseLibrary(IconBase);
   }
}

