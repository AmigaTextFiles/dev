/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
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
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  bench.c - Triton benchmark
 *
 */


/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////////////////////////////////////// Include our stuff // */
/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>

#include <libraries/triton.h>

#include <proto/triton.h>
#include <proto/dos.h>
#include <proto/intuition.h>


/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////////////////////////////////// Disable CTRL-C handling // */
/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */

int CXBRK(void) { return(0); }
int chkabort(void) { return(0); }


/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////////////////////////////////////// Test Open & Close // */
/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */

STRPTR cycle_entries[]= { "Entry 0", "1", "2", "3", "4", "5", "6", "7", "8", "9", NULL };
STRPTR mx_entries[]= { "Choice 0", "Choice 1", "Choice 2", NULL };

VOID test_open_close(VOID)
{
  ProjectDefinition(test_trwintags)
  {
    WindowTitle("Test"), WindowPosition(TRWP_CENTERDISPLAY), WindowID(1),
  
    TRMN_Title,                 (ULONG) "A menu",
    TRMN_Item,                 (ULONG) "A simple item", TRAT_ID, 1,
    TRMN_Item,                 (ULONG) "Another item", TRAT_ID, 2,
    TRMN_Item,                 (ULONG) "And now... a barlabel", TRAT_ID, 3,
    TRMN_Item,                 (ULONG) TRMN_BARLABEL,
    TRMN_Item,                 (ULONG) "1_An item with a shortcut", TRAT_ID, 4,
    TRMN_Item,                 (ULONG) "2_Another one", TRAT_ID, 5,
    TRMN_Item,                 (ULONG) "3_And number 3", TRAT_ID, 6,
    TRMN_Item,                 (ULONG) TRMN_BARLABEL,
    TRMN_Item,                 (ULONG) "_F1_And under OS3.0: Extended command keys", TRAT_ID, 6,
    TRMN_Item,                 (ULONG) "_F2_Another one", TRAT_ID, 7,
    TRMN_Item,                 (ULONG) TRMN_BARLABEL,
    TRMN_Item,                 (ULONG) "How do you like submenus?",
    TRMN_Sub,                 (ULONG) "G_Great!", TRAT_ID, 8,
    TRMN_Sub,                 (ULONG) "F_Fine", TRAT_ID, 9,
    TRMN_Sub,                 (ULONG) "D_Don't know", TRAT_ID, 10,
    TRMN_Sub,                 (ULONG) "N_Not so fine", TRAT_ID, 11,
    TRMN_Sub,                 (ULONG) "P_Puke!", TRAT_ID, 12,
    
    TRMN_Title,                 (ULONG) "Another menu",
    TRMN_Item,                 (ULONG) "This item is ghosted", TRMN_Flags, TRMF_DISABLED, TRAT_ID, 100,
    TRMN_Item,                 (ULONG) TRMN_BARLABEL,
    TRMN_Item,                 (ULONG) "Item 1 is checked", TRMN_Flags, TRMF_CHECKED, TRAT_ID, 13,
    TRMN_Item,                 (ULONG) "Item 2 can be checked, too", TRMN_Flags, TRMF_CHECKIT, TRAT_ID, 14,

    TRMN_Title,                 (ULONG) "Ghosted menu",
    TRMN_Flags,                 (ULONG) TRMF_DISABLED,
    TRMN_Item,                 (ULONG) "Item 1", TRAT_ID, 101,
    TRMN_Item,                 (ULONG) "Item 2", TRAT_ID, 102,

    TRGR_Vert,                  (ULONG) TRGR_PROPSHARE|TRGR_ALIGN,
    
    TROB_Space,               (ULONG) NULL,
    
    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_CENTER,
      TROB_Space,             (ULONG) NULL,
    TROB_Line,              (ULONG) TROF_HORIZ,
    TROB_Space,             (ULONG) NULL,
    TROB_Text,              (ULONG) NULL, TRAT_Text, (ULONG) "GadTools", TRAT_Flags, (ULONG) TRTX_TITLE,
    TROB_Space,             (ULONG) NULL,
    TROB_Line,              (ULONG) TROF_HORIZ,
    TROB_Space,             (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,
    
    TROB_Space,               (ULONG) NULL,
    
    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
    TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
    TROB_Space,           (ULONG) NULL,
    TROB_CheckBox,        (ULONG) NULL,
    TRAT_ID,            (ULONG) 1,
    TRAT_Value,         (ULONG) TRUE,
    TRGR_End,               (ULONG) NULL,
    TROB_Space,             (ULONG) NULL,
    TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
    TROB_Text,            (ULONG) NULL,
    TRAT_Text,          (ULONG) "_Checkbox",
    TRAT_ID,            (ULONG) 1,
    TROB_Space,           (ULONG) NULL,
    TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,
    
    TROB_Space,               (ULONG) NULL,
    
    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
    TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
    TROB_Space,           (ULONG) NULL,
    TROB_Slider,          (ULONG) NULL,
    TRAT_ID,            (ULONG) 4,
    TRSL_Min,           (ULONG) 1,
    TRSL_Max,           (ULONG) 3,
          TRAT_Value,         (ULONG) 1,
    TRGR_End,               (ULONG) NULL,
    TROB_Space,             (ULONG) NULL,
    TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
    TROB_Text,            (ULONG) NULL,
    TRAT_Text,          (ULONG) "_Slider: ",
    TRAT_ID,            (ULONG) 4,
    TROB_Text,            (ULONG) NULL,
    TRAT_Value,         (ULONG) 1,
    TRAT_ID,            (ULONG) 4,
    TRAT_MinWidth,      (ULONG) 3,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_Scroller,        (ULONG) NULL,
          TRAT_ID,            (ULONG) 5,
          TRAT_Value,         (ULONG) 2,
          TRSC_Total,         (ULONG) 7,
          TRSC_Visible,       (ULONG) 3,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "Sc_roller: ",
          TRAT_ID,            (ULONG) 5,
        TROB_Text,            (ULONG) NULL,
          TRAT_Value,         (ULONG) 2,
          TRAT_ID,            (ULONG) 5,
          TRAT_MinWidth,      (ULONG) 3,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_Palette,         (ULONG) NULL,
          TRAT_ID,            (ULONG) 3,
          TRAT_Value,         (ULONG) 1,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "_Palette: ",
          TRAT_ID,            (ULONG) 3,
        TROB_Text,            (ULONG) NULL,
          TRAT_Value,         (ULONG) 1,
          TRAT_ID,            (ULONG) 3,
          TRAT_MinWidth,      (ULONG) 3,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_Cycle,           (ULONG) cycle_entries,
          TRAT_ID,            (ULONG) 6,
          TRAT_Value,         (ULONG) 4,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "C_ycle: ",
          TRAT_ID,            (ULONG) 6,
        TROB_Text,            (ULONG) NULL,
          TRAT_Value,         (ULONG) 4,
          TRAT_ID,            (ULONG) 6,
          TRAT_MinWidth,      (ULONG) 3,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_Cycle,           (ULONG) mx_entries,
          TRAT_ID,            (ULONG) 13,
          TRAT_Value,         (ULONG) 1,
          TRAT_Flags,         (ULONG) TRCY_MX,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "_MX: ",
          TRAT_ID,            (ULONG) 13,
        TROB_Text,            (ULONG) NULL,
          TRAT_Value,         (ULONG) 1,
          TRAT_ID,            (ULONG) 13,
          TRAT_MinWidth,      (ULONG) 3,
        TROB_Space,           (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_String,          (ULONG) "foo bar",
          TRAT_ID,            (ULONG) 7,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "S_tring",
          TRAT_ID,            (ULONG) 7,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_String,          (ULONG) "",
          TRAT_Flags,         (ULONG) TRST_INVISIBLE,
          TRAT_ID,            (ULONG) 15,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "Pass_word",
          TRAT_ID,            (ULONG) 15,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_CENTER,
      TROB_Space,             (ULONG) NULL,
      TROB_Line,              (ULONG) TROF_HORIZ,
      TROB_Space,             (ULONG) NULL,
      TROB_Text,              (ULONG) NULL, TRAT_Text, (ULONG) "BOOPSI", TRAT_Flags, (ULONG) TRTX_TITLE,
      TROB_Space,             (ULONG) NULL,
      TROB_Line,              (ULONG) TROF_HORIZ,
      TROB_Space,             (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
      TROB_Space,             (ULONG) NULL,
      TROB_Button,            (ULONG) NULL, TRAT_ID, 2, TRAT_Text, (ULONG) "_Button",
      TROB_Space,             (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
      TROB_Space,             (ULONG) NULL,
      TROB_Text,              (ULONG) NULL, TRAT_Text, (ULONG) "_File:", TRAT_ID, 10,
      TROB_Space,             (ULONG) NULL,
      TROB_Button,            (ULONG) TRBT_GETFILE, TRAT_ID, 10, TRAT_Text, (ULONG) "",
      TROB_Space,             (ULONG) NULL,
      TROB_Text,              (ULONG) NULL, TRAT_Text, (ULONG) "_Drawer:", TRAT_ID, 11,
      TROB_Space,             (ULONG) NULL,
      TROB_Button,            (ULONG) TRBT_GETDRAWER, TRAT_ID, 11, TRAT_Text, (ULONG) "",
      TROB_Space,             (ULONG) NULL,
      TROB_Text,              (ULONG) NULL, TRAT_Text, (ULONG) "_Entry:", TRAT_ID, 12,
      TROB_Space,             (ULONG) NULL,
      TROB_Button,            (ULONG) TRBT_GETENTRY, TRAT_ID, 12, TRAT_Text, (ULONG) "",
      TROB_Space,             (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

  HorizGroupA, Space, VertGroupA,
    Space,

    NamedFrameBox("PROPSHARE (default)"), ObjectBackfillWin, VertGroupA, Space, HorizGroupC,
      Space,
      Button("Short",1),
      Space,
      Button("And much, much longer...",2),
      Space,
      EndGroup, Space, EndGroup,

    Space,

    NamedFrameBox("EQUALSHARE"), ObjectBackfillWin, VertGroupA, Space, HorizGroupEC,
      Space,
      Button("Short",3),
      Space,
      Button("And much, much longer...",4),
      Space,
      EndGroup, Space, EndGroup,

    Space,

    NamedFrameBox("PROPSPACES"), ObjectBackfillWin, VertGroupA, Space, HorizGroupSC,
      Space,
      Button("Short",5),
      Space,
      Button("And much, much longer...",6),
      Space,
      EndGroup, Space, EndGroup,

    Space,

    NamedFrameBox("TRGR_ARRAY"), ObjectBackfillWin, VertGroupA, Space, LineArray,
      BeginLine,
        Space,
        Button("Short",7),
        Space,
        Button("And much, much longer...",8),
        Space,
        EndLine,
      Space,
      BeginLine,
        Space,
        Button("Not so short",9),
        Space,
        Button("And a bit longer...",10),
        Space,
        EndLine,
      Space,
      BeginLineI,
        NamedSeparator("An independent line"),
        EndLine,
      Space,
      BeginLine,
        Space,
        Button("foo bar",12),
        Space,
        Button("42",13),
        Space,
        EndLine,
      EndArray, Space, EndGroup,

    Space,
    EndGroup, Space, EndGroup,

    TRGR_End,                 (ULONG) NULL,

    EndProject
  };

  clock_t start,end;
  int i;

  struct TR_Project *test_project;

  start=clock();
  for(i=0;i<5;i++)
  {
    if(test_project=TR_OpenProject(Application,test_trwintags))
    {
      TR_CloseProject(test_project);
    }
    else fprintf(stderr,"Error: Can't open test window.\n");
  }
  end=clock();
  printf("Opening & closing........: %d ms\n",(end-start)/5);
}


/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////////////////////////////////////////////////// Test Set & Get // */
/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */

VOID test_set_get(VOID)
{
  ProjectDefinition(test_trwintags)
  {
    WindowTitle("Test"), WindowPosition(TRWP_CENTERDISPLAY), WindowID(2),
  
    TRGR_Vert,                  (ULONG) TRGR_PROPSHARE|TRGR_ALIGN,
    
    TROB_Space,               (ULONG) NULL,
    
    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_CENTER,
      TROB_Space,             (ULONG) NULL,
    TROB_Line,              (ULONG) TROF_HORIZ,
    TROB_Space,             (ULONG) NULL,
    TROB_Text,              (ULONG) NULL, TRAT_Text, (ULONG) "GadTools", TRAT_Flags, (ULONG) TRTX_TITLE,
    TROB_Space,             (ULONG) NULL,
    TROB_Line,              (ULONG) TROF_HORIZ,
    TROB_Space,             (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,
    
    TROB_Space,               (ULONG) NULL,
    
    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
    TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
    TROB_Space,           (ULONG) NULL,
    TROB_CheckBox,        (ULONG) NULL,
    TRAT_ID,            (ULONG) 1,
    TRAT_Value,         (ULONG) TRUE,
    TRGR_End,               (ULONG) NULL,
    TROB_Space,             (ULONG) NULL,
    TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
    TROB_Text,            (ULONG) NULL,
    TRAT_Text,          (ULONG) "_Checkbox",
    TRAT_ID,            (ULONG) 1,
    TROB_Space,           (ULONG) NULL,
    TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,
    
    TROB_Space,               (ULONG) NULL,
    
    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
    TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
    TROB_Space,           (ULONG) NULL,
    TROB_Slider,          (ULONG) NULL,
    TRAT_ID,            (ULONG) 4,
    TRSL_Min,           (ULONG) 1,
    TRSL_Max,           (ULONG) 3,
          TRAT_Value,         (ULONG) 1,
    TRGR_End,               (ULONG) NULL,
    TROB_Space,             (ULONG) NULL,
    TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
    TROB_Text,            (ULONG) NULL,
    TRAT_Text,          (ULONG) "_Slider: ",
    TRAT_ID,            (ULONG) 4,
    TROB_Text,            (ULONG) NULL,
    TRAT_Value,         (ULONG) 1,
    TRAT_ID,            (ULONG) 4,
    TRAT_MinWidth,      (ULONG) 3,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_Scroller,        (ULONG) NULL,
          TRAT_ID,            (ULONG) 5,
          TRAT_Value,         (ULONG) 2,
          TRSC_Total,         (ULONG) 7,
          TRSC_Visible,       (ULONG) 3,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "Sc_roller: ",
          TRAT_ID,            (ULONG) 5,
        TROB_Text,            (ULONG) NULL,
          TRAT_Value,         (ULONG) 2,
          TRAT_ID,            (ULONG) 5,
          TRAT_MinWidth,      (ULONG) 3,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_Palette,         (ULONG) NULL,
          TRAT_ID,            (ULONG) 3,
          TRAT_Value,         (ULONG) 1,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "_Palette: ",
          TRAT_ID,            (ULONG) 3,
        TROB_Text,            (ULONG) NULL,
          TRAT_Value,         (ULONG) 1,
          TRAT_ID,            (ULONG) 3,
          TRAT_MinWidth,      (ULONG) 3,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_Cycle,           (ULONG) cycle_entries,
          TRAT_ID,            (ULONG) 6,
          TRAT_Value,         (ULONG) 4,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "C_ycle: ",
          TRAT_ID,            (ULONG) 6,
        TROB_Text,            (ULONG) NULL,
          TRAT_Value,         (ULONG) 4,
          TRAT_ID,            (ULONG) 6,
          TRAT_MinWidth,      (ULONG) 3,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_Cycle,           (ULONG) mx_entries,
          TRAT_ID,            (ULONG) 13,
          TRAT_Value,         (ULONG) 1,
          TRAT_Flags,         (ULONG) TRCY_MX,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "_MX: ",
          TRAT_ID,            (ULONG) 13,
        TROB_Text,            (ULONG) NULL,
          TRAT_Value,         (ULONG) 1,
          TRAT_ID,            (ULONG) 13,
          TRAT_MinWidth,      (ULONG) 3,
        TROB_Space,           (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_Horiz,               (ULONG) TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER,
      TRGR_Horiz,             (ULONG) TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER,
        TROB_Space,           (ULONG) NULL,
        TROB_String,          (ULONG) "foo bar",
          TRAT_ID,            (ULONG) 7,
      TRGR_End,               (ULONG) NULL,
      TROB_Space,             (ULONG) NULL,
      TRGR_Horiz,             (ULONG) TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER,
        TROB_Text,            (ULONG) NULL,
          TRAT_Text,          (ULONG) "S_tring",
          TRAT_ID,            (ULONG) 7,
      TROB_Space,             (ULONG) NULL,
      TRGR_End,               (ULONG) NULL,
    TRGR_End,                 (ULONG) NULL,

    TROB_Space,               (ULONG) NULL,

    TRGR_End,                 (ULONG) NULL,
    EndProject
  };

  clock_t start,end;
  int i;

  struct TR_Message *trmsg;
  struct TR_Project *test_project;

  if(test_project=TR_OpenProject(Application,test_trwintags))
  {
    start=clock();
    for(i=0;i<50;i++)
    {
      TR_SetAttribute(test_project,1,TRAT_Value,i%2);
      TR_SetAttribute(test_project,4,TRAT_Value,(i%2)+1);
      TR_SetAttribute(test_project,5,TRAT_Value,i%2);
      TR_SetAttribute(test_project,3,TRAT_Value,i%2);
      TR_SetAttribute(test_project,6,TRAT_Value,i%2);
      TR_SetAttribute(test_project,13,TRAT_Value,i%2);
      TR_SetAttribute(test_project,7,NULL,(ULONG)"New string");

      TR_GetAttribute(test_project,1,TRAT_Value);
      TR_GetAttribute(test_project,4,TRAT_Value);
      TR_GetAttribute(test_project,5,TRAT_Value);
      TR_GetAttribute(test_project,3,TRAT_Value);
      TR_GetAttribute(test_project,6,TRAT_Value);
      TR_GetAttribute(test_project,13,TRAT_Value);
      TR_GetAttribute(test_project,7,NULL);

      while(trmsg=TR_GetMsg(Application)) TR_ReplyMsg(trmsg);
    }
    end=clock();
    printf("Setting & getting........: %d ms\n",(end-start)/50);

    TR_CloseProject(test_project);
  }
  else fprintf(stderr,"Error: Can't open test window.\n");
}


/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////////////////////////////////////////// Main function // */
/* /////////////////////////////////////////////////////////////////////////////////////////////////////// */

int main(void)
{
  if(TR_OpenTriton(TRITON13VERSION,
		   TRCA_Name,"TritonBench",
		   TRCA_LongName,"Triton benchmark",
		   TRCA_Version,"1.0",TAG_END))
  {
    fprintf(stderr,"\n\nPlease limit mouse movements for system accuracy...\n\n\n");
    Delay(100);
    printf("TritonBench © 1995 by Stefan Zeiger\n");
    printf("=========================================\n");
    test_open_close();
    test_set_get();
    printf("=========================================\n");
    fprintf(stderr,"\nFinished.\n");

    TR_CloseTriton();
    return 0;
  } else puts("Can't open triton.library v4+.");

  return 20;
}
