                 positive values mean click was below center) */
ENDOBJECT

CONST MUI_LPR_ABOVE  = 1
CONST MUI_LPR_BELOW  = 2
CONST MUI_LPR_LEFT   = 4
CONST MUI_LPR_RIGHT  = 8

/***************************************************************************
**
** Macro Section
** -------------
**
** To make GUI creation more easy and understandable, you can use the
** macros below. If you dont want, just define MUI_NOSHORTCUTS to disable
** them.
**
***************************************************************************/

#ifndef MUI_NOSHORTCUTS

/***************************************************************************
**
** Object Generation
** -----------------
**
** The xxxObject (and xChilds) macros generate new instances of MUI classes.
** Every xxxObject can be followed by tagitems specifying initial create
** time attributes for the new object and must be terminated with the
** End macro:
**
** obj = StringObject,
**     