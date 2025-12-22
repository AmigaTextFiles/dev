OPT NATIVE, PREPROCESS
MODULE 'target/exec/types'
{#include <mui/BetterString_mcc.h>}
NATIVE {BETTERSTRING_MCC_H} CONST

/***************************************************************************

 BetterString.mcc - A better String gadget MUI Custom Class
 Copyright (C) 1997-2000 Allan Odgaard
 Copyright (C) 2005-2007 by BetterString.mcc Open Source Team

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 BetterString class Support Site:  http://www.sf.net/projects/bstring-mcc/

 $Id: BetterString_mcc.h 110 2007-09-28 07:00:44Z damato $

***************************************************************************/

NATIVE {MUIC_BetterString}     CONST
#define MUIC_BetterString muic_betterstring
STATIC muic_betterstring     = 'BetterString.mcc'

NATIVE {BetterStringObject}    CONST
#define BetterStringObject    Mui_NewObject(MUIC_BetterString

-> attributes
NATIVE {MUIA_BetterString_SelectSize}            CONST MUIA_BetterString_SelectSize            = $ad001001
NATIVE {MUIA_BetterString_StayActive}            CONST MUIA_BetterString_StayActive            = $ad001003
NATIVE {MUIA_BetterString_Columns}               CONST MUIA_BetterString_Columns               = $ad001005
NATIVE {MUIA_BetterString_NoInput}               CONST MUIA_BetterString_NoInput               = $ad001007
NATIVE {MUIA_BetterString_KeyUpFocus}            CONST MUIA_BetterString_KeyUpFocus            = $ad001008
NATIVE {MUIA_BetterString_KeyDownFocus}          CONST MUIA_BetterString_KeyDownFocus          = $ad001009
NATIVE {MUIA_BetterString_InactiveContents}      CONST MUIA_BetterString_InactiveContents      = $ad00100a
NATIVE {MUIA_BetterString_NoShortcuts}           CONST MUIA_BetterString_NoShortcuts           = $ad00100c

-> methods
NATIVE {MUIM_BetterString_Insert}                CONST MUIM_BetterString_Insert                = $ad001002
NATIVE {MUIM_BetterString_ClearSelected}         CONST MUIM_BetterString_ClearSelected         = $ad001004
NATIVE {MUIM_BetterString_FileNameStart}         CONST MUIM_BetterString_FileNameStart         = $ad001006
NATIVE {MUIM_BetterString_DoAction}              CONST MUIM_BetterString_DoAction              = $ad00100b

-> values for MUIM_BetterString_Insert
NATIVE {MUIV_BetterString_Insert_StartOfString}  CONST MUIV_BetterString_Insert_StartOfString  = $00000000
NATIVE {MUIV_BetterString_Insert_EndOfString}    CONST MUIV_BetterString_Insert_EndOfString    = $fffffffe
NATIVE {MUIV_BetterString_Insert_BufferPos}      CONST MUIV_BetterString_Insert_BufferPos      = $ffffffff

-> result values of MUIM_BetterString_FileNameStart
NATIVE {MUIR_BetterString_FileNameStart_Volume}  CONST MUIR_BetterString_FileNameStart_Volume  = -1

-> values for MUIM_BetterString_DoAction
NATIVE {MUIV_BetterString_DoActions} DEF
TYPE MUIV_BetterString_DoActions IS NATIVE {MUIV_BetterString_DoActions} VALUE
NATIVE {MUIV_BetterString_DoAction_Cut}            CONST MUIV_BetterString_DoAction_Cut            = 1
NATIVE {MUIV_BetterString_DoAction_Copy}           CONST MUIV_BetterString_DoAction_CopY           = 2
NATIVE {MUIV_BetterString_DoAction_Paste}          CONST MUIV_BetterString_DoAction_Paste          = 3
NATIVE {MUIV_BetterString_DoAction_SelectAll}      CONST MUIV_BetterString_DoAction_SelectAll      = 4
NATIVE {MUIV_BetterString_DoAction_SelectNone}     CONST MUIV_BetterString_DoAction_SelectNone     = 5
NATIVE {MUIV_BetterString_DoAction_Undo}           CONST MUIV_BetterString_DoAction_Undo           = 6
NATIVE {MUIV_BetterString_DoAction_Redo}           CONST MUIV_BetterString_DoAction_Redo           = 7
NATIVE {MUIV_BetterString_DoAction_Revert}         CONST MUIV_BetterString_DoAction_Revert         = 8
NATIVE {MUIV_BetterString_DoAction_ToggleCase}     CONST MUIV_BetterString_DoAction_ToggleCase     = 9
NATIVE {MUIV_BetterString_DoAction_ToggleCaseWord} CONST MUIV_BetterString_DoAction_ToggleCaseWord = 10
NATIVE {MUIV_BetterString_DoAction_IncreaseNum}    CONST MUIV_BetterString_DoAction_IncreaseNum    = 11
NATIVE {MUIV_BetterString_DoAction_DecreaseNum}    CONST MUIV_BetterString_DoAction_DecreaseNum    = 12
NATIVE {MUIV_BetterString_DoAction_HexToDec}       CONST MUIV_BetterString_DoAction_HexToDec       = 13
NATIVE {MUIV_BetterString_DoAction_DecToHex}       CONST MUIV_BetterString_DoAction_DecToHex       = 14
NATIVE {MUIV_BetterString_DoAction_NextFileComp}   CONST MUIV_BetterString_DoAction_NextFileComp   = 15
NATIVE {MUIV_BetterString_DoAction_PrevFileComp}   CONST MUIV_BetterString_DoAction_PrevFileComp   = 16
NATIVE {MUIV_BetterString_DoAction_Delete}         CONST MUIV_BetterString_DoAction_Delete         = 17


-> parameter structures for methods
NATIVE {MUIP_BetterString_Insert} OBJECT muip_betterstring_insert
	{MethodID}	methodid	:ULONG
	{text}	text	:/*STRPTR*/ ARRAY OF CHAR
	{pos}	pos	:VALUE
ENDOBJECT

NATIVE {MUIP_BetterString_ClearSelected} OBJECT muip_betterstring_clearselected
	{MethodID}	methodid	:ULONG
ENDOBJECT

NATIVE {MUIP_BetterString_FileNameStart} OBJECT muip_betterstring_filenamestart
	{MethodID}	methodid	:ULONG
	{buffer}	buffer	:/*STRPTR*/ ARRAY OF CHAR
	{pos}	pos	:VALUE
ENDOBJECT

NATIVE {MUIP_BetterString_DoAction} OBJECT muip_betterstring_doaction
	{MethodID}	methodid	:ULONG
	{action}	action	:MUIV_BetterString_DoActions
ENDOBJECT


#define BString(contents,maxlen) BetterStringObject,\
                StringFrame,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                MUIA_CycleChain, MUI_TRUE,\
                End

#define BStringID(contents,maxlen,id) BetterStringObject,\
                StringFrame,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                MUIA_ObjectID,id,\
                MUIA_CycleChain, MUI_TRUE,\
                End

#define BKeyString(contents,maxlen,controlchar) BetterStringObject,\
                StringFrame,\
                MUIA_ControlChar    , controlchar,\
                MUIA_CycleChain     ,MUI_TRUE,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                End

#define BKeyStringID(contents,maxlen,controlchar,id) BetterStringObject,\
                StringFrame,\
                MUIA_ControlChar    , controlchar,\
                MUIA_CycleChain     ,MUI_TRUE,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                MUIA_ObjectID,id,\
                End
