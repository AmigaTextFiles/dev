/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */


#include "triton_lib.h"


struct Library *TritonBase;
struct TR_App *__Triton_Support_App;


/****** triton.lib/TR_OpenTriton ******
*
*   NAME	
*	TR_OpenTriton -- Opens Triton ready to use.
*
*   SYNOPSIS
*	success = TR_OpenTriton(version, tag1,...)
*	D0
*
*	BOOL TR_OpenTriton(ULONG, ULONG,...);
*
*   FUNCTION
*	Opens triton.library with the specified minimum
*	version and creates an application.
*	The supplied tags are passed as a taglist to
*	TR_CreateApp().
*
*   RESULT
*	success - Was everything opened successful?
*
*   SEE ALSO
*	TR_CloseTriton(), TR_CreateApp()
*
******/

BOOL __stdargs TR_OpenTriton(ULONG version, ULONG taglist,...)
{
  if(!(TritonBase=OpenLibrary(TRITONNAME,version))) return FALSE;
  if(!(__Triton_Support_App=TR_CreateApp((struct TagItem *)&taglist))) return FALSE;
  return TRUE;
}


/****** triton.lib/TR_CloseTriton ******
*
*   NAME	
*	TR_CloseTriton -- Closes Triton easily.
*
*   SYNOPSIS
*	TR_CloseTriton()
*
*	VOID TR_CloseTriton(VOID);
*
*   FUNCTION
*	Closes the application created by OpenTriton()
*	and closes triton.library.
*
*   SEE ALSO
*	TR_OpenTriton()
*
******/

VOID __regargs TR_CloseTriton(VOID)
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
