
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.00 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Profyler Database Module Header				Last modified 07-May-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 The Database (DB) module encapsulates the database functionality of Profyl-
 er. This file documents the public interface to the Database module.

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

BOOL DB_Start(void);
void DB_Stop(void);
BOOL DB_Create(uint32 Target, STRPTR Name);
BOOL DB_Delete(uint32 Target);
BOOL DB_Check(uint32 Target);
STRPTR DB_Title(uint32 Target);
BOOL DB_PutRecord(uint32 Target, APTR FuncID, uint32 CallCt,
	uint64 InclTime, uint64 ExclTime);
BOOL DB_Totalize(uint32 Target);
void DB_GetStrings(APTR Record, STRPTR *Strings);
void DB_GetData(APTR Record, APTR *Data);
int32 DB_Compare(APTR Record1, APTR Record2, uint32 Column);
BOOL DB_Display(uint32 Target);

// -------------------------------------------------------------------------
// === Macros ===


// -------------------------------------------------------------------------
// === Defines ===

// The maximum lengths of the various text fields in the database, including
// the trailing NUL. GUI elements wishing to display the strings need to be
// able to accommodate these lengths.
#define DBASE_NAME_LEN		24		// the database (target) name
#define FUNC_NAME_LEN		32		// the function's name
#define FUNC_LOCN_LEN		32		// the function's source file location
#define CALL_CNT_LEN		12		// the call count
#define EXEC_TIME_LEN		12		// execution times, including units
#define PERCT_LEN			 8		// percentages

// -------------------------------------------------------------------------
// === Globals ===

