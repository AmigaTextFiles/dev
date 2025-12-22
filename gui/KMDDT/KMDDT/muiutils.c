 /* Copyright © 1996 Kai Hofmann. All rights reserved. */

 #include "muiutils.h"
 #include <exec/types.h>
 #include <clib/alib_protos.h>
 #include <string.h>
 #include <stdlib.h>
 #ifndef NOERRORHANDLING
 #include "muiext.h"
 #endif

 /* ------------------------------------------------------------------------ */

 ULONG STACKARGS DoSuperNew(struct IClass *cl, Object *obj, ULONG tags, ...)
  {
   return(DoSuperMethod(cl,obj,OM_NEW,&tags,NULL));
  }


 BOOL getbool(Object *obj, ULONG attr)
  {
   ULONG value;

   if (!GetAttr(attr,obj,&value))
    {
     value = FALSE;
     #ifndef NOERRORHANDLING
       /* insert your own error-handling here */
     #endif
    }
   return((BOOL)value);
  }


 Object *getobj(Object *obj, ULONG attr)
  {
   ULONG value;

   if (!GetAttr(attr,obj,&value))
    {
     value = NULL;
     #ifndef NOERRORHANDLING
       /* insert your own error-handling here */
     #endif
    }
   return((Object *)value);
  }


 Object *getapp(Object *obj)
  {
   ULONG value;

   if (!GetAttr(MUIA_ApplicationObject,obj,&value))
    {
     value = NULL;
     #ifndef NOERRORHANDLING
       /* insert your own error-handling here */
     #endif
    }
   return((Object *)value);
  }



 STRPTR copystr(Object *obj, ULONG attr)
  {
   ULONG value;

   if (GetAttr(attr,obj,&value))
    {
     size_t len;

     len = strlen((char *)value);
     if (len > 0)
      {
       STRPTR str = malloc(len+1);

       if (str != NULL)
        {
         strcpy(str,(char *)value);
         return(str);
        }
       else
        {
         #ifndef NOERRORHANDLING
           /* insert your own error-handling here */
         #endif
         return(NULL);
        }
      }
     else
      {
       /* strlen(value) == 0 */
       return(NULL);
      }
    }
   else
    {
     #ifndef NOERRORHANDLING
       /* insert your own error-handling here */
     #endif
     return(NULL);
    }
  }

 /* ------------------------------------------------------------------------ */
