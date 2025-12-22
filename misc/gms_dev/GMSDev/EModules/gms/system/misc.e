/*
**  $VER: misc.e V1.0
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register','gms/input/joydata'
MODULE 'gms/system/tasks','gms/graphics/screens'

/****************************************************************************
** Object Referencing structure.
*/

CONST VER_REFERENCE  = 1,
      TAGS_REFERENCE = $FFFB0000 OR ID_REFERENCE

OBJECT reference
  head[1]     :ARRAY OF head    /* Standard header */
  next        :PTR TO reference /* Next reference */
  prev        :PTR TO reference /* Previous reference */
  classid     :INT              /* ID of the class */
  pad         :INT              /* Reserved */
  classname   :LONG             /* Name of the class */
  modname     :LONG             /* Name of the module containing the object */
  checkfile   :LONG             /* CheckFile code */
  modnumber   :INT              /* Module ID number */
ENDOBJECT

CONST REFA_ClassID   = TWORD OR 20,
      REFA_ClassName = TAPTR OR 24,
      REFA_ModName   = TAPTR OR 28,
      REFA_CheckFile = TAPTR OR 32,
      REDA_ModNumber = TWORD OR 36

/****************************************************************************
** Universal Structure, used in the CopyStructure() routine.
*/

OBJECT universe
  head[1]         :ARRAY OF head
  palette         :LONG   
  planes          :INT   
  width           :INT   
  height          :INT   
  insidewidth     :INT
  insidebytewidth :INT
  insideheight    :INT
  task            :PTR TO dpktask
  frequency       :LONG
  amtcolours      :LONG
  scrmode         :INT
  bmptype         :INT
  source          :LONG
  joydata         :PTR TO joydata
  raster          :PTR TO raster
  xoffset         :INT
  yoffset         :INT
  insideyoffset   :INT
  insidexoffset   :INT
  channel         :INT
  priority        :INT
  length          :LONG
  octave          :INT
  volume          :INT
ENDOBJECT

