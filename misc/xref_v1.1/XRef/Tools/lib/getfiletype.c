/*
** $PROJECT: xrefsupport.lib
**
** $VER: getfiletype.c 1.2 (22.09.94)
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
** 22.09.94 : 001.002 :  skip whitespaces for table of contents compare added
** 04.09.94 : 001.001 :  initial
*/

/* ------------------------------ include's ------------------------------- */

#include "/source/Def.h"

#include "xrefsupport.h"

/* ---------------------------- filetype names ---------------------------- */

const STRPTR ftype[] = {
   NULL,
   "header",
   "autodoc",
   "doc",
   "amigaguide",
   "unix manualpage",
   "gnu infoview",
   };

/* ------------------------------ functions ------------------------------- */

ULONG getfiletype(BPTR fh,STRPTR file)
{
   UBYTE buffer[100];
   ULONG ftype = FTYPE_UNKNOWN;
   STRPTR ptr;

   if(checksuffix(file,".info"))
      return(ftype);
   else if(checksuffix(file,".doc"))
      ftype = FTYPE_DOC;
   else if(checksuffix(file,".h"))
      ftype = FTYPE_HEADER;
   else if(checksuffix(file,".0"))
      ftype = FTYPE_MAN;

   if((ptr = FGets(fh,buffer,sizeof(buffer))))
   {
      if(!Strnicmp(ptr,"@database",9))
         ftype = FTYPE_AMIGAGUIDE;
      else if(ftype == FTYPE_DOC)
      {
         do
         {
            if(!strncmp(ptr,"TABLE OF CONTENTS",17))
            {
               ftype = FTYPE_AUTODOC;
               break;
            } else
            {
               while(*ptr == ' ' && *ptr == '\t')
                  ptr++;

               if(*ptr != '\n')
                    break;
            }
         } while((ptr = FGets(fh,buffer,sizeof(buffer))));
      }

      Seek(fh,0,OFFSET_BEGINNING);
   }

   return(ftype);
}

