
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_guicontrol.h
 * Author    : Andrew Bell
 * Copyright : Copyright © 1998-1999 Andrew Bell (See GNU GPL)
 * Created   : Saturday 28-Feb-98 16:00:00
 * Modified  : Sunday 22-Aug-99 23:31:45
 * Comment   : 
 *
 * (Generated with StampSource 1.2 by Andrew Bell)
 *
 * [!END - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 */

/* File created on: Tue/3/Nov/1998 */

/*
 *  Hexy, binary file viewer and editor for the Amiga.
 *  Copyright (C) 1999 Andrew Bell
 *
 *  Author's email address: andrew.ab2000@bigfoot.com
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */


#define GD_GVDRAGBAR        0 /* main window */
#define GD_GNEXTL         1
#define GD_GPREVL         2
#define GD_GNEXTP         3
#define GD_GPREVP         4
#define GD_GSEARCH          5
#define GD_GQUIT          6
#define GD_GMODE          7
#define GD_GSTATUS          8
#define GD_GEDIT          9

#define GD_JGSTRING         0 /* jump window */
#define GD_JGDONE         1

#define GD_FGFINDNEXT       0 /* find window */
#define GD_FGDONE         1
#define GD_FGSTRING         2
#define GD_FGIGNORECASE       3
#define GD_FGBINSEARCH        4
#define GD_FGFINDPREV       5
#define GD_FGBINRESULT        6

#define GD_HLLV           0 /* hunklist window */
#define GD_HLDONE         1
#define GD_HLGOTO         2

/* Soon to be obsolete */

#define MAIN_CNT 10
#define JUMP_CNT 2
#define FIND_CNT 7
#define HUNKLIST_CNT 3
