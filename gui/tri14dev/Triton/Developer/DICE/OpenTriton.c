/*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1994
 *
 *  (c) 1993-1994 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 */


#include "triton_lib.h"


struct Library *TritonBase;
struct TR_App *__Triton_Support_App;


/****** triton.lib/TR_OpenTriton ******
*
*   NAME        
*       TR_OpenTriton -- Opens Triton ready to use.
*
*   SYNOPSIS
*       success = TR_OpenTriton(version, tag1,...)
*       D0
*
*       BOOL TR_OpenTriton(ULONG, ULONG,...);
*
*   FUNCTION
*       Opens triton.library with the specified minimum
*       version and creates an application.
*       The supplied tags are passed as a taglist to
*       TR_CreateApp().
*
*   RESULT
*       success - Was everything opened successful?
*
*   SEE ALSO
*       TR_CloseTriton(), TR_CreateApp()
*
******/

BOOL STACK TR_OpenTriton(ULONG version, ULONG taglist,...)
{
  if(!(TritonBase=OpenLibrary(TRITONNAME,version)))
    return FALSE;
  if(!(__Triton_Support_App=TR_CreateApp((struct TagItem *)&taglist)))
    return FALSE;
  return TRUE;
}


/****** triton.lib/TR_CloseTriton ******
*
*   NAME        
*       TR_CloseTriton -- Closes Triton easily.
*
*   SYNOPSIS
*       TR_CloseTriton()
*
*       VOID TR_CloseTriton(VOID);
*
*   FUNCTION
*       Closes the application created by OpenTriton()
*       and closes triton.library.
*
*   SEE ALSO
*       TR_OpenTriton()
*
******/

VOID REGS TR_CloseTriton(VOID)
{
  if(__Triton_Support_App)
  {
    TR_DeleteApp(__Triton_Support_App);
    __Triton_Support_App=NULL;
  }
  if(TritonBase)
  {
    CloseLibrary(TritonBase);
    TritonBase=NULL;
  }
}
