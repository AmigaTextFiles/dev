#ifndef FUNCS_DBPLAYER_FUNCS_H
#define FUNCS_DBPLAYER_FUNCS_H

/*
** Function declarations for ACE Basic
**
** Note: Translated to ACE by Oliver Gantert
**       <LucyG@t-online.de>
**
**       dbplayer.library by Sebastian Jedruszkiewicz
**       <bjsebo@delta.ii.tuniv.szczecin.pl>
**
** Date: 21-07-99
**
*/

#ifndef DBPLAYER_H
#include <dbplayer/dbplayer.h>
#endif

DECLARE FUNCTION LONGINT DBM_StartModule(ADDRESS dbm_module, LONGINT dbm_size, LONGINT dbm_AudioModeID, LONGINT dbm_AudioFrequency, LONGINT dbm_Flags) LIBRARY "dbplayer.library"
DECLARE FUNCTION DBM_StopModule() LIBRARY "dbplayer.library"
DECLARE FUNCTION DBM_SetPosition(SHORTINT dbm_SongPos, SHORTINT dbm_PattPos) LIBRARY "dbplayer.library"
DECLARE FUNCTION DBM_SetVolume(SHORTINT dbm_Volume) LIBRARY "dbplayer.library"
DECLARE FUNCTION LONGINT DBM_CheckPosition(SHORTINT dbm_SongPos, SHORTINT dbm_PattPos) LIBRARY "dbplayer.library"
DECLARE FUNCTION LONGINT DBM_Get7Command() LIBRARY "dbplayer.library"
DECLARE FUNCTION DBM_GetModuleAttrA(ADDRESS dbm_Tags) LIBRARY "dbplayer.library"

#endif
