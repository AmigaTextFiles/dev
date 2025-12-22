OPT NATIVE, PREPROCESS
MODULE 'target/libraries/mui', 'target/mui/NList_mcc'
{MODULE 'mui/NListview_mcc'}

/***************************************************************************

 NListview.mcc - New Listview MUI Custom Class
 Registered MUI class, Serial Number: 1d51 (0x9d510020 to 0x9d51002F)

 Copyright (C) 1996-2001 by Gilles Masson
 Copyright (C) 2001-2005 by NList Open Source Team

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 NList classes Support Site:  http://www.sf.net/projects/nlist-classes

 $Id: NListview_mcc.h 159 2007-06-10 12:29:34Z damato $

***************************************************************************/

NATIVE {MUIC_NListview} CONST
#define MUIC_NListview muic_nlistview
STATIC muic_nlistview = 'NListview.mcc'

NATIVE {NListviewObject} CONST
#define NListviewObject Mui_NewObjectA(MUIC_NListview,[TAG_IGNORE,0


/* Attributes */

NATIVE {MUIA_NListview_NList}                CONST MUIA_NListview_NList                = $9d510020 /* GM  i.g Object *          */

NATIVE {MUIA_NListview_Vert_ScrollBar}       CONST MUIA_NListview_Vert_ScrollBar       = $9d510021 /* GM  isg LONG              */
NATIVE {MUIA_NListview_Horiz_ScrollBar}      CONST MUIA_NListview_Horiz_ScrollBar      = $9d510022 /* GM  isg LONG              */
NATIVE {MUIA_NListview_VSB_Width}            CONST MUIA_NListview_VSB_Width            = $9d510023 /* GM  ..g LONG              */
NATIVE {MUIA_NListview_HSB_Height}           CONST MUIA_NListview_HSB_Height           = $9d510024 /* GM  ..g LONG              */

/*
NATIVE {MUIV_Listview_ScrollerPos_Default} CONST
NATIVE {MUIV_Listview_ScrollerPos_Left} CONST
NATIVE {MUIV_Listview_ScrollerPos_Right} CONST
NATIVE {MUIV_Listview_ScrollerPos_None} CONST
*/

NATIVE {MUIM_NListview_QueryBegining}       CONST MUIM_NListview_QueryBegining = MUIM_NList_QueryBeginning /* obsolete */

NATIVE {MUIV_NListview_VSB_Always}      CONST MUIV_NListview_VSB_Always      = 1
NATIVE {MUIV_NListview_VSB_Auto}        CONST MUIV_NListview_VSB_Auto        = 2
NATIVE {MUIV_NListview_VSB_FullAuto}    CONST MUIV_NListview_VSB_FullAuto    = 3
NATIVE {MUIV_NListview_VSB_None}        CONST MUIV_NListview_VSB_None        = 4
NATIVE {MUIV_NListview_VSB_Default}     CONST MUIV_NListview_VSB_Default     = 5
CONST MUIV_NListview_VSB_Left        = 6

NATIVE {MUIV_NListview_HSB_Always}      CONST MUIV_NListview_HSB_Always      = 1
NATIVE {MUIV_NListview_HSB_Auto}        CONST MUIV_NListview_HSB_Auto        = 2
NATIVE {MUIV_NListview_HSB_FullAuto}    CONST MUIV_NListview_HSB_FullAuto    = 3
NATIVE {MUIV_NListview_HSB_None}        CONST MUIV_NListview_HSB_None        = 4
NATIVE {MUIV_NListview_HSB_Default}     CONST MUIV_NListview_HSB_Default     = 5

NATIVE {MUIV_NListview_VSB_On}          CONST MUIV_NListview_VSB_On          = $0030
NATIVE {MUIV_NListview_VSB_Off}         CONST MUIV_NListview_VSB_Off         = $0010

NATIVE {MUIV_NListview_HSB_On}          CONST MUIV_NListview_HSB_On          = $0300
NATIVE {MUIV_NListview_HSB_Off}         CONST MUIV_NListview_HSB_Off         = $0100
