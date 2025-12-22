#ifndef DATESELECTORGADCLASS_H
#define DATESELECTORGADCLASS_H
/*
**  $Filename: DateSelectorGadClass.h $
**  $Revision: 1.1 $
**  $Date: 93/06/05 $
**
**  Header file for DateSelectorGadClass BOOPSI object.
**
**  Copyright (C) 1993 Markus Aalto
**
**  This file is distributed under the GNU General Public Licence. Please
**  refer to the file COPYING for details.
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

/************************************/
/*  Tags for DateSelectorGadClass.  */
/************************************/
#define     DSG_TAGBASE         ( TAG_USER )
#define     DSG_YEAR            ( DSG_TAGBASE + 1 )
#define     DSG_MONTH           ( DSG_TAGBASE + 2 )
#define     DSG_DAY             ( DSG_TAGBASE + 3 )
#define     DSG_TEXTFONT        ( DSG_TAGBASE + 4 )
#define     DSG_FIXEDPOSITION   ( DSG_TAGBASE + 5 )
#define     DSG_SUNDAYFIRST     ( DSG_TAGBASE + 6 )

/************************************************************/
/*  Protos for public functions in DateSelectorGadClass.lib */
/************************************************************/
Class       __asm *initDateSelectorGadClass( VOID );
BOOL        __asm freeDateSelectorGadClass( register __a0 Class * );
BOOL        __asm DateSelectorGadDimensions(    register __a0 struct TextFont *,
                                                register __a1 ULONG *,
                                                register __a2 ULONG *,
                                                register __d0 BOOL );

#endif /* DATESELECTORGADCLASS_H */
