; Compile me to get full executable
; Does not support keyboard short cuts yet


    include    toggledemowin.i

GT_ReplyIMsg             EQU    -78
GT_GetIMsg               EQU    -72
WaitPort                 EQU    -384
ItemAddress              EQU    -144
GT_BeginRefresh          EQU    -90
GT_EndRefresh            EQU    -96
CloseScreen              EQU    -66
GT_SetGadgetAttrsA       EQU    -42
RemoveGList              EQU    -444
AddGList                 EQU    -438
RefreshGList             EQU    -432

start

    jsr     OpenLibs
    tst.l   d0
    bne     NoLibs
    jsr     MakeImages
    tst.l   d0
    bne     NoImages
    jsr     OpenMainWindowWindow
    tst.l   d0
    bne     NoWindow
WaitHere:
    move.l  MainWindow,a1               ; Get win address
    move.l  86(a1),a2                   ; Get message port
    move.l  a2,a0
    move.l  _SysBase,a6
    jsr     WaitPort(a6)
    move.l  _GadToolsBase,a6
    move.l  a2,a0
    jsr     GT_GetIMsg(a6)
    tst.l   d0
    beq     WaitHere
    move.l  d0,a1
    move.l  20(a1),d2                   ; Get class
    move.w  24(a1),d3                   ; Get code
    move.l  28(a1),a4                   ; Get IAddress
    move.l  20(a1),d4
    
    move.l  _GadToolsBase,a6
    jsr     GT_ReplyIMsg(a6)

    cmpi.l  #$200,d4                    ; Quit if window closed
    beq     Done                        ; Remove when proper method implemented
    move.l  d2,d0                       ; Get class
    move.w  d3,d1                       ; Get code
    move.l  a4,a0                       ; Get IAddress
    jsr     ProcessWindowMainWindow     ; Call process routine
    jmp     WaitHere
Done:
    jsr     CloseMainWindowWindow
NoWindow:
    jsr     FreeImages
NoImages:
    jsr     CloseLibs
NoLibs:
    rts

FirstOpt:
    dc.b    'First Option',0
SecondOpt:
    dc.b    'Second Option',0
ThirdOpt:
    dc.b    'Third Option',0
    cnop    0,2

TagArray:
    dc.l    $8008000B,0,0               ; GTTX_Text,0,TAG_DONE


ProcessWindowMainWindow:                ; Class in d0,code in d1,iaddress in a0 required, others are up to you.
    movem.l d1-d4/a0-a6,-(sp)           ; Restore Registers
    cmp.l   #$20,d0                     ; IDCMP_GADGETDOWN
    bne     NotGADGETDOWN
                                        ;  Gadget message, gadget is in a0
    move.w  38(a0),d0                   ; Get id in d0
    cmp.w   #GD_FirstGadget,d0
    bne     NotFirstGadgetDown
                                        ; Boolean activated, Text of gadget : 
    jsr     RemoveGadgets
    
    movea.l MainWindowGadgets,a0
    jsr     SetGadgetOn
    movea.l MainWindowGadgets+4,a0
    jsr     SetGadgetOff
    movea.l MainWindowGadgets+8,a0
    jsr     SetGadgetOff
    
    jsr     ReturnGadgets
    lea.l   FirstOpt,a0
    jsr     SetGadgetString
    
    jmp     MainWindowDoneMessage
NotFirstGadgetDown:
    cmp.w   #GD_SecondGadget,d0
    bne     NotSecondGadgetDown
                                        ; Boolean activated, Text of gadget : 
    jsr     RemoveGadgets
    
    movea.l MainWindowGadgets,a0
    jsr     SetGadgetOff
    movea.l MainWindowGadgets+4,a0
    jsr     SetGadgetOn
    movea.l MainWindowGadgets+8,a0
    jsr     SetGadgetOff
    
    jsr     ReturnGadgets
    lea.l   SecondOpt,a0
    jsr     SetGadgetString
    
    jmp     MainWindowDoneMessage
NotSecondGadgetDown:
    cmp.w   #GD_ThirdGadget,d0
    bne     NotThirdGadgetDown
                                        ; Boolean activated, Text of gadget : 
    jsr     RemoveGadgets
    
    movea.l MainWindowGadgets,a0
    jsr     SetGadgetOff
    movea.l MainWindowGadgets+4,a0
    jsr     SetGadgetOff
    movea.l MainWindowGadgets+8,a0
    jsr     SetGadgetOn
    
    jsr     ReturnGadgets
    lea.l   ThirdOpt,a0
    jsr     SetGadgetString
    
    jmp     MainWindowDoneMessage
NotThirdGadgetDown:
    jmp     MainWindowDoneMessage
NotGADGETDOWN:
    cmp.l   #$200,d0                    ; IDCMP_CLOSEWINDOW
    bne     NotCLOSEWINDOW
                                        ; CloseWindow
    jmp     MainWindowDoneMessage
NotCLOSEWINDOW:
    cmp.l   #4,d0                       ; IDCMP_REFRESHWINDOW
    bne     NotREFRESHWINDOW
    movea.l MainWindow,a0
    movea.l _IntuitionBase,a6
    jsr     GT_BeginRefresh(a6)
                                        ; Refrsh Window
    move.l  #1,d0
    movea.l MainWindow,a0
    jsr     GT_EndRefresh(a6)
    jmp     MainWindowDoneMessage
NotREFRESHWINDOW:
    cmp.l   #$200000,d0                 ; IDCMP_VANILLAKEY
    bne     NotVANILLAKEY
                                        ; Processed key press
                                        ; gadgets need processing perhaps.
    jmp     MainWindowDoneMessage
NotVANILLAKEY:
MainWindowDoneMessage:
    movem.l (sp)+,d1-d4/a0-a6           ; Restore Registers
    rts
    
SetGadgetString:                        ; Put string in a0 then call this
    movea.l _GadToolsBase,a6            ; function to set text gadget.
    move.l  a0,TagArray+4
    movea.l MainWindowGadgets+12,a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     TagArray,a3
    jsr     GT_SetGadgetAttrsA(a6)
    rts
    
RemoveGadgets:
    movea.l _IntuitionBase,a6
    movea.l MainWindow,a0
    movea.l MainWindowGList,a1
    move.l  #$FFFFFFFF,d0
    jsr     RemoveGList(a6)
    rts

SetGadgetOn:                            ; Gadget in a0
    move.w  12(a0),d0
    bset    #7,d0
    move.w  d0,12(a0)
    rts
SetGadgetOff:                            ; Gadget in a0
    move.w  12(a0),d0
    bclr    #7,d0
    move.w  d0,12(a0)
    rts

ReturnGadgets:
    movea.l _IntuitionBase,a6
    movea.l MainWindow,a0
    movea.l MainWindowGList,a1
    move.l  #50,d0
    move.l  #$FFFFFFFF,d1
    move.l  #0,d2
    jsr     AddGList(a6)
    movea.l MainWindowGList,a0
    movea.l MainWindow,a1
    move.l  #0,d0
    move.l  #$FFFFFFFF,d1
    jsr     RefreshGList(a6)
    rts

    
    end
