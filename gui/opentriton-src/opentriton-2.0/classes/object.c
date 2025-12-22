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


/****** triton.library/class_Object ******
*
*   NAME	
*	class_Object -- The abstract root class
*
*   SUPERCLASS
*	<none>
*
*   SYNOPSIS
*	(TROB_Object)
*
*   ATTRIBUTES
*	<Default>        : <unused>
*
*   OBJECT MESSAGES
*	TROM_NEW         : Create an instance
*	TROM_DISPOSE     : Dispose of an instance
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "object.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Object,NEW,NewData)
{
  OBJECT->Project=data->project;
  return (ULONG)object;
}

//    case TROM_DISPOSE: // Not needed; the entire pool gets deleted
//      TR_FreePooled(OBJECT->Project->trp_MemPool,
//		    (void *)object,((struct TROD_Object *)object)->Class->trc_SizeOfClassData);
//      return 1L;
