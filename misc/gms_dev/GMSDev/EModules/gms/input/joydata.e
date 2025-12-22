/*
**  $VER: joydata.e
**
**  JoyData definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

/*****************************************************************************
** JoyData structure, for reading from joyports.
*/

CONST VER_JOYDATA  = 2,
      TAGS_JOYDATA = $FFFB0000 OR ID_JOYDATA

OBJECT joydata
  head[1]       :ARRAY OF head /* Standard header */
  port          :INT           /* Port number, 1/2/3/4 */
  xchange       :INT           /* Change in the x coordinate */
  ychange       :INT           /* Change in the y coordinate */
  zchange       :INT           /* Change in the z coordinate */
  buttons       :LONG          /* Currently pressed buttons */
  buttontimeout :INT           /* Micro-seconds before button time-out */
  movetimeout   :INT           /* Micro-seconds before movement time-out */
  nxlimit       :INT           /* Negative X limit */
  nylimit       :INT           /* Negative Y limit */
  pxlimit       :INT           /* Positive X limit */
  pylimit       :INT           /* Positive Y limit */
ENDOBJECT

CONST JD_FIRE1 = $00000001,  /* Standard Fire Button (1) - LMB */
      JD_FIRE2 = $00000002,  /* Standard Fire Button (2) - RMB */
      JD_FIRE3 = $00000004,  /* Standard Fire Button (3) - MMB */
      JD_FIRE4 = $00000008,  /* "Start"    */
      JD_FIRE5 = $00000010,  /* "Select"   */
      JD_FIRE6 = $00000020,  /* Rewind  L1 */
      JD_FIRE7 = $00000040,  /* Forward R1 */
      JD_FIRE8 = $00000080,  /* Rewind  L2 */
      JD_FIRE9 = $00000100   /* Forward R2 */

CONST JD_LMB   = JD_FIRE1,
      JD_RMB   = JD_FIRE2,
      JD_MMB   = JD_FIRE3

CONST JPORT_DIGITAL = -1,
      JPORT_ANALOGUE = -2

