                opt     o+,ow-,inconce
*
*       FONT.S
*
*       (C) Copyright 1995 Jaba Development.
*       (C) Copyright 1995 Jan van den Baard.
*           All Rights Reserved.
*
*       This is a small assembly example of BGUI. It is basically the
*       same as the "Font" demo except that this is coded in assembler.
*
*       Assembles OK with Devpac 3.
*

                incdir  'Work:Asm30/'
                include 'exec/types.i'
                include 'exec/memory.i'
                include 'exec/exec_lib.i'
                include 'dos/dos_lib.i'
                include 'libraries/bgui.i'
                include 'libraries/bgui_offsets.i'
                include 'libraries/bgui_macros.i'
                include 'libraries/gadtools.i'

                ;
                ;       Simple shortcut to: jsr _LVOfunc(a6)
                ;
Call            macro   ; func
                jsr     _LVO\1(a6)
                endm

                ;
                ;       Prints a message to the console.
                ;
Print           macro
                move.l  a6,-(sp)
                move.l  dosbase,a6
                Call    Output
                move.l  d0,d1
                move.l  #\1,d2
                Call    FPuts
                move.l  (sp)+,a6
                endm

main:           move.l  (4).w,a6

                ;
                ;       Open dos.
                ;
                lea.l   dosname(pc),a1
                moveq.l #0,d0
                Call    OpenLibrary
                move.l  d0,dosbase
                beq     bye

                ;
                ;       Open bgui.
                ;
                lea.l   bguiname(pc),a1
                moveq.l #BGUIVERSION,d0
                Call    OpenLibrary
                move.l  d0,bguibase
                bne.b   bguiok
                Print   bguierror
                move.l  dosbase,a1
                Call    CloseLibrary
                rts

bguiok:         move.l  d0,a6

                ;
                ;       Create the window object.
                ;
                WindowObject
                        ;
                        ;       The PUTC macro can put upto 15 values
                        ;       on the stack. All arguments you pass
                        ;       this macro will get a '#' preceeded
                        ;       so only absolute addresses and constants
                        ;       can be used here. For mixed data the
                        ;       PUTV macro can be used.
                        ;
                        PUTC    WINDOW_Title,wtitle
                        PUTC    WINDOW_ScaleWidth,20
                        PUTC    WINDOW_AutoAspect,1
                        MasterGroup
                                VGroupObject
                                        Spacing 4
                                        HOffset 4
                                        VOffset 4
                                        StartMember
                                                InfoObject
                                                        PUTC    INFO_TextFormat,header
                                                        PUTC    INFO_HorizOffset,0
                                                        PUTC    INFO_VertOffset,0
                                                EndObject
                                        EndMember FixMinHeight
                                        StartMember
                                                HGroupObject
                                                        PUTC    FRM_Type,FRTYPE_BUTTON
                                                        PUTC    FRM_Recessed,1
                                                        HOffset 4
                                                        VOffset 1
                                                        Spacing 4
                                                        StartMember
                                                                InfoObject
                                                                        PUTC    INFO_TextFormat,lefttext
                                                                        PUTC    INFO_FixTextWidth,1
                                                                        PUTC    INFO_MinLines,3
                                                                        PUTC    INFO_VertOffset,2
                                                                        PUTC    INFO_HorizOffset,0
                                                                EndObject
                                                        EndMember
                                                        StartMember
                                                                InfoObject
                                                                        PUTC    INFO_TextFormat,righttext
                                                                        PUTC    INFO_FixTextWidth,1
                                                                        PUTC    INFO_MinLines,3
                                                                        PUTC    INFO_VertOffset,2
                                                                        PUTC    INFO_HorizOffset,0
                                                                EndObject
                                                        EndMember
                                                EndObject
                                        EndMember
                                        ;
                                        ;       With the C macros the layout attributes
                                        ;       must be passed after the EndObject macro.
                                        ;
                                        ;       The assembly macros only allow the layout
                                        ;       attributes after the EndMember macro.
                                        ;
                                        StartMember
                                                Button wb,0
                                        EndMember FixMinHeight
                                        StartMember
                                                Button sd,0
                                        EndMember FixMinHeight
                                        StartMember
                                                Button ss,0
                                        EndMember FixMinHeight
                                        StartMember
                                                HGroupObject
                                                        StartMember
                                                                Button save,1
                                                        EndMember
                                                        VarSpace DEFAULT_WEIGHT
                                                        StartMember
                                                                Button use,1
                                                        EndMember
                                                        VarSpace DEFAULT_WEIGHT
                                                        StartMember
                                                                Button cancel,1
                                                        EndMember
                                                EndObject
                                        EndMember FixMinHeight
                                EndObject
                        EndMaster
                EndObject

                ;
                ;       Window OK?
                ;
                move.l  d0,WO_Window
                beq.w   noobj

                ;
                ;       Open it.
                ;
                xWindowOpen WO_Window
                tst.l   d0
                beq.w   noopen

                ;
                ;       Obtain window signal mask.
                ;
                DOMETHOD WO_Window,#OM_GET,#WINDOW_SigMask,#winsig

                ;
                ;       Poll messages.
                ;
                move.l  (4).w,a6
msgloop:        move.l  winsig,d0
                Call    Wait
poll:
                ;
                ;       Get messages.
                ;
                HandleEvent WO_Window
                cmp.l   #WMHI_NOMORE,d0
                beq.b   msgloop

                ;
                ;       Close gadget pressed?
                ;
                cmp.l   #WMHI_CLOSEWINDOW,d0
                beq.b   noopen

                ;
                ;       Object with 1 as it's ID selected?
                ;
                cmp.l   #1,d0
                beq.b   noopen

                ;
                ;       Next please...
                ;
                bra.b   poll

noopen:
                ;
                ;       Dump the window object.
                ;
                DOMETHOD WO_Window,#OM_DISPOSE
noobj:
                ;
                ;       Close the libraries.
                ;
                move.l  (4).w,a6
                move.l  bguibase,a1
                Call    CloseLibrary
                move.l  dosbase,a1
                Call    CloseLibrary
bye:
                moveq.l #0,d0
                rts

                ;
                ;       Texts used by the code.
                ;
dosname:        dc.b    'dos.library',0
bguiname:       dc.b    'bgui.library',0

bguierror:      dc.b    'unable to open the bgui.library',10,0

wtitle:         dc.b    'Font Preferences',0
header:         ISEQ_C
                dc.b    'Selected Fonts',0
lefttext:       ISEQ_R
                dc.b    'Workbench Icon Text:',10
                dc.b    'System Default Text:',10
                dc.b    'Screen Text:',0
righttext:      dc.b    'topaz 8',10,'topaz 8',10,'topaz 8',0
wb:             dc.b    'Select Workbench Icon Text...',0
sd:             dc.b    'Select System Default Text...',0
ss:             dc.b    'Select Screen Text...',0
save:           dc.b    'Save',0
use:            dc.b    'Use',0
cancel:         dc.b    'Cancel',0

                ;
                ;       Library base storage
                ;
dosbase:        dc.l    0
intuibase:      dc.l    0
bguibase:       dc.l    0

                ;
                ;       Window signal mask and object pointer.
                ;
winsig:         dc.l    0
WO_Window:      dc.l    0
