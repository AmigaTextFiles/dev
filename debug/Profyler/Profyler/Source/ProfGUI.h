
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.00 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Profyler User Interface Module Header		Last modified 20-Dec-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 The User Interface (GUI) module encapsulates the user interface functional-
 ity of Profyler. This file documents the public interface to the User Inter-
 face module.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This program is free software; you can redistribute it and/or modify it
 under the terms of the GNU General Public License as published by the Free
 Software Foundation; either version 2 of the License, or (at your option)
 any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 more details.
 
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

============================================================================
***************************************************************************/

// -------------------------------------------------------------------------
// === Includes ===

#include <exec/types.h>
#include <intuition/classusr.h>

// -------------------------------------------------------------------------
// === Prototypes ===

BOOL GUI_Start(Object *App);
void GUI_Stop(void);
BOOL GUI_CheckTarget(uint32 Target);
BOOL GUI_AddTarget(uint32 Target, STRPTR Title);
BOOL GUI_RemoveTarget(uint32 Target);
void GUI_BeginUpdate(uint32 Target);
void GUI_EndUpdate(uint32 Target);
BOOL GUI_AddEntry(uint32 Target, APTR Record);
void GUI_Sort(uint32 Target);
void GUI_Sleep(BOOL Sleep);

// -------------------------------------------------------------------------
// === Macros ===


// -------------------------------------------------------------------------
// === Defines ===

// The number of columns in the GUI's list viewer.
#define NUM_GUI_COLUMNS		9

// -------------------------------------------------------------------------
// === Globals ===

