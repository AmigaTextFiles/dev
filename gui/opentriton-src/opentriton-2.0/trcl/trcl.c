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
 *  trcl.c - Basic Triton Class source
 *
 */


#include <exec/exec.h>
#include <intuition/intuition.h>
#include <libraries/triton.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/triton_protos.h>
#include <clib/alib_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/triton_pragmas.h>


struct ExecBase *SysBase;
struct Library *TritonBase;
struct IntuitionBase *IntuitionBase;


void __saveds __UserLibCleanup(void);


int __saveds __asm __UserLibInit(void)
{
  SysBase=(*((struct ExecBase **)4));
  if(!(IntuitionBase=(struct IntuitionBase *)OpenLibrary((STRPTR)("intuition.library"),0)))
    { __UserLibCleanup(); return 1; }

  DisplayBeep(NULL);
  return 0;
}


void __saveds __UserLibCleanup(void)
{
  CloseLibrary(TritonBase);
  CloseLibrary((struct Library *)IntuitionBase);
}


BOOL __saveds __asm TRCL_Init(register __a1 struct TR_App *app)
{
  if(!(TritonBase=OpenLibrary((STRPTR)(TRITONNAME),0))) return FALSE;

  return TRUE;
}

void * __saveds __asm TRCL_Info(register __d0 ULONG type)
{
  return NULL;
}
