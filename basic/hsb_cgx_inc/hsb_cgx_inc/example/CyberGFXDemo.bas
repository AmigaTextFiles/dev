'CyberGFXDemo.bas 0.1

'Compiler: HBC 2.0+
'Includes: 3.1
'Author:   steffen.leistner@styx.in-chemnitz.de

DEFLNG a-z

' $NOWINDOW
' $NOEVENT
' $NOSTACK
' $NOARRAY
' $NOLINES
' $NOVARCHECKS
' $NOAUTODIM
' $NOLIBRARY
' $UNDERLINES

' $INCLUDE exec.bh
' $INCLUDE dos.bh
' $INCLUDE intuition.bh
' $INCLUDE utility.bh
' $INCLUDE cybergraphics.bh

CONST minver& = 37&
CONST cgxver& = 40&


FUNCTION Main&
    LIBRARY OPEN "exec.library", minver&
    LIBRARY OPEN "dos.library", minver&
    LIBRARY OPEN "intuition.library", minver&
    LIBRARY OPEN "cybergraphics.library", cgxver&

    Main& = RETURN_ERROR&
    workbuf& = AllocVec& (512&, MEMF_PUBLIC& OR MEMF_CLEAR&)
    IF workbuf& = NULL&
        PrintMessage "Error:", "Not enough memory!", "Break"
        EXIT FUNCTION
    END IF
    
    TAGLIST workbuf&, _
        CYBRBIDTG_Depth&,           24&, _
        CYBRBIDTG_NominalWidth&,    640&, _
        CYBRBIDTG_NominalHeight&,   480&, _
    TAG_END&
    modeid& = BestCModeIDTagList&(workbuf&)
    
    IF modeid& <> INVALID_ID&
        TAGLIST workbuf&, _
            SA_Width&,          640&, _
            SA_Height&,         480&, _
            SA_Depth&,          24&, _
            SA_DisplayID&,      modeid&, _
            SA_FullPalette&,    TRUE&, _
            SA_Title&,          "24bit-Screen", _
        TAG_END&
        scr& = OpenScreenTagList&(NULL&, workbuf&)
        
        IF scr&
            TAGLIST workbuf&, _
                WA_CustomScreen&,   scr&, _
                WA_Top&,            (PEEKW(scr& + ScreenHeight%) - 256%) \ 2, _
                WA_Left&,           (PEEKW(scr& + ScreenWidth%) - 512%) \ 2, _
                WA_InnerWidth&,     512&, _
                WA_InnerHeight&,    256&, _
                WA_GimmeZeroZero&,  TRUE&, _
                WA_CloseGadget&,    TRUE&, _
                WA_DragBar&,        TRUE&, _
                WA_SmartRefresh&,   TRUE&, _
                WA_Activate&,       TRUE&, _
                WA_Title&,          "Simple CyberGraphX-Demo", _
                WA_IDCMP&,          IDCMP_CLOSEWINDOW& OR IDCMP_VANILLAKEY&, _
            TAG_END&
            win& = OpenWindowTagList&(NULL&, workbuf&)
            
            IF win&
                rastport& = PEEKL(win& + RPort%)
                userport& = PEEKL(win& + UserPort%)
                
                argb& = NULL&
                FOR y% = 0% TO 255%
                    POKEB VARPTR(argb&) + 2%, y%
                    FOR x% = 0% TO 255%
                        POKEB VARPTR(argb&) + 3%, x%
                        junk& = WriteRGBPixel&(rastport&, x%, y%, argb&)
                    NEXT x%
                    FOR x% = 256% TO 511%
                        POKEB VARPTR(argb&) + 1%, x% - 255%
                        POKEB VARPTR(argb&) + 3%, 255% - x%
                        junk& = WriteRGBPixel&(rastport&, x%, y%, argb&)
                    NEXT x%
                NEXT y%
                
                DO
                    sig& = xWait&((1& << PEEKB(userport& + mp_SigBit%)) OR SIGBREAKF_CTRL_C&) 
                    IF sig& AND SIGBREAKF_CTRL_C& THEN
                        EXIT LOOP
                    ELSE
                        msg& = GetMsg&(userport&)
                        IF msg&
                            mclass& = PEEKL(msg& + Class%)
                            mcode%  = PEEKW(msg& + IntuiMessageCode%)
                            ReplyMsg msg&
                            
                            SELECT CASE mclass&
                                CASE IDCMP_CLOSEWINDOW&
                                    EXIT LOOP
                                CASE IDCMP_VANILLAKEY&
                                    IF mcode% = 27% THEN
                                        EXIT LOOP
                                    END IF
                            END SELECT
                        END IF
                    END IF
                LOOP
                Main& = RETURN_OK&
                CloseWindow win&

            ELSE
                PrintMessage "Error:", "Can't open Window!", "Break"
            END IF
            junk& = CloseScreen&(scr&)

        ELSE
            PrintMessage "Error:", "Can't open Screen!", "Break"
        END IF

    ELSE
        PrintMessage "Error:", "Cybergraphics-modes not available!", "Break"
    END IF

    FreeVec workbuf&
END FUNCTION


SUB PrintMessage (first$, second$, gadget$)
    IF PEEKL(SYSTAB + 8%)
        reqbufsize& = es_sizeof% + LEN(first$) + LEN(second$) + LEN(gadget$) + 4&
        easystruct& = AllocVec& (reqbufsize&, MEMF_PUPLIC& OR MEMF_CLEAR&)
        IF easystruct&
            toffs& = easystruct& + es_sizeof%
            CopyMem SADD(first$), toffs&, LEN(first$)
            POKEL easystruct& + es_Title%, toffs&
            toffs& = toffs& + LEN(first$) + 1&
            CopyMem SADD(second$), toffs&, LEN(second$)
            POKEL easystruct& + es_TextFormat%, toffs&
            toffs& = toffs& + LEN(second$) + 1&
            CopyMem SADD(gadget$), toffs&, LEN(gadget$)
            POKEL easystruct& + es_GadgetFormat%, toffs&
            junk& = EasyRequestArgs& (NULL&, easystruct&, NULL&, NULL&)
            FreeVec easystruct&
        END IF
    ELSE
        con$ = first$ + CHR$(10) + second$ + CHR$(10)
        junk& = xWrite&(xOutput&, SADD(con$), LEN(con$))
    END IF
END SUB


STOP Main&

DATA "$VER: CyberGFXDemo.bas 0.1 "
