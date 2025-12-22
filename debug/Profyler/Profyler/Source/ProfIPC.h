
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.00 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Profyler IPC Module Header					Last modified 08-Apr-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 The Inter-Process Communication (IPC) module encapsulates the communication
 functionality of Profyler between itself and external target programs. This
 file documents the public interface to the IPC module.

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

// -------------------------------------------------------------------------
// === Prototypes ===

BOOL IPC_Start(void);
void IPC_Stop(void);
uint32 IPC_GetSignal(void);
void IPC_Update(uint32 Target);
void IPC_Scan(void);
void IPC_Incoming(void);

// -------------------------------------------------------------------------
// === Macros ===


// -------------------------------------------------------------------------
// === Defines ===


// -------------------------------------------------------------------------
// === Globals ===

