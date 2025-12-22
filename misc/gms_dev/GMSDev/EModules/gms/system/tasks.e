/*
**  $VER: tasks.h V1.0
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

/****************************************************************************
** A UserData field exists here which you may use if necessary.  Other than
** this, DO NOT USE ANY TASK FIELDS FOR ANYTHING OTHER THAN DEBUGGING
** PURPOSES.
*/

CONST VER_TASK  = 1,
      TAGS_TASK = $FFFB0000 OR ID_TASK

OBJECT  dpktask
  head[1]  :ARRAY OF head  /* Standard header */
  userdata :LONG           /* Pointer to user data, no restrictions */
  taskname :LONG           /* Name of the task, if specified */
ENDOBJECT

