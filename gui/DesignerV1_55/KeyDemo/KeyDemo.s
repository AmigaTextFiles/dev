; Compile me to get full executable

    include    keydemowin.i

GT_ReplyIMsg             EQU    -78
GT_GetIMsg               EQU    -72
WaitPort                 EQU    -384
ItemAddress              EQU    -144
GT_BeginRefresh          EQU    -90
GT_EndRefresh            EQU    -96
CloseScreen              EQU    -66
GT_SetGadgetAttrs        EQU    -42
ActivateGadget           EQU    -462

start

    jsr     OpenLibs                    ; Open libraries
    tst.l   d0                          ; Test result
    bne     NoLibs                      ; If cannot open the exit
    jsr     OpenMainWindowWindow        ; Open window
    tst.l   d0                          ; Test window
    bne     NoWindow                    ; If window not open then fail
WaitHere:
    move.l  MainWindow,a1               ; Get win address
    move.l  86(a1),a2                   ; Get message port
    move.l  a2,a0
    move.l  _SysBase,a6                 ; Prepare for system call
    jsr     WaitPort(a6)                ; Wait for message at port
GetMessage:
    move.l  MainWindow,a1               ; Get win address
    move.l  86(a1),a2                   ; Get message port
    move.l  a2,a0
    move.l  _GadToolsBase,a6            ; Prepare for GadTools call
    jsr     GT_GetIMsg(a6)              ; Get message
    tst.l   d0                          ; See if message arrived
    beq     WaitHere                    ; If no message then wait for next
    move.l  d0,a1                       ; Put intuimessage in a1
    move.l  20(a1),d2                   ; Get class
    move.w  24(a1),d3                   ; Get code
    move.l  28(a1),a4                   ; Get IAddress
    move.l  20(a1),d4                   ; Get class in d4
    
    move.l  _GadToolsBase,a6            ; Prepare for GadTools call
    jsr     GT_ReplyIMsg(a6)            ; Reply message

    cmpi.l  #$200,d4                    ; Quit if window closed
    beq     Done                        ; Remove when proper method implemented
    move.l  d2,d0                       ; Get class
    move.w  d3,d1                       ; Get code
    move.l  a4,a0                       ; Get IAddress
    jmp     ProcessWindowMainWindow     ; Call process routine
MainWindowDoneMessage:
    
    jmp     GetMessage                  ; Get next message
Done:
    move.l  MainWindow,d0               ; Put window in d0
    tst.l   d0                          ; See if window open
    beq     NoWindow                    ; If it is not open then skip close
    jsr     CloseMainWindowWindow       ; Close Window
NoWindow:                               ; Window cannot be opened
    jsr     CloseLibs                   ; Close libraries
NoLibs:                                 ; Could not open libraries
    rts                                 ; Return


                                        ; Cut the core out of this function and edit it suitably.

ProcessWindowMainWindow:                ; Class in d0,code in d1,iaddress in a0 required, others are up to you.
    cmp.l   #$20,d0                     ; IDCMP_GADGETDOWN
    bne     NotGADGETDOWN
                                        ;  Gadget message, gadget is in a0
    move.w  38(a0),d0                   ; Get id in d0
    cmp.w   #GD_StringGadget,d0
    bne     NotStringGadgetDown
                                        ; String entered   , Text of gadget : _String
    jmp     MainWindowDoneMessage
NotStringGadgetDown:
    cmp.w   #GD_IntegerGadget,d0
    bne     NotIntegerGadgetDown
                                        ; Integer entered  , Text of gadget : _Integer
    jmp     MainWindowDoneMessage
NotIntegerGadgetDown:
    cmp.w   #GD_MXGadget,d0
    bne     NotMXGadgetDown
                                        ; MX changed       , Text of gadget : 
    jmp     MainWindowDoneMessage
NotMXGadgetDown:
    cmp.w   #GD_SliderGadget,d0
    bne     NotSliderGadgetDown
                                        ; Slider changed   , Text of gadget : S_lider
    move.l  #0,d0
    move.w  d1,d0
    move.l  d0,sliderpos
    jmp     MainWindowDoneMessage
NotSliderGadgetDown:
    cmp.w   #GD_ScrollerGadget,d0
    bne     NotScrollerGadgetDown
                                        ; Scroller changed , Text of gadget : Scrolle_r
    move.l  #0,d0
    move.w  d1,d0
    move.l  d0,scrollerpos
    jmp     MainWindowDoneMessage
NotScrollerGadgetDown:
    jmp     MainWindowDoneMessage
NotGADGETDOWN:
    cmp.l   #$40,d0                     ; IDCMP_GADGETUP
    bne     NotGADGETUP
                                        ;  Gadget message, gadget is in a0
    move.w  38(a0),d0                   ; Get id in d0
    cmp.w   #GD_CheckBoxGadget,d0
    bne     NotCheckBoxGadgetUp
                                        ; CheckBox changed, Text of gadget : _CheckBox
    jmp     MainWindowDoneMessage
NotCheckBoxGadgetUp:
    cmp.w   #GD_CycleGadget,d0
    bne     NotCycleGadgetUp
                                        ; Cycle changed   , Text of gadget : C_ycle
    move.l  #0,d0
    move.w  d1,d0
    move.l  d0,cyclepos
    jmp     MainWindowDoneMessage
NotCycleGadgetUp:
    cmp.w   #GD_SliderGadget,d0
    bne     NotSliderGadgetUp
                                        ; Slider changed  , Text of gadget : S_lider
    move.l  #0,d0
    move.w  d1,d0
    move.l  d0,sliderpos
    jmp     MainWindowDoneMessage
NotSliderGadgetUp:
    cmp.w   #GD_ScrollerGadget,d0
    bne     NotScrollerGadgetUp
                                        ; Scroller changed, Text of gadget : Scrolle_r
    move.l  #0,d0
    move.w  d1,d0
    move.l  d0,scrollerpos
    jmp     MainWindowDoneMessage
NotScrollerGadgetUp:
    cmp.w   #GD_PaletteGadget,d0
    bne     NotPaletteGadgetUp
                                        ; Colour Selected , Text of gadget : _Palette
    move.l  #0,d0
    move.w  d1,d0
    move.l  d0,palettepos
    jmp     MainWindowDoneMessage
NotPaletteGadgetUp:
    jmp     MainWindowDoneMessage
NotGADGETUP:
    cmp.l   #4,d0                       ; IDCMP_REFRESHWINDOW
    bne     NotREFRESHWINDOW
    movea.l MainWindow,a0
    movea.l _GadToolsBase,a6
    jsr     GT_BeginRefresh(a6)
    move.l  #1,d0
    movea.l MainWindow,a0
    jsr     GT_EndRefresh(a6)
    jmp     MainWindowDoneMessage
NotREFRESHWINDOW:
    cmp.l   #$200000,d0                 ; IDCMP_VANILLAKEY
    bne     NotVANILLAKEY
                                        ; Processed key press
    cmp.w   #'q',d1
    beq     Done
    
    cmp.w   #'Q',d1
    beq     Done
    
    cmp.w   #'b',d1
    beq     ButtonPressed
    
    cmp.w   #'B',d1
    beq     ButtonPressed
    
    cmp.w   #'l',d1
    beq     SliderUp
    
    cmp.w   #'L',d1
    beq     SliderDown
    
    cmp.w   #'r',d1
    beq     ScrollerUp
    
    cmp.w   #'R',d1
    beq     ScrollerDown
    
    cmp.w   #'p',d1
    beq     PaletteDown
    
    cmp.w   #'P',d1
    beq     PaletteUp
    
    cmp.w   #'y',d1
    beq     CycleUp
    
    cmp.w   #'Y',d1
    beq     CycleDown
    
    cmp.w   #'c',d1
    beq     ToggleCheckBox
    
    cmp.w   #'C',d1
    beq     ToggleCheckBox
    
    cmp.w   #'0',d1
    beq     MX0
    
    cmp.w   #'1',d1
    beq     MX1
    
    cmp.w   #'2',d1
    beq     MX2
    
    cmp.w   #'3',d1
    beq     MX3
    
    cmp.w   #'s',d1
    beq     StringActive
    
    cmp.w   #'S',d1
    beq     StringActive
    
    cmp.w   #'i',d1
    beq     IntegerActive
    
    cmp.w   #'I',d1
    beq     IntegerActive
    
NotVANILLAKEY:
    jmp     MainWindowDoneMessage

ButtonPressed:
    jmp     MainWindowDoneMessage

SliderUp:
    move.l  sliderpos,d0
    cmpi.l  #15,d0
    beq     SkipSliderInc
    add.l   #1,sliderpos
SkipSliderInc:
    move.l  #GD_SliderGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  sliderpos,ti_data
    move.l  #$80080028,ti_tag       ; GTSL_Level
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

SliderDown:
    move.l  sliderpos,d0
    cmpi.l  #0,d0
    beq     SkipSliderDec
    sub.l   #1,sliderpos
SkipSliderDec:
    move.l  #GD_SliderGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  sliderpos,ti_data
    move.l  #$80080028,ti_tag       ; GTSL_Level
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

ScrollerUp:
    move.l  scrollerpos,d0
    cmpi.l  #8,d0
    beq     SkipScrollerInc
    add.l   #1,scrollerpos
SkipScrollerInc:
    move.l  #GD_ScrollerGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  scrollerpos,ti_data
    move.l  #$80080015,ti_tag       ; GTSC_Top
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

ScrollerDown:
    move.l  scrollerpos,d0
    cmpi.l  #0,d0
    beq     SkipScrollerDec
    sub.l   #1,scrollerpos
SkipScrollerDec:
    move.l  #GD_ScrollerGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  scrollerpos,ti_data
    move.l  #$80080015,ti_tag        ; GTSC_Top
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

PaletteUp:
    move.l  MainWindowDepth,d1
    move.l  #1,d2
    asl.l   d1,d2
    move.l  palettepos,d0
    cmpi.l  #0,d0
    bne     SkipPaletteDown
    move.l  d2,palettepos
SkipPaletteDown:
    sub.l   #1,palettepos
    move.l  #GD_PaletteGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  palettepos,ti_data
    move.l  #$80080011,ti_tag        ; GTPA_Color
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

PaletteDown:
    move.l  MainWindowDepth,d1
    move.l  #1,d2
    asl.l   d1,d2
    add.l   #1,palettepos
    move.l  palettepos,d0
    cmp.l   d2,d0
    bne     SkipPaletteUp
    move.l  #0,palettepos
SkipPaletteUp:
    move.l  #GD_PaletteGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  palettepos,ti_data
    move.l  #$80080011,ti_tag        ; GTPA_Color
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

CycleUp:
    add.l   #1,cyclepos
    move.l  cyclepos,d0
    cmpi.l  #4,d0
    bne     SkipCycleDown
    move.l  #0,cyclepos
SkipCycleDown:
    move.l  #GD_CycleGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  cyclepos,ti_data
    move.l  #$8008000F,ti_tag        ; GTCY_Active
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

CycleDown:
    move.l  cyclepos,d0
    cmpi.l  #0,d0
    bne     SkipCycleUp
    move.l  #4,cyclepos
SkipCycleUp:
    sub.l   #1,cyclepos
    move.l  #GD_CycleGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  cyclepos,ti_data
    move.l  #$8008000F,ti_tag        ; GTCY_Active
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

StringActive:
    move.l  #GD_StringGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    movea.l _IntuitionBase,a6
    jsr     ActivateGadget(a6)
    jmp     MainWindowDoneMessage

IntegerActive:
    move.l  #GD_IntegerGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    movea.l _IntuitionBase,a6
    jsr     ActivateGadget(a6)
    jmp     MainWindowDoneMessage

MX0:
    move.l  #0,ti_data
    jmp     MXA

MX1:
    move.l  #1,ti_data
    jmp     MXA

MX2:
    move.l  #2,ti_data
    jmp     MXA

MX3:
    move.l  #3,ti_data
    jmp     MXA

MXA:
    move.l  #GD_MXGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  #$8008000A,ti_tag       ; GTMX_Active
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

ToggleCheckBox:
    move.l  #GD_CheckBoxGadget,d0
    mulu    #4,d0
    lea.l   MainWindowGadgets,a0
    adda.l  d0,a0
    movea.l (a0),a0                  ; Gadget in a0
    movea.l MainWindow,a1
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    move.l  #$80080004,ti_tag        ; GTCB_Checked 
    move.w  12(a0),d0
    move.l  #1,ti_data
    btst    #7,d0
    beq     CorrectTag
    move.l  #0,ti_data
CorrectTag:
    jsr     GT_SetGadgetAttrs(a6)
    jmp     MainWindowDoneMessage

tags:
ti_tag:
    dc.l    0
ti_data:
    dc.l    0,0
sliderpos:
    dc.l    0
scrollerpos:
    dc.l    0
cyclepos:
    dc.l    0
palettepos  
    dc.l    0
    end
