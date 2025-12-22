/*
** PutMsg.rexx
**
** $VER: PutMsg.rexx 1.0.0 (19.02.94)
**
** This script add a new msg to the SCMSG list.
**
** SAS/C is a registered trademark of SAS Institute, Inc.
*/

ADDRESS 'SC_SCMSG'
PARSE ARG file line text

'newmsg' file file line 0 "" 0 '"Warning"' 0 text
EXIT 0
