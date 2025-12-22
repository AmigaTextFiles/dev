/*
**  $VER: dpkbase.e
**
**  Definition of the dpkernel base structure.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register','gms/graphics/screens'
MODULE 'exec/libraries','gms/system/misc','gms/files/files','gms/system/modules'
MODULE 'gms/system/events','gms/system/tasks','gms/system/sysobject'

/*****************************************************************************
** All DPKBase fields are private.  This file is included in the developers
** archive for module writers and debugging purposes only.
*/

OBJECT sscreen
  next    :PTR TO sscreen
  screen  :PTR TO screen
ENDOBJECT

OBJECT gvbase
  libnode[1]      :ARRAY OF lib
  screenflip      :INT              /* Private */
  seglist         :LONG             /* Private */
  dprintf         :LONG
  ded3            :INT              /* Private */
  ownblitter      :INT              /* Private */
  vblposition     :INT              /* Private */
  switch          :CHAR             /* Private */
  destruct        :CHAR             /* Private */
  randomseed      :LONG             /* Random seed */
  blitterused     :INT              /* 0 = Free, 1 = Grabbed */
  blitterpriority :INT              /* 0 = NoPriority, 1 = Priority */
  currentScreen   :PTR TO screen    /* Currently displayed screen */
  ticks           :LONG             /* Pointer to list of all current tasks */
  hsync           :INT              /* Private */
  sysobjects      :PTR TO sysobject /* System object list (master) */
  debugactive     :CHAR             /* Set if debugger is currently active */
  scrblanked      :CHAR             /* Set if screen is currently blanked */
  version         :INT              /* The version of this kernel */
  revision        :INT              /* The revision of this kernel */
  screenlist      :PTR TO sscreen   /* List of shown screens, starting from back. */
  childobjects    :PTR TO sysobject /* System object list (hidden & children) */
  referencedir    :PTR TO directory /* List of references files */
  referencelist   :PTR TO reference /* List of object references */
  screensmodule   :PTR TO module    /* Pointer to module */
  blittermodule   :PTR TO module    /* Pointer to module */
  filemodule      :PTR TO module    /* Pointer to module */
  keymodule       :PTR TO module    /* Pointer to module */
  screensbase     :LONG
  blitterbase     :LONG
  filebase        :LONG
  keybase         :LONG
  soundmodule     :PTR TO module
  soundbase       :LONG
  modlist         :PTR TO modentry
  eventarray      :PTR TO evtentry
  flipsignal      :LONG
  userfocus       :PTR TO dpktask
  debug           :LONG
  tasklist        :PTR TO dpktask
  configmodule    :PTR TO module
ENDOBJECT

